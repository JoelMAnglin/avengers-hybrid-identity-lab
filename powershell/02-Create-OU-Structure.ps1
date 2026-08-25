[CmdletBinding(SupportsShouldProcess)] param()
Set-StrictMode -Version Latest; $ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'modules/AvengersLab/AvengersLab.psm1') -Force
$ctx = Get-LabDomainContext; $log = New-LabLogPath 'ou-structure'
$definitions = @(
    @{Name='Avengers';Path=$ctx.BaseDN},
    @{Name='Users';Path=$ctx.AvengersOU}, @{Name='Computers';Path=$ctx.AvengersOU},
    @{Name='Groups';Path=$ctx.AvengersOU}, @{Name='Service Accounts';Path=$ctx.AvengersOU},
    @{Name='Privileged Accounts';Path=$ctx.AvengersOU}, @{Name='Disabled Users';Path=$ctx.AvengersOU},
    @{Name='Executive';Path="OU=Users,$($ctx.AvengersOU)"}, @{Name='Engineering';Path="OU=Users,$($ctx.AvengersOU)"},
    @{Name='Security';Path="OU=Users,$($ctx.AvengersOU)"}, @{Name='Operations';Path="OU=Users,$($ctx.AvengersOU)"},
    @{Name='Research';Path="OU=Users,$($ctx.AvengersOU)"}, @{Name='Contractors';Path="OU=Users,$($ctx.AvengersOU)"},
    @{Name='Workstations';Path="OU=Computers,$($ctx.AvengersOU)"}, @{Name='Servers';Path="OU=Computers,$($ctx.AvengersOU)"},
    @{Name='Security';Path="OU=Groups,$($ctx.AvengersOU)"}, @{Name='Distribution';Path="OU=Groups,$($ctx.AvengersOU)"}
)
foreach ($ou in $definitions) {
    $dn = "OU=$($ou.Name),$($ou.Path)"
    if (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'" -ErrorAction Stop) {
        Write-LabAudit $log CreateOU $dn Skipped 'Already exists'; continue
    }
    if ($PSCmdlet.ShouldProcess($dn, 'Create protected OU')) {
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -ProtectedFromAccidentalDeletion $true
        Write-LabAudit $log CreateOU $dn Success
    }
}
Write-LabStatus PASS "OU processing complete. Log: $log"
