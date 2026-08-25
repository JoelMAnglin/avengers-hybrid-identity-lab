[CmdletBinding()]param([string]$OutputDirectory=(Join-Path (Split-Path $PSScriptRoot -Parent) 'reports'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory
if(-not(Test-Path $OutputDirectory)){New-Item -ItemType Directory $OutputDirectory|Out-Null}
Get-ADUser -Filter * -Properties Department,Title,Enabled,LastLogonDate|Select-Object Name,SamAccountName,UserPrincipalName,Department,Title,Enabled,LastLogonDate|Export-Csv (Join-Path $OutputDirectory 'users.csv') -NoTypeInformation
Get-ADGroup -Filter * -SearchBase "OU=Groups,OU=Avengers,$((Get-ADDomain).DistinguishedName)"|ForEach-Object{$g=$_;Get-ADGroupMember $g|Select-Object @{n='Group';e={$g.Name}},Name,ObjectClass}|Export-Csv (Join-Path $OutputDirectory 'group-memberships.csv') -NoTypeInformation

