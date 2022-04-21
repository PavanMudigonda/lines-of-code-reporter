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
    exclude_dir     = Get-ActionInput exclude_dir
    exclude_file_types     = Get-ActionInput exclude_file_types
}

$test_results_dir = Join-Path $PWD _TMP
Write-ActionInfo "Creating test results space"
mkdir $test_results_dir
Write-ActionInfo $test_results_dir
$script:loc_report_md_path = Join-Path $test_results_dir loc-results.md
$script:loc_report_json_path = Join-Path $test_results_dir loc-results.json
$script:skip_check_run = $inputs.skip_check_run
$script:directory = $inputs.directory
$script:exclude_dir = $inputs.exclude_dir
$script:exclude_lang = $inputs.exclude_lang
$script:exclude_file_types = $inputs.exclude_file_types


function Build-Report 
{
    Write-ActionInfo "Running CLOC Command Line Tool to generate lines of code Markdown"
    npm install -g cloc
    cloc $script:directory --md --out=$script:loc_report_md_path --exclude-lang=$script:exclude_lang --exclude-dir=$script:exclude_dir
    $Content=Get-Content -path $loc_report_md_path -Raw
    $Content.replace('cloc|github.com/AlDanial/cloc', 'Lines of Code | ') | Set-Content -Path $loc_report_md_path
    Get-Content -Path $loc_report_md_path
    cloc $script:directory --json --out=$script:loc_report_json_path  --exclude-lang=$script:exclude_lang --exclude-dir=$script:exclude_dir
    $json=Get-Content -Raw -Path $script:loc_report_json_path | Out-String | ConvertFrom-Json
    $total_lines = ($json.SUM).code
    Set-ActionOutput -Name total_lines -Value $total_lines
    Set-ActionOutput -Name loc_report -Value $loc_report_md_path
    Write-Output $total_lines
    Write-Output $loc_report
}

function Publish-ToCheckRun {
    param(
        [string]$reportData,
        [string]$reportName,
        [string]$reportTitle
    )

    Write-ActionInfo "Publishing Report to GH Workflow"

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
        Accept = 'application/vnd.github.antiope-preview+json'
        Authorization = "token $ghToken"
    }
    $bdy = @{
        name       = $reportName
        head_sha   = $ref
        status     = 'completed'
        conclusion = 'neutral'
        output     = @{
            title   = $reportTitle
            summary = "This run completed at ``$([datetime]::Now)``"
            text    = $ReportData
        }
    }
      Invoke-WebRequest -Headers $hdr $url -Method Post -Body ($bdy | ConvertTo-Json)
#     $CHECK_RUN_ID = $Response.Content | Where-Object { $_.name -like "* id*" } | Select-Object Name, Value
#     Set-ActionOutput -Name total_lines -Value $CHECK_RUN_ID
#     Write-Output "Check Run URL"
#     Write-Output $CHECK_RUN_ID
#     Set-ActionOutput -Name check_run_id -Value $CHECK_RUN_ID
#     # Set-ActionOutput -Name check_run_url -Value https://github.com/$repoFullName/runs/$CHECK_RUN_ID
#     # Write-Output https://github.com/$repoFullName/runs/$CHECK_RUN_ID
}


Write-ActionInfo "Publishing Report to GH Workflow"    

if ($inputs.skip_check_run -ne $true)
    {
        Write-Output "generating report and publishing"

        Build-Report
        
        $locData = [System.IO.File]::ReadAllText($loc_report_md_path)

        Set-Variable -Name "report_title" -Value "Lines of Code"

        Set-Variable -Name "loc_report_name" -Value "Lines of Code"
        
        Publish-ToCheckRun -ReportData $locData -ReportName $loc_report_name -ReportTitle $report_title
    }
else
    {
        Write-Output "skipping"
    }

if ($stepShouldFail) {
    Write-ActionInfo "Thowing error as Code Coverage is less than "minimum_coverage" is not met and 'fail_below_threshold' was true."
    throw "Code Coverage is less than Minimum Code Coverage Required"
}
