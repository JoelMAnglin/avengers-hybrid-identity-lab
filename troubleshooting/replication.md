# Replication

**SYMPTOM:** multi-DC objects/passwords/GPOs differ. **LIKELY CAUSES:** DNS, time,
RPC/firewall, topology, lingering/offline DC, or SYSVOL. **COMMANDS:** `repadmin
/replsummary`, `repadmin /showrepl`, `dcdiag /test:replications`, Directory Service
and DFS Replication logs. **RESOLUTION:** repair DNS/connectivity/time first; never
force destructive metadata cleanup casually. **VALIDATION:** every partner shows
recent success and SYSVOL/NETLOGON shares exist. **LESSON LEARNED:** one-DC lab
cannot demonstrate replication; add DC02 only after baseline health.

