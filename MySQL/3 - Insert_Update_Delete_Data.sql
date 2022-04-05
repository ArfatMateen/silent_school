-- Select database to work with
USE sql_store;


-- INSERT DATA
-- Insert single row
INSERT INTO customers
VALUES (DEFAULT, 'Edward', 'Kenway', '1994-01-01', NULL, '23rd Avenue', 'New York', 'NY', DEFAULT);

INSERT INTO customers (last_name, first_name, phone, address, city, state)
VALUES ('Kenway', 'Connar', DEFAULT, 'Berklay Street', 'San Francisco', 'CA');

-- Insert multiple rows
INSERT INTO shippers (name)
VALUES ('Shipper 1'),
	   ('Shipper 2'),
       ('Shipper 3');
       
-- Insert hierarchical data
-- Insert data into multiple tables
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1.95),
	   (LAST_INSERT_ID(), 2, 1, 3.95);
       
-- Create a copy of table using subquery
CREATE TABLE orders_archived AS
SELECT * FROM orders;

-- Insert data into table using subquery
INSERT INTO orders_archived
SELECT * FROM orders
WHERE order_date < '2019-01-01';

-- Create table using subquery from multiple tables
USE sql_invoicing;

CREATE TABLE invoices_archived AS
SELECT 
	i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
FROM invoices i
JOIN clients c
	USING (client_id)
WHERE payment_date IS NOT NULL;


-- UPDATE DATA
-- Update single record
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE invoice_id = 3;

-- Update multiple records
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id = 3;

-- Update using subquery
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN (
				SELECT client_id
				FROM clients
				WHERE state IN ('CA', 'NY'));


-- DELETE DATA
USE sql_store;

DELETE FROM customers
WHERE customer_id IN (11, 12);

-- Using subquery
USE sql_invoicing;

DELETE FROM invoices 
WHERE client_id = (
				SELECT client_id
                FROM clients
                WHERE name = 'MyWorks');

