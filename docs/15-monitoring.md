# Monitoring

Run `docker compose config` before `docker compose up -d`; then open local-only
Grafana on `http://localhost:3000`. Change the initial Grafana administrator
password immediately. Pinned image tags make the build reviewable; update them
deliberately after reading release notes.

Install the Prometheus community Windows exporter on DC01, enable only needed
collectors, allow TCP 9182 from the monitoring host only, and verify
`http://10.10.10.10:9182/metrics`. Install Grafana Alloy on DC01 (not just in the
container) to read Windows events; restrict channels/events and protect transport.
Useful signals: CPU, memory, disk, DNS/Netlogon/KDC service health, 4625 failures,
4740 lockouts, and availability. Logs can contain usernames and host data; apply
access control, retention, and privacy review.

The base Compose stack cannot observe AD automatically. Validate Prometheus
Targets, query `up{job="dc01-windows"}`, generate a safe failed lab logon, and
confirm the selected event reaches Loki before building dashboards/alerts.

