--Phase 3 - SQL Buisness Analysis
-- ============================================================
-- Olist E-Commerce Intelligence — Business Analysis Queries
-- Author: Pradeep Kumar
-- Tool: PostgreSQL
-- Description: End-to-end SQL business analysis covering
--              revenue, customers, products, logistics,
--              and seller performance using window functions,
--              CTEs, and subqueries
-- ============================================================
--SECTION 1:-REVENUE AND GROWTH ANALYSIS
-- ============================================================
-- QUERY 1.1: Overall Business KPIs
-- Business Question: What is the total scale of this business?
-- Technique: Basic aggregation, ROUND(), CAST()
-- ============================================================
select
	count(distinct o.order_id) as total_orders,
	count(distinct o.customer_id) as total_customers,
	count(distinct oi.seller_id) as total_sellers,
	count(distinct oi.product_id) as total_products,
	round(sum(oi.price +oi.freight_value)::numeric,2) as total_revenue,
	round(avg(oi.price+oi.freight_value)::numeric,2) as average_order_value,
	min(o.order_purchase_timestamp::date) as first_order_date,
	max(o.order_purchase_timestamp::date) as last_order_date
from orders o
join order_items oi
on o.order_id=oi.order_id
where o.order_status not in('canceled','unavailable');-- we exclude cancelled and unavailable orders because they generated no real revenue

--o/p:-
"total_orders"	"total_customers"	"total_sellers"	"total_products"	"total_revenue"	"average_order_value"	"first_order_date"	"last_order_date"
	98199			98199				3053			32729			15735527.03				140.37				"2016-09-04"	"2018-09-03"

-- ============================================================
-- QUERY 1.2: Revenue trend by year
-- Business Question: Is the business growing year over year?
-- Technique: GROUP BY, ORDER BY, date extraction
-- ============================================================
select
	extract(year from o.order_purchase_timestamp::date) as order_year,
	count(distinct o.order_id) as total_orders,
	count(distinct o.customer_id) as total_customers,
	round(sum(oi.price+oi.freight_value)::numeric,2) as total_revenue,
	round(avg(oi.price+oi.freight_value)::numeric,2) as average_order_value
from orders o
join order_items oi
on o.order_id=oi.order_id
where o.order_status not in('canceled','unavailabale')
group by extract(year from o.order_purchase_timestamp::date)
order by order_year;

--o/p:-
"order_year"	"total_orders"	"total_customers"	"total_revenue"	"average_order_value"
2016				299				  299				53794.32		151.53
2017				44375			  44375				7090569.24		140.08
2018				53531			  53531				8593303.96		140.56

-- ============================================================
-- QUERY 1.3: Month-over-Month revenue growth rate
-- Business Question: Which months had the highest growth?
-- Technique: LAG() window function, CTE, growth rate formula
-- ============================================================
with monthly_revenue as(
select
	extract(year from o.order_purchase_timestamp::date) as order_year,
	date_trunc('month',o.order_purchase_timestamp::date) as month_date,
	to_char(o.order_purchase_timestamp::date,'MM-YY') as year_month,
	round(sum(oi.price+oi.freight_value)::numeric,2) as revenue
from orders o
join order_items oi
on o.order_id=oi.order_id
where o.order_status not in('canceled','unavailable')
group by
	extract(year from o.order_purchase_timestamp::date),
	date_trunc('month',o.order_purchase_timestamp::date),
	to_char(o.order_purchase_timestamp::date,'MM-YY')
)
select 
	year_month,
	revenue as current_revenue,
	lag(revenue)over(order by month_date) as previous_month_revenue,
	round(
		(revenue-lag(revenue)over(order by month_date))
		/nullif(lag(revenue)over(order by month_date),0)
		*100,2
	) as mom_growth_pct
