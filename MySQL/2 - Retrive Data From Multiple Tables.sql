-- Select database to work with
USE sql_store;


-- INNER JOIN
SELECT * 
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id;

-- Implicit Join Syntax
-- WHERE clause is necessory for inner join,
-- Otherwise it will become cross join.
-- Best practice is to use explicit join.
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT order_id, oi.product_id, quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- Joining Aross Databases
SELECT * 
FROM order_items oi
JOIN sql_inventory.products p ON oi.product_id = p.product_id;

-- Joining Multiple Tables
SELECT 
	o.order_id, o.order_date,
	c.first_name, c.last_name,
    os.name AS status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_statuses os ON o.status = os.order_status_id;


-- Compound Join Conditions
SELECT *
FROM order_items oi
JOIN order_item_notes oin 
	ON oi.order_id = oin.order_Id
    AND oi.product_id = oin.product_id;


-- OUTER JOINS
-- LEFT
-- RIGHT

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

-- Joining Multiple Tables
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;


-- USING Clause
-- To simplify Joining conditions
-- Only works if the conditioning column names are similar across tables
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM orders o
LEFT JOIN customers c
	-- ON o.customer_id = c.customer_id
    USING (customer_id)
LEFT JOIN shippers sh
	-- ON o.shipper_id = sh.shipper_id
    USING (shipper_id)
ORDER BY c.customer_id;

-- USING clause even works for Compound Join Conditions
SELECT *
FROM order_items oi
JOIN order_item_notes oin 
	-- ON oi.order_id = oin.order_Id
    -- AND oi.product_id = oin.product_id;
    USING (order_id, product_id);


-- NATURAL JOIN
-- Doesn't require joining conditions
-- Database engine will guess the best possible column to condition on
-- It's not a good idea to use natural join
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
NATURAL JOIN customers c;


-- CROSS JOIN
SELECT
    c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;


-- SELF JOIN
USE sql_hr;

SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
JOIN employees m ON e.reports_to = m.employee_id;

-- SELF OUTER JOIN
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
LEFT JOIN employees m ON e.reports_to = m.employee_id;


-- Select database to work with
USE sql_store;

-- UNION
-- Combines rows instead of column
-- Can be used with different tables
-- However number of columns needs to the same

SELECT 
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE orders.order_date >= '2019-01-01'
UNION
SELECT 
	order_id,
    order_date,
    'Archived' AS status
FROM orders
WHERE orders.order_date < '2019-01-01'
ORDER BY order_date DESC


