# SaaS Monetization, Pricing & Unit Economics
Last reviewed: 2026-10

## Pricing models
| Model | Fits | Watch |
|---|---|---|
| Flat subscription | Simple single-segment products | Leaves money on table with large customers |
| Tiered (Good/Better/Best) | Most B2B SaaS | Feature fences must map to segments |
| Per seat | Collaboration tools | Seat compression; AI reduces seats needed |
| Usage-based (API calls, GB, docs, minutes) | Infra/dev tools, AI products | Revenue volatility; needs metering & spend caps |
| Hybrid (platform fee + usage) | AI SaaS, data products | Explainability to buyers |
| Outcome-based | AI agents (per resolved ticket, per qualified lead) | Measurement & attribution |
| Freemium | Viral/PLG products with low marginal cost | Free-tier costs (esp. LLM) — cap usage |
| Credits | AI generation products | Clear credit-to-value mapping |
| Marketplace take rate | Two-sided platforms | Liquidity first |
| Licensing / on-prem / BYOC | Regulated enterprise | Support burden |

## Unit economics
- **MRR/ARR**, **ARPA**, **gross margin** = (revenue − COGS)/revenue. COGS includes hosting, LLM tokens,
  third-party APIs, payment fees, support.
- **Churn**: logo vs revenue; **NRR** (net revenue retention) > 100% means expansion beats churn
  (best-in-class B2B 120%+).
- **CAC** (sales + marketing ÷ new customers), **LTV** ≈ ARPA × GM% ÷ monthly churn, **LTV:CAC ≥ 3**,
  **CAC payback** ≤ 12 months (SMB) / ≤ 18–24 (enterprise).
- **Rule of 40** (growth % + profit margin % ≥ 40) for scaled companies.

## AI product economics
Model cost per task × tasks per user per month → cost per user; protect margin with: model routing (small
models first), prompt caching, batch processing, response length limits, semantic caching, usage caps per
tier, passing heavy usage to usage-based pricing. Re-price as model costs fall.

## Pricing process
1. Identify value metric. 2. Segment customers (willingness to pay differs). 3. Research: Van Westendorp
price sensitivity, conjoint, competitor benchmarks, sales conversations. 4. Set tiers & fences.
5. Launch, measure conversion/expansion, iterate (price increases for new customers first, grandfather
existing).

## Payments & billing stack
Stripe (global), Razorpay / Cashfree / PayU (India: UPI AutoPay mandates, cards with RBI e-mandate rules),
Paddle / Lemon Squeezy (merchant of record handles global sales tax/VAT), Chargebee / Orb / Metronome /
Lago (subscription & usage billing). Cloud marketplaces (AWS/Azure/GCP) for enterprise procurement.

## India-specific notes ⚠️ consult a CA
GST on SaaS (18%); export of services may be zero-rated under LUT; FEMA/FIRC for foreign receipts; TDS
considerations for B2B; entity choice (Pvt Ltd for fundraising; LLP for services); invoicing compliance
(e-invoicing thresholds).

## GTM metrics
Activation rate, time-to-value, D7/D30 retention, free→paid conversion (freemium 2–5% typical; trial
10–25%), pipeline coverage (sales-led), win rate, sales cycle length.
