# Google Cloud Networking
Last reviewed: 2026-10 ⚠️ verify

## VPC model
**Global VPC**: one network spans all regions; subnets regional. Firewall rules / hierarchical firewall
policies / network firewall policies (tag- or service-account-based targeting). Routes (system, custom,
dynamic via Cloud Router BGP). Auto-mode vs custom-mode (use custom in production).

## Multi-project networking
- **Shared VPC**: host project owns the network; service projects deploy into shared subnets. Central
  network/security control — enterprise default.
- **VPC Network Peering**: non-transitive, no overlapping ranges.
- **Network Connectivity Center (NCC)**: hub-and-spoke for VPC spokes and hybrid spokes (transit).
- **Private Service Connect (PSC)**: private endpoints to Google APIs, published services (producer/
  consumer), overlapping IPs OK.
- **Private Google Access**: VMs without external IPs reach Google APIs.
- **Private Services Access**: peering-based private IPs for Cloud SQL, Memorystore, etc. (PSC
  increasingly preferred ⚠️).

## Load balancing (Cloud Load Balancing)
| LB | Scope | Notes |
|---|---|---|
| Global external Application LB | Global anycast IP | L7, Cloud CDN, Cloud Armor, serverless NEGs |
| Regional external/internal Application LB | Regional | Envoy-based L7 |
| Cross-region internal Application LB | Global internal | Multi-region internal services |
| External/internal passthrough Network LB | Regional | L4, preserves client IP |
| Proxy Network LB | Global/regional | TCP/SSL proxy |

## Hybrid
HA VPN (99.99% SLA with 2 tunnels/interfaces), Dedicated Interconnect (10/100 Gbps), Partner
Interconnect, Cross-Cloud Interconnect (to AWS/Azure/OCI/Alibaba), Cloud Router (BGP).

## DNS
Cloud DNS (public/private zones, forwarding zones, peering zones, DNS policies with inbound server
policy for on-prem resolution), response policies.

## Security
Cloud Armor (WAF, DDoS, adaptive protection, bot management), Cloud NAT (managed, no proxy VM),
Cloud IDS, Cloud NGFW (Enterprise with threat intel), VPC Service Controls (service perimeters around
APIs to prevent exfiltration), Identity-Aware Proxy (IAP) for zero-trust access to apps/VMs (TCP
forwarding).

## Exam traps (PCNE / PCA)
Shared VPC vs peering; global vs regional LB selection; Private Google Access vs PSC; firewall rule
priority (lower number = higher priority), implied deny ingress/allow egress; VPC SC for data
exfiltration questions; HA VPN requires Cloud Router (dynamic routing).
