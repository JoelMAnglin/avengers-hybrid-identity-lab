[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]param([Parameter(Mandatory)][string]$Username,[Parameter(Mandatory)][ValidateSet('Executive','Engineering','Security','Operations','Research','Contractors')][string]$NewDepartment,[Parameter(Mandatory)][string]$NewTitle,[string]$RequestId)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory
$u=Get-ADUser $Username -Properties Department,MemberOf;$d=Get-ADDomain;$oldGroups=@($u.MemberOf|ForEach-Object{(Get-ADGroup $_).Name});$deptGroups=@('GG-Executive','GG-Engineering','GG-Security','GG-Operations','GG-Research','GG-Contractors','GG-Security-Analysts')
if($PSCmdlet.ShouldProcess($Username,"Move from $($u.Department) to $NewDepartment")){
 foreach($g in $oldGroups|Where-Object{$deptGroups -contains $_}){Remove-ADGroupMember $g $u -Confirm:$false}
 Set-ADUser $u -Department $NewDepartment -Title $NewTitle -Description "Moved by $RequestId on $(Get-Date -Format s)"
 Move-ADObject $u.DistinguishedName -TargetPath "OU=$NewDepartment,OU=Users,OU=Avengers,$($d.DistinguishedName)"
 &(Join-Path $PSScriptRoot '05-Assign-GroupMembership.ps1');Get-ADUser $Username -Properties Department,Title,MemberOf
}

