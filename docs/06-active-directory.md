# Active Directory Structure

Run `02-Create-OU-Structure.ps1`, then `03-Create-Groups.ps1`. OUs scope
administration/GPO; security groups grant access. Protected OUs reduce accidental
deletion but are not backups. Validate with `Get-ADOrganizationalUnit -Filter *`
and `Get-ADGroup -SearchBase 'OU=Groups,OU=Avengers,DC=avengers,DC=lab' -Filter *`.

AGDLP maps Accounts → Global role groups → Domain Local resource groups →
Permissions. Example: Peter Parker → `GG-Engineering` →
`DL-Engineering-Share-RW` → share ACL. This keeps user moves out of resource ACLs.

