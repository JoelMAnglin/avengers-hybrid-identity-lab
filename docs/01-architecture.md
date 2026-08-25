# Architecture

## Objective and enterprise context

Create an isolated identity lab with clear trust and traffic boundaries. AD DS
runs only on Windows Server; containers provide optional observability.

## Components

| System | Address | Role | DNS |
|---|---:|---|---:|
| DC01 | 10.10.10.10/24 | AD DS, DNS, GPO | 10.10.10.10 |
| CLIENT01 | 10.10.10.20/24 | User/GPO tests | 10.10.10.10 |
| MGMT01 | 10.10.10.30/24 | RSAT/Graph | 10.10.10.10 |

Each VM has NAT adapter 1 and Internal Network adapter 2 named
`AVENGERS-LAB`. Configure the static address only on adapter 2 and leave its
default gateway blank; NAT supplies internet routing on adapter 1. Register the
internal address in DNS. If Windows chooses the wrong route or DNS registration,
adjust interface metrics and disable DNS registration on the NAT interface.

## Identity flow

```text
CSV/HR request → PowerShell → AD DS → synchronization agent → Entra ID
                                  ↘ Windows events → Alloy → Loki → Grafana
                                  ↘ windows_exporter → Prometheus → Grafana
```

AD remains authoritative for synchronized attributes. Cloud-only objects remain
cloud authoritative. Scope only the intended OUs, use least-privilege Graph
scopes, and verify synchronization before depending on cloud-side state.

## Trust boundaries and ports

Domain traffic on the internal network includes DNS 53, Kerberos 88, LDAP 389,
LDAPS 636 when configured, SMB 445, RPC endpoint mapper 135 plus dynamic RPC,
and Global Catalog 3268/3269. NAT is not a security boundary between lab guests
and the internet; keep host-only secrets out of guests and take snapshots.

## Validation

From CLIENT01: resolve `dc01.avengers.lab`, locate the DC with `nltest`, test
ports 53/88/389/445, and confirm the internal adapter points only at DC01.

## Screenshot

Capture the two-adapter settings, IP configuration, and a successful DC locator
result. See `diagrams/screenshots/README.md`.

## Interview prompt

Why should a domain member use the AD DNS server even when public DNS appears to
resolve internet names? Because AD publishes service records that public DNS
does not know; the AD DNS server can forward unrelated queries upstream.

