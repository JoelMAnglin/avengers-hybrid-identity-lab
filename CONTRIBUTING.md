# Contributing

Use a feature branch, keep changes focused, and use Conventional Commit-style
messages such as `feat: automate Avengers OU creation` or
`docs: add DNS troubleshooting lab`.

Before proposing a change:

1. Run `powershell/Invoke-ProjectValidation.ps1` in PowerShell 7 or Windows PowerShell.
2. Run affected scripts with `-WhatIf` where supported.
3. Remove generated reports, logs, tenant identifiers, and screenshots with secrets.
4. Update the relevant guide and `CHANGELOG.md`.

Administrative scripts must remain rerunnable, validate inputs, use terminating
errors for failed operations, and avoid logging passwords.