from monthly_revenue
order by month_date;
--o/p:-
"year_month"	"current_revenue"	"previous_month_revenue"	"mom_growth_pct"
	"09-16"			279.69		
	"10-16"			51354.52				279.69					18261.23
	"12-16"			19.62					51354.52			   -99.96
	"01-17"			136943.46				19.62					697878.90
	"02-17"			283561.69				136943.46				107.06
	"03-17"			425617.96				283561.69				50.10
	"04-17"			405848.61				425617.96			   -4.64
	"05-17"			582710.83				405848.61				43.58
	"06-17"			499652.24				582710.83			   -14.25
	"07-17"			578753.73				499652.24				15.83
	"08-17"			661903.52				578753.73				14.37
	"09-17"			717102.72				661903.52				8.34
	"10-17"			764756.03				717102.72				6.65
	"11-17"			1172191.68				764756.03				53.28
	"12-17"			861526.77				1172191.68			   -26.50
	"01-18"			1101920.01				861526.77				27.90
	"02-18"			979486.16				1101920.01			   -11.11
	"03-18"			1152656.99				979486.16				17.68
	"04-18"			1156248.89				1152656.99				0.31
	"05-18"			1145686.46				1156248.89			   -0.91
	"06-18"			1020381.90				1145686.46			   -10.94
	"07-18"			1039783.58				1020381.90			  	1.90
	"08-18"			996973.51				1039783.58			   -4.12
	"09-18"			166.46					996973.51			   -99.98
-- Anomaly 1 — Dec 2016 revenue was only $19.62
-- Oct 2016 had $51K revenue, then Dec 2016 had just $19.62. That -99.96% drop is not a business collapse — November 2016 is simply missing 
--from the dataset. The data collection was incomplete for that month.
--Same pattern at the end — Sep 2018 shows $166 because the dataset was cut off mid-month. 
--This is why Query 1.1 shows the last order date as Sep 3, 2018.

--Section 2:-Customer Behaviour Analysis
--Revenue by State.
-- ============================================================
-- QUERY 2.1: Revenue and orders by customer state
-- Business Question: Which states drive the most business?
-- Technique: JOIN, GROUP BY, ORDER BY, RANK()
-- ============================================================
select
	c.customer_state,
	count(distinct o.order_id) as total_orders,
	count(distinct o.customer_id) as total_customers,
	round(sum(oi.price+oi.freight_value)::numeric,2) as total_revenue,
	round(avg(oi.price+oi.freight_value)::numeric,2) as average_order_value,
	rank()over(order by sum(oi.price+oi.freight_value) desc) as revenue_rank
from orders o
join customers c 
on o.customer_id=c.customer_id
join order_items oi
on o.order_id=oi.order_id
where o.order_status not in('canceled','unavailable')
group by c.customer_state
order by total_revenue desc
limit 10;
o/p:-
"customer_state"	"total_orders"	"total_customers"	"total_revenue"	"average_order_value"	"revenue_rank"
	"SP"				41125				41125			5878132.06			124.66					1
	"RJ"				12697				12697			2115667.56			145.82					2
	"MG"				11496				11496			1843074.43			141.00					3
	"RS"				5415				5415			877290.59			141.25					4
	"PR"				4982				4982			794196.61			138.87					5
	"SC"				3599				3599			608023.70			146.12					6
	"BA"				3344				3344			606908.66			160.35					7
	"DF"				2120				2120			351327.21			146.57					8
	"GO"				1998				1998			340544.37			146.60					9
	"ES"				2018				2018			323081.03			143.72					10

--Payment Method Analysis:
-- ============================================================
-- QUERY 2.2: Payment method breakdown
-- Business Question: How do customers prefer to pay?
-- Technique: GROUP BY, percentage calculation, ROUND
-- ============================================================
select
	payment_type,
	count(distinct order_id) as total_orders,
	round(sum(payment_value)::numeric,2) as total_revenue,
	round(avg(payment_installments)::numeric,2) as avg_installments,
	round(count(distinct(order_id))*100
	/sum(count(order_id))over( ),2) as pct_of_orders   --SUM(COUNT(DISTINCT order_id)) OVER () gives the grand total of all orders across all payment types
from order_payments
group by payment_type
order by total_orders desc;
--o/p:-
"payment_type"	"total_orders"	"total_revenue"	"avg_installments"	"pct_of_orders"
"credit_card"		76505		 12542084.19		 3.51				73.64
"boleto"			19784		 2869361.27		 	 1.00				19.04
"voucher"			3866		 379436.87			 1.00				3.72
"debit_card"		1528		 217989.79			 1.00				1.47
"not_defined"		3			 0.00			     1.00				0.00

