CREATE VIEW bi.seller_freight_ratio AS
SELECT
i.seller_sk,
SUM(i.price) AS total_revenue,
SUM(i.freight_value) AS total_freight,
SUM(i.freight_value)/NULLIF(SUM(i.price),0) AS freight_revenue_ratio
FROM fact.fact_order_items i
GROUP BY i.seller_sk;


CREATE VIEW bi.seller_late_delivery_rate AS
SELECT
    seller_sk,
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END) AS late_orders,
    SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END)::float
        / NULLIF(COUNT(*),0) AS late_delivery_rate
FROM fact.fact_seller_order
WHERE is_delivered_flag = TRUE
GROUP BY seller_sk;


CREATE VIEW bi.category_revenue AS
SELECT
p.product_category_name,
p.product_category_name_english,
SUM(i.price) AS revenue
FROM fact.fact_order_items i
JOIN dim.dim_product p
ON i.product_sk=p.product_sk
GROUP BY p.product_category_name,p.product_category_name_english;



CREATE VIEW bi.customer_issue_rate AS
SELECT
c.customer_state,
COUNT(o.order_id) AS total_orders,
SUM(
CASE
WHEN o.is_late_delivery OR o.is_failed_order THEN 1 ELSE 0 END) AS issue_orders,
SUM(
CASE WHEN o.is_late_delivery OR o.is_failed_order THEN 1 ELSE 0 END)::float/NULLIF(COUNT(o.order_id),0) AS issue_rate
FROM fact.fact_orders o
JOIN dim.dim_customer c
ON o.customer_sk=c.customer_sk
GROUP BY c.customer_state;


CREATE VIEW bi.seller_performance AS
SELECT
s.seller_sk,
SUM(i.price) AS revenue,
SUM(i.freight_value) AS total_freight,
SUM(i.freight_value)/NULLIF(SUM(i.price),0) AS freight_revenue_ratio,
COUNT(DISTINCT s.order_id) AS delivered_orders,
SUM(CASE WHEN s.is_late_delivery THEN 1 ELSE 0 END) AS late_orders,
SUM(CASE WHEN s.is_late_delivery THEN 1 ELSE 0 END)::float/NULLIF(COUNT(DISTINCT s.order_id),0) AS late_delivery_rate
FROM fact.fact_order_items i
JOIN fact.fact_seller_order s
ON i.order_id=s.order_id AND i.seller_sk=s.seller_sk
WHERE s.is_delivered_flag = TRUE
GROUP BY s.seller_sk;

CREATE VIEW bi.seller_revenue AS 
SELECT 
seller_sk, 
SUM(price) AS revenue 
FROM fact.fact_order_items 
GROUP BY seller_sk;


CREATE VIEW bi.category_late_delivery_rate AS
SELECT
p.product_category_name,
p.product_category_name_english,
COUNT(DISTINCT o.order_id) AS delivered_orders,
COUNT(DISTINCT CASE WHEN is_late_delivery THEN o.order_id END) AS late_orders,
COUNT(DISTINCT CASE WHEN is_late_delivery THEN o.order_id END)::float/NULLIF(COUNT(DISTINCT o.order_id),0) AS late_delivery_rate
FROM fact.fact_orders o
JOIN fact.fact_order_items i
ON o.order_id=i.order_id
JOIN dim.dim_product p
ON i.product_sk=p.product_sk
WHERE o.is_delivered_flag=TRUE
GROUP BY p.product_category_name,p.product_category_name_english;


CREATE VIEW bi.order_item_analytics AS
SELECT
i.order_id,
s.seller_sk,
p.product_sk,
p.product_category_name,
p.product_category_name_english,
s.seller_id,
p.product_id,
c.customer_sk,
c.customer_id,
c.customer_state,
c.customer_city,
d.full_date AS purchase_date,
d.year AS purchase_year,
d.month AS purchase_month,
i.price,
i.freight_value,
(i.price+i.freight_value) AS total_item_value,
o.is_delivered_flag,
o.is_late_delivery,
o.is_failed_order,
o.delivery_delay_days
FROM fact.fact_orders o
JOIN fact.fact_order_items i
ON o.order_id=i.order_id
JOIN dim.dim_product p
ON i.product_sk=p.product_sk
JOIN dim.dim_seller s
ON i.seller_sk=s.seller_sk
JOIN dim.dim_customer c
ON o.customer_sk=c.customer_sk
JOIN dim.dim_date d
ON o.purchase_date_sk=d.date_sk;