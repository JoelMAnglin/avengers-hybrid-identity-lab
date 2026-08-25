# Lessons Learned and Interview Questions

Identity systems are distributed systems: DNS, time, routing, replication, and
source-of-authority errors often appear as "password problems." OUs manage scope;
groups grant authorization. AGDLP separates business roles from resource ACLs.
Privileged separation reduces credential exposure, while gMSA removes manual
service-password rotation for supported workloads. Monitoring is only credible
after testing the signal path end to end.

Practice answering: Why does AD depend on DNS? Authentication vs authorization?
OU vs group? What is AGDLP? Kerberos, LDAP, and SPNs? Why separate admin accounts?
What is least privilege and gMSA? AD vs Entra? Hybrid source of authority? How do
you diagnose domain join, lockout, GPO scope, or a missing synchronized user?

