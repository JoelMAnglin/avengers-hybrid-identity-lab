# Entra Synchronization

**SYMPTOM:** on-premises object is missing or stale in Entra. **LIKELY CAUSES:** OU/
attribute scope, invalid/duplicate attributes, UPN/domain, matching conflict,
permissions, unhealthy agent, or quarantine. **INVESTIGATION:** verify local
object/UPN, configured scope, agent/provisioning logs, Entra audit/provisioning
logs, and Graph comparison. **RESOLUTION:** correct authoritative on-prem data or
sync configuration; do not create a duplicate cloud user as a shortcut.
**VALIDATION:** object appears with expected source and sync flag. **LESSON
LEARNED:** source-of-authority and object matching must be understood before edits.

