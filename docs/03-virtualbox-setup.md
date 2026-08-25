# VirtualBox VM Setup

## Build DC01

Create a Windows Server VM with 2–4 vCPU, 4–6 GB RAM, 60 GB dynamic VDI, EFI if
required, and two adapters. Install Windows, update it, install Guest Additions,
rename it to DC01, reboot, and snapshot `00-Clean-Windows-Server`.

```powershell
Rename-Computer -NewName DC01 -Restart
```

## Build CLIENT01

Create a Windows 11 VM with 2 vCPU, 4–6 GB RAM and 60 GB dynamic VDI. Windows 11
Pro/Enterprise is required for AD domain join. Rename and snapshot it.

```powershell
Rename-Computer -NewName CLIENT01 -Restart
```

An optional MGMT01 follows the CLIENT01 pattern. Install RSAT there after domain
join so routine administration does not require interactive DC logon.

## Snapshot gates

Take snapshots only while the VM is shut down when practical: clean OS, static
IP, AD DS installed, domain created, OUs/groups, users, GPOs, domain join, Entra,
and monitoring. Snapshots are short-term lab rollback, not backups.

## Validation

Confirm Guest Additions, updates, hostname, time, both NICs, and snapshot names.
Do not promote DC01 until the IP and DNS plan passes the networking guide.

