/* =========================================================
OLIST E-COMMERCE ANALYTICS PROJECT
Author: Rudra Patel

Project Goal:
Analyze customer behavior, revenue trends,
seller performance, product performance,
and operational efficiency using SQL.
========================================================= */

/* =========================================================
SECTION 1 : REVENUE ANALYSIS
========================================================= */

-- Q1 Total Revenue

SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;

-- Q2 Total Orders

SELECT
COUNT(*) AS total_orders
FROM orders;

-- Q3 Average Order Value (AOV)

SELECT
ROUND(
SUM(p.payment_value)
/ COUNT(DISTINCT o.order_id),
2
) AS avg_order_value
FROM payments p
JOIN orders o
ON p.order_id = o.order_id;

-- Q4 Monthly Revenue Trend

SELECT
DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
ROUND(SUM(p.payment_value),2) AS revenue
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 1;

/* =========================================================
SECTION 2 : CUSTOMER ANALYSIS
========================================================= */

-- Q5 Total Unique Customers

SELECT
COUNT(DISTINCT customer_unique_id)
AS total_customers
FROM customers;

-- Q6 Top Customers By Revenue

SELECT
c.customer_id,
ROUND(SUM(ot.price),2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items ot
ON o.order_id = ot.order_id
GROUP BY c.customer_id
ORDER BY revenue DESC;

-- Q7 Top Real Customers By Order Frequency

SELECT
c.customer_unique_id,
COUNT(DISTINCT o.order_id)
AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;

-- Q8 Repeat Customers

SELECT
c.customer_unique_id,
COUNT(DISTINCT o.order_id)
AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- Q9 Repeat Customer Rate

WITH RC AS
(
SELECT COUNT(*) AS repeat_customers
FROM
(
SELECT c.customer_unique_id
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
) x
),

DC AS
(
SELECT COUNT(DISTINCT customer_unique_id)
AS total_customers
FROM customers
)

SELECT
ROUND(
(RC.repeat_customers * 100.0)
/
DC.total_customers,
2
) AS repeat_customer_rate

FROM RC, DC;

/* =========================================================
SECTION 3 : GEOGRAPHIC ANALYSIS
========================================================= */

-- Q10 Top States By Orders

SELECT
c.customer_state,
COUNT(o.order_id)
AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

-- Q11 Top States By Revenue

SELECT
c.customer_state,
ROUND(SUM(ot.price),2)
AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items ot
ON o.order_id = ot.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

/* =========================================================
SECTION 4 : PRODUCT ANALYSIS
========================================================= */

-- Q12 Top Product Categories By Revenue

SELECT
pd.product_category_name,
ROUND(SUM(ot.price),2)
AS category_revenue
FROM order_items ot
JOIN products pd
ON ot.product_id = pd.product_id
GROUP BY pd.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;

/* =========================================================
SECTION 5 : SELLER ANALYSIS
========================================================= */

-- Q13 Top Sellers By Revenue

SELECT
s.seller_id,
ROUND(SUM(ot.price),2)
AS seller_revenue
FROM order_items ot
JOIN sellers s
ON ot.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY seller_revenue DESC
LIMIT 10;

-- Q14 Top Sellers By Order Count

SELECT
seller_id,
COUNT(DISTINCT order_id)
AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 10;

-- Q15 Top Sellers With Location

SELECT
s.seller_city,
s.seller_state,
s.seller_id,
COUNT(DISTINCT ot.order_id)
AS total_orders
FROM sellers s
JOIN order_items ot
ON s.seller_id = ot.seller_id
GROUP BY
s.seller_city,
s.seller_state,
s.seller_id
ORDER BY total_orders DESC
LIMIT 10;

/* =========================================================
SECTION 6 : OPERATIONS ANALYSIS
========================================================= */

-- Q16 Average Delivery Time

SELECT
ROUND(
AVG(
order_delivered_customer_date::date
-----------------------------------

order_purchase_timestamp::date
),
2
)
AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date
IS NOT NULL;



/* =========================================================
   DASHBOARD KPI QUERIES
========================================================= */

-- KPI 1 -- Total Revenue
SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;

-- KPI 2 -- Total orders
SELECT
COUNT(*) AS total_orders
FROM orders;

-- KPI 3 -- Average Order Value
SELECT
ROUND(
SUM(p.payment_value)
/ COUNT(DISTINCT o.order_id),
2
) AS avg_order_value
FROM payments p
JOIN orders o
ON p.order_id = o.order_id;

-- KPI 4 -- Repeat Customer Rate
WITH RC AS
(
    SELECT COUNT(*) AS repeat_customers
    FROM
    (
        SELECT c.customer_unique_id
        FROM customers c
        JOIN orders o
        ON c.customer_id = o.customer_id
        GROUP BY c.customer_unique_id
        HAVING COUNT(DISTINCT o.order_id) > 1
    ) x
),

DC AS
(
    SELECT COUNT(DISTINCT customer_unique_id)
    AS total_customers
    FROM customers
)

SELECT
ROUND(
(RC.repeat_customers * 100.0)
/
DC.total_customers,
2
) AS repeat_customer_rate

FROM RC, DC;





-- Exporting Data --

SELECT
DATE_TRUNC('month',o.order_purchase_timestamp)::date AS month,
ROUND(SUM(p.payment_value),2) AS revenue
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 1;


SELECT
c.customer_state,
ROUND(SUM(ot.price),2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items ot
ON o.order_id = ot.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;


SELECT
pd.product_category_name,
ROUND(SUM(ot.price),2) AS category_revenue
FROM order_items ot
JOIN products pd
ON ot.product_id = pd.product_id
GROUP BY pd.product_category_name
ORDER BY category_revenue DESC;

SELECT
s.seller_id,
ROUND(SUM(ot.price),2) AS seller_revenue
FROM order_items ot
JOIN sellers s
ON ot.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY seller_revenue DESC;
