# Build Validation Report

Date: 2026-08-22

## Completed locally

- Repository initialized on branch `main` with no configured remote.
- 72 project files created across documentation, PowerShell, Entra, Docker,
  datasets, diagrams, examples, and troubleshooting.
- All 16 PowerShell entry-point scripts passed the PowerShell parser.
- Core-file and basic committed-secret pattern checks passed.
- `docker compose config --quiet` passed with the pinned Compose definition.
- Fictional datasets contain 16 users, 15 groups, and 6 departments.
- Hybrid/Graph guidance was cross-checked against Microsoft Learn on 2026-08-22;
  primary links are embedded in docs 12 and 13.

## Intentionally not performed

- No Git commit, GitHub repository, remote, push, release, or external upload.
- No AD DS deployment: requires the DC01 Windows Server VM and an authorized
  reboot/promotion.
- No client join or GPO-result validation: requires CLIENT01/MGMT01.
- No Entra tenant, consent, or synchronization changes: requires the operator's
  tenant/licensing decisions.
- No Windows exporter/event collection test: requires DC01 and the monitoring
  network path.

## Acceptance path

Follow `docs/20-validation.md`. Static validation proves repository integrity,
not the behavior of a domain, tenant, or Windows event pipeline. Record VM/cloud
evidence under ignored `reports/` and sanitized screenshots before the first
commit or GitHub publication.
