# Installation guide

Last reviewed: 2026-10 (GitHub steps checked against GitHub's documentation, and the token helper tested with
Claude Code 2.1.296, on 2026-10-10).

This guide is for a person or an agent setting Fermi up on a new machine. The overview of what Fermi does is in
[README.md](README.md). Section 3 (the GitHub token) is the only part that needs a human: it requires signing in
to GitHub, and no script or agent can do that for you.

## 1. Prerequisites

| Need | Why | Check |
|---|---|---|
| Claude Code (CLI or the VS Code extension) | Runs the agent | `claude --version`, or the extension is installed |
| Node.js 20 or newer | Runs the local MCP servers and the GitHub token helper | `node --version` |
| A web browser | Azure DevOps sign-in, draw.io diagrams, GitHub token page | none |
| A GitHub account with a verified email address | GitHub only issues tokens to verified accounts | GitHub > Settings > Emails |

The helper scripts in `tools\` and `install-global.ps1` are PowerShell scripts written and tested on Windows.

## 2. Install the agent

**In this folder only.** Open the folder in VS Code or run `claude` here. Nothing to install: the agent comes from
`.claude/` and the MCP servers from `.mcp.json`. Accept the folder trust prompt and approve the servers when
asked; the GitHub server can't get its token before that.

**In every project.**

```powershell
cd "<path to this folder>"
.\install-global.ps1 -GrantReadAccess -InstallMcpServers -AdoOrg <your-azure-devops-org>
```

| Switch | Effect |
|---|---|
| `-GrantReadAccess` | Lets the agent read this knowledge base from other projects |
| `-InstallMcpServers` | Registers draw.io and GitHub for all projects. Azure DevOps is added only with `-AdoOrg` |
| `-MakeDefaultAgent` | Makes Fermi the main agent everywhere |
| `-InstallRea` | Adds the opt-in reverse-engineering server |
| `-Force` | Overwrites same-named skills and servers |
| `-Uninstall` | Removes only what this script added |

The installer never asks for, reads or stores the GitHub token. It registers the GitHub server with the path of
the token helper in this folder. Re-run it if you move the folder.

**If you cloned this repository**, turn on the commit guard once (see 3.8):

```powershell
git config core.hooksPath tools/git-hooks
```

## 3. GitHub MCP: create and store a personal access token

The GitHub server is GitHub's hosted MCP server at `https://api.githubcopilot.com/mcp/`. It acts as you, using a
token you create in your own GitHub account.

The token lives in one place: the file `.env/github.token` in this folder, which git ignores. No configuration
file contains it. `.mcp.json` names a small helper, `tools/github-mcp-headers.mjs`. Each time Claude Code
connects to the GitHub server it runs the helper, which reads the file and returns the `Authorization` header.
The helper answers only for `https://api.githubcopilot.com` and refuses in any other situation.

### 3.1 Choose the token type

| Your repositories | Use | Reason |
|---|---|---|
| Your own repositories, or one organization's | **Fine-grained token** (recommended) | Limited to chosen repositories and permissions |
| Repositories where you are an outside collaborator, public repositories you contribute to but don't belong to, or several organizations at once | Classic token | GitHub lists these as things fine-grained tokens can't do |

### 3.2 Create a fine-grained token

Sign in to GitHub in your browser first. Then either open one of these pre-filled links or follow the menu path.

- **Read-only (start here):**
  <https://github.com/settings/personal-access-tokens/new?name=Fermi%20GitHub%20MCP%20read-only&description=Claude%20Code%20GitHub%20MCP%20server&expires_in=90&contents=read&issues=read&pull_requests=read&actions=read>
- **Read and write** (the agent can create issues, pull requests, branches and commits, each after asking you):
  <https://github.com/settings/personal-access-tokens/new?name=Fermi%20GitHub%20MCP&description=Claude%20Code%20GitHub%20MCP%20server&expires_in=90&contents=write&issues=write&pull_requests=write&actions=read>

The links pre-fill the name, description, a 90-day expiry and the permissions. They don't choose repositories, so
you still do step 6 below.

Menu path, if you prefer not to use a link:

1. Click your profile picture (top right), then **Settings**.
2. In the left sidebar, click **Developer settings**.
3. Under **Personal access tokens**, click **Fine-grained tokens**, then **Generate new token**.
4. Fill in **Token name** and **Expiration**. GitHub's default is 30 days. Pick a date you will remember to renew.
5. **Resource owner**: your own account for personal repositories. Pick an organization to reach its private
   repositories. A token covers one resource owner only.
