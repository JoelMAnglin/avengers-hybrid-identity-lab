[CmdletBinding()]param([string]$TenantId)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop'
if(-not(Get-Module -ListAvailable Microsoft.Graph.Authentication)){throw 'Install for the current user: Install-Module Microsoft.Graph -Scope CurrentUser'}
Import-Module Microsoft.Graph.Authentication
$params=@{Scopes=@('User.Read.All','Group.Read.All');NoWelcome=$true;ContextScope='Process'};if($TenantId){$params.TenantId=$TenantId}
Connect-MgGraph @params
Get-MgContext|Select-Object Account,TenantId,Scopes,AuthType
