# Infrastructure as Code
Last reviewed: 2026-10 ⚠️ Terraform moved to BSL (2023) → OpenTofu (MPL, Linux Foundation); IBM acquired HashiCorp (2025)

Deep dive on Terraform/OpenTofu: `devops/terraform-deep-dive.md`. Failure diagnosis:
`devops/pipeline-and-iac-failure-modes.md`.

## Tool selection
| Tool | Language | Best for |
|---|---|---|
| Terraform / OpenTofu | HCL | Multi-cloud, huge provider ecosystem, most common in enterprises |
| AWS CDK | TS/Python/Java/C#/Go → CloudFormation | AWS-only teams who prefer code & constructs |
| CloudFormation | YAML/JSON | AWS-native, StackSets for org-wide |
| Bicep | DSL → ARM | Azure-native |
| Pulumi | General-purpose languages | Developer-centric multi-cloud |
| Crossplane | K8s CRDs | Platform teams building control planes |

## Terraform practices
- Remote state with locking (S3 native lockfile or DynamoDB legacy; Azure Storage; GCS; HCP Terraform);
  state per environment/component (blast radius); never commit state.
- Module structure: reusable modules (versioned registry) + root modules per environment; pin provider
  and module versions.
- Workflow: fmt → validate → tflint → security scan (Checkov/Trivy config/KICS) → plan (PR comment via
  Atlantis/HCP/GitHub Actions) → policy check (OPA/Conftest/Sentinel) → apply with approvals.
- Avoid workspaces for env isolation in large orgs (prefer separate state/backends/accounts).
- Import/moved blocks for refactoring; drift detection jobs.
- Secrets: never in variables files; reference secret managers; mark sensitive outputs.

## Policy as code
OPA/Rego (Conftest, Gatekeeper), Sentinel, Checkov custom policies, cfn-guard, Azure Policy, AWS Config
rules, SCPs.

## Environments & promotion
Same code, different variables; promote artifacts (module versions) through dev → staging → prod; use
account/subscription-per-environment.

## Interview angles
Handling state corruption/drift; module design for multi-team platforms; GitOps for infra; preventing
misconfigurations reaching prod (policy gates).
