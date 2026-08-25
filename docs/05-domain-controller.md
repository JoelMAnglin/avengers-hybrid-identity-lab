# Domain Controller

Run prerequisite checks on DC01 after static networking. Take snapshot
`01-Static-IP-Configured`, then execute `01-Install-ADDS.ps1` elevated. It
installs AD DS/DNS, securely prompts for DSRM, creates `avengers.lab`, and
reboots. After reboot, sign in as `AVENGERS\Administrator` and validate:

```powershell
Get-ADDomain
Get-ADForest
Get-ADDomainController
dcdiag /v
Resolve-DnsName _ldap._tcp.dc._msdcs.avengers.lab -Type SRV
```

Save `dcdiag` output, resolve errors before automation, and take snapshots
`02-ADDS-Installed`/`03-Avengers-Domain-Created`. DSRM is a recovery credential;
store it outside Git and test the recovery process in a disposable snapshot.