--Section 3-Product Performance:-
--TOP 10 Categories By Revenue
-- ============================================================
-- QUERY 3.1: Top 10 product categories by revenue
-- Business Question: Which categories drive the most revenue?
-- Technique: Multiple JOINs, COALESCE, GROUP BY, LIMIT
-- ============================================================
select 
	coalesce(t.product_category_name_english,'unkown') as category,
	count(distinct oi.order_id) as total_orders,
	count(oi.product_id) as total_products,
	round(sum(oi.price)::numeric,2) as total_revenue, -- Only what customer paid FOR THE PRODUCT,Does NOT include shipping cost,So we exclude freight_value
	round(avg(oi.price)::numeric,2) as avg_price,
	rank()over(order by sum(oi.price)  desc) as revenue_rank
from order_items oi
join products p 
on oi.product_id=p.product_id
left join product_category_translation t --LEFT JOIN — used here for the translation table because not every product has an English category name. A regular JOIN would drop those products entirely. LEFT JOIN keeps them and returns NULL for the translation columns — which we then handle with COALESCE.
on p.product_category_name=t.product_category_name
where oi.order_id in 
					(
					select 
						order_id
					from orders 
					where order_status not in('canceled','unavailable')
					)
group by coalesce(t.product_category_name_english,'unkown')
order by total_revenue desc
limit 10;
--o/p:-
"category"			"total_orders"	"total_products"	"total_revenue"		"avg_price"		"revenue_rank"
"health_beauty"			8800			  9634				1255695.13		  130.34			1
"watches_gifts"			5604			  5970				1198185.21		  200.70			2
"bed_bath_table"		9399			  11097				1035964.06		  93.36				3
"sports_leisure"		7673	   		  8590				979740.92		  114.06			4
"computers_accessories"	6654			  7781				904322.02		  116.22			5
"furniture_decor"		6425			  8298				727465.05		  87.67				6
"housewares"			5847			  6915				626825.80		  90.65				7
"cool_stuff"			3616			  3779				620770.49		  164.27			8
"auto"					3872			  4204				586585.73		  139.53			9
"garden_tools"			3505			  4328				481009.94		  111.14			10

--Pareto analysis (the 80/20 rule)
-- ============================================================
-- QUERY 3.2: Pareto Analysis — do 20% of categories = 80% revenue?
-- Business Question: Which categories should we focus on?
-- Technique: CTE + running total + window functions
-- ============================================================
with category_revenue as(
select
	coalesce(t.product_category_name_english,'unknown') as category,
	round(sum(oi.price)::numeric,2) as revenue
from order_items oi
join products p
on oi.product_id=p.product_id
left join product_category_translation t
on p.product_category_name=t.product_category_name
group by coalesce(t.product_category_name_english,'unknown')
),
ranked as(
select 
	category,
	revenue,
	sum(revenue)over(order by revenue desc 
					 rows between unbounded preceding and current row) as running_total,
	sum(revenue)over() as grand_total,
	row_number()over(order by revenue desc) as revenue_rank
from category_revenue
),
pareto_analysis as(
select
	revenue_rank,
	category,
	revenue,
	running_total,
	round(running_total/grand_total*100,2) as cumulative_pct,
	count(*)over() as total_categories,
	case
		when running_total/grand_total <=0.80 then 'Top 80% revenue'
		else 'Remaining 20%'
	end as pareto_group
from ranked
order by revenue_rank
)
select 
	pareto_group,
	count(*) as number_of_categories,
	max(total_categories) as total_categories,
	round(count(*)*100.0/max(total_categories),2)||'%' as pareto_distribution
from pareto_analysis
group by pareto_group
order by pareto_distribution;
--o/p:-
"pareto_group"		"number_of_categories"		"total_categories"		"pareto_distribution"
"Top 80% revenue"			17							72						23.61%
"Remaining 20%"				55							72						76.39%

--Section 4-Delivery And Logistics:-
--Late Delivery Rate by State
-- ============================================================
	-- QUERY 4.1: Late delivery rate by customer state
