# Identity & Access Management
Last reviewed: 2026-10

## Protocols
| Protocol | Purpose | Notes |
|---|---|---|
| OAuth 2.0 (→ OAuth 2.1 consolidation) | Delegated authorization (access tokens) | Use Authorization Code + PKCE for all clients; Client Credentials for machine-to-machine; Device Code for TVs/CLIs; no Implicit or Password grant |
| OpenID Connect | Authentication on top of OAuth 2.0 (ID token) | Discovery, UserInfo, nonce, standard claims |
| SAML 2.0 | Enterprise SSO (XML assertions) | Common with legacy enterprise IdPs |
| SCIM 2.0 | User provisioning | Joiner/mover/leaver automation |
| FIDO2/WebAuthn (passkeys) | Phishing-resistant authentication | Preferred MFA |
| mTLS | Mutual certificate-based service identity | Service mesh, B2B APIs; certificate-bound tokens |
| SPIFFE/SPIRE | Workload identity standard | Cross-platform service identity |

## Tokens
- JWT: header.payload.signature; validate `alg` (pin, never `none`), signature (JWKS with key rotation),
  `iss`, `aud`, `exp`/`nbf`, scopes/roles. Keep access tokens short-lived (5–60 min); refresh token
  rotation with reuse detection; revoke via short TTL + denylist for critical cases.
- Opaque tokens + introspection when revocation must be immediate.
- Token storage in browsers: BFF pattern with httpOnly cookies is safest for SPAs.
- DPoP / mTLS-bound tokens to prevent replay of stolen tokens.

## Authorization models
RBAC (roles), ABAC (attributes/tags), ReBAC (relationships — Google Zanzibar; OpenFGA, SpiceDB, Auth0
FGA), policy engines (OPA/Rego, Cedar — Amazon Verified Permissions). Multi-tenant SaaS: tenant context
in token claims + enforcement at every data access (RLS, partition keys, per-tenant keys).

## Zero trust (NIST SP 800-207)
Continuous verification of user + device + context, least privilege, micro-segmentation, assume breach.
Implementations: identity-aware proxies (IAP, Verified Access, Entra Private Access), ZTNA replacing VPNs,
device posture checks, conditional access.

## Workforce identity in cloud
Federate IdP (Entra ID/Okta/Google) → cloud SSO (IAM Identity Center permission sets / Entra RBAC /
GCP IAM); no IAM users with long-lived keys; break-glass accounts monitored; PIM/JIT elevation;
access reviews quarterly.

## Workload identity
IAM roles for compute (instance profiles, IRSA/EKS Pod Identity, Lambda roles), Azure managed identities,
GCP service accounts with Workload Identity Federation; GitHub Actions OIDC to cloud roles — no static
secrets in CI.

## Customer identity (CIAM)
Cognito, Entra External ID, Auth0/Okta CIC, Firebase/Identity Platform, Keycloak (self-hosted). Features:
social login, MFA, passwordless, adaptive risk, bot protection, account linking, consent management.

## Interview angles
OAuth vs OIDC; why PKCE; JWT revocation strategies; multi-tenant authorization design; service-to-service
auth (mTLS vs JWT client credentials vs cloud IAM).
