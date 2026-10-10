# Playbook: Monetization & Go-To-Market

Knowledge: `knowledge/business/saas-monetization-and-pricing.md`,
`knowledge/business/entrepreneurship-and-idea-validation.md`.

## Step 1 — Identify the value metric
What unit of value does the customer get (seats, API calls, documents processed, GB, outcomes)?
Price should scale with the value metric.

## Step 2 — Choose a model (justify)
Subscription (tiered / per-seat / usage-based / hybrid), freemium, free trial (reverse trial),
transaction fee/marketplace take rate, licensing/on-prem, services + product, ads (consumer only,
needs scale), API monetization, AI credits (pass-through LLM cost + margin).

## Step 3 — Unit economics (show the math)
- COGS per user/month (infra + LLM tokens + third-party APIs + support) → target gross margin ≥ 70–80%
  for SaaS (AI-heavy products often 50–65% — design cost controls).
- CAC, LTV = ARPA × gross margin ÷ churn; target LTV:CAC ≥ 3, CAC payback < 12–18 months.
- Break-even users at chosen price.

## Step 4 — Pricing page draft
3 tiers (Good/Better/Best) + Enterprise "Contact us"; anchor; annual discount 15–20%; usage limits tied
to the value metric; feature fences that map to segments. For India: consider INR pricing, UPI
autopay, GST (18% on SaaS — verify with a CA), and purchasing power tiers.

## Step 5 — GTM motion
| Motion | When | Channels |
|---|---|---|
| Product-led (PLG) | Low ACV, self-serve | SEO, content, communities, Product Hunt, templates, integrations marketplaces |
| Sales-led | High ACV, enterprise | Outbound, partners, LinkedIn, events, POCs |
| Community-led | Dev tools | OSS core, Discord, DevRel |
| Marketplace | Cloud-buyers | AWS/Azure/GCP Marketplace (counts toward customer commit spend) |

## Step 6 — Launch plan (first 90 days)
Waitlist → design partners (5–10) → private beta → public launch; metrics: activation rate, D7/D30
retention, conversion to paid, NPS. Instrument with product analytics from day 1.

## Step 7 — Legal/ops checklist (flag "consult a professional")
Entity (India: Pvt Ltd / LLP / sole prop), GST registration, payment gateway (Razorpay/Stripe/
Cashfree), ToS/Privacy Policy (DPDP Act 2023 / GDPR), invoicing, international payments (FIRC/LUT
for export of services — verify with CA).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard (Deep for legal/tax claims)**.
Apply: B (pricing model, GTM motion), R-check all unit-economics arithmetic, E (competitor prices, GST/payment rules — primary sources or flagged). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
