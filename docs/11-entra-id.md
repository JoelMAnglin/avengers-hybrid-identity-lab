# Microsoft Entra ID

Use a dedicated test tenant, enable MFA for administrators, create two emergency
access accounts according to current Microsoft guidance, and avoid production
identities. Licensing changes: confirm current Free/P1/P2/Entra ID Governance
requirements before claiming Conditional Access, PIM, access reviews, or risk
features. Record tenant region, custom-domain/UPN decision, roles, licenses, and
consent approvals without recording secrets.

Cloud-only and synchronized identities have different sources of authority.
Never edit synchronized attributes in the cloud merely to hide an on-premises
data problem. Capture a redacted portal screenshot and validate a test user with
Graph rather than relying only on the UI.

