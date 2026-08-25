[CmdletBinding(SupportsShouldProcess)] param()
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop'
$categories=@('Credential Validation','Kerberos Authentication Service','Kerberos Service Ticket Operations','Logon','Account Lockout','User Account Management','Security Group Management','Directory Service Changes')
foreach($category in $categories){if($PSCmdlet.ShouldProcess($env:COMPUTERNAME,"Enable audit policy: $category")){& auditpol.exe /set "/subcategory:$category" /success:enable /failure:enable;if($LASTEXITCODE){throw "auditpol failed for $category"}}}
& auditpol.exe /get /category:*

