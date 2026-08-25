[CmdletBinding(SupportsShouldProcess)]
param([string]$MapPath=(Join-Path (Split-Path $PSScriptRoot -Parent) 'data/departments.csv'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'modules/AvengersLab/AvengersLab.psm1') -Force
$null=Get-LabDomainContext;$log=New-LabLogPath 'memberships';$maps=Import-Csv -LiteralPath $MapPath
foreach($map in $maps){
 $groups=@($map.PrimaryGroup)+@($map.AdditionalGroups -split ';'|Where-Object{$_})
 $users=Get-ADUser -Filter "Department -eq '$($map.Department)'"
 foreach($user in $users){foreach($group in $groups){
  $memberDns=@(Get-ADGroupMember -Identity $group -Recursive:$false | ForEach-Object DistinguishedName)
  if($memberDns -contains $user.DistinguishedName){Write-LabAudit $log AddMembership "$($user.SamAccountName)->$group" Skipped 'Already a direct member';continue}
  if($PSCmdlet.ShouldProcess($group,"Add $($user.SamAccountName)")){Add-ADGroupMember -Identity $group -Members $user;Write-LabAudit $log AddMembership "$($user.SamAccountName)->$group" Success}
 }}
}
Write-LabStatus PASS "Membership processing complete. Log: $log"
