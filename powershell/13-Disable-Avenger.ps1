[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]param([Parameter(Mandatory)][string]$Username,[Parameter(Mandatory)][string]$RequestId,[securestring]$ResetPassword)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory
$u=Get-ADUser $Username;if(-not$ResetPassword){$ResetPassword=Read-Host 'Enter random containment password (not logged)' -AsSecureString}
if($PSCmdlet.ShouldProcess($Username,"Disable and reset password for $RequestId")){Set-ADAccountPassword $u -Reset -NewPassword $ResetPassword;Disable-ADAccount $u;Set-ADUser $u -Description "Disabled by $RequestId at $(Get-Date -Format o)";Get-ADUser $u -Properties Enabled,Description}

