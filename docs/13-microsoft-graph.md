# Microsoft Graph PowerShell

Install `Microsoft.Graph` for the current user, connect interactively with the
provided script, inventory users/groups, and disconnect. Delegated permissions
act as the signed-in user plus consented scopes; application permissions act as
an application and require stronger governance. The lab uses read-only delegated
scopes and does not persist credentials.

AD cmdlets manage LDAP-backed on-premises objects; Graph cmdlets call Microsoft
Graph for Entra/Microsoft 365 objects. Similar names do not imply the same source
of authority. Success is a consented context and CSV inventory; 403 means the
scope/role/consent is insufficient, while sign-in errors often indicate tenant or
Conditional Access policy.

Primary reference: [Microsoft Graph PowerShell authentication commands](https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands?view=graph-powershell-1.0).
The connection helper uses process-scoped authentication so its cached context
does not persist into later PowerShell sessions.
