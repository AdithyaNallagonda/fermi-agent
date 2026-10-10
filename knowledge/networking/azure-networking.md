# Azure Networking
Last reviewed: 2026-10 ⚠️ verify via `microsoft-learn` MCP

## VNet basics
VNets are regional; subnets span AZs. NSGs (stateful, subnet or NIC), Application Security Groups
(group NICs logically in rules), User-Defined Routes (UDRs) to force traffic via firewall/NVA. Default
outbound access for new VNets is being retired → use NAT Gateway, Azure Firewall, or LB outbound rules.

## Topologies
- **Hub-spoke (customer-managed)**: hub VNet with Azure Firewall, VPN/ExpressRoute gateways, Bastion,
  DNS Private Resolver; spokes peered to hub; UDRs force traffic through firewall.
- **Virtual WAN**: Microsoft-managed hubs, any-to-any transit, routing intent for secured hubs, scale for
  many branches/regions.
- VNet peering (regional/global, non-transitive) — use hub NVA/firewall or vWAN for transit. Azure
  Virtual Network Manager for connectivity & security admin rules at scale.

## Private access
- **Private Endpoint** (Private Link): private IP in your VNet for PaaS (SQL, Storage, Key Vault…);
  requires Private DNS zones (privatelink.*) linked to VNets; reachable from peered VNets & on-prem.
- **Service Endpoint**: optimized route to PaaS public endpoint from a subnet; no private IP; not
  reachable from on-prem. Prefer Private Endpoints for zero-trust.
- **Private Link Service**: expose your own service behind Standard LB.

## Load balancing decision
| Service | Scope | Layer | Use |
|---|---|---|---|
| Front Door (Standard/Premium) | Global | L7 + CDN + WAF | Global web apps, edge acceleration |
| Traffic Manager | Global | DNS | Non-HTTP global failover/routing |
| Application Gateway (v2, WAF) | Regional | L7 | Regional web apps, AGIC/App Gateway for Containers for AKS |
| Load Balancer (Standard) | Regional (+ cross-region tier) | L4 | TCP/UDP, HA ports for NVAs |

## Hybrid
VPN Gateway (S2S, P2S, active-active, BGP), ExpressRoute (private peering, Microsoft peering;
Global Reach to connect sites via Microsoft backbone; FastPath; ExpressRoute Direct 10/100 Gbps;
resiliency: two circuits in different peering locations for maximum resiliency).

## DNS
Azure DNS public zones; Private DNS zones; **Azure DNS Private Resolver** (inbound/outbound endpoints,
forwarding rulesets) replaces custom DNS VMs for hybrid resolution.

## Security
Azure Firewall (Standard/Premium: TLS inspection, IDPS, URL filtering), Firewall Manager, DDoS Network
Protection, WAF on Front Door/App Gateway, Bastion (no public IPs on VMs), NSG flow logs → VNet flow
logs, Network Watcher.

## Exam traps (AZ-700 / AZ-305)
Gateway transit on peering for shared VPN/ER gateway; Private Endpoint DNS configuration is the #1
failure cause; Front Door vs App Gateway vs Traffic Manager; ExpressRoute isn't encrypted by default
(use MACsec or IPsec over ER); forced tunneling via UDR 0.0.0.0/0.
