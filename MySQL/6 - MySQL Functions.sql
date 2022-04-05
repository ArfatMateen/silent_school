-- MySQL FUNCTIONS


-- NUMERIC FUNCTIONS
-- ROUND
SELECT ROUND(7.345);
SELECT ROUND(7.345, 2);

-- TRUNCATE
SELECT TRUNCATE(7.345, 2);

-- CEILING
SELECT CEILING(7.345);

-- FLOOR
SELECT FLOOR(7.345);

-- ABSOLUTE
SELECT ABS(-7.345);

-- RANDOM 
SELECT RAND();

-- Compllete list of numeric functions
-- https://dev.mysql.com/doc/refman/8.0/en/numeric-functions.html


-- STRING FUNCTIONS
-- LENGTH
SELECT LENGTH('Hello World!');

-- UPPER CASE
SELECT UPPER('Hello World!');

-- LOWER CASE
SELECT LOWER('Hello World!');

-- TRIMING
-- LEFT TRIM
SELECT LTRIM('        Hello World!        ');

-- RIGHT TRIM
SELECT RTRIM('        Hello World!        ');

-- TRIM
SELECT TRIM('        Hello World!        ');

-- LEFT
SELECT LEFT('Hello World!', 5);

-- RIGHT
SELECT RIGHT('Hello World!', 6);

-- SUBSTRING
SELECT SUBSTRING('Hello World!', 7, 5);

-- LOCATE
SELECT LOCATE('L', 'Hello World!');

-- REPLACE
SELECT REPLACE('Hello World!', 'World', 'MySQL');

-- CONCATE
SELECT CONCAT('First ', 'Last ', 'Name');

USE sql_store;
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Compllete list of string functions
-- https://dev.mysql.com/doc/refman/8.0/en/string-functions.html


-- DATE FUNCTIONS
-- CURRENT DATE & TIME
SELECT NOW() AS DATE_TIME, CURDATE() AS DATE_ONLY, CURTIME() AS TIME_ONLY;

-- YEAR, We also have MONTH, DAY, HOUR, MINUTE, SECOND all of these functions returns numeric value
SELECT YEAR(NOW());

-- NAME OF DAY returns string value
SELECT DAYNAME(NOW());

-- NAME OF MONTH returns string value
SELECT MONTHNAME(NOW());

-- EXTRACT is part of standard sql
SELECT EXTRACT(DAY FROM NOW());


-- FORMATING DATES
-- MySQL default date format 'YYYY-MM-DD'
-- FORMAT DATE
SELECT DATE_FORMAT(NOW(), '%d %m %y');
SELECT DATE_FORMAT(NOW(), '%M %D %Y');

-- FORMAT TIME
SELECT TIME_FORMAT(NOW(), '%h:%i %p');
SELECT TIME_FORMAT(NOW(), '%H %i');


-- CALCULATING DATES & TIMES
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- DATE DIFFERENCE only returns day difference
SELECT DATEDIFF(NOW(), '2020-01-01');

-- TIME DIFFERENCE
-- TIME_TO_SEC returns time elapsed since mid night
SELECT TIME_TO_SEC('09:00');

-- Time differece in seconds
SELECT TIME_TO_SEC('09:02') - TIME_TO_SEC('09:00');


-- IFNULL substitute null value with the provided value 
SELECT 
	order_id,
    IFNULL(shipper_id, 'Not Assigned') AS shipper
FROM orders;

-- COALESCE returns first not null value in the provided list
SELECT 
	order_id,
    COALESCE(shipper_id, comments, 'Not Assigned') AS shipper
FROM orders;


-- IF FUNCTION
-- IF(expression (true or false), true value, false value)
SELECT
	order_id,
    order_date,
    IF(YEAR(order_date) = 2019, 'ACTIVE', 'ARCHIVED') AS category
FROM orders;

-- CASE OPERATOR for multiple test expression
SELECT
	order_id,
    CASE
		WHEN YEAR(order_date) = 2019 THEN 'ACTIVE'
        WHEN YEAR(order_date) = 2018 THEN 'LAST YEAR'
        WHEN YEAR(order_date) < 2018 THEN 'ARCHIVED'
        ELSE 'FUTURE'
	END AS category
FROM orders;


