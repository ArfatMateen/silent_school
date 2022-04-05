-- Select database to work with
USE sql_store;


-- SUBQUERIES
-- Find products that are more expensive than Lettuce (id = 3)
SELECT *
FROM products
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
);

-- IN Operator
-- Find products that have never been ordered
SELECT *
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
	FROM order_items
);

-- Select clients without invoice
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
    FROM invoices
);

-- SUBQUERY VS JOIN
SELECT *
FROM clients
LEFT JOIN invoices USING (client_id)
WHERE invoice_id IS NULL;

-- Find customers who have ordered Lettuce (id = 3)
USE sql_store;

-- Using subquery
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (
	SELECT customer_id
    FROM order_items
    JOIN orders USING (order_id)
    WHERE product_id = 3
);

-- Using Join
SELECT 
	DISTINCT c.customer_id, 
    c.first_name, 
    c.last_name
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE oi.product_id = 3;


-- ALL KEYWORD
-- Select invoices larger than all invoices of client 3
USE sql_invoicing;

-- Using MAX
SELECT *
FROM invoices 
WHERE invoice_total > (
	SELECT MAX(invoice_total)
	FROM invoices
	WHERE client_id = 3
);

-- Using ALL
SELECT *
FROM invoices 
WHERE invoice_total > ALL (
	SELECT invoice_total
	FROM invoices
	WHERE client_id = 3
);


-- ALL KEYWORD
-- Select clients with at least two invoices
SELECT *
FROM clients
-- WHERE client_id IN (
WHERE client_id = ANY (
	SELECT client_id
	FROM invoices 
	GROUP BY client_id
	HAVING COUNT(*) >= 2
);


-- CORRELATED SUBQUERIES
-- Select employees whose salary is above the average in their office
USE sql_hr;

SELECT *
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
);

-- Select invoices larger than the client's average invoice amount
USE sql_invoicing;

SELECT *
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i.client_id
);


-- EXISTS OPERATOR
-- SELECT client that have an invoice
SELECT * 
FROM clients
WHERE client_id IN (
	SELECT DISTINCT client_id
    FROM invoices
);

SELECT *
FROM clients c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);


-- SUBQUERIES in SELECT Clause
SELECT
	invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference
FROM invoices;


-- SUBQUERIES in FROM Clause
SELECT *
FROM (
	-- Following query returns a table which we can use inside FROM clause and treat it like a normal table
	SELECT
		client_id,
		name,
		(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
		(SELECT total_sales - invoice_average) AS difference
	FROM clients c
) AS sales_summary -- Whenever we use subquery in FROM clause we must need to give the query an alias
WHERE total_sales IS NOT NULL;
-- same can be achieved using VIEWS...
