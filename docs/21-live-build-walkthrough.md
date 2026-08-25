# Live Build Walkthrough and Validation Journal

This journal records what was actually performed on the local VirtualBox lab.
Planned work is explicitly separated from completed, validated work.

## Host and media discovery

VirtualBox 7.1.6, 20 logical processors, approximately 16 GB RAM, and sufficient
disk were detected. The Server ISO was identified as build `10.0.26100.32230`
with Standard/Datacenter evaluation editions and Desktop Experience.

```powershell
VBoxManage --version
VBoxManage list vms
VBoxManage unattended detect --iso=<SERVER-ISO>
Get-CimInstance Win32_OperatingSystem
```

Free RAM fell below 1 GB during installation. The VMs were therefore installed
sequentially at low process priority rather than run together.

## VM construction

DC01 uses 2 vCPU, 3 GB RAM, a 60 GB dynamic VDI, EFI, NAT, and Internal Network
`AVENGERS-LAB`. CLIENT01 uses 2 vCPU, 3 GB RAM, an 80 GB dynamic VDI, NAT, and
the same internal network. Clipboard, drag/drop, recording, and shared folders
remain disabled.

The registered `Joel` VM was an unused shell: its VDI occupied roughly 2 MB and
an Ubuntu installer was attached. It was snapshotted, renamed CLIENT01, and the
Ubuntu ISO was detached. This did not alter host files or a working guest OS.

Snapshots:

- DC01: `00-VM-Hardware-Created`, `01-Clean-Server-2025`
- CLIENT01: `00-Pre-CLIENT01-Repurpose`, `01-Clean-Server-2025-Client`

Validated build snapshots were later added:

- DC01: `02-Core-AD-Configured`, `03-Client-Joined-Validated`
- CLIENT01: `02-Domain-Joined-GPO-Validated`

Validate with `VBoxManage showvminfo <name>` and `VBoxManage snapshot <name>
list`.

## Operating-system installation

Both VMs use Windows Server 2025 Standard Evaluation Desktop Experience (image
index 2). A strong temporary password was generated into ignored
`secrets.psd1`. CLIENT01 is a Server member-workstation substitute because no
Windows 11 Pro/Enterprise ISO was available. It can demonstrate DNS, domain
join, Kerberos, LDAP, RSAT, and many GPO behaviors, but this project must not
claim Windows 11-specific testing.

UEFI initially stopped at `Press any key to boot from CD or DVD`. Repeated Space
scan codes entered Windows Boot Manager; Enter selected Windows Setup. This was
a boot timing/device-order issue, not an invalid ISO.

DC01 reached the desktop while Windows still had pending setup changes. A forced
power-off caused Windows to display `Something didn't go as planned` and roll
back the pending change. It recovered successfully. Later shutdowns were issued
inside Windows with elevated `shutdown` and allowed to reach VirtualBox
`poweroff`. Lesson: a desktop is not proof that servicing is complete.

CLIENT01 completed installation, shut down cleanly, and received its clean-client
snapshot. Both clean OS milestones are reproducible and independently visible.

## Management-channel troubleshooting

VirtualBox Guest Additions 7.1.6 was installed. Run levels observed were 0
(unavailable), 1 (system components detected), and 3 (desktop integration).

OpenSSH was enabled through an elevated one-time bootstrap. VirtualBox maps
host-loopback `127.0.0.1:5522` to guest TCP 22. The TCP connection succeeded but
SSH timed out before its banner. An open forwarded socket is not proof of a
healthy `sshd` application.

Guest Additions later reported run level 3 while `guestcontrol run` still
returned `The guest execution service is not ready (yet)`. Rather than treating
that optional management channel as a domain-build dependency, the build used
an elevated guest console and a temporary HTTP server bound to host port 8765.
Port 8000 was avoided after validation proved it belonged to an existing Splunk
service. The temporary transfer channel contained no committed secrets.

## Completed domain phase

DC01 was configured with `10.10.10.10/24` on `AD-LAN`, no internal gateway, and
itself as DNS. The NAT adapter retained internet access without registering its
address in AD DNS. AD DS and DNS were installed and the `avengers.lab` forest
was promoted successfully. Transcript evidence recorded `DCPromo.General.3`,
`Status: Success`; subsequent validation returned:

- DNS root: `avengers.lab`
- NetBIOS name: `AVENGERS`
- Domain mode: `Windows2025Domain`
- Signed-in identity after promotion: `AVENGERS\LabAdmin`

The live provisioning run then created the complete protected OU hierarchy,
groups, AGDLP nesting, 16 fictional employee identities, department membership,
five GPOs, four disabled traditional service-account placeholders, auditing,
and CSV/HTML reports. The health report observed 24 total users, 18 enabled,
six disabled, zero locked, one privileged user, and five service identities.

Runtime testing found and corrected three idempotency/reporting defects:

1. The OU existence test used `-Identity` for a missing DN, which terminated
   before creation. It now uses an exact distinguished-name filter.
2. Empty group membership was accessed as a scalar property under strict mode.
   The script now materializes a safe array of member distinguished names.
3. Empty GPO links and nested HTML body fragments caused strict-mode and
   parameter-binding failures. Both are now normalized to arrays/strings.

Windows Server 2025 rejected KDS root-key creation with `0x80070032` for both
backdated and immediate forms in this VM. The optional gMSA demonstration is
therefore documented but not claimed as operational; disabled traditional
service-account placeholders were created without passwords.

## Completed client phase

CLIENT01 is a Windows Server 2025 Desktop Experience member-workstation
substitute, not Windows 11. Its `AD-LAN` address is `10.10.10.20/24` and DNS is
`10.10.10.10`. It joined `avengers.lab` directly into:

`OU=Workstations,OU=Computers,OU=Avengers,DC=avengers,DC=lab`

The first `gpupdate /force` correctly exposed a clock-skew condition. After
configuring the client for domain-hierarchy time and restarting Windows Time,
computer and user policy both completed successfully. `gpresult` confirmed the
computer DN above and these applied policies:

- `AVENGERS - Windows Defender`
- `AVENGERS - Windows Firewall`
- `AVENGERS - Workstation Security`
- `Default Domain Policy`

Both VMs were left powered off or saved after snapshots so normal host activity
is not burdened. Start DC01 first and wait for AD DS/DNS before starting CLIENT01.

## Independent validation

Open VirtualBox Manager and confirm VM names, resources, adapters, and snapshots.
Start only DC01 and compare every claimed milestone against
`docs/20-validation.md`. Store command evidence in ignored `reports/` and add
only redacted screenshots. Never expose `secrets.psd1`.

## Learning and interview takeaway

Evidence discipline matters. A listening TCP port was not called healthy SSH,
an integration run level was not called a working execution channel, and an
installed OS was not called an AD domain. Each identity dependency needs a
functional validation before the next layer is added.
