# Group Policy

**SYMPTOM:** expected setting absent. **LIKELY CAUSES:** wrong OU, link/inheritance,
security/WMI filtering, SYSVOL/DC/DNS, or refresh timing. **COMMANDS:** `gpupdate
/force`, `gpresult /r`, `gpresult /h C:\Temp\gp-report.html`, `Get-GPInheritance`,
and GroupPolicy Operational log. **RESOLUTION:** correct object scope/filter or
underlying DNS/SYSVOL issue; change one thing. **VALIDATION:** resultant-set report
shows applied GPO and setting. **LESSON LEARNED:** a GPO existing is not evidence
that a particular computer/user is in its effective scope.

