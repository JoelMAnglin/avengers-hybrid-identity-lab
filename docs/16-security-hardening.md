# Security Hardening

- Separate daily and privileged accounts; never browse/email as an admin.
- Use MFA and least privilege in Entra; review emergency-access procedures.
- Patch guests, minimize DC software, restrict management paths, and back up AD.
- Prefer gMSA for supported services; keep placeholder service users disabled.
- Enforce firewall, Defender, account/audit policy, and tiered administration.
- Use LDAPS only after correct PKI deployment; port 636 being open alone proves little.
- Review Domain Admins and dangerous delegation regularly.
- Secure DSRM, BitLocker/recovery material, snapshots, logs, and exports outside Git.

Hardening is risk-managed and tested. A setting copied without understanding may
reduce availability or create bypasses. Baseline against current Microsoft
Security Compliance Toolkit guidance and test in a pilot OU.

