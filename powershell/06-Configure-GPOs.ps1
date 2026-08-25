[CmdletBinding(SupportsShouldProcess)] param()
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop'
Import-Module ActiveDirectory,GroupPolicy -ErrorAction Stop
$domain=Get-ADDomain;$root="OU=Avengers,$($domain.DistinguishedName)";$workstations="OU=Workstations,OU=Computers,$root"
if($PSCmdlet.ShouldProcess($domain.DNSRoot,'Configure domain password and lockout policy')){
 Set-ADDefaultDomainPasswordPolicy -Identity $domain.DNSRoot -ComplexityEnabled $true -MinPasswordLength 14 -PasswordHistoryCount 24 -MaxPasswordAge (New-TimeSpan -Days 90) -MinPasswordAge (New-TimeSpan -Days 1) -LockoutThreshold 10 -LockoutDuration (New-TimeSpan -Minutes 15) -LockoutObservationWindow (New-TimeSpan -Minutes 15)
}
$policies=@(
 @{Name='AVENGERS - Windows Defender';Link=$workstations;Values=@{
  'HKLM\Software\Policies\Microsoft\Windows Defender|DisableAntiSpyware'=@('DWord',0)
 }},
 @{Name='AVENGERS - Windows Firewall';Link=$workstations;Values=@{
  'HKLM\Software\Policies\Microsoft\WindowsFirewall\DomainProfile|EnableFirewall'=@('DWord',1)
 }},
 @{Name='AVENGERS - Workstation Security';Link=$workstations;Values=@{
  'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System|InactivityTimeoutSecs'=@('DWord',900)
 }},
 @{Name='AVENGERS - Audit Policy';Link=$root;Values=@{}},
 @{Name='AVENGERS - Restricted Admin Access';Link=$workstations;Values=@{}}
)
foreach($p in $policies){
 $gpo=Get-GPO -Name $p.Name -ErrorAction SilentlyContinue
 if(-not $gpo -and $PSCmdlet.ShouldProcess($p.Name,'Create GPO')){$gpo=New-GPO -Name $p.Name}
 if($gpo){
  $links=@((Get-GPInheritance -Target $p.Link).GpoLinks | ForEach-Object DisplayName)
  if($links -notcontains $p.Name -and $PSCmdlet.ShouldProcess($p.Link,"Link $($p.Name)")){New-GPLink -Name $p.Name -Target $p.Link -LinkEnabled Yes|Out-Null}
  foreach($entry in $p.Values.GetEnumerator()){$parts=$entry.Key -split '\|';Set-GPRegistryValue -Name $p.Name -Key $parts[0] -ValueName $parts[1] -Type $entry.Value[0] -Value $entry.Value[1]}
 }
}
Write-Warning 'Audit and restricted-admin GPOs are created as review gates. Configure approved advanced-audit/user-right settings in GPMC, then back up and peer-review them.'
Get-ADDefaultDomainPasswordPolicy | Format-List MinPasswordLength,LockoutThreshold,LockoutDuration,ComplexityEnabled
