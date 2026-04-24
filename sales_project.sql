
DROP TABLE IF EXISTS temp_table;

CREATE TABLE temp_table (
    order_id VARCHAR(50),
    order_date DATE,
    customer_id VARCHAR(50),
    customer_name VARCHAR(255),
    product_id VARCHAR(50),
    category VARCHAR(100),
    product_name VARCHAR(255),
    sales DOUBLE,
    quantity INT,
    discount DOUBLE,
    profit DOUBLE
);


SELECT *
FROM temp_table;

SELECT COUNT(*) FROM temp_table;

SELECT SUM(sales) AS total_revenue
FROM temp_table;

SELECT SUM(profit) AS total_profit
FROM temp_table;

-- Which category has highest revenue
SELECT category, SUM(sales) AS revenue
FROM temp_table
GROUP BY category
ORDER BY revenue DESC;

-- Top 10 most selling products
SELECT product_name, SUM(sales) AS total_sales
FROM temp_table
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Monthly sales trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
	SUM(sales) AS revenue
FROM temp_table
GROUP BY month
ORDER BY month;

CREATE TABLE sales_clean AS
SELECT 
    order_id,
    order_date,
    customer_id,
    customer_name,
    product_id,
    category,
    product_name,
    sales,
    quantity,
    discount,
    profit
FROM temp_table;

SELECT * 
FROM sales_clean;


-- Which category is actually profitable (not just high sales)
SELECT 
    category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
FROM sales_clean
GROUP BY category
ORDER BY profit_margin DESC;

-- High-value customers
SELECT 
    customer_name,
    SUM(sales) AS total_spent
FROM sales_clean
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- How much customers spend per order
SELECT 
    ROUND(SUM(sales)/COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM sales_clean;
-- people spend 254.42 per order on average

-- Are discounts hurting profit?
SELECT 
    discount,
    AVG(profit) AS avg_profit
FROM sales_clean
GROUP BY discount
ORDER BY discount;
-- Increase in discount decreases the avg profit

-- Monthly Profit Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(profit) AS total_profit
FROM sales_clean
GROUP BY month
ORDER BY month;

SELECT * 
FROM sales_clean;