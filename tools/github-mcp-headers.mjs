#!/usr/bin/env node
// Supplies the Authorization header for GitHub's hosted MCP server.
// Claude Code runs this as the server's `headersHelper` and reads one JSON object from stdout.
//
// The token is read from <repo>/.env/github.token (git-ignored). It is never taken from arguments, never
// logged, and only handed out when Claude Code is connecting to GitHub's MCP host. Do not run this by hand:
// outside that context it refuses, so the token is not printed to a terminal or into an agent's context.

import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const ALLOWED_HOST = 'api.githubcopilot.com';
const tokenFile = join(dirname(fileURLToPath(import.meta.url)), '..', '.env', 'github.token');

function fail(message) {
  process.stderr.write(`github-mcp-headers: ${message}\n`);
  process.exit(1);
}

let host = '';
try {
  const url = new URL(process.env.CLAUDE_CODE_MCP_SERVER_URL || '');
  if (url.protocol === 'https:') host = url.hostname;
} catch {
  // handled below
}
if (host !== ALLOWED_HOST) {
  fail(`refusing to output the token: this helper only answers Claude Code connecting to https://${ALLOWED_HOST}.`);
}

let token = '';
try {
  token = readFileSync(tokenFile, 'utf8').replace(/^﻿/, '').trim();
} catch {
  fail(`token file not found (${tokenFile}). Run tools/set-github-token.ps1; see INSTALL.md section 3.`);
}
if (!token || /\s/.test(token)) {
  fail(`token file is empty or contains whitespace (${tokenFile}). Store the token again.`);
}

process.stdout.write(JSON.stringify({ Authorization: `Bearer ${token}` }));
