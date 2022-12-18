#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

## Make sure any modules we depend on are installed
$modulesToInstall = @(
    'GitHubActions'
)

$modulesToInstall | ForEach-Object {
    if (-not (Get-Module -ListAvailable -All $_)) {
        Write-Output "Module [$_] not found, INSTALLING..."
        Install-Module $_ -Force
    }
}

## Import dependencies
Import-Module GitHubActions -Force

Write-ActionInfo "Running from [$($PSScriptRoot)]"

function splitListInput { $args[0] -split ',' | % { $_.Trim() } }
function writeListInput { $args[0] | % { Write-ActionInfo "    - $_" } }

$inputs = @{
    directory = Get-ActionInput directory -Required
    github_token       = Get-ActionInput github_token -Required
    skip_check_run     = Get-ActionInput skip_check_run
    exclude_lang     = Get-ActionInput exclude_lang
    include_lang     = Get-ActionInput include_lang
    exclude_dir     = Get-ActionInput exclude_dir
    include_ext       = Get-ActionInput include_ext    
}

function removeSpace { $args[0].Replace(' ','') }

$test_results_dir = Join-Path $PWD _TMP
Write-ActionInfo "Creating test results space"
mkdir $test_results_dir
Write-ActionInfo $test_results_dir
$script:loc_report_md_path = Join-Path $test_results_dir loc-results.md
$script:loc_report_json_path = Join-Path $test_results_dir loc-results.json
$script:skip_check_run = $inputs.skip_check_run
$script:directory =  $inputs.directory
$script:exclude_dir = removeSpace $inputs.exclude_dir
$script:exclude_lang = removeSpace $inputs.exclude_lang
$script:include_lang = removeSpace $inputs.include_lang
$script:include_ext = $inputs.include_ext


function Build-Report 
{
    $script:directory = $inputs.directory
    $script:exclude_dir = removeSpace $inputs.exclude_dir
    $script:exclude_lang = removeSpace $inputs.exclude_lang
    $script:include_lang = removeSpace $inputs.include_lang
    $script:include_ext = removeSpace $inputs.include_ext
    Write-ActionInfo "Running CLOC Command Line Tool to generate lines of code Markdown"
    npm install -g cloc
    Write-ActionInfo $script:include_lang
    Write-ActionInfo $script:include_ext
    
    if($script:include_lang -eq "" -and $script:include_ext -eq "")
    {
        Write-Output "Include lang is null" -Foreground Yellow
        Write-Output "Include ext is null" -Foreground Yellow
        cloc "$script:directory" --md --out=$script:loc_report_md_path --exclude-lang="$script:exclude_lang" --exclude-dir="$script:exclude_dir"
        cloc "$script:directory" --json --out=$script:loc_report_json_path --exclude-lang="$script:exclude_lang" --exclude-dir="$script:exclude_dir"
    }
    if($script:include_lang -ne "" -and $script:include_ext -eq "")
    {
        Write-Output "Include lang not null" -Foreground Green
        Write-Output "Include ext is null" -Foreground Yellow
        cloc "$script:directory" --md --out=$script:loc_report_md_path --exclude-lang="$script:exclude_lang" --exclude-dir="$script:exclude_dir" --include-lang="$script:include_lang"
        cloc "$script:directory" --json --out=$script:loc_report_json_path  --exclude-lang="$script:exclude_lang" --exclude-dir="$script:exclude_dir" --include-lang="$script:include_lang"
    }
    if($script:include_lang -eq "" -and $script:include_ext -ne "")
    {
        Write-Output "Include lang is null" -Foreground Yellow
        Write-Output "Include ext is not null" -Foreground Green
        cloc "$script:directory" --md --out=$script:loc_report_md_path --exclude-lang="$script:exclude_lang" --exclude-dir="$script:exclude_dir" --include-ext="$script:include_ext"
        cloc "$script:directory" --json --out=$script:loc_report_json_path  --exclude-lang="$script:exclude_lang" --exclude-dir="$script:exclude_dir" --include-ext="$script:include_ext"
    }
    if($script:include_lang -ne "" -and $script:include_ext -ne "")
    {
        Write-Output "Include lang not null" -Foreground Yellow
        Write-Output "Include ext not null" -Foreground Yellow
        Write-ActionInfo "Thowing error as both include_lang and include_ext were supplied to action which is not supported. Please use only of the option"
        throw "Please use either include_lang or include_ext but not both together which is not supported"
    }
    
    $Content=Get-Content -path $loc_report_md_path -Raw
    $Content.replace('cloc|github.com/AlDanial/cloc', '   Lines of Code Report|    ') | Set-Content -Path $loc_report_md_path
    Get-Content -Path $loc_report_md_path
    $json=Get-Content -Raw -Path $script:loc_report_json_path | Out-String | ConvertFrom-Json
    $total_lines = ($json.SUM).code
    $total_lines_int = ($json.SUM).code
    $total_lines_string = '{0:N0}' -f ($total_lines - 16)
    Set-ActionOutput -Name total_lines -Value $total_lines
    Set-ActionOutput -Name total_lines_int -Value ($total_lines_int - 16)
    Set-ActionOutput -Name total_lines_string -Value $total_lines_string
    Set-ActionOutput -Name loc_report -Value $loc_report_md_path
    Write-Output $total_lines
    Write-Output $loc_report
    $locData = [System.IO.File]::ReadAllText($loc_report_md_path)
    # Set-ActionOutput -Name lines-of-code-summary -Value $locData
}

