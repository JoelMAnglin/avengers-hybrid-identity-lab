# Avengers Hybrid Identity Lab

Enterprise Microsoft Active Directory and Microsoft Entra hybrid identity
engineering lab. It is designed as a reproducible learning environment and a
recruiter-facing portfolio project—not a production baseline.

## Overview

The lab builds `avengers.lab` on a Windows Server VM, joins a Windows client,
models role-based access with AGDLP, automates identity lifecycle operations,
and adds optional Entra/Graph and Docker-based observability. Fictional Marvel
identities are sample data; the engineering patterns are the focus.

## Architecture

```text
Windows 11 host
├─ VirtualBox NAT + AVENGERS-LAB internal network
│  ├─ DC01     10.10.10.10  AD DS / DNS / GPO
│  ├─ CLIENT01 10.10.10.20  domain client / testing
│  └─ MGMT01   10.10.10.30  RSAT / Graph (optional)
├─ Docker Desktop
│  └─ Grafana :3000 / Prometheus :9090 / Loki :3100 / Alloy
└─ Microsoft Entra ID (optional tenant)
   └─ Microsoft-supported synchronization agent + Microsoft Graph
```

See [architecture](docs/01-architecture.md) and the Draw.io-compatible diagrams
under `diagrams/`.

## Technologies and skills demonstrated

Windows Server 2022/2025, AD DS, DNS, Kerberos, LDAP, Group Policy, Entra ID,
Microsoft Graph PowerShell, PowerShell automation, VirtualBox, Docker Compose,
Prometheus, Loki, Grafana, RBAC, AGDLP, Joiner/Mover/Leaver, auditing, and
identity troubleshooting.

## Business scenario

Avengers Initiative needs repeatable onboarding, department transfer,
offboarding, privileged-account separation, secure service identities, and
auditable authentication. A CSV acts as the lab's HR source. In a real company,
an HRIS and ticketing workflow would be authoritative.

## Lab requirements and network design

- Windows 11 host with hardware virtualization, 16 GB RAM minimum (24 GB preferred), and 150 GB free disk.
- Oracle VirtualBox, Windows Server evaluation ISO, Windows 11 ISO, Git, and PowerShell.
- DC01 and clients each use NAT for updates and `AVENGERS-LAB` Internal Network for domain traffic.
- Domain members use `10.10.10.10` for DNS. DC01 forwards external queries; clients do not use public DNS directly.

Detailed setup: [prerequisites](docs/02-prerequisites.md),
[VirtualBox setup](docs/03-virtualbox-setup.md), and
[networking](docs/04-virtualbox-networking.md).

## Installation and build order

1. Clone or copy this repository and run `powershell/Invoke-ProjectValidation.ps1`.
2. Build DC01 and CLIENT01 using docs 02–04; take the named snapshots.
3. On DC01, run `00-Test-Prerequisites.ps1`, configure the static IP, and run
   `01-Install-ADDS.ps1`. The promotion reboots the server.
4. After reboot, run scripts 02–10 in numeric order from an elevated shell.
5. Join CLIENT01 using [the domain-join guide](docs/09-client-domain-join.md),
   then validate GPOs and test `AVENGERS\pparker`.
6. Exercise scripts 11–14 with `-WhatIf` before making lifecycle changes.
7. Optionally add Entra synchronization and Graph using docs 11–13.
8. Start monitoring with `docker compose config` then `docker compose up -d`.
9. Complete [operator acceptance](docs/20-validation.md).

All commands assume the repository is copied to the target VM. Never run the
domain scripts on a production domain.

## Active Directory build and RBAC

Automation creates protected OUs, 15 groups, 16 users, department membership,
AGDLP resource nesting, security-oriented GPOs, separated privileged accounts,
and example service identities. `GG-*` groups describe roles; `DL-*` groups
represent resource permissions. Users are never assigned directly to a share.

## Identity automation and JML

- `04-Create-Users.ps1` provisions CSV identities with a secure password prompt.
- `11-New-Avenger.ps1` implements a ticket-aware joiner workflow.
- `12-Move-Avenger.ps1` changes OU, attributes, and department access.
- `13-Disable-Avenger.ps1` performs reversible immediate containment.
- `14-Terminate-Avenger.ps1` exports membership, removes access, and moves the user.

Mutating lifecycle tools support `-WhatIf`; deletion is intentionally excluded.

## Group Policy and security controls

The lab configures domain password/lockout policy with supported domain cmdlets
and creates workstation Defender, firewall, audit, and security GPOs. Guides
explain scope, inheritance, validation, and recovery. Controls are educational
defaults and require risk review before production use.

## Hybrid identity and Microsoft Graph

The Entra phase is optional because it requires a tenant and current licensing.
It uses delegated Graph permissions for read-only inventory and documents source
of authority, synchronization scope, matching, and cloud-side deprovisioning.
No tenant ID, token, or password belongs in Git.

## Monitoring

Docker runs support services only—never AD DS. Windows exporter exposes host
metrics to Prometheus; Grafana Alloy can forward selected Windows events to
Loki. The design requires explicit installation and firewall configuration on
DC01 and avoids claiming that the base containers automatically observe AD.

## Troubleshooting and challenges

Protocol runbooks cover DNS, Kerberos, LDAP, replication, lockouts, GPO, and
Entra sync. Five intentional-failure exercises teach evidence-led diagnosis.
Start with [the troubleshooting index](docs/17-troubleshooting.md), then use
the [troubleshooting journal](docs/22-troubleshooting-journal.md) to reproduce
the diagnostic workflow and record evidence without exposing sensitive data.

## Screenshots

Screenshot placeholders and a capture checklist are in
`diagrams/screenshots/README.md`. Capture only your own completed lab and hide
passwords, tenant identifiers, tokens, public IPs, and recovery data.

## Lessons learned and interview talking points

The lab demonstrates that identity availability starts with DNS and time, OUs
are management boundaries rather than permission grants, groups should model
roles and resources separately, and safe offboarding needs evidence plus a
reversible containment step. See [lessons learned](docs/19-lessons-learned.md).
The evidence-backed [live build walkthrough](docs/21-live-build-walkthrough.md)
records the completed Server 2025 DC and member-workstation build, validation
evidence, and every runtime issue corrected during deployment. Windows 11,
Entra synchronization, Graph tenant access, gMSA, and Docker monitoring remain
explicit optional extensions and are not represented as completed.

Resume-ready examples:

- Automated provisioning and lifecycle handling for 16 fictional users across 6 departments.
- Implemented 15 role/resource groups and an AGDLP permission model without direct user ACLs.
- Built four JML workflows and five repeatable authentication troubleshooting exercises.
- Automated more than 12 identity, DNS, security, and domain-controller health checks.
- Documented an optional metrics/logging stack using four containerized support services.

## Repository structure

`docs/` contains the build course, `powershell/` the on-prem automation,
`entra/` Graph tooling, `data/` identity sources, `docker/` monitoring config,
`troubleshooting/` protocol runbooks, and `examples/` operator scenarios.

## Disclaimer

LAB ONLY. Marvel names are fictional sample identities used for education. This
project is not affiliated with or endorsed by Marvel or Microsoft. Validate all
security settings, licensing, and product support statements against current
vendor documentation before production use.
