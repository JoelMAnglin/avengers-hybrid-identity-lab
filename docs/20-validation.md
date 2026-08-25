# Operator Acceptance Checklist

## Local static gate

Run `powershell/Invoke-ProjectValidation.ps1`. It parses every PowerShell file,
checks core assets, performs a basic secret scan, and validates Compose when
Docker is available. This does not prove administrative behavior.

## DC01 gate

- `dcdiag /v` has no unexplained failures; AD DNS SRV records resolve.
- All protected OUs, 15 CSV groups, and 16 CSV users exist.
- Department membership and AGDLP nesting match the datasets.
- Default domain policy and linked GPOs match the approved design.
- Health/report scripts produce redacted output and critical services are running.

## CLIENT01/MGMT01 gate

- Client uses DC01 DNS, locates the domain, joins successfully, and logs on a test user.
- Workstation object is in the correct OU and `gpresult` shows expected GPOs.
- RSAT queries work under the intended administrator identity.

## Optional cloud/monitoring gates

- Graph context has only intended scopes; comparison explains every mismatch.
- Sync scope and verified UPN design are recorded; test object source is correct.
- Compose is healthy, Windows exporter target is up, and a test event reaches Loki.

Attach evidence in ignored `reports/` and screenshots. Do not mark a VM-dependent
gate complete based solely on static code validation.

