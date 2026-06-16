$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $repoRoot "index.html"
$versionPath = Join-Path $repoRoot "version.json"
$androidIndexPath = Join-Path $repoRoot "android\app\src\main\assets\public\index.html"
$buildVersion = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds().ToString()

$indexContent = Get-Content -Path $indexPath -Raw
$updatedIndex = [regex]::Replace($indexContent, 'const EMBEDDED_BUILD_VERSION = ".*?";', "const EMBEDDED_BUILD_VERSION = `"$buildVersion`";", 1)
Set-Content -Path $indexPath -Value $updatedIndex -Encoding UTF8

$versionJson = @{
    version = $buildVersion
    generatedAt = [DateTime]::UtcNow.ToString("o")
} | ConvertTo-Json

Set-Content -Path $versionPath -Value $versionJson -Encoding UTF8

if (Test-Path $androidIndexPath) {
    Copy-Item -Path $indexPath -Destination $androidIndexPath -Force
}

Write-Output "Prepared web release version $buildVersion"
