[CmdletBinding()]param([string]$OutputPath=(Join-Path $PSScriptRoot '../reports/entra-groups.csv'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module Microsoft.Graph.Groups
$folder=Split-Path $OutputPath -Parent;if(-not(Test-Path $folder)){New-Item -ItemType Directory $folder|Out-Null}
Get-MgGroup -All -Property Id,DisplayName,MailEnabled,SecurityEnabled,OnPremisesSyncEnabled|Select-Object Id,DisplayName,MailEnabled,SecurityEnabled,OnPremisesSyncEnabled|Export-Csv $OutputPath -NoTypeInformation