-- Business Question: Which states have the worst delivery performance?
-- Technique: CASE WHEN inside AVG (boolean aggregation)
-- ============================================================
select 
	c.customer_state,
	count(distinct o.order_id) as total_orders,
	sum(case when o.order_delivered_customer_date::date
		>o.order_estimated_delivery_date::date then 1 else 0 end) as late_orders,
	round(
	avg(case when o.order_delivered_customer_date::date
		>o.order_estimated_delivery_date::date then 1 else 0 end)*100
	,2) as late_delivery_pct,
	round(avg(o.order_delivered_customer_date::date - o.order_estimated_delivery_date:: date)::numeric,2) as avg_delay_days
from orders o
join customers c
on o.customer_id=c.customer_id
where o.order_status='delivered'
	and o.order_delivered_customer_date::date is not null
	and o.order_estimated_delivery_date::date is not null
group by c.customer_state
order by late_delivery_pct desc
limit 15;
--o/p:-
"customer_state"	"total_orders"	"late_orders"	"late_delivery_pct"	"avg_delay_days"
	"AL"				397			   	 85					21.41			-8.71
	"MA"				717		       	 125				17.43			-9.57
	"SE"				335			   	 51					15.22			-10.02
	"PI"				476				 66					13.87			-11.31
	"CE"				1279		   	 176				13.76			-10.80
	"RR"				41				 5					12.20			-17.29
	"BA"				3256		  	 396				12.16			-10.79
	"RJ"				12350			 1495				12.11			-11.76
	"PA"				946				 106				11.21			-14.07
	"ES"				1995			 214				10.73			-10.50
	"PB"				517				 54					10.44			-13.26
	"TO"				274				 27					9.85			-12.13
	"MS"				701				 68					9.70			-11.05
	"PE"				1593			 153				9.60			-13.29
	"RN"				474				 44					9.28			-13.65
--Look at our late delivery query — avg_delay_days shows -8.71 for AL, -9.57 for MA etc. 
--Negative means on average orders arrive earlier than estimated — even in states with high late delivery rates. 
--This is because the estimated delivery date is set very conservatively.

--Does Late delivery hurt review score?
-- ============================================================
-- QUERY 4.2: Impact of late delivery on customer review scores
-- Business Question: Do late deliveries cause bad reviews?
-- Technique: CASE WHEN grouping, AVG, COUNT
-- ============================================================
select
	case 
		when o.order_delivered_customer_date::date <= o.order_estimated_delivery_date::date then 'On Time'
		when o.order_delivered_customer_date::date <= o.order_estimated_delivery_date::date + interval '3 days' then 'Slightly Late(1-3 days)'
		when o.order_delivered_customer_date::date <= o.order_estimated_delivery_date::date +interval '7days' then 'Late (4-7 days)'
		else 'Very Late(7+ Days)'
	end as delivery_category,
	count(o.order_id) as total_orders,
	round(avg(r.review_score)::numeric,2) as avg_review_score,
	round(
		sum(case when r.review_score<=2 then 1 else 0 end)*100
		/count(r.review_score)
	,2)||'%' as pct_bad_reviews
from orders o
join order_reviews r
on o.order_id=r.order_id
where o.order_status='delivered' 
	  and o.order_delivered_customer_date is not null 
	  and o.order_estimated_delivery_date is not null
group by 
	case 
		when o.order_delivered_customer_date::date <= o.order_estimated_delivery_date::date then 'On Time'
		when o.order_delivered_customer_date::date <= o.order_estimated_delivery_date::date + interval '3 days' then 'Slightly Late(1-3 days)'
		when o.order_delivered_customer_date::date <= o.order_estimated_delivery_date::date +interval '7days' then 'Late (4-7 days)'
		else 'Very Late(7+ Days)'
	end
order by avg_review_score desc;
-- o/p:-
"delivery_category"   		"total_orders"   		"avg_review_score"		"pct_bad_reviews"
"On Time"						89944					4.29					"9.00%"
"Slightly Late(1-3 days)"		1856					3.29					"32.00%"
"Late (4-7 days)"				1756					2.10					"67.00%"
"Very Late(7+ Days)"			2797					1.70					"79.00%"

