# VirtualBox Networking

## Configure adapters

Power off each VM. Set adapter 1 to NAT and adapter 2 to Internal Network
`AVENGERS-LAB`. Use the same exact internal-network name on all guests.

On DC01, identify the internal interface, rename it `AD-LAN`, and configure it:

```powershell
Get-NetAdapter
Rename-NetAdapter -Name 'Ethernet 2' -NewName 'AD-LAN'
New-NetIPAddress -InterfaceAlias 'AD-LAN' -IPAddress 10.10.10.10 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias 'AD-LAN' -ServerAddresses 10.10.10.10
```

Leave the AD-LAN default gateway blank. The NAT NIC normally uses DHCP. Disable
DNS registration on NAT to keep its address out of domain records:

```powershell
Set-DnsClient -InterfaceAlias 'Ethernet' -RegisterThisConnectionsAddress $false
```

Use equivalent addresses `.20` and `.30` on clients with DNS `.10`. Before the
domain exists, resolving `avengers.lab` will fail; basic ping between static
addresses should succeed if firewall rules permit it.

## DNS after promotion

Configure DNS forwarders on DC01 rather than public DNS on clients:

```powershell
Set-DnsServerForwarder -IPAddress 1.1.1.1,8.8.8.8
```

Choose forwarders consistent with your privacy/security policy. Validate with
`Get-DnsClientServerAddress`, `Get-NetIPConfiguration`, `Resolve-DnsName
_ldap._tcp.dc._msdcs.avengers.lab`, and `nltest /dsgetdc:avengers.lab`.

## Troubleshooting

Multiple default gateways cause unpredictable routing; public DNS on a client
breaks AD discovery; a typo in the internal-network name creates isolated
segments. See `troubleshooting/dns.md` for the full evidence workflow.

