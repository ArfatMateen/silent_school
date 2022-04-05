-- Aggregate Functions
-- MAX()
-- MIN()
-- AVG()
-- SUM()
-- COUNT()

USE sql_invoicing;

SELECT 
	MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total) AS total_sales,
    COUNT(invoice_total) AS number_of_invoices, -- Only counts not null values
    COUNT(payment_date) AS count_of_payments,
    COUNT(*) AS total_records, -- Counts irrespective of null values also counts duplicate values
    COUNT(DISTINCT client_id) AS total_records -- Counts unique values
FROM invoices;
-- WHERE...   aggregate functions will only summarize filter data

-- Can also be used on dates and strings
SELECT 
	MAX(payment_date) AS highest,
    MIN(payment_date) AS lowest
FROM invoices;

-- Summarize data by first and second half of year 2019
SELECT 
	'First half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 
	'Second half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 
	'total' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';


-- GROUP BY Clause
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
GROUP BY client_id
ORDER BY total_sales DESC;

-- Group by multiple columns
SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c
	USING (client_id)
GROUP BY state, city;

-- HAVING Clause
-- To filter date after grouping data
-- Get those clients whose total sales is more than 500
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;


-- WITH ROLLUP
SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c
	USING (client_id)
GROUP BY state, city WITH ROLLUP;


-- Get customer located in verginia who has spent more than 100 dollars
USE sql_store;

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE state = 'VA'
GROUP BY 
	c.customer_id,
	c.first_name,
    c.last_name
HAVING total_sales > 100;


