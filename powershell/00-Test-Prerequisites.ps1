[CmdletBinding()]
param([string]$ExpectedComputerName = 'DC01')
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'modules/AvengersLab/AvengersLab.psm1') -Force

$failed = 0
function Test-Item([string]$Name, [scriptblock]$Test, [bool]$Blocking = $false) {
    try {
        if (& $Test) { Write-LabStatus PASS $Name }
        elseif ($Blocking) { Write-LabStatus FAIL $Name; $script:failed++ }
        else { Write-LabStatus WARN $Name }
    } catch {
        if ($Blocking) { Write-LabStatus FAIL "$Name - $($_.Exception.Message)"; $script:failed++ }
        else { Write-LabStatus WARN "$Name - $($_.Exception.Message)" }
    }
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
Test-Item 'Running as Administrator' { $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) } $true
Test-Item 'PowerShell 5.1 or newer' { $PSVersionTable.PSVersion -ge [version]'5.1' } $true
Test-Item "Hostname is $ExpectedComputerName" { $env:COMPUTERNAME -eq $ExpectedComputerName }
Test-Item 'At least two connected network adapters' { @(Get-NetAdapter | Where-Object Status -eq Up).Count -ge 2 }
Test-Item '10.10.10.10 is configured locally' { @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress -contains '10.10.10.10' }
Test-Item 'A DNS client points to 10.10.10.10' { @(Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses -contains '10.10.10.10' }
Test-Item 'AD-Domain-Services feature is installed (expected WARN before phase 2)' { (Get-WindowsFeature AD-Domain-Services).InstallState -eq 'Installed' }
Test-Item 'ActiveDirectory module is available (expected WARN before phase 2)' { $null -ne (Get-Module -ListAvailable ActiveDirectory) }

if ($failed) { Write-LabStatus FAIL "$failed blocking prerequisite(s) failed."; exit 1 }
Write-LabStatus PASS 'No blocking prerequisite failures detected.'

