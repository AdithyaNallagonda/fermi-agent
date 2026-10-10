# AWS Networking
Last reviewed: 2026-10 ⚠️ verify quotas/pricing

## VPC basics
Regional; subnets per AZ (public = route to IGW; private = route to NAT GW or none). Security groups
(stateful, allow-only, reference other SGs) vs NACLs (stateless, subnet-level, allow+deny, ordered).
Route tables, IGW, egress-only IGW (IPv6), NAT Gateway (per AZ for HA; charged per hour + per GB
processed), Elastic IPs (public IPv4 now charged hourly).

## Private access to AWS services
- **Gateway endpoints**: S3 and DynamoDB only, free, route-table based.
- **Interface endpoints (PrivateLink)**: ENIs with private IPs for most services; hourly + per GB.
- Endpoint policies restrict which resources can be accessed (data perimeter).

## Connecting VPCs
| Option | Use | Notes |
|---|---|---|
| VPC peering | Few VPCs, low latency, no extra hop | Non-transitive, no overlapping CIDRs |
| Transit Gateway | Hub-and-spoke at scale (thousands of VPCs), route tables for segmentation | Per-attachment hourly + per-GB processing |
| Cloud WAN | Global network with policy-driven segments across regions | Built on TGW concepts |
| PrivateLink (endpoint services) | Expose a service (behind NLB/GWLB) to consumers, overlapping CIDRs OK, unidirectional | SaaS pattern |
| VPC Lattice | Service-to-service connectivity, auth policies, across VPCs/accounts | Application-layer service network |
| Shared VPC (RAM subnet sharing) | Central network team, app teams deploy into shared subnets | |

## Edge & load balancing
CloudFront (CDN, OAC for S3, Functions/Lambda@Edge, VPC origins), Global Accelerator (anycast static
IPs, TCP/UDP, fast regional failover), ALB (L7, path/host routing, OIDC auth, gRPC, Lambda targets),
NLB (L4, static IP per AZ, ultra-low latency, TLS passthrough/termination, PrivateLink), GWLB (inline
appliances via GENEVE).

## DNS (Route 53)
Public/private hosted zones; alias records (apex to ELB/CloudFront free queries); routing policies;
health checks; Resolver inbound/outbound endpoints + rules for hybrid DNS; DNS Firewall; Route 53 ARC for
multi-region failover controls; Route 53 Profiles to share DNS config across accounts.

## Hybrid
Site-to-Site VPN (2 tunnels per connection; attach to VGW or TGW; Accelerated VPN), Direct Connect
(dedicated 1/10/100 Gbps or hosted; private/public/transit VIFs; DX Gateway for multi-region; resiliency
models: dev → high (2 locations) → maximum (4 connections, 2 locations)), DX + VPN backup, MACsec.

## Inspection & security
Network Firewall (stateful, Suricata rules, domain filtering) in centralized inspection VPC with TGW
appliance mode; WAF on CloudFront/ALB/API Gateway/AppSync; Shield Standard (free) / Advanced; Firewall
Manager; VPC Flow Logs; Traffic Mirroring; Verified Access (zero-trust app access without VPN).

## Data transfer cost model (high level ⚠️)
Same-AZ private IP: free; cross-AZ: ~$0.01/GB each direction; inter-region: ~$0.02/GB (varies);
internet egress tiered ~ $0.09/GB first tier (first 100 GB/month free); NAT GW processing ~ $0.045/GB;
TGW processing ~ $0.02/GB. Design to keep chatty traffic in-AZ and use endpoints.

## Reference topologies
1. **Centralized egress**: spokes → TGW → egress VPC (NAT GW + Network Firewall) → IGW.
2. **Centralized ingress**: internet → CloudFront/WAF → ALB in ingress VPC → TGW/PrivateLink → apps.
3. **Hybrid DNS**: on-prem ↔ Route 53 Resolver endpoints in shared services VPC, rules shared via RAM.
4. **Multi-region**: Cloud WAN segments (prod/dev/shared) with policy-based routing.

## Exam traps (ANS-C01 / SAP-C02)
Transitive routing not possible through peering/VGW; DX public VIF to reach public AWS endpoints; BGP
attributes to prefer DX over VPN (more specific prefixes, AS_PATH prepending, local preference
communities); NLB preserves source IP; PrivateLink is unidirectional; overlapping CIDRs → PrivateLink
or private NAT gateway.
