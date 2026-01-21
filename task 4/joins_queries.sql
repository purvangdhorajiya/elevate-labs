-- INNER JOIN: Orders with customers
SELECT o.order_id, o.order_date, c.customer_name, c.region
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- LEFT JOIN: Customers with no orders
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Revenue per product
SELECT p.product_id, p.product_name,
       SUM(o.quantity * p.price) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- Category-wise revenue
SELECT cat.category_name,
       SUM(o.quantity * p.price) AS category_revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY category_revenue DESC;

-- Sales in a region between dates
SELECT c.region,
       SUM(o.quantity * p.price) AS total_sales
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id
WHERE c.region = 'West'
  AND o.order_date BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY c.region;

-- Final joined output
SELECT o.order_id, o.order_date, c.customer_name, c.region,
       p.product_name, cat.category_name, o.quantity,
       (o.quantity * p.price) AS order_value
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id;
