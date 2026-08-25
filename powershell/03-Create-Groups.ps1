[CmdletBinding(SupportsShouldProcess)]
param([string]$CsvPath = (Join-Path (Split-Path $PSScriptRoot -Parent) 'data/groups.csv'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'modules/AvengersLab/AvengersLab.psm1') -Force
$ctx=Get-LabDomainContext; $log=New-LabLogPath 'groups'; $rows=Import-Csv -LiteralPath $CsvPath
foreach($row in $rows) {
    if($row.Name -notmatch '^(GG|DL|DG)-'){ throw "Invalid group naming convention: $($row.Name)" }
    if(Get-ADGroup -Filter "SamAccountName -eq '$($row.Name)'" -ErrorAction SilentlyContinue){ Write-LabAudit $log CreateGroup $row.Name Skipped 'Already exists'; continue }
    $path="OU=$($row.OU),OU=Groups,$($ctx.AvengersOU)"
    if($PSCmdlet.ShouldProcess($row.Name,'Create AD group')){
        New-ADGroup -Name $row.Name -SamAccountName $row.Name -GroupScope $row.Scope -GroupCategory $row.Category -Path $path -Description $row.Description
        Write-LabAudit $log CreateGroup $row.Name Success
    }
}
$nesting=@{'DL-Engineering-Share-RW'='GG-Engineering';'DL-Security-Logs-R'='GG-Security-Analysts'}
foreach($dl in $nesting.Keys){ if($PSCmdlet.ShouldProcess($dl,"Nest $($nesting[$dl])")){ Add-ADGroupMember -Identity $dl -Members $nesting[$dl] -ErrorAction SilentlyContinue } }
Write-LabStatus PASS "Group processing complete. Log: $log"

