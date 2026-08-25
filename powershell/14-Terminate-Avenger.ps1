[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]param([Parameter(Mandatory)][string]$Username,[Parameter(Mandatory)][string]$RequestId,[string]$EvidenceDirectory=(Join-Path (Split-Path $PSScriptRoot -Parent) 'reports/terminations'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory
$u=Get-ADUser $Username -Properties MemberOf,Enabled;$d=Get-ADDomain;if(-not(Test-Path $EvidenceDirectory)){New-Item -ItemType Directory $EvidenceDirectory|Out-Null}
$evidence=Join-Path $EvidenceDirectory "$Username-$RequestId-groups.csv";$u.MemberOf|ForEach-Object{Get-ADGroup $_|Select-Object Name,DistinguishedName}|Export-Csv $evidence -NoTypeInformation
if($PSCmdlet.ShouldProcess($Username,"Remove access and move to Disabled Users for $RequestId")){
 if($u.Enabled){throw 'Run 13-Disable-Avenger.ps1 first; termination requires a disabled account.'}
 foreach($dn in $u.MemberOf){Remove-ADGroupMember -Identity $dn -Members $u -Confirm:$false}
 Move-ADObject $u.DistinguishedName -TargetPath "OU=Disabled Users,OU=Avengers,$($d.DistinguishedName)"
 Set-ADUser $Username -Description "Terminated by $RequestId at $(Get-Date -Format o); evidence $evidence"
}

