[CmdletBinding()]param([string]$Root=(Split-Path $PSScriptRoot -Parent))
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';$fail=0
$required=@('README.md','SECURITY.md','.gitignore','docker-compose.yml','data/users.csv','data/groups.csv','data/departments.csv')
foreach($file in $required){if(Test-Path (Join-Path $Root $file)){Write-Host "[PASS] $file" -ForegroundColor Green}else{Write-Host "[FAIL] $file" -ForegroundColor Red;$fail++}}
$scripts=Get-ChildItem (Join-Path $Root 'powershell') -Filter *.ps1
foreach($s in $scripts){$tokens=$null;$errors=$null;[void][Management.Automation.Language.Parser]::ParseFile($s.FullName,[ref]$tokens,[ref]$errors);if($errors){$errors|ForEach-Object{Write-Host "[FAIL] $($s.Name): $($_.Message)" -ForegroundColor Red};$fail++}else{Write-Host "[PASS] syntax $($s.Name)" -ForegroundColor Green}}
$secretPatterns='IAmIronMan|ICanDoThisAllDay|BringMeThanos|AlwaysAngry|GreatPower|RedRoom|ScarletWitch|client_secret\s*=|password\s*=\s*["''][^<C]'
$hits=Get-ChildItem $Root -Recurse -File|Where-Object{$_.FullName -notmatch '\\.git\\' -and $_.Name -ne 'Invoke-ProjectValidation.ps1'}|Select-String -Pattern $secretPatterns -ErrorAction SilentlyContinue
if($hits){$hits|ForEach-Object{Write-Host "[FAIL] possible secret $($_.Path):$($_.LineNumber)" -ForegroundColor Red};$fail++}else{Write-Host '[PASS] basic secret-pattern scan' -ForegroundColor Green}
if(Get-Command docker -ErrorAction SilentlyContinue){Push-Location $Root;try{& docker compose config --quiet;if($LASTEXITCODE){$fail++}else{Write-Host '[PASS] docker compose config'}}finally{Pop-Location}}else{Write-Host '[WARN] Docker not installed; Compose validation skipped' -ForegroundColor Yellow}
if($fail){throw "$fail validation category/categories failed"};Write-Host '[PASS] Local static validation complete.' -ForegroundColor Green
