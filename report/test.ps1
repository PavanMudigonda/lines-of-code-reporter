$json=Get-Content -Raw -Path ./report/json.json | Out-String | ConvertFrom-Json

# $foo="code"
$total_lines = ($json.SUM).code

Write-Output $total_lines