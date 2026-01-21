-- Create database and table
CREATE DATABASE task3_sql;
USE task3_sql;

CREATE TABLE sales (
    order_id VARCHAR(50),
    order_date DATE,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    category VARCHAR(50),
    segment VARCHAR(50),
    sales DECIMAL(10,2),
    profit DECIMAL(10,2)
);

-- Basic checks
SELECT COUNT(*) FROM sales;
SELECT * FROM sales LIMIT 10;

-- Filtering and sorting
SELECT * FROM sales WHERE category = 'Technology';
SELECT * FROM sales ORDER BY sales DESC LIMIT 10;

-- Aggregations
SELECT category, SUM(sales) AS total_sales
FROM sales
GROUP BY category;

SELECT region, AVG(profit) AS avg_profit
FROM sales
GROUP BY region;

SELECT segment, COUNT(*) AS total_orders
FROM sales
GROUP BY segment;

-- HAVING
SELECT category, SUM(sales) AS total_sales
FROM sales
GROUP BY category
HAVING SUM(sales) > 100000;

-- BETWEEN and LIKE
SELECT SUM(sales) AS jan_sales
FROM sales
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-31';

SELECT DISTINCT customer_name
FROM sales
WHERE customer_name LIKE 'A%';

-- Top 5 customers
SELECT customer_name, SUM(sales) AS total_spend
FROM sales
GROUP BY customer_name
ORDER BY total_spend DESC
LIMIT 5;
