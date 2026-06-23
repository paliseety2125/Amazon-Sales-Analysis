CREATE DATABASE IF NOT EXISTS amazon_sales;
USE amazon_sales;

-- Create table for cleaned Amazon orders
CREATE TABLE amazon_orders (
    `index` INT,
    order_id VARCHAR(50),
    date DATE,
    status VARCHAR(50),
    fulfilment VARCHAR(50),
    sales_channel VARCHAR(100),
    ship_service VARCHAR(50),
    style VARCHAR(100),
    sku VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(50),
    qty INT,
    amount DECIMAL(10,2),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_country VARCHAR(100),
    courier_status VARCHAR(50),
    currency VARCHAR(20),
    promotion_ids VARCHAR(50),
    fulfilled_by VARCHAR(50),
    b2b VARCHAR(10),
    order_month VARCHAR(20)
);


use amazon_sales;
-- 1. Top SKUs by Sales
SELECT SKU, SUM(Amount) AS total_sales
FROM cleaned_amazon_orders
GROUP BY SKU
ORDER BY total_sales DESC;
-- 2. Top Categories
SELECT Category, SUM(Amount) AS total_sales
FROM amazon_orders
GROUP BY Category
ORDER BY total_sales DESC;

-- 3. Top 5 States
SELECT ship_state, SUM(Amount) AS total_sales
FROM amazon_orders
GROUP BY ship_state
ORDER BY total_sales DESC
LIMIT 5;

-- 4. Top 5 Cities
SELECT ship_city, SUM(Amount) AS total_sales
FROM amazon_orders
GROUP BY ship_city
ORDER BY total_sales DESC
LIMIT 5;

-- 5. Orders by Category
SELECT Category, COUNT(*) AS orders
FROM amazon_orders
GROUP BY Category;

-- 6. Orders by State
SELECT ship_state, COUNT(*) AS orders
FROM amazon_oders
GROUP BY ship_state;

-- Revenue - Based Analysis 


SELECT DATE(date) AS order_day,
       SUM(amount) AS daily_revenue
FROM amazon_orders
GROUP BY order_day
ORDER BY order_day;

SELECT DATE_FORMAT(date, '%Y-%m') AS order_month,
       SUM(amount) AS monthly_revenue
FROM amazon_orders
GROUP BY order_month
ORDER BY order_month;

-- 8. Fulfilment Profitability
SELECT Fulfilment, SUM(Amount) AS total_revenue
FROM amazon_orders
GROUP BY fulfilment;

-- Ship Service vs Revenue
SELECT ship_service, SUM(Amount) AS total_revenue
FROM amazon_oders
GROUP BY ship_service;


SELECT category, SUM(qty), SUM(amount)amazon_orders
FROM amazon_orders
GROUP BY category;

--  SQL Queries for General Analysis

SELECT ship_service, category, COUNT(*) AS order_count
FROM amazon_orders
GROUP BY ship_service, category
ORDER BY ship_service, order_count DESC;

-- Cancellation rates by category and size
SELECT category, size,
       SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS cancellation_rate
FROM amazon_orders
GROUP BY category, size
ORDER BY cancellation_rate DESC;

-- Promotion type vs Order Amount
SELECT promotion_ids, AVG(amount) AS avg_order_amount, SUM(amount) AS total_sales
FROM amazon_orders
GROUP BY promotion_ids
ORDER BY avg_order_amount DESC;
-- Category Distribution

SELECT category, COUNT(*) AS order_count
FROM amazon_orders
GROUP BY category
ORDER BY order_count DESC;

SELECT size , count(*) as total_orders
FROM amazon_orders
GROUP BY size
ORDER BY total_orders DESC;

select style , count(*) as total_orders
From amazon_orders
Group by style
order by total_orders Desc;

SELECT 
    (top10.top10_revenue * 100.0 / total.total_revenue) AS top10_percentage
FROM
(
    SELECT SUM(Amount) AS total_revenue FROM amazon_orders
) total,
(
    SELECT SUM(revenue) AS top10_revenue
    FROM (
        SELECT SKU, SUM(Amount) AS revenue
        FROM amazon_orders
        GROUP BY SKU
        ORDER BY revenue DESC
        LIMIT 10
    ) t
) top10;


SELECT SKU,
       SUM(Amount) AS revenue
FROM amazon_orders
GROUP BY SKU
ORDER BY revenue DESC
LIMIT 10;