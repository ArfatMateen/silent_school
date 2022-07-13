-- Select database to work with
USE sql_invoicing;

-- TRIGGER
-- A block of SQL code that automatically gets executed before or 
-- after an insert, update or delete statement.

-- Quite often we use triggers to enforce data consistancy

-- TRIGGER naming convention
-- TableName_Timing_Event

-- CREATING TRIGGER
DELIMITER $$
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END$$

DELIMITER ;

SELECT * FROM invoices;
SELECT * FROM payments;

-- TEST TRIGGER
INSERT INTO payments
VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1);

SELECT * FROM invoices;

-- CREATING TRIGGER
DELIMITER $$
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END$$

DELIMITER ;

SELECT * FROM payments;

-- TEST TRIGGER
DELETE
FROM payments
WHERE payment_id = 9;

SELECT * FROM invoices;


-- VIEWING TRIGGERS
SHOW TRIGGERS LIKE 'payments%';


-- DROP TRIGGER
DROP TRIGGER IF EXISTS payments_after_delete;


-- EVENT
-- A task (or block of SQL code) that gets executed according to a schedule.
-- With event we can automate database maintenance tasks such as copying data 
-- from one table into archive table or aggregating data to generate reports.

-- Check if event scheduler is enable
SHOW VARIABLES LIKE 'event%';

-- To enable event scheduler
SET GLOBAL event_scheduler = ON;


-- CREATING EVENT
DELIMITER $$
CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
	-- AT '2019-01-01'
	-- EVERY 1 HOUR
    -- EVERY 2 DAY
    EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-12-31'
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$

DELIMITER ;


-- VIEWING EVENTS
SHOW EVENTS;

-- ALTER EVENT
ALTER EVENT yearly_delete_stale_audit_rows DISABLE;
-- Alter event can also be used just like creating event and update the schedule or action SQL code for the event

-- DROP EVENT
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;