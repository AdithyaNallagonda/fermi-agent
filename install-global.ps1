<#
.SYNOPSIS
  Installs the fermi agent and its skills into your user-level Claude config
  (~/.claude) so you can use them from ANY project in Claude Code CLI or the VS Code extension.

.DESCRIPTION
  - Copies .claude/agents/fermi.md  -> ~/.claude/agents/
  - Copies .claude/skills/*                         -> ~/.claude/skills/
  - Rewrites "KB_ROOT = `.`" to this repo's absolute path, so the agent reads the knowledge base
    from here no matter which project you are in. Keep this folder in place (re-run after moving it).
  - Optional -GrantReadAccess adds this folder to permissions.additionalDirectories in
    ~/.claude/settings.json so reads of the knowledge base don't prompt in other projects.
  - Optional -MakeDefaultAgent sets "agent": "fermi" in ~/.claude/settings.json so EVERY
    Claude Code session (CLI + VS Code) runs as this agent and self-routes your asks — no commands needed.
    A project's own .claude/settings.json "agent" key or `claude --agent <name>` still overrides it.
    -Uninstall reverts this (only if the value is still fermi).
  - Optional -InstallMcpServers registers the bundled MCP servers from this repo's .mcp.json at USER scope
    (all projects) through the Claude CLI: draw.io (@drawio/mcp) and, when -AdoOrg <organization> is given,
    Azure DevOps (@azure-devops/mcp). Versions are pinned in .mcp.json. Also sets the ADO_ORG user environment
    variable so the project-scoped .mcp.json resolves the same organization. Requires Node.js 20+ (npx).
    Also registers GitHub's hosted MCP server; it gets its token through tools\github-mcp-headers.mjs, which
    reads .env\github.token (store it with tools\set-github-token.ps1; this script never handles the token).
    Servers you already have under the same name are left alone unless -Force. -Uninstall removes only the
    servers (and the ADO_ORG variable) this script added.
  - Optional -InstallRea registers the opt-in REA reverse-engineering MCP server from mcp-optional.json
    (third-party, single maintainer, 139 tools, can run target programs). Use it only for software you are
    authorised to analyse; see instructions\reverse-engineering.md.

.EXAMPLE
  .\install-global.ps1
  .\install-global.ps1 -Force -GrantReadAccess
  .\install-global.ps1 -GrantReadAccess -MakeDefaultAgent
  .\install-global.ps1 -GrantReadAccess -InstallMcpServers -AdoOrg contoso
  .\install-global.ps1 -InstallRea
  .\install-global.ps1 -Uninstall
#>
param(
    [switch]$Force,
    [switch]$GrantReadAccess,
    [switch]$MakeDefaultAgent,
    [switch]$InstallMcpServers,
    [string]$AdoOrg,
    [switch]$InstallRea,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$repo      = $PSScriptRoot
$kbRoot    = ($repo -replace '\\', '/')
$userClaude = Join-Path $env:USERPROFILE '.claude'
$agentsDst = Join-Path $userClaude 'agents'
$skillsDst = Join-Path $userClaude 'skills'
$agentSrc  = Join-Path $repo '.claude\agents\fermi.md'
$skillDirs = Get-ChildItem (Join-Path $repo '.claude\skills') -Directory
# Earlier names of this agent: their installed copies are treated as ours (replaced / removed).
$legacyAgents = @('principal-architect')
$ownMarker = 'agents/fermi\.md|principal-architect'

function Write-Utf8NoBom([string]$Path, [string]$Text) {
    [System.IO.File]::WriteAllText($Path, $Text, (New-Object System.Text.UTF8Encoding($false)))
}

$settingsPath = Join-Path $userClaude 'settings.json'
function Read-UserSettings {
    if (Test-Path $settingsPath) { Get-Content $settingsPath -Raw | ConvertFrom-Json } else { New-Object PSObject }
}
function Save-UserSettings($obj) {
    if (Test-Path $settingsPath) { Copy-Item $settingsPath "$settingsPath.bak" -Force }
    Write-Utf8NoBom $settingsPath ($obj | ConvertTo-Json -Depth 20)
}

# --- Bundled MCP servers (registered through the Claude CLI; .mcp.json is the single source of truth) ---
$bundleStatePath = Join-Path $userClaude 'fermi-bundle.json'   # what this script added, so -Uninstall removes only that
function Read-BundleState {
    if (Test-Path $bundleStatePath) { Get-Content $bundleStatePath -Raw | ConvertFrom-Json }
    else { [pscustomobject]@{ mcpServers = @(); adoOrgEnvSet = $false } }
}
function Find-ClaudeCli {
    $cmd = Get-Command claude -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    # The VS Code extension ships the CLI even when it is not on PATH.
    $ext = Get-ChildItem (Join-Path $env:USERPROFILE '.vscode\extensions\anthropic.claude-code-*\resources\native-binary\claude.exe') -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime | Select-Object -Last 1
    if ($ext) { return $ext.FullName }
    return $null
}
function ConvertTo-NativeArg([string]$Text) {
    # Windows PowerShell (and PowerShell 7 before 7.3, or in Legacy mode) does not escape embedded double quotes
    # when calling a native program, so a JSON argument arrives mangled unless the quotes are escaped here.
    $legacy = ($PSVersionTable.PSVersion -lt [version]'7.3') -or ("$PSNativeCommandArgumentPassing" -eq 'Legacy')
    if ($legacy) { return ($Text -replace '(\\*)"', '$1$1\"') }
    return $Text
}
function Invoke-ClaudeCli([string]$Cli, [string[]]$CliArgs) {
    # Exit codes are unreliable on Windows, and stderr under 'Stop' would throw: capture text and match on it.
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    try { (& $Cli @CliArgs 2>&1 | ForEach-Object { "$_" }) -join "`n" } finally { $ErrorActionPreference = $old }
}

if ($Uninstall) {
    $a = Join-Path $agentsDst 'fermi.md'
    if (Test-Path $a) { Remove-Item $a -Confirm:$false; Write-Host "Removed $a" }
    foreach ($l in $legacyAgents) {
        $la = Join-Path $agentsDst "$l.md"
        if (Test-Path $la) { Remove-Item $la -Confirm:$false; Write-Host "Removed legacy agent $la" }
    }
    foreach ($d in $skillDirs) {
        $t = Join-Path $skillsDst $d.Name
        $marker = Join-Path $t 'SKILL.md'
        if ((Test-Path $marker) -and ((Get-Content $marker -Raw) -match $ownMarker)) {
            Remove-Item $t -Recurse -Confirm:$false; Write-Host "Removed skill $($d.Name)"
        }
    }
    if (Test-Path $settingsPath) {
        $st = Read-UserSettings
        if ($st.PSObject.Properties['agent'] -and ($st.agent -eq 'fermi' -or $legacyAgents -contains $st.agent)) {
            $st.PSObject.Properties.Remove('agent'); Save-UserSettings $st
            Write-Host 'Removed default agent from ~/.claude/settings.json (backup: settings.json.bak)'
        }
    }
    if (Test-Path $bundleStatePath) {
        $state = Read-BundleState
        $cli = Find-ClaudeCli
        foreach ($name in @($state.mcpServers)) {
            if ($cli) {
                $out = Invoke-ClaudeCli $cli @('mcp', 'remove', $name, '--scope', 'user')
                if ($out -match 'Removed') { Write-Host "Removed MCP server $name" } else { Write-Warning "Could not remove MCP server ${name}: $out" }
            } else { Write-Warning "Claude CLI not found. Remove manually: claude mcp remove $name --scope user" }
        }
        if ($state.adoOrgEnvSet) {
            [Environment]::SetEnvironmentVariable('ADO_ORG', $null, 'User'); Write-Host 'Removed ADO_ORG user environment variable'
        }
        Remove-Item $bundleStatePath -Confirm:$false
    }
    Write-Host 'Uninstall complete.'
    return
}

New-Item -ItemType Directory -Force $agentsDst, $skillsDst | Out-Null

# Agent
$agentText = (Get-Content $agentSrc -Raw).Replace('KB_ROOT = `.`', "KB_ROOT = ``$kbRoot``")
Write-Utf8NoBom (Join-Path $agentsDst 'fermi.md') $agentText
Write-Host "Installed agent -> $agentsDst\fermi.md"

# Clean up copies installed under an earlier agent name
foreach ($l in $legacyAgents) {
    $la = Join-Path $agentsDst "$l.md"
    if (Test-Path $la) { Remove-Item $la -Confirm:$false; Write-Host "Removed legacy agent $l (renamed to fermi)" }
}
if (Test-Path $settingsPath) {
    $st = Read-UserSettings
    if ($st.PSObject.Properties['agent'] -and ($legacyAgents -contains $st.agent)) {
        $st.agent = 'fermi'; Save-UserSettings $st
        Write-Host 'Updated default agent in ~/.claude/settings.json to fermi (backup: settings.json.bak)'
    }
}

# Skills
foreach ($d in $skillDirs) {
    $target = Join-Path $skillsDst $d.Name
    $targetFile = Join-Path $target 'SKILL.md'
    if ((Test-Path $targetFile) -and -not $Force -and -not ((Get-Content $targetFile -Raw) -match $ownMarker)) {
        Write-Warning "Skipping /$($d.Name): a different skill with that name already exists (use -Force to overwrite)."
        continue
    }
    New-Item -ItemType Directory -Force $target | Out-Null
    $text = (Get-Content (Join-Path $d.FullName 'SKILL.md') -Raw).Replace('KB_ROOT = `.`', "KB_ROOT = ``$kbRoot``")
    Write-Utf8NoBom $targetFile $text
    Write-Host "Installed skill /$($d.Name)"
}

# Optional: allow reading the KB from other projects without prompts
if ($GrantReadAccess) {
    $settings = Read-UserSettings
    if (-not $settings.PSObject.Properties['permissions']) {
        $settings | Add-Member -NotePropertyName permissions -NotePropertyValue (New-Object PSObject)
    }
    if (-not $settings.permissions.PSObject.Properties['additionalDirectories']) {
        $settings.permissions | Add-Member -NotePropertyName additionalDirectories -NotePropertyValue @()
    }
    $dirs = @($settings.permissions.additionalDirectories)
    if ($dirs -notcontains $kbRoot) {
        $settings.permissions.additionalDirectories = $dirs + $kbRoot
        Save-UserSettings $settings
        Write-Host "Added $kbRoot to permissions.additionalDirectories (backup: settings.json.bak)"
    }
}

# Optional: make the agent the default main thread for every session
if ($MakeDefaultAgent) {
    $settings = Read-UserSettings
    if ($settings.PSObject.Properties['agent'] -and $settings.agent -and $settings.agent -ne 'fermi' -and -not $Force) {
        Write-Warning "~/.claude/settings.json already sets agent '$($settings.agent)'. Re-run with -Force to replace it."
    } elseif (-not ($settings.PSObject.Properties['agent'] -and $settings.agent -eq 'fermi')) {
        if ($settings.PSObject.Properties['agent']) { $settings.agent = 'fermi' }
        else { $settings | Add-Member -NotePropertyName agent -NotePropertyValue 'fermi' }
        Save-UserSettings $settings
        Write-Host 'Set fermi as the default agent for all sessions (backup: settings.json.bak)'
    }
}

# Optional: register MCP servers at user scope (.mcp.json = bundled set, mcp-optional.json = opt-in REA)
$defFiles = @()
if ($InstallMcpServers) { $defFiles += (Join-Path $repo '.mcp.json') }
if ($InstallRea) { $defFiles += (Join-Path $repo 'mcp-optional.json') }
if ($defFiles.Count -gt 0) {
    $cli = Find-ClaudeCli
    if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
        Write-Warning 'npx not found: install Node.js 20+ first. Skipping MCP servers.'
    } elseif (-not $cli) {
        Write-Warning 'Claude CLI not found (not on PATH and no VS Code extension binary). Skipping MCP servers; the project .mcp.json still works inside this folder.'
    } else {
        $state = Read-BundleState
        $added = @($state.mcpServers)
        foreach ($defFile in $defFiles) {
            $defs = (Get-Content $defFile -Raw | ConvertFrom-Json).mcpServers
            foreach ($p in $defs.PSObject.Properties) {
                $name = $p.Name
                if ($p.Value.PSObject.Properties['url'] -and $p.Value.PSObject.Properties['headersHelper']) {
                    # Remote (HTTP) server whose credentials come from a helper script, e.g. GitHub:
                    # tools\github-mcp-headers.mjs reads .env\github.token. At user scope the helper runs from
                    # ~/.claude, so register its absolute path. The secret never passes through this script.
                    if ([string]$p.Value.headersHelper -notmatch '^node\s+(\S+)$') {
                        Write-Warning "Skipping $name`: unsupported headersHelper format (expected 'node <relative path>')."; continue
                    }
                    $helperPath = (Join-Path $repo $Matches[1]) -replace '\\', '/'
                    $json = ([ordered]@{ type = 'http'; url = $p.Value.url; headersHelper = ('node "' + $helperPath + '"') } | ConvertTo-Json -Compress)
                    $addArgs = @('mcp', 'add-json', '--scope', 'user', $name, (ConvertTo-NativeArg $json))
                } elseif ($p.Value.PSObject.Properties['url']) {
                    # Remote (HTTP) server with static headers; values such as ${VAR} are stored as references.
                    $addArgs = @('mcp', 'add', '--scope', 'user', '--transport', 'http', $name, $p.Value.url)
                    if ($p.Value.PSObject.Properties['headers']) {
                        foreach ($h in $p.Value.headers.PSObject.Properties) { $addArgs += @('--header', ($h.Name + ': ' + $h.Value)) }
                    }
                } else {
                    $srvArgs = @($p.Value.args)
                    if ($srvArgs -contains '${ADO_ORG}') {
                        if (-not $AdoOrg) { Write-Warning "Skipping $name`: pass -AdoOrg <organization> to register it."; continue }
                        $srvArgs = $srvArgs | ForEach-Object { if ($_ -eq '${ADO_ORG}') { $AdoOrg } else { $_ } }
                    }
                    $addArgs = @('mcp', 'add', '--scope', 'user', '--transport', 'stdio', $name, '--', $p.Value.command) + $srvArgs
                }
                $out = Invoke-ClaudeCli $cli $addArgs
                if ($out -match 'already exists') {
                    if ($Force -or ($added -contains $name)) {
                        [void](Invoke-ClaudeCli $cli @('mcp', 'remove', $name, '--scope', 'user'))
                        $out = Invoke-ClaudeCli $cli $addArgs
                    } else {
                        Write-Warning "MCP server '$name' already exists in your user config; left unchanged (use -Force to replace)."; continue
                    }
                }
                if ($out -match 'Added') {
                    Write-Host "Registered MCP server $name (user scope)"
                    if ($added -notcontains $name) { $added += $name }
                } else { Write-Warning "Could not register MCP server ${name}: $out" }
            }
        }
        $envSet = [bool]$state.adoOrgEnvSet
        if ($InstallMcpServers -and $AdoOrg) {
            $current = [Environment]::GetEnvironmentVariable('ADO_ORG', 'User')
            if ($current -and $current -ne $AdoOrg -and -not $Force -and -not $envSet) {
                Write-Warning "ADO_ORG is already set to '$current'; left unchanged (use -Force to replace). The project .mcp.json will use that value."
            } elseif ($current -ne $AdoOrg) {
                [Environment]::SetEnvironmentVariable('ADO_ORG', $AdoOrg, 'User'); $envSet = $true
                Write-Host "Set ADO_ORG=$AdoOrg (user environment variable; restart VS Code to pick it up)"
            }
        }
        Write-Utf8NoBom $bundleStatePath ([pscustomobject]@{ mcpServers = $added; adoOrgEnvSet = $envSet } | ConvertTo-Json)
        if ($InstallMcpServers -and -not (Test-Path -LiteralPath (Join-Path $repo '.env\github.token'))) {
            Write-Warning 'GitHub MCP needs a token: run tools\set-github-token.ps1 (hidden prompt), then restart VS Code.'
        }
    }
}

Write-Host ''
Write-Host 'Done. Restart Claude Code / reload the VS Code window, then:'
Write-Host '  - Just ask:       with -MakeDefaultAgent every session self-routes your plain-language asks'
Write-Host '  - Main-thread:    claude --agent fermi   (per session, without -MakeDefaultAgent)'
Write-Host '  - Delegate:       type @ and pick the fermi agent'
Write-Host '  - Shortcuts:      /rca, /design-system, /idea-to-app, /dba, /ux-design, /brand, ... (optional)'
Write-Host '  - MCP servers:    -InstallMcpServers [-AdoOrg <org>] adds draw.io, GitHub, Azure DevOps; run /mcp to check'
Write-Host '  - GitHub token:   tools\set-github-token.ps1   |   Reverse engineering (opt-in): -InstallRea'
