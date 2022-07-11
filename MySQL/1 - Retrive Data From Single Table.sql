-- Select database to work with
USE sql_store;


-- SELECT Clause
SELECT * FROM customers;

SELECT customer_id, first_name, last_name
FROM customers;

SELECT first_name, last_name, points, (points + 10) * 100 AS discount_factor
FROM customers;

SELECT DISTINCT state
FROM customers;

SELECT name, unit_price, unit_price * 1.1 AS new_price
FROM products;


-- WHERE Clause
SELECT * FROM customers WHERE points > 3000;

-- Available Comparision Operators
-- > 			greater than
-- >=			greater than and equal to
-- <			smaller than
-- <=			smaller than and equal to
-- =			equality
-- != OR <>		not equal to

-- Customer in Verginia
SELECT * FROM customers WHERE state = 'VA';

-- Customer outside Verginia
SELECT * FROM customers WHERE state != 'VA';
SELECT * FROM customers WHERE state <> 'VA';

-- Customer born after Jan 1st 1990
SELECT * FROM customers WHERE birth_date > '1990-01-01';

-- Get all the orders placed in year 2019
SELECT * FROM orders WHERE YEAR(order_date) = '2019';

-- Multiple search conditions to filter data
-- AND
-- OR
-- NOT

-- Ger all customers born after Jan 1st 1990 and has more than 1000 points
SELECT * FROM customers WHERE birth_date > '1990-01-01' AND points > 1000;

-- Ger all customers born after Jan 1st 1990 or has more than 1000 points and live in Verginia
SELECT * FROM customers WHERE birth_date > '1990-01-01' OR points > 1000 AND state = 'VA';

-- From the order_items table, get all the items from order #6 where total price is greater than 30
SELECT * FROM order_items WHERE order_id = 6 AND (quantity * unit_price) > 30;

-- IN operator
-- Select customer located in Verginia, Georgia or Florida
SELECT * FROM customers WHERE state = 'VA' OR state = 'GA' OR state = 'FL';
SELECT * FROM customers WHERE state IN ('VA', 'GA', 'FL');

-- Select customer located outside Verginia, Georgia or Florida
SELECT * FROM customers WHERE state NOT IN ('VA', 'GA', 'FL');

-- Return products with quantity in stock equal to 49, 38, 72
SELECT * FROM products WHERE quantity_in_stock IN (49, 38, 72);

-- BETWEEN Operator
-- Customers with points between 1000 and 3000
SELECT * FROM customers WHERE points >= 1000 AND points <= 3000;
SELECT * FROM customers WHERE points BETWEEN 1000 AND 3000;

-- Select customers born between Jan 1st 1990 and Jan 1st 2000
SELECT * FROM customers WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- LIKE Operator
-- % represents pattern with any number of characters
-- _ represents pattern with single character

-- Select customers with last name start with leter b
SELECT * FROM customers WHERE last_name LIKE 'b%';

-- Select customer with last name is 6 characters long and end with letter y
SELECT * FROM customers WHERE last_name LIKE '_____y';

-- Select customer with last name start with letter b and end with letter y
SELECT * FROM customers WHERE last_name LIKE 'b%y';

-- Get customers whose addresses contain TRAIL or AVENUE 
SELECT * FROM customers WHERE address LIKE '%Trail%' OR address LIKE '%Avenue%';

-- Get customers whose phone number end with 9
SELECT * FROM customers WHERE phone LIKE '%9';

-- REGEXP Operator
-- ^ begining
-- $ end
-- | logical OR (multiple search patterns)
-- [abcd] any character from the list
-- [a-g] any character between a and g
-- AND MANY MORE...

-- Select customer whose last name end with field
SELECT * FROM customers WHERE last_name REGEXP 'field$';

-- Select customer whose last name end with field or contain max or start with rose
SELECT * FROM customers WHERE last_name REGEXP 'field$|mac|^rose';

-- Select customer whose last name contain letter e and before letter e must have letter g, i or m
SELECT * FROM customers WHERE last_name REGEXP '[gim]e';

-- Select customer whose last name contain letter e and before letter e must have a letter between a to h
SELECT * FROM customers WHERE last_name REGEXP '[a-h]e';

-- IN NULL Operator
-- Select customer without phone number
SELECT * FROM customers WHERE phone IS NULL;

-- Get orders that are not shipped
SELECT * FROM orders WHERE shipper_id IS NULL;


-- ORDER BY Clause
SELECT * FROM customers ORDER BY first_name;
SELECT * FROM customers ORDER BY first_name DESC;

SELECT * FROM customers ORDER BY state, first_name;

-- From the order_items table, get all the items from order #2 and ORDER BY total price in decending order
SELECT *, (unit_price * quantity) AS total_price FROM order_items WHERE order_id = 2 ORDER BY total_price DESC;


-- LIMIT Clause
SELECT * FROM customers LIMIT 3;

-- Offset for pagination
-- first argument is offset
-- second argument is limit
SELECT * FROM customers LIMIT 6, 3;

-- Get top 3 loyal customers (with highest points)
SELECT * FROM customers ORDER BY points DESC LIMIT 3;

-- ORDER of clauses
-- 1st SELECT
-- 2nd FROM - JOIN
-- 3rd WHERE
-- 4th GROUP BY
-- 5th ORDER BY
-- 6th LIMIT
