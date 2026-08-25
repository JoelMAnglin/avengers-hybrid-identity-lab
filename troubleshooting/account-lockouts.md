# Account Lockouts

**SYMPTOM:** valid user cannot log on. **LIKELY CAUSES:** stale saved credentials,
service/task, mapped drive, phone, or malicious guessing. **COMMANDS:**
`Search-ADAccount -LockedOut`, `Get-ADUser pparker -Properties LockedOut`, locate
DC event 4740 and caller computer, then correlate 4625. **RESOLUTION:** remove the
bad credential source before `Unlock-ADAccount pparker`. **VALIDATION:** one clean
login and no repeat 4740. **LESSON LEARNED:** unlocking without root cause creates
a loop and can erase useful timing evidence.

