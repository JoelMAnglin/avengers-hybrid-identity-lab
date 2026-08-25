# PowerShell Automation

Scripts use strict mode, terminating errors, parameter validation, shared status
and audit helpers, idempotent existence checks, and `SupportsShouldProcess` for
mutations. Run numeric scripts in order. First use `-WhatIf`, review the target,
then rerun intentionally. Logs contain object/action/result but never passwords.

Joiner, mover, disable, and termination reflect separate ticketed workflows.
Disable is immediate reversible containment; termination exports memberships,
requires the user already be disabled, removes access, and moves the object.
Production workflows also coordinate mailbox, devices, sessions, applications,
legal hold, data ownership, cloud groups, licenses, and HR approvals.

