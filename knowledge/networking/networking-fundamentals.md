# Networking Fundamentals
Last reviewed: 2026-10 | Load when: protocols, latency, DNS, TLS, CDN, LB, network interviews

## Layers (practical)
L2 Ethernet/ARP → L3 IP (routing, CIDR, BGP) → L4 TCP/UDP (ports, flow control) → L7 HTTP/gRPC/DNS.

## IP & CIDR
/16 = 65,536 addrs, /20 = 4,096, /24 = 256, /28 = 16. Cloud reserves addresses per subnet (AWS 5,
Azure 5, GCP 4). RFC 1918: 10/8, 172.16/12, 192.168/16. Plan non-overlapping CIDRs org-wide (IPAM) —
overlaps block peering/hybrid routing later. IPv6 to mitigate IPv4 exhaustion & public IPv4 charges.

## TCP vs UDP vs QUIC
- TCP: 3-way handshake (1 RTT), reliable ordered, congestion control (CUBIC, BBR), head-of-line blocking.
- UDP: connectionless; DNS, streaming, games, QUIC.
- QUIC (HTTP/3): over UDP, TLS 1.3 built in, 0/1-RTT setup, no transport-level HOL blocking,
  connection migration (mobile).

## TLS
TLS 1.3: 1-RTT handshake (0-RTT resumption with replay caveats), forward secrecy, fewer ciphers.
Certificates (X.509 chain), SNI, ALPN, OCSP stapling, mTLS (client certs) for service identity.
Termination options: at edge (CDN/LB) vs end-to-end re-encryption vs passthrough (L4).

## HTTP evolution
HTTP/1.1 (keep-alive, one request at a time per connection) → HTTP/2 (multiplexing, HPACK, binary)
→ HTTP/3 (QUIC). Headers: Cache-Control, ETag, Vary, CORS (preflight OPTIONS), HSTS.

## DNS
Recursive resolver → root → TLD → authoritative. Records: A/AAAA, CNAME (not at apex — use ALIAS/ANAME),
MX, TXT (SPF/DKIM/DMARC), NS, SOA, CAA, SRV. TTL trade-off: low TTL = faster failover, more queries.
Routing policies: weighted, latency, geolocation, geoproximity, failover, multivalue. Split-horizon/
private DNS; hybrid resolution with conditional forwarders (Route 53 Resolver endpoints, Azure DNS
Private Resolver, Cloud DNS forwarding). DNSSEC.

## Load balancing & anycast
L4 vs L7 (see fundamentals). Global: DNS-based (Route 53/Traffic Manager) vs anycast IP (Global
Accelerator, Front Door, GCP global LB, Cloudflare) — anycast routes users to the nearest PoP via BGP and
fails over without DNS TTL waits.

## CDN
Edge caching, TLS termination near user, origin shield, DDoS absorption, edge compute. Metrics: cache
hit ratio, origin offload, TTFB.

## Hybrid connectivity
Site-to-site IPsec VPN (quick, internet-based, ~1.25 Gbps per tunnel on AWS ⚠️), dedicated links (Direct
Connect/ExpressRoute/Interconnect: 1–100 Gbps, predictable latency, MACsec), BGP for dynamic routing
(AS paths, local preference, MED for path selection), SD-WAN integration.

## Troubleshooting toolkit
`dig`/`nslookup`, `traceroute`/`mtr`, `curl -v --resolve`, `openssl s_client`, `tcpdump`/Wireshark,
VPC Flow Logs/NSG flow logs, Reachability Analyzer / Network Watcher / Connectivity Tests.

## Interview angles
"What happens when you type a URL?" → DNS → TCP/QUIC → TLS → HTTP → CDN/LB → app → response → render.
