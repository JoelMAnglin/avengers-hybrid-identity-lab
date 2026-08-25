# Intentional Failure Labs

Perform only in disposable snapshots and restore correct state after each lab.

1. Domain join: set CLIENT01 DNS to a public resolver, observe failed SRV/DC
   discovery, collect `ipconfig /all`/`nltest`, restore `10.10.10.10`, validate.
2. Lockout: trigger only the configured threshold against `pparker`, locate 4740
   and source, remove the bad credential source, unlock, validate one login.
3. GPO: move `nromanoff` to the wrong OU or use temporary security filtering,
   capture `gpresult`, restore scope, refresh and validate.
4. Missing cloud identity: exclude a test OU from sync, inspect scope/agent logs,
   restore the scope, sync and compare. Requires a configured tenant.
5. Kerberos: snapshot CLIENT01, shift time beyond tolerance, inspect time/tickets,
   resynchronize, purge tickets and validate. Never alter DC time.

For each, submit symptom, hypothesis, evidence, correction, validation, root
cause, and preventive control. Screenshots must redact secrets and tenant data.

