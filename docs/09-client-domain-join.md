# CLIENT01 Domain Join

Set CLIENT01 internal IP to `10.10.10.20/24`, no internal gateway, and DNS only
`10.10.10.10`. Confirm Windows Pro/Enterprise, time, SRV lookup, and DC discovery.

GUI: Settings → System → About → Domain or workgroup → join `avengers.lab`.
PowerShell:

```powershell
$credential = Get-Credential 'AVENGERS\Administrator'
Add-Computer -DomainName avengers.lab -Credential $credential -Restart
```

After restart validate `whoami`, `hostname`, `nltest /dsgetdc:avengers.lab`,
`Resolve-DnsName dc01.avengers.lab`, and test `AVENGERS\pparker`. Move the
computer object into the Workstations OU before GPO testing.

