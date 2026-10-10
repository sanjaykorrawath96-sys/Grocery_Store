create database Grocery_store;
use Grocery_store;

-- 1. Supplier Table
CREATE TABLE IF NOT EXISTS supplier (
    sup_id TINYINT PRIMARY KEY,
    sup_name VARCHAR(255),
    address TEXT
);

-- 2. Categories Table
CREATE TABLE IF NOT EXISTS categories(
    cat_id TINYINT PRIMARY KEY,
    cat_name VARCHAR(255)
);

-- 3. Employees Table
CREATE TABLE IF NOT EXISTS employees (
    emp_id TINYINT PRIMARY KEY,
    emp_name VARCHAR(255),
    hire_date VARCHAR(255)
);

-- 4. Customers Table
CREATE TABLE IF NOT EXISTS customers (
    cust_id SMALLINT PRIMARY KEY,
    cust_name VARCHAR(255),
    address TEXT
);

-- 5. Products Table
CREATE TABLE IF NOT EXISTS products (
    prod_id TINYINT PRIMARY KEY,
    prod_name VARCHAR(255),
    sup_id TINYINT,
    cat_id TINYINT,
    price DECIMAL(10,2),
    FOREIGN KEY (sup_id) REFERENCES supplier(sup_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- 6. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    ord_id SMALLINT PRIMARY KEY,
    cust_id SMALLINT,
    emp_id TINYINT,
    order_date VARCHAR(255),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- 7. Order_Details Table
CREATE TABLE IF NOT EXISTS order_details (
    ord_detID SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ord_id SMALLINT,
    prod_id TINYINT,
    quantity TINYINT,
    each_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (ord_id) REFERENCES orders(ord_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES products(prod_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

select * from supplier;
desc supplier;

select * from categories;
desc categories;

select * from employees;
desc employees;


alter table employees
modify column hire_date date;

select * from customers;
desc customers;

select * from products;
desc products;



select * from order_details;
desc order_details;

-- checking for duplicates in primary keys supplier

SELECT sup_id, COUNT(*) AS duplicate_count
FROM supplier
GROUP BY sup_id
HAVING COUNT(*) > 1;


-- checking for duplicates in primary keys customers

SELECT cust_id, COUNT(*)
FROM customers
GROUP BY cust_id
HAVING COUNT(*) > 1;

-- checking for duplicates in primary keys employees
SELECT emp_id, COUNT(*) AS duplicate_count
FROM employees
GROUP BY emp_id
HAVING COUNT(*) > 1;
-- checking for duplicates in primary keys categories
SELECT cat_id, COUNT(*) AS duplicate_count
FROM categories
GROUP BY cat_id
HAVING COUNT(*) > 1;
-- checking for duplicates in primary keys products
SELECT prod_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY prod_id
HAVING COUNT(*) > 1;
-- checking for duplicates in primary keys orders
SELECT ord_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY ord_id
HAVING COUNT(*) > 1;

-- checking for duplicates in primary keys order_details

SELECT ord_detID, COUNT(*) AS duplicate_count
FROM order_details
GROUP BY ord_detID
HAVING COUNT(*) > 1;

-- checking null values 

SELECT *
FROM supplier
WHERE sup_id IS NULL
   OR sup_name IS NULL
   OR address IS NULL;
   
   SELECT *
FROM categories
WHERE cat_id IS NULL
   OR cat_name IS NULL;
   
   SELECT *
FROM employees
WHERE emp_id IS NULL
   OR emp_name IS NULL
   OR hire_date IS NULL;
   
   SELECT *
FROM customers
WHERE cust_id IS NULL
   OR cust_name IS NULL
   OR address IS NULL;
   
   SELECT *
FROM products
WHERE prod_id IS NULL
   OR prod_name IS NULL
   OR sup_id IS NULL
   OR cat_id IS NULL
   OR price IS NULL;
   
   SELECT *
FROM order_details
WHERE ord_detID IS NULL
   OR ord_id IS NULL
   OR prod_id IS NULL
   OR quantity IS NULL
   OR each_price IS NULL
   OR total_price IS NULL;
   
   -- Check Foreign-Key Relationships.
   
   SELECT p.sup_id
FROM products p
LEFT JOIN supplier s
ON p.sup_id = s.sup_id
WHERE s.sup_id IS NULL;

SELECT p.cat_id
FROM products p
LEFT JOIN categories c
ON p.cat_id = c.cat_id
WHERE c.cat_id IS NULL;

SELECT o.cust_id
FROM orders o
LEFT JOIN customers c
ON o.cust_id = c.cust_id
WHERE c.cust_id IS NULL;

SELECT o.emp_id
FROM orders o
LEFT JOIN employees e
ON o.emp_id = e.emp_id
WHERE e.emp_id IS NULL;

SELECT od.ord_id
FROM order_details od
LEFT JOIN orders o
ON od.ord_id = o.ord_id
WHERE o.ord_id IS NULL;

SELECT od.ord_id
FROM order_details od
LEFT JOIN orders o
ON od.ord_id = o.ord_id
WHERE o.ord_id IS NULL;

SELECT od.prod_id
FROM order_details od
LEFT JOIN products p
ON od.prod_id = p.prod_id
WHERE p.prod_id IS NULL;

SELECT od.prod_id
FROM order_details od
LEFT JOIN products p
ON od.prod_id = p.prod_id
WHERE p.prod_id IS NULL;







-- Customer insights

-- How many unique customers have placed orders?
SELECT COUNT(DISTINCT cust_id) AS unique_customers_count
FROM orders;

-- Which customers have placed the highest number of orders?
SELECT c.cust_id, c.cust_name, COUNT(o.ord_id) 
AS total_orders
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name
ORDER BY total_orders DESC;

-- What is the total and average purchase value per customer?

SELECT 
    c.cust_id, 
    c.cust_name, 
    SUM(od.total_price) AS total_purchase_value,
    AVG(od.total_price) AS avg_purchase_value
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY c.cust_id, c.cust_name;

-- Who are the top 5 customers by total purchase amount?
WITH customer_sales AS (
    SELECT
        c.cust_id,
        c.cust_name,
        SUM(od.total_price) AS total_purchase_amount
    FROM customers c
    JOIN orders o
        ON c.cust_id = o.cust_id
    JOIN order_details od
        ON o.ord_id = od.ord_id
    GROUP BY c.cust_id, c.cust_name
),
ranked_customers AS (
    SELECT *,
           DENSE_RANK() OVER (
               ORDER BY total_purchase_amount DESC
           ) AS sales_rank
    FROM customer_sales
)
SELECT
    cust_id,
    cust_name,
    total_purchase_amount
FROM ranked_customers
WHERE sales_rank <= 5;


-- 2. Product Performance
-- How many products exist in each category?

SELECT cat.cat_id, cat.cat_name, COUNT(p.prod_id)
AS total_products
FROM categories cat
LEFT JOIN products p ON cat.cat_id = p.cat_id
GROUP BY cat.cat_id, cat.cat_name;


-- What is the average price of products by category?

SELECT cat.cat_id, cat.cat_name, AVG(p.price) AS avg_product_price
FROM categories cat
JOIN products p ON cat.cat_id = p.cat_id
GROUP BY cat.cat_id, cat.cat_name;

-- Which products have the highest total sales volume (by quantity)?
CREATE VIEW product_sales_summary AS
SELECT
    p.prod_id,
    p.prod_name,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.total_price) AS total_sales
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY p.prod_id, p.prod_name;

SELECT *
FROM product_sales_summary
ORDER BY total_quantity_sold DESC;



-- What is the total revenue generated by each product?
SELECT p.prod_id, p.prod_name, SUM(od.total_price) 
AS total_revenue
FROM products p
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY p.prod_id, p.prod_name
ORDER BY total_revenue DESC;


-- How do product sales vary by category and supplier?

SELECT 
    cat.cat_name,
    s.sup_name,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.total_price) AS total_revenue
FROM order_details od
JOIN products p ON od.prod_id = p.prod_id
JOIN categories cat ON p.cat_id = cat.cat_id
JOIN supplier s ON p.sup_id = s.sup_id
GROUP BY cat.cat_name, s.sup_name
ORDER BY total_revenue DESC;

-- 3. Sales and Order Trends
-- How many orders have been placed in total?

SELECT COUNT(ord_id) AS total_orders
FROM orders;

-- What is the average value per order?

WITH order_totals AS (
    SELECT
        ord_id,
        SUM(total_price) AS order_total
    FROM order_details
    GROUP BY ord_id
)
SELECT
    AVG(order_total) AS avg_order_value
FROM order_totals;

-- On which dates were the most orders placed?

SELECT order_date, COUNT(ord_id) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY total_orders DESC;



-- What are the monthly trends in order volume and revenue?


SELECT 
    DATE_FORMAT(STR_TO_DATE(o.order_date, '%Y-%m-%d'), '%m') AS order_month,
    COUNT(DISTINCT o.ord_id) AS order_volume,
    SUM(od.total_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY order_month
ORDER BY order_month;

-- How do order patterns vary across weekdays and weekends?

SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(o.order_date, '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT o.ord_id) AS total_orders,
    SUM(od.total_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY day_type;



-- 4. Supplier Contribution

-- How many suppliers are there in the database?

SELECT COUNT(sup_id) AS total_suppliers
FROM supplier;

-- Which supplier provides the most products?

SELECT s.sup_id, s.sup_name, COUNT(p.prod_id) AS total_products
FROM supplier s
JOIN products p ON s.sup_id = p.sup_id
GROUP BY s.sup_id, s.sup_name
ORDER BY total_products DESC limit 1;

-- What is the average price of products from each supplier?

SELECT s.sup_id, s.sup_name, AVG(p.price) AS avg_product_price
FROM supplier s
JOIN products p ON s.sup_id = p.sup_id
GROUP BY s.sup_id, s.sup_name;
 

-- Which suppliers contribute the most to total product sales (by revenue)?

WITH supplier_sales AS (
    SELECT
        s.sup_id,
        s.sup_name,
        SUM(od.total_price) AS total_revenue
    FROM supplier s
    JOIN products p
        ON s.sup_id = p.sup_id
    JOIN order_details od
        ON p.prod_id = od.prod_id
    GROUP BY s.sup_id, s.sup_name
)
SELECT
    sup_id,
    sup_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM supplier_sales
ORDER BY revenue_rank;

-- 5. Employee Performance

-- How many employees have processed orders?

SELECT COUNT(DISTINCT emp_id) AS active_employees_count
FROM orders;


-- Which employees have handled the most orders?
CREATE VIEW employee_order_summary AS
SELECT
    e.emp_id,
    e.emp_name,
    COUNT(o.ord_id) AS total_orders_handled
FROM employees e
JOIN orders o
    ON e.emp_id = o.emp_id
GROUP BY e.emp_id, e.emp_name;

SELECT *
FROM employee_order_summary
ORDER BY total_orders_handled DESC;

-- What is the total sales value processed by each employee?

SELECT 
    e.emp_id, 
    e.emp_name, 
    SUM(od.total_price) AS total_sales_processed
FROM employees e
JOIN orders o ON e.emp_id = o.emp_id
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY e.emp_id, e.emp_name
ORDER BY total_sales_processed DESC;



-- What is the average order value handled per employee?
WITH employee_order_values AS (
    SELECT
        o.emp_id,
        o.ord_id,
        SUM(od.total_price) AS order_value
    FROM orders o
    JOIN order_details od
        ON o.ord_id = od.ord_id
    GROUP BY o.emp_id, o.ord_id
)
SELECT
    e.emp_id,
    e.emp_name,
    AVG(eov.order_value) AS avg_order_value
FROM employees e
JOIN employee_order_values eov
    ON e.emp_id = eov.emp_id
GROUP BY e.emp_id, e.emp_name;

-- 6. Order Details Deep Dive

-- What is the relationship between quantity ordered and total price?

SELECT
    quantity,
    AVG(each_price) AS avg_unit_price,
    AVG(quantity * each_price) AS avg_calculated_total_price,
    AVG(total_price) AS avg_actual_total_price,
    AVG(total_price - (quantity * each_price)) AS avg_difference
FROM order_details
GROUP BY quantity
ORDER BY quantity;

-- What is the average quantity ordered per product?

SELECT p.prod_id, p.prod_name, 
AVG(od.quantity) AS avg_quantity_ordered
FROM products p
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY p.prod_id, p.prod_name;


-- How does the unit price vary across products and orders?

SELECT 
    p.prod_id,
    p.prod_name AS ProductName,
    ROUND(p.price, 2) AS CatalogUnitPrice,
    COUNT(od.ord_detID) AS TotalTimesOrdered,
    SUM(od.quantity) AS TotalUnitsSold,
    ROUND(SUM(od.total_price), 2) AS TotalRevenueGenerated
FROM products p
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY p.prod_id, p.prod_name, p.price
ORDER BY TotalRevenueGenerated DESC;


