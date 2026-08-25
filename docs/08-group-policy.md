# Group Policy

`06-Configure-GPOs.ps1` sets the supported default-domain password/lockout policy
and creates/links Defender, firewall, workstation, audit, and restricted-admin
GPOs. Audit and user-right assignments remain explicit review gates because
blind registry templates can lock out administrators. Configure them in GPMC,
peer-review, back up the GPOs, and test on a pilot OU.

Password/account policy belongs at domain scope; workstation controls link to
the Workstations OU. Validate with `Get-ADDefaultDomainPasswordPolicy`,
`gpupdate /force`, `gpresult /r`, and `gpresult /h C:\Temp\gp-report.html`.
Check OU placement, link order, inheritance, security filtering, WMI filters,
SYSVOL, DNS, and client time before editing a policy.