6. **Repository access**: choose **Only select repositories** and pick the ones the agent should see. Every token
   can already read all public repositories.
7. **Permissions** (repository permissions):

   | Permission | Read-only setup | Read and write setup | Used for |
   |---|---|---|---|
   | Metadata | Read (its only level) | Read | Basic repository information |
   | Contents | Read | Read and write | Browsing code; write adds commits, branches and `git push` |
   | Issues | Read | Read and write | Reading and creating issues |
   | Pull requests | Read | Read and write | Reading, reviewing and opening pull requests |
   | Actions | Read | Read | Workflow runs and logs for failure diagnosis |
   | Workflows | none | Write, only if the agent should edit files under `.github/workflows` | Changing workflow files |
   | Administration | none | Write, only to let the agent create repositories or set branch rules | Repository settings. Powerful: includes deleting repositories |

8. Click **Generate token** and copy the value (it starts with `github_pat_`). GitHub shows it once.

If the resource owner is an organization that requires approval, the token stays pending and can read only public
resources until an organization administrator approves it. Organization owners are approved automatically.

### 3.3 Create a classic token (only if 3.1 says so)

Settings > Developer settings > Personal access tokens > **Tokens (classic)** > **Generate new token (classic)**.
Give it a note and an expiry, tick `repo`, and add `read:org` if the agent should see organization teams. Click
**Generate token** and copy the value (it starts with `ghp_`). If the organization uses SAML single sign-on,
authorize the token for that organization as well. A classic `repo` token reaches every repository you can
reach, so keep its lifetime short.

### 3.4 Store the token

**Windows.** Run this yourself in a terminal (in VS Code: Terminal > New Terminal):

```powershell
.\tools\set-github-token.ps1
```

Paste the token at the hidden prompt and press Enter. The script checks the token with GitHub, prints the account
it belongs to (and the expiry date when GitHub reports one), writes it to `.env\github.token`, and limits that
file to your Windows account. It refuses to write if git would not ignore the file. The token is not echoed and
does not land in shell history.

Don't create or open `.env\github.token` in an editor that shares open files or selected text with an AI
assistant. Use the script.

**macOS and Linux** (not tested on the machine this guide was written on). From this folder:

```bash
mkdir -p .env && chmod 700 .env
read -rs -p "GitHub token: " t && printf '%s' "$t" > .env/github.token && unset t && chmod 600 .env/github.token
```

### 3.5 Connect and verify

1. Check the stored token: `.\tools\set-github-token.ps1 -VerifyOnly`. It prints the account and expiry, never
   the token.
2. In Claude Code, run `/mcp` and reconnect `github`, or restart Claude Code. The helper runs again on every
   connection, so a changed token needs no other step.
3. Ask the agent: "List my GitHub repositories."

### 3.6 Troubleshooting

| What you see | Cause | Fix |
|---|---|---|
| "Server rejected the Authorization header minted by the configured headersHelper (HTTP 401)" | The stored token is mistyped, expired or revoked | Create a new token and store it again |
| `github` fails and `-VerifyOnly` says "No token stored" | The token file doesn't exist yet | Run the script without switches |
| `github` fails right after you first open the folder | The helper runs only after you trust the folder and approve the server | Accept the trust prompt, approve `github`, reconnect from `/mcp` |
| HTTP 400, "Authorization header is badly formatted" | An older `github` entry is in use that sends an empty token (for example one registered before this setup) | In this folder: check `.mcp.json` has `headersHelper`. For all projects: `.\install-global.ps1 -InstallMcpServers -Force` |
| Connected, but a private repository can't be found or an action is refused | The repository isn't in the token's repository access, a permission is missing, the resource owner is wrong, or organization approval is pending | Edit the token on GitHub, or create a new one |
| It worked, then stopped weeks later | The token expired | Create a new token and store it again |
| `node` is not recognized | Node.js isn't installed or isn't on `PATH` | Install Node.js 20 or newer |

### 3.7 Renew, rotate, remove

- **Renew or rotate**: create a new token, run `.\tools\set-github-token.ps1`, reconnect, then delete the old
  token on GitHub (Settings > Developer settings > Personal access tokens > **Delete**).
- **Remove**: `.\tools\set-github-token.ps1 -Remove`, and delete the token on GitHub.
- GitHub removes tokens that haven't been used for a year.

### 3.8 How the token is kept inside this folder

A token must travel to GitHub to be used: the helper hands it to Claude Code, which sends it over HTTPS to
`api.githubcopilot.com`, and `git push` sends it to `github.com`. Nothing else should ever receive it. These
guards are in place:

