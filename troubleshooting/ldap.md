# LDAP and LDAPS

**SYMPTOM:** directory query/application bind fails. **LIKELY CAUSES:** network,
firewall, DNS, bind identity, TLS certificate, or protocol policy. **COMMANDS:**
`Test-NetConnection DC01 -Port 53/88/389/445/636` (run separately), `ldp.exe`,
and Directory Service/System logs. **RESOLUTION:** fix the failing layer; for
LDAPS deploy a trusted certificate with correct EKU/name and validate the TLS
chain. **VALIDATION:** bind/query succeeds with intended encryption. **LESSON
LEARNED:** an open port does not prove a valid LDAP bind or trusted TLS channel.

