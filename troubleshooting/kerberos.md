# Kerberos

**SYMPTOM:** repeated prompts, fallback, or authentication errors. **LIKELY
CAUSES:** time skew, DNS, stale tickets, duplicate/missing SPN, disabled account.
**INVESTIGATION/COMMANDS:** `w32tm /query /status`, `klist`, `setspn -Q
service/host`, account state, and DC events 4768/4769. **RESOLUTION:** restore the
domain time hierarchy, correct DNS/SPN/account, then `klist purge` in the affected
session. Never purge before collecting evidence. **VALIDATION:** obtain a new TGT
and access the named service. **LESSON LEARNED:** Kerberos binds identity, service
names, DNS, and time.

