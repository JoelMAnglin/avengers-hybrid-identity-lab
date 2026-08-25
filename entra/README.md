# Microsoft Graph tools

These scripts use interactive delegated authentication and read-only
`User.Read.All`/`Group.Read.All` scopes. An Entra administrator may need to grant
consent. Install `Microsoft.Graph` from PowerShell Gallery, run
`Connect-MicrosoftGraph.ps1`, then inventory or compare identities. Do not use
legacy AzureAD/MSOnline examples, store tokens, or commit exported tenant data.
Disconnect with `Disconnect-MgGraph` when finished.

