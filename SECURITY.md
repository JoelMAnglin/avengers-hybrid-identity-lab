# Security Policy

This repository is a lab template. Never use its fictional identities, example
password placeholders, or deliberately insecure exercises in production.

## Secret handling

- Never commit passwords, tenant secrets, tokens, private keys, certificates,
  recovery keys, or screenshots containing credentials.
- Copy `secrets.example.psd1` to `secrets.psd1`; the latter is ignored by Git.
- Prefer `Get-Credential`, `Read-Host -AsSecureString`, managed identities, or
  delegated Microsoft Graph sign-in.
- Review staged content with `git diff --cached` before every commit.
- If a secret is committed, revoke/rotate it first; removing it from the latest
  commit does not remove it from history.

Report security issues privately to the repository owner. Do not include live
credentials or sensitive tenant data in a report.

