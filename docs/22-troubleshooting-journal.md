# Troubleshooting Journal

This document makes the lab's diagnostic process reproducible. It records the
issues actually encountered during the build, the evidence used to distinguish
symptoms from causes, the correction applied, and the validation that closed
each incident. Commands are examples for this isolated `avengers.lab` lab only.

## Standard diagnostic workflow

### 1. Capture the failure before changing anything

Record UTC/local time, the exact command or UI action, the full error, affected
user/computer, and whether the issue worked previously. Take a VM snapshot only
when the guest is in a safe state. Never put credentials or unredacted tenant
details in a screenshot, transcript, issue, or commit.

```powershell
Get-Date -Format o
hostname
whoami
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,LastBootUpTime
```

### 2. Establish scope and recent change

Repeat the same test with one known-good identity or device when safe. Ask what
changed immediately before failure: VM adapter, DNS, clock, password, group
membership, GPO link, certificate, firewall, service, or synchronization scope.
Do not clear logs, purge tickets, unlock accounts, or restart services yet.

### 3. Validate dependencies bottom-up

Run each command in its own elevated PowerShell session where required:

```powershell
Get-NetAdapter
Get-NetIPConfiguration
Get-DnsClientServerAddress -AddressFamily IPv4
Resolve-DnsName dc01.avengers.lab
Resolve-DnsName _ldap._tcp.dc._msdcs.avengers.lab -Type SRV
w32tm /query /status
nltest /dsgetdc:avengers.lab
Test-NetConnection dc01.avengers.lab -Port 53
Test-NetConnection dc01.avengers.lab -Port 88
Test-NetConnection dc01.avengers.lab -Port 389
Test-NetConnection dc01.avengers.lab -Port 445
```

Only test port 636 after LDAPS is intentionally configured. A successful TCP
test proves reachability, not a successful bind, trusted certificate, or healthy
application protocol.

### 4. Inspect the failing layer

- DNS/DC discovery: use `troubleshooting/dns.md`.
- Kerberos/tickets/time/SPNs: use `troubleshooting/kerberos.md`.
- LDAP/LDAPS/binds/certificates: use `troubleshooting/ldap.md`.
- Repeated lockout: use `troubleshooting/account-lockouts.md`.
- GPO scope/resultant set: use `troubleshooting/group-policy.md`.
- Multi-DC divergence: use `troubleshooting/replication.md`.
- On-premises-to-Entra object state: use `troubleshooting/entra-sync.md`.

Export only the narrow event window needed. Useful IDs include 4625 (failed
logon), 4740 (lockout), 4768/4769 (Kerberos), and GroupPolicy Operational events.
Record the source computer and status/substatus rather than guessing from the ID.

### 5. Correct one cause and validate the original symptom

Write the hypothesis first. Prefer a reversible correction. Re-run the exact
original operation and at least one independent health test. If it still fails,
roll back the change where practical and return to evidence collection.

## Completed incident record

### INC-01: VM did not boot from installation media

- Symptom: UEFI stopped at `Press any key to boot from CD or DVD`.
- Evidence: the Server ISO was detected by VirtualBox and Windows Boot Manager
  was available, so the media was readable.
- Cause: boot timing/input focus, not corrupt installation media.
- Correction: send repeated Space scan codes, then press Enter in Windows Boot
  Manager to select Setup.
- Validation: Windows Setup loaded and both guests completed installation.
- Prevention: confirm optical boot order and keep the VM console focused during
  the short UEFI prompt.

### INC-02: Windows rolled back a pending setup change

- Symptom: after a forced power-off, DC01 displayed `Something didn't go as
  planned` and rolled back changes.
- Evidence: the desktop had appeared, but Windows servicing was still pending.
- Cause: host-side power-off interrupted guest servicing.
- Correction: allow rollback to complete; use elevated in-guest `shutdown` and
  wait for VirtualBox to report `poweroff` for later shutdowns.
- Validation: DC01 booted normally and later completed AD DS promotion.
- Prevention: treat desktop arrival as insufficient evidence of servicing
  completion; prefer guest-aware shutdown and snapshot only after clean poweroff.

### INC-03: Forwarded SSH port opened but no banner arrived

- Symptom: host TCP `127.0.0.1:5522` connected, but SSH timed out before banner.
- Evidence: the NAT rule and TCP handshake worked; the application response did
  not. Guest Additions run level also did not make guest execution available.
- Cause: the optional guest management application path was unhealthy even
  though its transport/integration indicators looked available.
