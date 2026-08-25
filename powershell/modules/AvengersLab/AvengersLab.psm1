Set-StrictMode -Version Latest

function Write-LabStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateSet('PASS','WARN','FAIL','INFO')][string]$Level,
        [Parameter(Mandatory)][string]$Message
    )
    $color = @{ PASS='Green'; WARN='Yellow'; FAIL='Red'; INFO='Cyan' }[$Level]
    Write-Host ('[{0}] {1}' -f $Level, $Message) -ForegroundColor $color
}

function Get-LabDomainContext {
    [CmdletBinding()]
    param()
    Import-Module ActiveDirectory -ErrorAction Stop
    $domain = Get-ADDomain -ErrorAction Stop
    [pscustomobject]@{
        Domain      = $domain
        DnsRoot     = $domain.DNSRoot
        BaseDN      = $domain.DistinguishedName
        AvengersOU = "OU=Avengers,$($domain.DistinguishedName)"
    }
}

function New-LabLogPath {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Name)
    $root = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    $folder = Join-Path $root 'logs'
    if (-not (Test-Path -LiteralPath $folder)) {
        $null = New-Item -ItemType Directory -Path $folder -Force
    }
    Join-Path $folder ('{0}-{1:yyyyMMdd-HHmmss}.csv' -f $Name, (Get-Date))
}

function Write-LabAudit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Action,
        [Parameter(Mandatory)][string]$Target,
        [Parameter(Mandatory)][ValidateSet('Success','Skipped','Failed','WhatIf')][string]$Result,
        [string]$Detail = ''
    )
    [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        Operator  = [Environment]::UserName
        Action    = $Action
        Target    = $Target
        Result    = $Result
        Detail    = $Detail
    } | Export-Csv -LiteralPath $Path -Append -NoTypeInformation
}

function Resolve-LabPath {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$RelativePath)
    $root = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Join-Path $root $RelativePath
}

Export-ModuleMember -Function Write-LabStatus,Get-LabDomainContext,New-LabLogPath,Write-LabAudit,Resolve-LabPath

