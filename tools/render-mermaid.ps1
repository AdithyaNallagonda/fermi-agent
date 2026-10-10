<#
.SYNOPSIS
  Validates and renders a Mermaid diagram locally with the official Mermaid CLI (@mermaid-js/mermaid-cli).
  Nothing leaves the machine. Uses an installed Edge/Chrome so no bundled Chromium is downloaded.

.EXAMPLE
  .\render-mermaid.ps1 -In diagram.mmd                 # validate only (renders to a temp SVG, then deletes it)
  .\render-mermaid.ps1 -In diagram.mmd -Out diagram.svg
  .\render-mermaid.ps1 -In diagram.mmd -Out diagram.png -Theme dark -Scale 2

.NOTES
  Exit code 0 = valid (and rendered); non-zero = parse/render error (message printed).
  Requires Node.js 20+ (npx). First run downloads the pinned CLI into the npm cache.
#>
param(
    [Parameter(Mandatory = $true)][string]$In,
    [string]$Out,
    [ValidateSet('default', 'neutral', 'dark', 'forest', 'base')][string]$Theme = 'default',
    [int]$Scale = 1,
    [string]$Version = '12.0.0'
)

$ErrorActionPreference = 'Continue'
if (-not (Test-Path $In)) { Write-Output "ERROR: input not found: $In"; exit 2 }
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) { Write-Output 'ERROR: npx not found. Install Node.js 20+.'; exit 2 }

# Prefer a browser that is already installed (avoids Puppeteer downloading its own Chromium).
$candidates = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)
$browser = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if ($browser) {
    $env:PUPPETEER_SKIP_DOWNLOAD = 'true'
    $env:PUPPETEER_EXECUTABLE_PATH = $browser
} else {
    Write-Warning 'No Edge/Chrome found; Puppeteer will download its own Chromium on first run (large).'
}

$validateOnly = -not $Out
if ($validateOnly) { $Out = Join-Path ([System.IO.Path]::GetTempPath()) ("mermaid-validate-" + [guid]::NewGuid().ToString('N') + '.svg') }

# "$_" turns PowerShell 5.1 error records (stderr lines) back into plain message text.
$lines = & npx -y "@mermaid-js/mermaid-cli@$Version" -i $In -o $Out -t $Theme -s $Scale -q 2>&1 | ForEach-Object { "$_" }
$ok = Test-Path $Out

if ($ok) {
    if ($validateOnly) { Remove-Item $Out -Force -Confirm:$false; Write-Output "VALID: $In" }
    else { Write-Output "RENDERED: $Out" }
    exit 0
}
Write-Output "INVALID: $In"
# Keep the useful part of the parser message, drop the stack trace.
($lines | Where-Object { $_ -and $_.Trim() -and ($_ -notmatch '^\s*at |mermaid-cli-intercept|node:internal|^\s*\^|^System\.Management\.Automation\.') } | Select-Object -First 8) -join "`n"
exit 1