function Publish-ToCheckRun {
    param(
        [string]$reportData,
        [string]$reportName,
        [string]$reportTitle
    )

#     if ($env:GITHUB_EVENT_NAME -eq "workflow_dispatch") {
#         Write-Host "::notice title=Check Run Publishing Skipped::Check run publishing has been skipped as it is not possible to attach check runs to workflows triggered with 'workflow_dispatch'."
#     } else {
#         Write-ActionInfo "Publishing Report to GH Workflow"

        $ghToken = $inputs.github_token
        $ctx = Get-ActionContext
        $repo = Get-ActionRepo
        $repoFullName = "$($repo.Owner)/$($repo.Repo)"

        Write-ActionInfo "Resolving REF"
        $ref = $ctx.Sha
        if ($ctx.EventName -eq 'pull_request') {
            Write-ActionInfo "Resolving PR REF"
            $ref = $ctx.Payload.pull_request.head.sha
            if (-not $ref) {
                Write-ActionInfo "Resolving PR REF as AFTER"
                $ref = $ctx.Payload.after
            }
        }
        if (-not $ref) {
            Write-ActionError "Failed to resolve REF"
            exit 1
        }
        Write-ActionInfo "Resolved REF as $ref"
        Write-ActionInfo "Resolve Repo Full Name as $repoFullName"

        Write-ActionInfo "Adding Check Run"
        $url = "https://api.github.com/repos/$repoFullName/check-runs"
        $hdr = @{
            Accept = 'application/vnd.github+json'
            Authorization = "token $ghToken"
        }
        $bdy = @{
            name       = $reportName
            head_sha   = $ref
            status     = 'completed'
            conclusion = 'success'
            output     = @{
                title   = $reportTitle
                summary = "This run completed at ``$([datetime]::Now)``"
                text    = $reportData
            }
        }
        Invoke-WebRequest -Headers $hdr $url -Method Post -Body ($bdy | ConvertTo-Json)
    }
# }

#     $CHECK_RUN_ID = $Response.Content | Where-Object { $_.name -like "* id*" } | Select-Object Name, Value
#     Set-ActionOutput -Name total_lines -Value $CHECK_RUN_ID
#     Write-Output "Check Run URL"
#     Write-Output $CHECK_RUN_ID
#     Set-ActionOutput -Name check_run_id -Value $CHECK_RUN_ID
#     # Set-ActionOutput -Name check_run_url -Value https://github.com/$repoFullName/runs/$CHECK_RUN_ID
#     # Write-Output https://github.com/$repoFullName/runs/$CHECK_RUN_ID


Write-ActionInfo "Publishing Report to GH Workflow"    

if ($inputs.skip_check_run -ne $true)
    {
        Write-Output "generating report and publishing"

        Build-Report
        
        $locData = [System.IO.File]::ReadAllText($loc_report_md_path)

        Set-Variable -Name "report_title" -Value "Lines of Code"

        Set-Variable -Name "loc_report_name" -Value "Lines of Code $total_lines_string"
        
        Publish-ToCheckRun -ReportData $locData -ReportName $loc_report_name -ReportTitle $report_title
    }
else
    {
        Write-Output "skipping"
    }
