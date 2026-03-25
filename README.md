# Olist E-Commerce Customer Intelligence Platform
### End-to-End Data Analytics Project | Python · PostgreSQL · Tableau · Machine Learning

> **Live Dashboards →** 
[Executive Overview](<https://public.tableau.com/views/Olist-Ecommerce-Intelligence-ExcecutiveOverview-2016to2018-PradeepKumar/OlistE-CommerceExecutiveOverview20162018?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link>) |
[Geographic Analysis](<https://public.tableau.com/views/Olist-Ecommerce-Intelligence-PradeepKumar-Geographicrevenueanddeliveryanalysis/GeographicRevenueDeliveryAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link>) | 
[Product Analysis](<https://public.tableau.com/views/Olist-Ecommerce-Intelligence-CustomerProductCategoryAnalysisParetoAnalysis-PradeepKumar/ProductCategoryAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link>) | 
[RFM Segmentation](<https://public.tableau.com/views/Olist-Ecommerce-Intelligence-PradeepKumar/CustomerSegmentationChurnRiskAnalysisRFMModel?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link>) | 
[Delivery Quality](<https://public.tableau.com/views/Olist-Ecommerce-Intelligence-DeliveryQualityCustomerSatisfactionAnalysis-PradeepKumar/OlistE-CommerceDeliveryQualityCustomerSatisfactionAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link>)

---

## Project Overview

Analysed **96,000+ orders** from Olist — Brazil's largest e-commerce marketplace — 
to uncover revenue drivers, customer retention risks, and operational inefficiencies 
across a 2-year period (2016–2018).

This project covers the complete data analytics pipeline:
data ingestion → cleaning → SQL analysis → customer segmentation → 
churn prediction → interactive dashboards → business recommendations.

---

## Key Business Findings

| # | Finding | Impact |
|---|---------|--------|
| 1 | Only 17 of 72 product categories generate **80% of revenue** (Pareto) | Focus investment on top categories |
| 2 | A **1–3 day delivery delay** drops avg review score by 23% (4.21 → 3.23 stars) | Fix logistics before marketing |
| 3 | **96.9% of customers never return** after first purchase | Retention is the #1 growth lever |
| 4 | **22,780 At-Risk customers** hold $3.84M revenue at risk | Win-back campaign needed urgently |
| 5 | **SP, RJ, MG** generate 66% of all revenue (3 of 27 states) | Geographic concentration risk |
| 6 | Credit card + installments = **73.6% of orders** (avg 3.5 installments) | Expand installment options |

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **Python + Pandas** | Data cleaning, feature engineering, EDA |
| **PostgreSQL** | Relational schema, SQL business analysis |
| **Scikit-learn** | Churn prediction (Logistic Regression, Random Forest) |
| **Tableau Public** | Interactive dashboards (5 views) |
| **SQLAlchemy** | Python–PostgreSQL connection |
| **Jupyter Notebook** | Analysis notebooks |
| **GitHub** | Version control, portfolio hosting |

---

## Project Structure
```
olist-ecommerce-intelligence/
│
├── data/
│   ├── raw/              ← original Kaggle CSVs (9 files)
│   └── processed/        ← cleaned + engineered datasets
│           ├──Tableau_Files/     ← cleaned + direct Use in Tableau
├── notebooks/
│   ├── 01_data_cleaning.ipynb         ← Phase 2
│   ├── 02_rfm_segmentation.ipynb      ← Phase 4
│   ├── 02_cohort_analysis.ipynb       ← Phase 4
│   └── 03_churn_prediction.ipynb      ← Phase 5
│
├── sql/
│   ├── schema.sql         ← database schema (9 tables) <--Phase 3
│   └── analysis.sql       ← 10 business queries   <--Phase 3
│
├── reports/
│   ├── rfm_segments.png
│   ├── cohort_retention_heatmap.png
│   ├── churn_model_results.png
│   └── executive_summary.md
│   └── Tableau DashBoard Screenshots/
|                        └──1_Executive_Overview.png
|                        └──2_Geographic_Analysis.png
|                        └──3_Product_Analysis(Pareto_Analysis).png
|                        └──4_RFm_Customer_Segmentaion.png
|                        └──5_Delivery_Quality_And_Customer_Satisfaction_Analysis.png
└── README.md
```

---

## Dashboard Previews

### Dashboard 1 — Executive Overview
![Executive Overview](<olist-ecommerce-intelligence/reports/Tableau DashBoard Screenshots/1_Executive_Overview.png>)
### Dashboard 2 — Geographic Analysis
![Geographic Analysis](<olist-ecommerce-intelligence/reports/Tableau DashBoard Screenshots/2_Geographic_Analysis.png>)
### Dashboard 3 — Product_Analysis(Pareto_Analysis)
![Product_Analysis(Pareto_Analysis)](<olist-ecommerce-intelligence/reports/Tableau DashBoard Screenshots/3_Product_Analysis(Pareto_Analysis).png>)

### Dashboard 4 — RFM Customer Segmentation  
![RFM Segmentation](<olist-ecommerce-intelligence/reports/Tableau DashBoard Screenshots/4_RFM_Customer_Segmentation.png>)
### Dashboard 5 — Delivery Quality & Customer Satisfaction Analysis
![Delivery Quality & Customer Satisfaction Analysis](<olist-ecommerce-intelligence/reports/Tableau DashBoard Screenshots/5_Delivery_Quality_And_Customer_Satisfaction_Analysis.png>)


---

## Methodology

### Data Pipeline
- Loaded 9 CSV tables into PostgreSQL with proper foreign key relationships
- Engineered 10+ new features including ,`delivery_delay_days`, `is_late`, 
  `revenue_per_item`, `customer_order_number`,`is_late`,`num_of_installments`,`review_score`,`is_repeat_customer`,`review_bucket`,`order_month` etc.
- Built master fact table (112,650 rows × 36 columns)

### SQL Analysis
- Wrote 10 business queries using CTEs, window functions (`LAG`, `RANK`, 
  `NTILE`, `ROW_NUMBER`), and subqueries
- Conducted Pareto analysis using cumulative `SUM() OVER()` window function
--SECTION 1:-REVENUE AND GROWTH ANALYSIS
    -- QUERY 1.1: Overall Business KPIs
    -- Business Question: What is the total scale of this business?
    -- Technique: Basic aggregation, ROUND(), CAST()

    -- QUERY 1.2: Revenue trend by year
    -- Business Question: Is the business growing year over year?
    -- Technique: GROUP BY, ORDER BY, date extraction

    -- QUERY 1.3: Month-over-Month revenue growth rate
    -- Business Question: Which months had the highest growth?
    -- Technique: LAG() window function, CTE, growth rate formula

--Section 2:-Customer Behaviour Analysis
    -- QUERY 2.1: Revenue and orders by customer state
    -- Business Question: Which states drive the most business?
    -- Technique: JOIN, GROUP BY, ORDER BY, RANK()

    -- QUERY 2.2: Payment method breakdown
    -- Business Question: How do customers prefer to pay?
    -- Technique: GROUP BY, percentage calculation, ROUND

--Section 3-Product Performance:-
    -- QUERY 3.1: Top 10 product categories by revenue
    -- Business Question: Which categories drive the most revenue?
    -- Technique: Multiple JOINs, COALESCE, GROUP BY, LIMIT

    -- QUERY 3.2: Pareto Analysis — do 20% of categories = 80% revenue?
    -- Business Question: Which categories should we focus on?
    -- Technique: CTE + running total + window functions

--Section 4-Delivery And Logistics:-
    -- QUERY 4.1: Late delivery rate by customer state
    -- Business Question: Which states have the worst delivery performance?
    -- Technique: CASE WHEN inside AVG (boolean aggregation)

    -- QUERY 4.2: Impact of late delivery on customer review scores
    -- Business Question: Do late deliveries cause bad reviews?
    -- Technique: CASE WHEN grouping, AVG, COUNT

-- Section 5 — Seller Performance
    -- QUERY 5.1: Seller ranking with window functions
    -- Business Question: Who are our best and worst sellers?
    -- Technique: Multiple window functions, CTE, NTILE()

--Section 6: The Executive Summary View
    -- QUERY 6.1: Executive summary — one query to rule them all
    -- Business Question: Give me the health of this business in one view
    -- Technique: Subqueries as columns, everything in one SELECT

    -- QUERY 6.2: Customer-level summary for RFM (feeds Phase 4)
    -- Business Question: What does each customer's purchase history look like?

### RFM Segmentation
- Scored 95,420 customers on Recency, Frequency, Monetary dimensions
- Assigned 7 business segments with recommended marketing actions
- Built cohort retention matrix (23 cohorts × 20 periods)

### Churn Prediction
- Defined churn as single-purchase customers (96.9% churn rate)
- Handled 97% class imbalance using `class_weight='balanced'`
- Compared Logistic Regression (AUC: 0.60) vs Random Forest (AUC: 0.58)
- Identified 19,231 high-value at-risk customers ($8.2M revenue at stake)

---

## Business Recommendations

1. **Launch a win-back campaign** targeting the 22,780 At-Risk customers 
   (avg 400 days inactive) — even 5% conversion = $192K recovered revenue

2. **Reduce delivery delays in AL, MA, SE states** (20%+ late delivery rate) 
   — direct path to improving review scores and retention

3. **Invest in top 17 product categories** exclusively until retention improves 
   — 80% of revenue from 23% of categories

4. **Introduce second-purchase incentive** for New Customers within 30 days 
   — cohort analysis shows near-zero retention after month 1

5. **Expand installment payment options** — 73.6% of customers use credit cards 
   with avg 3.5 installments, suggesting appetite for flexible payment

---

## Dataset

**Brazilian E-Commerce Public Dataset by Olist**  
Source: [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
Size: 9 tables, ~100K orders, 2016–2018

---

## Author

**Pradeep Kumar**  
Aspiring Data Analyst | Python · SQL · Tableau  
[LinkedIn](<www.linkedin.com/in/pradeep-kumar-3bb34b103>) · [Tableau Public](<https://public.tableau.com/app/profile/pradeep.kumar7153>)