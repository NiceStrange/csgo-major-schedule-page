$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $repoRoot "index.html"
$versionPath = Join-Path $repoRoot "version.json"
$androidIndexPath = Join-Path $repoRoot "android\app\src\main\assets\public\index.html"
$buildVersion = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds().ToString()
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$indexContent = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)
$updatedIndex = [regex]::Replace($indexContent, 'const EMBEDDED_BUILD_VERSION = ".*?";', "const EMBEDDED_BUILD_VERSION = `"$buildVersion`";", 1)
[System.IO.File]::WriteAllText($indexPath, $updatedIndex, $utf8NoBom)

$versionJson = @{
    version = $buildVersion
    generatedAt = [DateTime]::UtcNow.ToString("o")
} | ConvertTo-Json

[System.IO.File]::WriteAllText($versionPath, $versionJson, $utf8NoBom)

if (Test-Path $androidIndexPath) {
    [System.IO.File]::WriteAllText($androidIndexPath, $updatedIndex, $utf8NoBom)
}

Write-Output "Prepared web release version $buildVersion"
