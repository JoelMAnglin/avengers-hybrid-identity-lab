# Troubleshooting Index

Use evidence in this order:

1. Record the exact symptom, timestamp, affected identity/device, and last known
   successful test. Redact passwords, tokens, tenant IDs, and public addresses.
2. Establish scope: one user, one workstation, one site, or the whole domain.
3. Record recent changes and preserve current command output and event logs.
4. Verify dependencies from the bottom up: link/IP, DNS, time, DC discovery,
   ports, authentication, directory/object state, and finally policy/application.
5. Form one testable hypothesis. Apply one reversible correction only.
6. Repeat the original failing test, not a substitute test, and record the result.
7. Roll back if validation fails; otherwise capture the root cause and prevention.

The [troubleshooting journal](22-troubleshooting-journal.md) contains the exact
workflow, copy/paste evidence commands, completed build incidents, and a reusable
incident template. The [live build walkthrough](21-live-build-walkthrough.md)
separates observed evidence from planned or optional work.

- `troubleshooting/dns.md` — name and DC discovery
- `troubleshooting/kerberos.md` — tickets, time, SPNs
- `troubleshooting/ldap.md` — LDAP/LDAPS and ports
- `troubleshooting/account-lockouts.md` — 4740 evidence and credential sources
- `troubleshooting/group-policy.md` — scope/inheritance/SYSVOL
- `troubleshooting/replication.md` — multi-DC health
- `troubleshooting/entra-sync.md` — scope, attributes, agent/provisioning logs

Never "fix" several layers at once. Preserve timestamps, command output, event
IDs, and the exact validation result in an incident note.

## Safe evidence collection

Create an ignored local folder before collecting output:

```powershell
New-Item -ItemType Directory -Path .\reports -Force
Start-Transcript -Path ".\reports\triage-$((Get-Date).ToString('yyyyMMdd-HHmmss')).txt"
```

Stop with `Stop-Transcript`. Review every artifact before sharing it. The
repository ignores `reports/`, transcripts, secrets files, exported certificates,
and common private-key formats; ignored does not mean safe, so inspect staged
files with `git diff --cached` before every commit.
