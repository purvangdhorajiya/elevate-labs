-- ============================================
-- Task 8: SQL Window Functions
-- File: task8_window.sql
-- ============================================

-- 1. Base Aggregation: Total Sales per Customer
SELECT 
    customer_id,
    customer_name,
    region,
    SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id, customer_name, region;


-- 2. ROW_NUMBER(): Rank Customers by Sales per Region
SELECT 
    customer_id,
    customer_name,
    region,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS row_num
FROM orders
GROUP BY customer_id, customer_name, region;


-- 3. RANK() and DENSE_RANK(): Compare Tie Handling
SELECT 
    customer_id,
    customer_name,
    region,
    SUM(sales) AS total_sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS dense_rank_in_region
FROM orders
GROUP BY customer_id, customer_name, region;


-- 4. Running Total of Sales by Date
SELECT 
    order_date,
    sales,
    SUM(sales) OVER (ORDER BY order_date 
                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
FROM orders
ORDER BY order_date;


-- 5. Monthly Sales (CTE) for MoM Growth
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT 
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY month) AS mom_growth
FROM monthly_sales
ORDER BY month;


-- 6. Top 3 Products per Category using DENSE_RANK()
WITH product_sales AS (
    SELECT 
        category,
        product_name,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY category, product_name
),
ranked_products AS (
    SELECT 
        category,
        product_name,
        total_sales,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank_in_category
    FROM product_sales
)

SELECT 
    category,
    product_name,
    total_sales,
    rank_in_category
FROM ranked_products
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
