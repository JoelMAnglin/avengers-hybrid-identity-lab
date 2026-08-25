# DNS

**SYMPTOM:** Domain join/DC discovery/logon fails. **LIKELY CAUSES:** public DNS,
wrong NIC registration, missing SRV record, firewall, or DNS service stopped.
**INVESTIGATION/COMMANDS:** `ipconfig /all`, `Get-DnsClientServerAddress`,
`Resolve-DnsName dc01.avengers.lab`, `Resolve-DnsName
_ldap._tcp.dc._msdcs.avengers.lab -Type SRV`, `nltest /dsgetdc:avengers.lab`,
`Test-NetConnection DC01 -Port 53`. **RESOLUTION:** point the client only at
10.10.10.10, correct registration/records, start DNS, then `ipconfig /flushdns`
and `/registerdns`. **VALIDATION:** SRV and DC locator succeed. **LESSON LEARNED:**
AD finds services through DNS; an A record alone is insufficient.

