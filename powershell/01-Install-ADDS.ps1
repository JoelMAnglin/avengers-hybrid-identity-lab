[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [ValidatePattern('^[a-z0-9.-]+$')][string]$DomainName = 'avengers.lab',
    [ValidatePattern('^[A-Z0-9]{1,15}$')][string]$NetbiosName = 'AVENGERS'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'modules/AvengersLab/AvengersLab.psm1') -Force

if (-not ([Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole('Administrator')) {
    throw 'Run this script from an elevated PowerShell session on DC01.'
}
if ($env:COMPUTERNAME -ne 'DC01') { Write-LabStatus WARN "Expected DC01; current hostname is $env:COMPUTERNAME." }
$existingForest = Get-CimInstance Win32_ComputerSystem
if ($existingForest.Domain -eq $DomainName -and $existingForest.DomainRole -ge 4) {
    Write-LabStatus PASS "$env:COMPUTERNAME is already a domain controller for $DomainName."
    return
}

if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Install AD DS management tools')) {
    $feature = Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    if (-not $feature.Success) { throw 'AD-Domain-Services feature installation failed.' }
}
$dsrm = Read-Host 'Enter a unique Directory Services Restore Mode password' -AsSecureString
Import-Module ADDSDeployment -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($DomainName, 'Create a new AD DS forest and reboot')) {
    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetbiosName `
        -InstallDns -SafeModeAdministratorPassword $dsrm -NoRebootOnCompletion:$false -Force
}

# Expected behavior: the server reboots. After sign-in, validate with:
# Get-ADDomain; Get-ADForest; Get-ADDomainController; dcdiag /v

