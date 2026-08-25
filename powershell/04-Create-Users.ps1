[CmdletBinding(SupportsShouldProcess)]
param(
 [string]$CsvPath=(Join-Path (Split-Path $PSScriptRoot -Parent) 'data/users.csv'),
 [securestring]$InitialPassword
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'modules/AvengersLab/AvengersLab.psm1') -Force
if(-not $InitialPassword){$InitialPassword=Read-Host 'Enter one temporary LAB password (not logged)' -AsSecureString}
$ctx=Get-LabDomainContext; $log=New-LabLogPath 'user-provisioning'; $users=Import-Csv -LiteralPath $CsvPath
$required='FirstName','LastName','Username','Department','Title','OU'
foreach($column in $required){if($users.Count -and -not ($users[0].PSObject.Properties.Name -contains $column)){throw "Missing CSV column: $column"}}
$success=0;$skipped=0;$failed=0
foreach($u in $users){
 try{
  if($u.Username -notmatch '^[a-z][a-z0-9.-]{2,19}$'){throw 'Username has an invalid format.'}
  if(Get-ADUser -Filter "SamAccountName -eq '$($u.Username)'" -ErrorAction SilentlyContinue){Write-LabAudit $log CreateUser $u.Username Skipped 'Already exists';$skipped++;continue}
  $path="OU=$($u.OU),OU=Users,$($ctx.AvengersOU)"; $name="$($u.FirstName) $($u.LastName)"; $upn="$($u.Username)@$($ctx.DnsRoot)"
  if($PSCmdlet.ShouldProcess($upn,'Create enabled AD user requiring password change')){
   New-ADUser -Name $name -GivenName $u.FirstName -Surname $u.LastName -DisplayName $name -SamAccountName $u.Username -UserPrincipalName $upn -Department $u.Department -Title $u.Title -Path $path -AccountPassword $InitialPassword -Enabled $true -ChangePasswordAtLogon $true
   Write-LabAudit $log CreateUser $u.Username Success; $success++
  }
 }catch{Write-LabAudit $log CreateUser $u.Username Failed $_.Exception.Message;Write-Warning "$($u.Username): $($_.Exception.Message)";$failed++}
}
Write-LabStatus INFO "Success=$success Skipped=$skipped Failed=$failed Log=$log"
if($failed){exit 1}

