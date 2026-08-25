# Hybrid Identity

Choose the Microsoft-supported synchronization option appropriate to the
tenant—Microsoft Entra Cloud Sync or Microsoft Entra Connect Sync—and check the
current feature comparison before installation. Use a dedicated supported host,
scope synchronization to lab OUs, use a routable verified UPN suffix for real
cloud sign-in, and start with a pilot group/OU.

Flow: validate attributes → configure source anchor/matching → pilot sync → inspect
provisioning logs → verify Entra object and `OnPremisesSyncEnabled` → expand scope.
`avengers.lab` is non-routable, so a real tenant normally needs a verified suffix
for UPNs. Do not install a sync agent merely to complete the local-only phases.

For a missing object inspect OU/scope filtering, UPN/proxyAddresses, duplicates,
permissions, agent health, connector/provisioning logs, and quarantine state.
Run `Compare-OnPrem-Cloud.ps1` only after Graph connection and AD module access.

Current primary references: [What is Microsoft Entra Cloud Sync?](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync),
[configure Cloud Sync](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/how-to-configure),
and [Microsoft Entra Connect Sync overview](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-sync-whatis).
Microsoft currently describes Cloud Sync as its strategic direction; confirm the
feature comparison and migration requirements for the lab's chosen scenario.
