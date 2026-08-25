[CmdletBinding()]param([int]$StaleDays=90,[string]$OutputPath=(Join-Path (Split-Path $PSScriptRoot -Parent) 'reports/ad-health.html'))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';Import-Module ActiveDirectory
$folder=Split-Path $OutputPath -Parent;if(-not(Test-Path $folder)){New-Item -ItemType Directory $folder|Out-Null}
$d=Get-ADDomain;$f=Get-ADForest;$users=Get-ADUser -Filter * -Properties Enabled,LockedOut,LastLogonDate,PasswordNeverExpires,PasswordLastSet,ServicePrincipalName
$cutoff=(Get-Date).AddDays(-$StaleDays);$admins=Get-ADGroupMember 'Domain Admins' -Recursive
$checks=[ordered]@{
 Domain=$d.DNSRoot;Forest=$f.Name;DomainControllers=@(Get-ADDomainController -Filter *).Count;TotalUsers=$users.Count
 EnabledUsers=@($users|Where-Object Enabled).Count;DisabledUsers=@($users|Where-Object{-not $_.Enabled}).Count
 LockedUsers=@($users|Where-Object LockedOut).Count;StaleUsers=@($users|Where-Object{$_.Enabled -and $_.LastLogonDate -and $_.LastLogonDate -lt $cutoff}).Count
 PasswordNeverExpires=@($users|Where-Object PasswordNeverExpires).Count;PrivilegedUsers=@($admins).Count
 ServiceIdentities=@($users|Where-Object{$_.SamAccountName -like 'svc-*' -or $_.ServicePrincipalName.Count}).Count
}
$dns=try{Resolve-DnsName "_ldap._tcp.dc._msdcs.$($d.DNSRoot)" -Type SRV -ErrorAction Stop;'PASS'}catch{'FAIL'}
$services=Get-Service NTDS,DNS,Netlogon,KDC|Select-Object Name,Status
$disk=Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"|Select-Object DeviceID,@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}}
$body=@('<h1>Avengers AD Health</h1>',"<p>Generated $(Get-Date -Format o) | DNS SRV: $dns</p>",($checks.GetEnumerator()|ForEach-Object{"<p><b>$($_.Key)</b>: $($_.Value)</p>"}),($services|ConvertTo-Html -Fragment),($disk|ConvertTo-Html -Fragment),'<h2>Privileged membership</h2>',($admins|Select-Object Name,ObjectClass|ConvertTo-Html -Fragment),'<h2>Stale enabled users</h2>',($users|Where-Object{$_.Enabled -and $_.LastLogonDate -and $_.LastLogonDate -lt $cutoff}|Select-Object Name,SamAccountName,LastLogonDate|ConvertTo-Html -Fragment)) -join [Environment]::NewLine
ConvertTo-Html -Title 'Avengers AD Health' -Body $body|Set-Content -LiteralPath $OutputPath -Encoding UTF8
[pscustomobject]$checks;Write-Host "Report: $OutputPath"