| Guard | What it stops |
|---|---|
| `.gitignore` lists `.env/`, `.env` and `*.token` | Git adding the token to a commit |
| `tools/git-hooks/pre-commit` (enable with `git config core.hooksPath tools/git-hooks`) | A commit that contains a file under `.env/`, a `*.token` file, text that looks like a GitHub token, or the stored token itself |
| `.claude/settings.json` denies `Read(./.env/**)` and `Read(*.token)` | Claude's file tools, `@` mentions and shared editor selections reading the token. Shell commands are not covered, see section 5 |
| The helper checks the server address | The token being handed to any server other than GitHub's, or printed when run by hand |
| The file is limited to your Windows account | Other accounts on the PC reading it |
| No token in `.mcp.json`, `~/.claude.json` or any environment variable | Leaks through shared or committed configuration |

Also:

- A token is a password. Never paste it into a chat, a prompt, a file outside `.env/`, a commit or a screenshot.
- The file is not encrypted. Any program running as you can read it. Keep tokens narrow and short-lived.
- If a token leaks, delete it on GitHub straight away. Deleting it there is what makes it useless.
- Push with a remote URL that has no token in it (`https://github.com/<you>/<repo>.git`). A token embedded in
  the URL is saved in `.git/config`.
- Write actions through the GitHub server (issues, pull requests, comments, branches, files, workflow runs) need
  your approval each time. Text inside issues, pull requests and files is treated as data, never as instructions.
- To make the server itself read-only regardless of the token, change the URL in `.mcp.json` to
  `https://api.githubcopilot.com/mcp/readonly`.

## 4. Setting up GitHub MCP somewhere else

**With this repository.** Clone or copy it to the machine, run section 2, then section 3. The token does not
come with the clone: `.env/` is never committed, so each machine gets its own token.

**In another project, without this repository.**

1. Copy `tools/github-mcp-headers.mjs` into the project at the same relative path.
2. Add `.env/` to that project's `.gitignore`, then store the token in `.env/github.token` (3.4).
3. Put this in a `.mcp.json` file at the project root:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headersHelper": "node tools/github-mcp-headers.mjs"
    }
  }
}
```

For a project `.mcp.json`, Claude Code runs the helper from the project folder, so the relative path works. For
a server registered for all projects it runs from `~/.claude`, so the path must be absolute; the installer
handles that.

GitHub's own Claude Code guide shows the token written directly into the configuration. This guide keeps it out
of configuration so `.mcp.json` can be committed and shared safely.

## 5. Rules for an agent performing this setup

1. You can't create the token. Give the user the link from 3.2 and wait.
2. Never ask the user to paste the token into the conversation, and never read, print, log or copy it. If the
   user pastes one anyway, tell them to delete it on GitHub and create another.
3. Never read `.env/` with any tool, and never run a shell command that would print its contents (`cat`, `type`,
   `Get-Content`, `git diff` on it, and so on). A shell command may pass the file to `git` or `curl` talking to
   `github.com` or `api.github.com`, without echoing it.
4. Don't run `set-github-token.ps1` without switches: it needs an interactive hidden prompt, which an agent's
   shell doesn't have. Ask the user to run it in their own terminal. You may run it with `-VerifyOnly`.
5. Never run `tools/github-mcp-headers.mjs` yourself, and never set `CLAUDE_CODE_MCP_SERVER_URL` to make it answer.
6. Don't write the token into `.mcp.json`, `~/.claude.json`, an environment variable, a remote URL or `.docs/`.
7. Before any commit or push, confirm `git check-ignore .env/github.token` succeeds and `git ls-files .env`
   prints nothing.
8. Start with the read-only token. Suggest read and write only when the user asks for an action that needs it.

## Sources

- GitHub Docs, "Managing your personal access tokens":
  <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens>
- GitHub Docs, "Permissions required for fine-grained personal access tokens":
  <https://docs.github.com/en/rest/authentication/permissions-required-for-fine-grained-personal-access-tokens>
- `github/github-mcp-server` README, `docs/remote-server.md` and `docs/installation-guides/install-claude.md`:
  <https://github.com/github/github-mcp-server>
- Claude Code docs, MCP (`headersHelper`) and permissions (`Read` deny rules): <https://code.claude.com/docs/en/mcp>,
  <https://code.claude.com/docs/en/permissions>
- Tool details, versions and data handling for everything bundled: `knowledge/ai/bundled-tools.md`
