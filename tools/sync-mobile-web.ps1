$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$webDir = Join-Path $repoRoot "mobile-web"

New-Item -ItemType Directory -Force -Path $webDir | Out-Null

Copy-Item -LiteralPath (Join-Path $repoRoot "index.html") -Destination (Join-Path $webDir "index.html") -Force

$versionFile = Join-Path $repoRoot "version.json"
if (Test-Path $versionFile) {
  Copy-Item -LiteralPath $versionFile -Destination (Join-Path $webDir "version.json") -Force
}
