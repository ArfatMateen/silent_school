-- Select database to work with
USE sql_invoicing;

-- Stored procedures are used to store and organize SQL code
-- Stored procedures can return result sets with multiple rows and coumns

-- CREATING PROCEDURE
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$

DELIMITER ;

-- CALLING PROCEDURE
CALL get_clients();


-- Get invoices with balance > 0 STORED PROCEDURE
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
	SELECT *
	FROM invoices_with_balance
	WHERE balance > 0;
END$$

DELIMITER ;

-- CALLING PROCEDURE
CALL get_invoices_with_balance();


-- DROP PROCEDURE
DROP PROCEDURE IF EXISTS get_clients;


-- PARAMETERS
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
	SELECT *
    FROM clients c
    WHERE c.state = state;
END$$

DELIMITER ;

-- CALLING PROCEDURE with PARAMETER
CALL get_clients_by_state('CA');


-- PARAMETER with default value
DROP PROCEDURE IF EXISTS get_clients_by_state_with_default_value;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state_with_default_value(state CHAR(2))
BEGIN
/*
	IF state IS NULL THEN
		SELECT * FROM clients;
    ELSE
		SELECT *
		FROM clients c
		WHERE c.state = state;
    END IF;
*/
	SELECT *
		FROM clients c
		WHERE c.state = IFNULL(state, c.state);
END$$

DELIMITER ;

-- CALLING PROCEDURE with PARAMETER
CALL get_clients_by_state_with_default_value(NULL);


-- PARAMETER VALIDATION
DROP PROCEDURE IF EXISTS make_payment;
DELIMITER $$
CREATE PROCEDURE make_payment(
	invoice_id INT,
    payment_amount DECIMAL(9, 2),
    payment_date DATE
)
BEGIN
	IF payment_amount <= 0 THEN
		-- 22003 is SQL ERROR CODE (for numeric value out of range) check documentation
		SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid payment amount';
	END IF;

	UPDATE invoices i
    SET
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END$$

DELIMITER ;

-- CALLING PROCEDURE with PARAMETER VALIDATION
CALL make_payment(2, 100, '2019-01-01');


-- OUTPUT PARAMETERS
DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;
DELIMITER $$
CREATE PROCEDURE get_unpaid_invoices_for_client(
	client_id INT,
    OUT invoices_count INT,
    OUT invoices_total DECIMAL(9, 2)
)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id 
		AND payment_total = 0;
END$$

DELIMITER ;

-- Create User or Session Variables
SET @invoices_count = 0;
SET @invoices_total = 0;

-- CALLING PROCEDURE with OUTPUT PARAMETERS
CALL get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);

SELECT @invoices_count, @invoices_total;


-- LOCAL VARIABLES exist locally inside stored procedures or functions
DROP PROCEDURE IF EXISTS get_risk_factor;
DELIMITER $$
CREATE PROCEDURE get_risk_factor()
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_count INT;
    DECLARE invoices_total DECIMAL(9, 2);
    
	SELECT COUNT(*), SUM(invoice_total)
	INTO invoices_count, invoices_total
    FROM invoices;
    
    SET risk_factor = invoices_total / invoices_count * 5; -- arbitrary multiplication
    
    SELECT risk_factor;
END$$

DELIMITER ;

-- CALLING PROCEDURE
CALL get_risk_factor();


-- FUNCTIONS can only returns single value
DROP FUNCTION IF EXISTS get_risk_factor_for_client;
DELIMITER $$
CREATE FUNCTION get_risk_factor_for_client(client_id INT)
RETURNS INTEGER
-- Attributes like
-- DETERMINISTIC (if giving same set of value it always return same value)
-- MODIFIES SQL DATA
READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_count INT;
    DECLARE invoices_total DECIMAL(9, 2);
    
	SELECT COUNT(*), SUM(invoice_total)
	INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;
    
    SET risk_factor = invoices_total / invoices_count * 5; -- arbitrary multiplication
    
    RETURN IFNULL(risk_factor, 0);
END$$

DELIMITER ;

-- CALLING FUNCTION
SELECT
	client_id,
	name,
    get_risk_factor_for_client(client_id) AS risk_factor
FROM clients;
