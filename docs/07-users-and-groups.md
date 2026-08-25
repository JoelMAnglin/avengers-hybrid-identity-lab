# Users and Groups

Run `04-Create-Users.ps1` and enter a unique temporary LAB password; it is never
logged. Then run `05-Assign-GroupMembership.ps1`. The CSV is an educational HR
source; real integrations require authoritative identifiers, approvals, data
quality checks, and reconciliation.

Validate `Get-ADUser pparker -Properties Department,Title,MemberOf` and
`Get-ADGroupMember GG-Engineering`. A duplicate is skipped, malformed input
fails, and per-user results appear in ignored `logs/`. Never use movie-inspired
passwords outside a disposable lab or commit them anywhere.

