-- Select database to work with
USE sql_invoicing;

-- VIEW behave like a virtual table which doesn't store the data
-- VIEWS are used to simplify queries

-- CREATING VIEW
CREATE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id, name;


-- QUERYING VIEW
SELECT *
FROM sales_by_client
WHERE total_sales > 500
ORDER BY total_sales DESC;


-- ALTERING OR DROPPING VIEW
-- DROP VIEW
DROP VIEW sales_by_client;

-- ALTERING VIEW
CREATE OR REPLACE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id, name
ORDER BY total_sales DESC;


-- UPDATABLE VIEW
-- So far we use the VIEW in FROM clause
-- But if the VIEW doesn't contain the following:
-- DISTINCT
-- Aggregatge Functions (MIN, MAX, SUM...)
-- GROUP BY / HAVING
-- UNION
-- then that view is called UPDATABLE VIEW which mean we can update data through that VIEW
-- we can use UPDATABLE VIEW in INSERT, UPDATE OR DELETE statements.

-- CREATE UPDATABLE VIEW
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0;

-- Delete data from UPDATABLE VIEW
DELETE FROM invoices_with_balance
WHERE invoice_id = 1;

-- Update data from UPDATABLE VIEW
UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;


-- Inserting data through UPDATABLE VIEW will only work if the UPDATABLE VIEW have all the required column in the underlying table

-- WITH CHECK OPTION clause
-- it is possible to update data using UPDATABLE VIEW which is not visible through the view. 
-- This update makes the view inconsistent. 
-- To ensure the consistency of the view, you use the WITH CHECK OPTION clause when you create or modify the view.
