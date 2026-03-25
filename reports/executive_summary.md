# Olist E-Commerce — Executive Summary
**Prepared by:** Pradeep Kumar  
**Analysis Period:** September 2016 – September 2018  
**Dataset:** 98,199 orders · 95,420 customers · 3,053 sellers · 32,729 products

---

## Business Context

Olist is Brazil's largest e-commerce marketplace connecting small businesses 
to major retail channels. This analysis examines 2 years of transactional data 
to identify revenue drivers, customer retention risks, and operational 
inefficiencies — and to provide data-backed recommendations for growth.

---

## Financial Performance

| Metric | Value |
|--------|-------|
| Total Revenue | $15,735,527 |
| Total Orders | 98,199 |
| Average Order Value | $140.37 |
| YoY Revenue Growth (2016→2017) | +13,079% |
| YoY Revenue Growth (2017→2018) | +21.2% |
| Peak Month | November 2017 — $1.17M (Black Friday) |

**Interpretation:** The business experienced hyper-growth in its first full year 
(2017) driven by market expansion. Growth slowed significantly in 2018 — 
signalling the end of the easy acquisition phase and the urgent need to shift 
focus from new customer acquisition to retention.

---

## Critical Finding — The Retention Crisis

> **96.9% of customers never place a second order.**

This is the single most important finding in this analysis. Of 95,420 unique 
customers, only 2,997 (3.1%) returned for a second purchase. Every cohort 
analysed shows near-zero retention after month 1.

This means Olist is running on a constant treadmill of new customer acquisition 
with almost no compounding retention value. Fixing retention is worth more than 
any marketing spend on new customers.

---

## Revenue Concentration Risks

### Geographic concentration
- São Paulo alone generates **37.3% of total revenue**
- Top 3 states (SP, RJ, MG) generate **66% of revenue**
- 24 remaining states share only 34% — significant untapped potential

### Product concentration  
- **17 of 72 categories (23.6%) generate 80% of revenue** (Pareto rule confirmed)
- Top category: Health & Beauty — $1.26M revenue
- Bottom 55 categories together generate only $3.15M

### Payment concentration
- **73.6% of orders paid by credit card** with avg 3.5 installments
- Boleto (Brazilian bank slip) = 19% — important for unbanked customers
- Only 1.5% use debit card

---

## Delivery Performance & Its Business Impact

| Delivery Category | Orders | Avg Review Score | Bad Review Rate |
|-------------------|--------|-----------------|-----------------|
| On Time | 89,944 | 4.29 ⭐ | 9% |
| Slightly Late (1-3 days) | 1,856 | 3.29 ⭐ | 32% |
| Late (4-7 days) | 1,756 | 2.10 ⭐ | 67% |
| Very Late (7+ days) | 2,797 | 1.70 ⭐ | 79% |

**Key insight:** Even a minor 1-3 day delay causes a 23% drop in review score 
and triples the bad review rate. The states with worst late delivery rates 
(AL: 21.4%, MA: 17.4%, SE: 15.2%) are also the states with lowest customer 
satisfaction scores.

**Delivery quality is the #1 controllable driver of customer satisfaction 
and retention.**

---

## Customer Segmentation (RFM Model)

| Segment | Customers | % of Total | Revenue | Strategic Action |
|---------|-----------|------------|---------|-----------------|
| At Risk | 22,780 | 23.9% | $3.84M | Win-back campaign |
| Occasional Buyers | 20,993 | 22.0% | $1.39M | Re-engagement emails |
| New Customers | 15,283 | 16.0% | $2.51M | Second-purchase incentive |
| Loyal Customers | 14,495 | 15.2% | $3.01M | Loyalty programme |
| Big Spenders | 8,786 | 9.2% | $2.65M | Frequency campaigns |
| Champions | 6,627 | 6.9% | $2.09M | VIP rewards |
| Lost | 6,456 | 6.8% | $0.36M | Final win-back or write off |

**Most urgent:** The At-Risk segment (22,780 customers) holds $3.84M in 
revenue and has an average of 400 days since last purchase. Without 
intervention, these customers will move to Lost within months.

---

## Churn Prediction Model

- **Model:** Logistic Regression vs Random Forest
- **Target:** Single-purchase customers (96.9% churn rate)
- **Challenge:** Extreme class imbalance handled via class_weight='balanced'
- **Best model AUC:** 0.602 (Logistic Regression)
- **High-value at-risk customers identified:** 19,231
- **Revenue at stake:** $8,213,434

**Finding:** Churned and non-churned customers show nearly identical 
first-order behaviour — confirming that Olist's churn is structural 
(market-level habit, not experience-driven) rather than experience-driven.
This means the solution is relationship-building post-purchase, not 
fixing the purchase experience itself.

---

## Top 5 Business Recommendations

### 1. Launch a win-back campaign for At-Risk customers
**Target:** 22,780 customers · **Revenue at stake:** $3.84M  
Send personalised "We miss you" emails with a 10-15% discount code.  
Even 5% conversion rate = **$192,000 recovered revenue.**  
Priority: customers with high monetary score who haven't bought in 6-12 months.

### 2. Fix delivery in high-delay states before expanding
**Target:** AL (21.4% late), MA (17.4%), SE (15.2%)  
Late delivery is the strongest predictor of bad reviews and non-return.  
Negotiate SLAs with logistics partners in Northeast Brazil specifically.  
A 5-point reduction in late delivery rate could lift platform avg review 
from 4.09 to ~4.3 stars.

### 3. Introduce a second-purchase incentive within 30 days
**Target:** 15,283 New Customers  
Cohort analysis shows retention drops to near-zero after month 1.  
A time-limited offer (30-day window post first purchase) creates urgency.  
This directly attacks the retention crisis at its earliest intervention point.

### 4. Concentrate product investment on top 17 categories
**Target:** Health & Beauty, Watches & Gifts, Bed/Bath, Sports, Computers  
These 17 categories generate 80% of revenue.  
Expand seller recruitment, promotional spend, and inventory depth here first.  
Pause expansion into the bottom 55 categories until retention is solved.

### 5. Build a loyalty programme for Champions and Loyal Customers
**Target:** 21,122 combined customers · **Revenue:** $5.09M (32% of total)  
These customers already return — reward them so they stay and refer others.  
Early access to new products, free shipping threshold, referral bonuses.  
Protecting this group is cheaper than acquiring new customers.

---

## Conclusion

Olist has built strong revenue growth on the back of Brazil's e-commerce 
expansion. However, the data reveals a business at an inflection point — 
easy acquisition growth is slowing and the near-zero retention rate 
(3.1%) means the business must fundamentally shift strategy.

The path forward is clear:
**Fix delivery → Improve satisfaction → Drive retention → Compound revenue.**

The tools exist. The data proves the opportunity. The cost of inaction is 
$3.84M in at-risk revenue and a growing Lost customer segment that will 
never return.

---

*Analysis conducted using Python (Pandas,NumPy,Matplot,Seaborn, Scikit-learn), PostgreSQL, 
and Tableau Public. Full methodology, SQL queries, and notebooks 
available at: [https://github.com/P568848382]*