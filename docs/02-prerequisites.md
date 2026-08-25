# Prerequisites

## Objective

Confirm the host and installation media can support a two-VM lab before build.

## Host checklist

- Enable Intel VT-x/AMD-V in firmware and confirm it in Task Manager.
- Reserve at least 16 GB host RAM, 150 GB disk, and four logical CPUs.
- Install current VirtualBox and use a matching Extension Pack only if USB/RDP
  features are needed. Do not download ISOs from third-party mirrors.
- Obtain a supported Windows Server 2022/2025 evaluation ISO and Windows 11 ISO.
- Record ISO checksums where the vendor publishes them.
- Install Git and an editor. Docker Desktop is optional until monitoring.

## Guest checklist

Use Desktop Experience for a beginner-friendly first build. Apply updates,
install Guest Additions, set the timezone, and take `00-Clean-Windows-*` before
changing networking. Use unique local administrator passwords stored outside Git.

Run from an elevated PowerShell prompt on DC01:

```powershell
Set-ExecutionPolicy -Scope Process RemoteSigned
.\powershell\00-Test-Prerequisites.ps1 -ExpectedComputerName DC01
```

PASS means the check is satisfied, WARN requires review, and FAIL blocks the
next phase. AD feature/module checks are expected to warn before installation.

## Common failures

- No 64-bit guest choices: firmware virtualization is disabled or another
  hypervisor owns it.
- VM will not start: reduce allocated RAM/CPUs and close competing hypervisors.
- Windows 11 install blocks: enable EFI, TPM 2.0, and Secure Boot in VM settings
  where supported; follow Microsoft's requirements rather than bypassing them.

## Validation and lesson learned

Record host capacity, ISO source, guest edition, and test-script output. Capacity
and rollback planning are part of identity availability, not merely setup chores.

