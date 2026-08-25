[CmdletBinding(SupportsShouldProcess)]
param([string[]]$TraditionalAccounts=@('svc-grafana','svc-backup','svc-monitoring','svc-webapp'),[switch]$CreateGmsa,[string[]]$GmsaHosts=@('DC01$'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory
$d=Get-ADDomain;$ou="OU=Service Accounts,OU=Avengers,$($d.DistinguishedName)"
foreach($name in $TraditionalAccounts){if(-not(Get-ADUser -Filter "SamAccountName -eq '$name'")){if($PSCmdlet.ShouldProcess($name,'Create disabled placeholder service account')){New-ADUser -Name $name -SamAccountName $name -Path $ou -Enabled $false -Description 'LAB placeholder; prefer gMSA where supported'}}}
if($CreateGmsa){
 try{Get-KdsRootKey -ErrorAction Stop|Out-Null}catch{throw 'No KDS root key. In a single-DC LAB ONLY, create one with Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10)); never backdate in production.'}
 $hosts=$GmsaHosts|ForEach-Object{Get-ADComputer -Identity $_}
 if(-not(Get-ADServiceAccount -Identity 'gmsa-monitoring' -ErrorAction SilentlyContinue) -and $PSCmdlet.ShouldProcess('gmsa-monitoring','Create gMSA')){New-ADServiceAccount -Name 'gmsa-monitoring' -DNSHostName "gmsa-monitoring.$($d.DNSRoot)" -PrincipalsAllowedToRetrieveManagedPassword $hosts}
}

