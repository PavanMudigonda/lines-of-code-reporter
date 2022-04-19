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
    patterns     = Get-ActionInput patterns
    exclude_directory     = Get-ActionInput exclude_directory
    exclude_file_types     = Get-ActionInput exclude_file_types
}

$test_results_dir = Join-Path $PWD _TMP
Write-ActionInfo "Creating test results space"
mkdir $test_results_dir
Write-ActionInfo $test_results_dir
$script:loc_report_path = Join-Path $test_results_dir loc-results.md
$script:skip_check_run = $inputs.skip_check_run
$script:directory = $inputs.directory
$script:exclude_directory = $inputs.exclude_directory
$scrit:patterns = $inputs.patterns
$script:exclude_file_types = $inputs.exclude_file_types


function Build-Report 
{
    Write-ActionInfo "Running CLOC Command Line Tool to generate lines of code Markdown"
    cloc $script:directory --md --out=$script:loc_report_path
    ((Get-Content -path $loc_report_path -Raw) -replace 'cloc|github.com/AlDanial/cloc v 1.92', ' ') | Set-Content -Path $loc_report_path
    ((Get-Content -path $loc_report_path -Raw) -replace 'cloc', 'Lines of Code') | Set-Content -Path $loc_report_path
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
}


Write-ActionInfo "Publishing Report to GH Workflow"    

if ($inputs.skip_check_run -ne $true)
    {
        Write-Output "generating report and publishing"

        Build-Report
        
        $locData = [System.IO.File]::ReadAllText($loc_report_path)

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
