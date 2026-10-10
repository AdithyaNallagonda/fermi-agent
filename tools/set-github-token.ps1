<#
.SYNOPSIS
  Stores a GitHub personal access token for the GitHub MCP server in <repo>\.env\github.token without echoing
  it or leaving it in shell history. The file is git-ignored; the MCP configuration reads it through
  tools\github-mcp-headers.mjs, so the token never appears in any configuration file.

.DESCRIPTION
  Create a fine-grained token first (GitHub > Settings > Developer settings > Personal access tokens >
  Fine-grained tokens): choose only the repositories you need, an expiry date, and the minimum permissions
  (read-only "Contents" and "Metadata" to browse code; add Issues / Pull requests / Actions only as needed).

  Step-by-step instructions, pre-filled token links and troubleshooting: INSTALL.md (section 3) in the repo root.

  Run this yourself in a terminal: it needs an interactive hidden prompt. Do not open .env\github.token in an
  editor that shares open files or selections with an AI assistant.

  The token is stored unencrypted in that file, readable only by your Windows account, so prefer short-lived,
  narrowly scoped tokens. Restart VS Code / Claude Code afterwards.

.EXAMPLE
  .\set-github-token.ps1                # prompt (hidden input), verify with GitHub, then store
  .\set-github-token.ps1 -VerifyOnly    # check the token that is already stored (prints account + expiry only)
  .\set-github-token.ps1 -Remove        # delete the stored token
#>
param(
    [switch]$VerifyOnly,
    [switch]$Remove,
    [switch]$SkipVerify
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$tokenDir = Join-Path $repoRoot '.env'
$tokenPath = Join-Path $tokenDir 'github.token'
$legacyVar = 'GITHUB_PERSONAL_ACCESS_TOKEN'

function Test-GitHubToken([string]$Token) {
    # Returns a result object; never prints the token.
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $resp = Invoke-WebRequest -Uri 'https://api.github.com/user' -UseBasicParsing -TimeoutSec 20 -Headers @{
            Authorization = "Bearer $Token"; 'User-Agent' = 'fermi-set-github-token'; Accept = 'application/vnd.github+json'
        }
        $login = ($resp.Content | ConvertFrom-Json).login
        $expiry = $resp.Headers['github-authentication-token-expiration']
        return [pscustomobject]@{ Ok = $true; Message = "accepted for user '$login'" + $(if ($expiry) { " (expires $expiry)" } else { '' }) }
    } catch {
        $code = $null
        if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode }
        if ($code -eq 401) { return [pscustomobject]@{ Ok = $false; Message = 'rejected by GitHub (401: bad, expired or revoked token)' } }
        return [pscustomobject]@{ Ok = $false; Message = "could not verify ($(if ($code) { "HTTP $code" } else { $_.Exception.Message }))" }
    }
}

function Test-TokenPathIgnored {
    # True when the folder is not a git repository, or git ignores the token file.
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot '.git'))) { return $true }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return $false }
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    try { $null = & git -C $repoRoot check-ignore -q -- '.env/github.token'; return ($LASTEXITCODE -eq 0) }
    finally { $ErrorActionPreference = $old }
}

function Clear-LegacyVariable {
    if ([Environment]::GetEnvironmentVariable($legacyVar, 'User')) {
        [Environment]::SetEnvironmentVariable($legacyVar, $null, 'User')
        Write-Output "Removed the old $legacyVar user environment variable (no longer used)."
    }
}

if ($Remove) {
    if (Test-Path -LiteralPath $tokenPath) { Remove-Item -LiteralPath $tokenPath -Force -Confirm:$false; Write-Output "Deleted $tokenPath." }
    else { Write-Output 'No stored token file found.' }
    Clear-LegacyVariable
    Write-Output 'Delete the token on GitHub as well if it is no longer needed.'
    exit 0
}

if ($VerifyOnly) {
    if (-not (Test-Path -LiteralPath $tokenPath)) { Write-Output "No token stored ($tokenPath does not exist)."; exit 1 }
    $stored = ([IO.File]::ReadAllText($tokenPath)).Trim().TrimStart([char]0xFEFF)
    if (-not $stored) { Write-Output 'The token file is empty.'; exit 1 }
    $r = Test-GitHubToken $stored
    $stored = $null
    Write-Output "Stored token: $($r.Message)"
    if (-not (Test-TokenPathIgnored)) { Write-Warning 'The token file is NOT ignored by git. Add ".env/" to .gitignore before committing anything.' }
    if ($r.Ok) { exit 0 } else { exit 1 }
}

if (-not (Test-TokenPathIgnored)) {
    Write-Output 'Stopped: git does not ignore .env/github.token in this folder. Add ".env/" to .gitignore (or .git/info/exclude) first. Nothing changed.'
    exit 1
}

$secure = Read-Host -AsSecureString "Paste your GitHub token (input is hidden)"
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try { $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
$plain = "$plain".Trim()

if (-not $plain) { Write-Output 'No token entered; nothing changed.'; exit 1 }
if ($plain -match '\s') { Write-Output 'The token contains whitespace; nothing changed.'; exit 1 }
if ($plain -notmatch '^(github_pat_|ghp_|gho_|ghu_|ghs_)') {
    Write-Warning 'This does not look like a GitHub token (expected a github_pat_ or ghp_ prefix).'
}

if (-not $SkipVerify) {
    $r = Test-GitHubToken $plain
    Write-Output "GitHub check: $($r.Message)"
    if (-not $r.Ok -and $r.Message -like 'rejected*') { Write-Output 'Nothing changed.'; exit 1 }
}

New-Item -ItemType Directory -Force -Path $tokenDir | Out-Null
[IO.File]::WriteAllText($tokenPath, $plain, (New-Object Text.UTF8Encoding($false)))
$plain = $null

# Restrict the file to the current Windows account (best effort; the file is usable either way).
$old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
try {
    $me = [Security.Principal.WindowsIdentity]::GetCurrent().Name
    $null = & icacls $tokenPath /inheritance:r /grant:r "${me}:(M)"
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Could not restrict the file permissions; other accounts on this PC may be able to read it.' }
} catch { Write-Warning 'Could not restrict the file permissions; other accounts on this PC may be able to read it.' }
finally { $ErrorActionPreference = $old }

Clear-LegacyVariable
Write-Output "Stored in $tokenPath (git-ignored). Restart VS Code / Claude Code, then run /mcp to confirm 'github' is connected."
