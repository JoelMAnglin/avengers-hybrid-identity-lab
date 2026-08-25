[CmdletBinding()]param([string]$OutputPath=(Join-Path $PSScriptRoot '../reports/hybrid-comparison.csv'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory,Microsoft.Graph.Users
$ctx=Get-MgContext;if(-not$ctx){throw 'Connect first with Connect-MicrosoftGraph.ps1'}
$cloud=Get-MgUser -All -Property UserPrincipalName,AccountEnabled,OnPremisesSyncEnabled,OnPremisesSamAccountName
$byUpn=@{};foreach($c in $cloud){$byUpn[$c.UserPrincipalName.ToLowerInvariant()]=$c}
$report=Get-ADUser -Filter * -SearchBase "OU=Users,OU=Avengers,$((Get-ADDomain).DistinguishedName)" -Properties UserPrincipalName,Enabled|ForEach-Object{
 $match=$byUpn[$_.UserPrincipalName.ToLowerInvariant()]
 [pscustomobject]@{LocalUsername=$_.SamAccountName;UPN=$_.UserPrincipalName;EntraObjectMatch=[bool]$match;OnPremEnabled=$_.Enabled;EntraEnabled=if($match){$match.AccountEnabled}else{$null};SyncEnabled=if($match){$match.OnPremisesSyncEnabled}else{$null};Warning=if(-not$match){'Missing in Entra'}elseif($_.Enabled-ne$match.AccountEnabled){'Enabled-state mismatch'}else{''}}
}
$folder=Split-Path $OutputPath -Parent;if(-not(Test-Path $folder)){New-Item -ItemType Directory $folder|Out-Null};$report|Export-Csv $OutputPath -NoTypeInformation;$report