-- Section 5 — Seller Performance
--Seller performance ranking
-- ============================================================
-- QUERY 5.1: Seller ranking with window functions
-- Business Question: Who are our best and worst sellers?
-- Technique: Multiple window functions, CTE, NTILE()
-- ============================================================
with seller_metrics as(select
	oi.seller_id,
	s.seller_state,
	count(distinct oi.order_id) as total_orders,
	count(distinct oi.product_id) as unique_products,
	round(sum(oi.price)::numeric,2) as total_revenue,
	round(avg(oi.price)::numeric,2) as avg_price,
	round(avg(r.review_score)::numeric,2) as avg_review_score,
	sum(case when o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date then 1 else 0 end) as late_deliveries
from order_items oi
join orders o
on oi.order_id=o.order_id
join sellers s
on oi.seller_id=s.seller_id
left join order_reviews r
on o.order_id=r.order_id
where o.order_status not in('canceled','unavailable')
group by oi.seller_id,
		 s.seller_state
)
select 
	seller_id,
	seller_state,
	total_orders,
	total_revenue,
	avg_review_score,
	late_deliveries,
	rank()over(order by total_revenue desc) as revenue_rank,
	rank()over(order by avg_review_score desc) as review_rank,
	ntile(4)over(order by total_revenue desc) as revenue_quartile
from seller_metrics
order by total_revenue desc
limit 20;
--o/p:-i only show top 5 rows only.
"seller_id"							"seller_state"		"total_orders"	"total_revenue"	"avg_review_score"	"late_deliveries"	"revenue_rank"	"review_rank"	"revenue_quartile"
"4869f7a5dfa277a7dca6462dcf3b52b2"		"SP"				1131			229237.63			4.13				121				1				1634			1
"53243585a1d6dc2643021fd1853d8905"		"BA"				358				222776.05			4.08				12				2				1716			1
"4a3ca9315b744ce9f8e9374361493884"		"SP"				1804			202852.32			3.80				191				3				2252			1
"fa1c13f2614d7b5c4749cbc52fecda94"		"SP"				584				192842.13			4.34				53				4				1229			1
"7c67e1448b00f6e969d365cea6b010ab"		"SP"				982				189417.67			3.35				121				5				2582			1

--Section 6: The Executive Summary View
-- ============================================================
-- QUERY 6.1: Executive summary — one query to rule them all
-- Business Question: Give me the health of this business in one view
-- Technique: Subqueries as columns, everything in one SELECT
-- ============================================================
select
	(select count(distinct order_id)
	 from orders
	 where order_status not in ('canceled','unavailable')
	 ) as total_orders,
	 (select round(sum(oi.price + oi.freight_value)::numeric,2)
	 from order_items oi
	 join orders o
	 on oi.order_id=o.order_id
	 where o.order_status not in ('canceled','unavailable')
	 ) as total_revenue,
	 (select round(avg(review_score)::numeric,2)
	 from order_reviews
	 ) as avg_review_score,
	 (select round(avg(case when order_delivered_customer_date::date > order_estimated_delivery_date::date then 1.0 else 0.0 end)*100,2)
	 from orders
	 where order_status='delivered'
	 ) as late_delivery_pct,
	 (select count(distinct seller_id)
	 from order_items
	 ) as active_sellers,
	 (select count(distinct product_id)
	 from order_items 
	 ) as active_products;
-- o/p:-
"total_orders"	"total_revenue"	"avg_review_score"	"late_delivery_pct"	"active_sellers"	"active_products"
	98207		  15735527.03		  4.09					6.77			  3095				  32951

-- ============================================================
-- QUERY 6.2: Customer-level summary for RFM (feeds Phase 4)
-- Business Question: What does each customer's purchase history look like?
-- ============================================================
select
	c.customer_unique_id,
	count(distinct o.order_id) as frequency,
	max(o.order_purchase_timestamp::date) as last_order_date,
	min(o.order_purchase_timestamp::date) as first_order_date,
	round(sum(oi.price+oi.freight_value)::numeric,2) as monetary_value,
	round(avg(r.review_score)::numeric,2) as avg_review_score,
	max('2018-09-03'::date - o.order_purchase_timestamp::date) as recency_days
from orders o
join customers c 
on o.customer_id=c.customer_id
join order_items oi
on o.order_id=oi.order_id
left join order_reviews r
on o.order_id=r.order_id
where o.order_status not in ('canceled','unavailable')
group by c.customer_unique_id
order by monetary_value desc;

	