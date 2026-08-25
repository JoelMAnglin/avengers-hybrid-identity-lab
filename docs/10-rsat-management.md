# RSAT Management

On domain-joined CLIENT01/MGMT01, install capabilities from an elevated shell:

```powershell
Get-WindowsCapability -Online -Name RSAT.ActiveDirectory* | Add-WindowsCapability -Online
Get-WindowsCapability -Online -Name RSAT.GroupPolicy* | Add-WindowsCapability -Online
```

Use a separate privileged account and a hardened admin workstation. Routine DC
interactive logon expands the attack surface. Validate `Get-ADUser`,
`Get-ADGroup`, `Get-ADComputer`, and `Get-ADDomainController` from MGMT01.

