# Cloud Security Architecture
Last reviewed: 2026-10

## Shared responsibility
Provider secures the cloud (facilities, hardware, hypervisor, managed service internals); customer
secures what's in the cloud (identity, data, config, network rules, app code). Responsibility shifts
toward provider as you move IaaS → PaaS → SaaS.

## Reference controls by layer
| Layer | AWS | Azure | GCP |
|---|---|---|---|
| Org guardrails | SCPs, RCPs, Control Tower | Azure Policy, Management Groups | Org Policy |
| Identity | IAM Identity Center, IAM roles, Access Analyzer | Entra ID, PIM, Conditional Access | Cloud Identity, IAM, PAM |
| Network | SGs, NACLs, Network Firewall, WAF, Shield | NSGs, Azure Firewall, WAF, DDoS Protection | VPC firewall policies, Cloud Armor, Cloud NGFW |
| Data | KMS, Macie, S3 Block Public Access | Key Vault, Purview, Storage firewalls | Cloud KMS, Sensitive Data Protection, VPC SC |
| Detection | GuardDuty, Security Hub, Inspector, Detective | Defender for Cloud, Sentinel | Security Command Center, Google SecOps |
| Logging | CloudTrail (org trail), Config, VPC Flow Logs | Activity Log, Diagnostic settings, Log Analytics | Cloud Audit Logs, VPC Flow Logs |

## Data perimeter (AWS concept, generalizable)
Only trusted identities access trusted resources from expected networks: SCP/RCP conditions
(`aws:PrincipalOrgID`, `aws:ResourceOrgID`, `aws:SourceVpce`), VPC endpoint policies, resource policies.
Azure/GCP analogs: Private Endpoints + policies; VPC Service Controls.

## Encryption & keys
Envelope encryption (data key encrypted by KMS key); customer-managed keys for regulated data; key
rotation; separation of duties (key admins ≠ key users); HSM for FIPS 140-3 L3 needs; BYOK/HYOK/EKM for
sovereignty.

## Secrets
Central vault, automatic rotation, workload identity instead of secrets where possible (IAM roles, managed
identities, workload identity federation), no secrets in env files committed or container images.

## CSPM / CNAPP
Continuous misconfiguration detection (CIS Benchmarks), attack path analysis, workload protection
(CWPP), CIEM (entitlements), container/K8s security, IaC scanning. Vendors: Wiz, Prisma Cloud, Orca,
Defender for Cloud, Security Hub CSPM.

## Incident response in cloud
Pre-provisioned forensic accounts/roles, automated isolation (quarantine SG, revoke sessions), snapshot
evidence, CloudTrail/Activity Log analysis, playbooks (exposed access key, public bucket, crypto-mining
instance, compromised IAM user).

## Compliance frameworks
CIS, NIST CSF 2.0, ISO 27001/27017/27018, SOC 2, PCI DSS 4.0, HIPAA, FedRAMP, GDPR, India: DPDP Act 2023
(and DPDP Rules 2025 ⚠️ verify), CERT-In directions (6-hour incident reporting, log retention 180 days),
RBI master directions on IT/outsourcing/cloud, SEBI CSCRF, IRDAI guidelines.