- Correction: stop treating SSH/guestcontrol as a domain-build dependency. Use
  the elevated guest console and a temporary, non-secret HTTP transfer channel.
- Validation: files transferred on host port 8765 and the build continued.
- Prevention: validate the application protocol, not merely an open socket.

### INC-04: Proposed transfer port was already occupied

- Symptom: host port 8000 could not be safely assigned to the temporary server.
- Evidence: listener ownership showed it belonged to an existing Splunk service.
- Cause: local port collision.
- Correction: leave the existing service untouched and bind the temporary server
  to port 8765.
- Validation: the intended process owned 8765 and the guest downloaded the files.
- Prevention: check listener ownership before selecting a host port.

```powershell
Get-NetTCPConnection -State Listen | Where-Object LocalPort -In 8000,8765
Get-Process -Id (Get-NetTCPConnection -State Listen -LocalPort 8765).OwningProcess
```

### INC-05: OU provisioning terminated on a missing object

- Symptom: the OU creation script stopped before creating a missing OU.
- Evidence: the existence probe used `Get-ADOrganizationalUnit -Identity` and the
  missing distinguished name generated a terminating error.
- Cause: a lookup intended as a Boolean existence test used identity semantics.
- Correction: query with an exact distinguished-name filter and handle an empty
  result as the expected create path.
- Validation: a clean run created the hierarchy; a second run made no duplicate
  OUs and completed successfully.
- Prevention: test both first-run and repeat-run behavior for every provisioning
  function.

### INC-06: Empty group membership failed under strict mode

- Symptom: group provisioning failed when a target group had no existing members.
- Evidence: strict mode rejected scalar/property access on an empty result.
- Cause: the script assumed membership output was always a populated collection.
- Correction: materialize a safe array of member distinguished names before
  comparison.
- Validation: empty and populated groups both processed; a repeat run remained
  idempotent.
- Prevention: test zero-, one-, and many-item PowerShell pipeline output.

### INC-07: Empty GPO links and HTML fragments broke reporting

- Symptom: validation/report generation produced strict-mode and parameter-binding
  failures in environments with no links or nested body fragments.
- Evidence: failures correlated with empty GPO-link output and array-valued HTML.
- Cause: collection shape was not normalized at command boundaries.
- Correction: normalize links to arrays and HTML body content to a single string.
- Validation: reports generated successfully with empty and populated data.
- Prevention: define and normalize function input/output shapes explicitly.

### INC-08: KDS root key creation was unsupported in this guest

- Symptom: both immediate and backdated KDS root-key creation returned
  `0x80070032` on the Server 2025 VM.
- Evidence: both supported invocation styles failed consistently; other AD
  provisioning and health tests passed.
- Cause: the precise guest/platform limitation was not proven, so the lab records
  the result as unsupported rather than inventing a cause.
- Correction: keep the gMSA phase optional and create disabled traditional
  service-account placeholders without passwords.
- Validation: placeholders existed disabled; no claim of working gMSA was made.
- Prevention: gate optional features on a prerequisite test and report `skipped`
  separately from `passed`.

### INC-09: Group Policy refresh exposed clock skew

- Symptom: the first client `gpupdate /force` failed after domain join.
- Evidence: client time was not following the domain hierarchy; DNS and join
  state were otherwise valid.
- Cause: clock skew disrupted domain authentication/policy processing.
- Correction: configure CLIENT01 for domain-hierarchy time and restart Windows
  Time, then refresh policy again.
- Validation: computer and user policy completed; `gpresult` showed the expected
  computer DN and four applied policies documented in the live walkthrough.
- Prevention: validate time before Kerberos, domain join, and GPO testing.

## Closure checklist

- [ ] Original failing operation now succeeds.
- [ ] Independent health check succeeds.
- [ ] No unrelated security control was weakened.
- [ ] Temporary listeners, files, or firewall rules were removed.
- [ ] Root cause distinguishes proven evidence from inference.
- [ ] Prevention or monitoring action is recorded.
- [ ] Evidence was reviewed for secrets and stored under ignored `reports/`.

## Blank incident template

```text
ID / title:
Date, timezone, operator:
Affected user/device/service:
Exact symptom and error:
Last known success:
Scope and recent change:
Evidence collected:
Hypothesis:
Single correction and rollback plan:
Original-test validation:
Independent validation:
Root cause (proven / inferred):
Prevention:
Redaction and cleanup completed:
```
