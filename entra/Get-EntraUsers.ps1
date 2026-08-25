[CmdletBinding()]param([string]$OutputPath=(Join-Path $PSScriptRoot '../reports/entra-users.csv'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module Microsoft.Graph.Users
$folder=Split-Path $OutputPath -Parent;if(-not(Test-Path $folder)){New-Item -ItemType Directory $folder|Out-Null}
Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,AccountEnabled,OnPremisesSyncEnabled,OnPremisesSamAccountName|Select-Object Id,DisplayName,UserPrincipalName,AccountEnabled,OnPremisesSyncEnabled,OnPremisesSamAccountName|Export-Csv $OutputPath -NoTypeInformation

