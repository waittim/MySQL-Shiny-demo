-- Name: Jiayi Wang, Zekun Wang
-- Email: jiayi.wang.2@vanderbilt.edu
-- Project2

-- create database

DROP DATABASE IF EXISTS loan;
CREATE DATABASE loan;
USE loan;

-- create stored procedure 1
DROP PROCEDURE IF EXISTS getNYTECH;

DELIMITER //
CREATE PROCEDURE getNYTECH()
BEGIN
SELECT annual_inc,total_acc,addr_state, emp_title, delinq_amnt
FROM loan.borrower
WHERE addr_state ="NY" and emp_title="Tech";

END//

DELIMITER ;

-- create stored procedure 2
DROP PROCEDURE IF EXISTS getA;

DELIMITER //
CREATE PROCEDURE getA()
BEGIN
SELECT int_rate,grade,loan_amnt,disbursement_method	
FROM loan.loan
WHERE grade ="A";

END//

DELIMITER ;

DROP TABLE IF EXISTS raw;
CREATE TABLE raw(
id INT(9),
int_rate DECIMAL(4,2),
grade char(2),
loan_amnt INT(9),
loan_status VARCHAR(20),
disbursement_method VARCHAR(20)  CHECK (disbursement_method IN ('CASH', 'DIRECT_PAY')),
title VARCHAR(200),
zip_code VARCHAR(50),
funded_amnt VARCHAR(20),
funded_amnt_inv INT(9),
initial_list_status VARCHAR(10),
purpose VARCHAR(50),
addr_state CHAR(2),
annual_inc INT(9), 
verification_status VARCHAR(50), 
home_ownership VARCHAR(20) CHECK(home_ownership IN ('RENT',' OWN', 'MORTGAGE', 'OTHER')) ,
last_credit_pull_d VARCHAR(8),
emp_title VARCHAR(50), 
emp_length VARCHAR(50), 
total_acc VARCHAR(10), 
delinq_2yrs SMALLINT(2), 
open_acc VARCHAR(20), 
delinq_amnt VARCHAR(100), 
earliest_cr_line VARCHAR(100), 
pub_rec_bankruptcies VARCHAR(100), 
pub_rec VARCHAR(50),
mths_since_recent_bc VARCHAR(10),
num_actv_bc_tl INT(9),
num_bc_sats INT(9),
num_bc_tl INT(9),
total_bc_limit INT(9),
mo_sin_rcnt_tl INT(5),
num_accts_ever_120_pd INT(5),
num_sats INT(5),
num_tl_120dpd_2m VARCHAR(10),
num_tl_30dpd INT(5),
num_tl_90g_dpd_24m INT(5),
num_tl_op_past_12m INT(5),
tot_cur_bal INT(9),
inq_fi VARCHAR(10),
inq_last_12m VARCHAR(20),
mths_since_recent_inq VARCHAR(20),
installment DECIMAL(9,3),
mo_sin_old_il_acct VARCHAR(10),
mths_since_rcnt_il VARCHAR(10),
num_il_tl INT(9)
);


LOAD DATA INFILE '/Users/jiayiwang/Desktop/projects/database/project2/loan.csv'
INTO TABLE raw
CHARACTER SET latin1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'; 


-- create tables with UML diagrams

-- loan TABLE
DROP TABLE IF EXISTS loan;
CREATE TABLE loan(
id INT(9) PRIMARY KEY,
int_rate DECIMAL(4,2),
grade CHAR(2),
loan_amnt INT(9),
loan_status VARCHAR(20),
disbursement_method VARCHAR(20)  CHECK (disbursement_method IN ('Cash', 'DIRECT_PAY')),
title VARCHAR(200),
zip_code VARCHAR(50),
funded_amnt VARCHAR(20),
funded_amnt_inv INT(9),
initial_list_status VARCHAR(10) CHECK(initial_list_status IN ('W','F')),
purpose VARCHAR(50)
);

INSERT INTO loan
SELECT id, int_rate, grade,loan_amnt,loan_status,disbursement_method,title,zip_code,funded_amnt,funded_amnt_inv,initial_list_status,purpose
FROM raw;

-- call stored procedure 2
CALL getA();

-- create view 1
DROP VIEW IF EXISTS cash;
CREATE VIEW cash AS
SELECT id, grade, loan_amnt, funded_amnt, purpose, disbursement_method
FROM loan
WHERE disbursement_method ='CASH';

SELECT * FROM cash;

-- ALTER VIEW cash AS
-- SELECT id, grade, loan_amnt, funded_amnt, purpose, disbursement_method
-- FROM loan
-- WHERE disbursement_method ='DIRECT_PAY';

-- SELECT * FROM cash;

-- borrower table
DROP TABLE IF EXISTS borrower;
CREATE TABLE borrower(
id INT(9),
addr_state CHAR(2),
annual_inc INT(9), 
verification_status VARCHAR(50), 
home_ownership VARCHAR(20) CHECK(home_ownership IN ('RENT',' OWN', 'MORTGAGE', 'OTHER')) ,
last_credit_pull_d VARCHAR(8),
emp_title VARCHAR(50), 
emp_length VARCHAR(50), 
total_acc VARCHAR(10), 
delinq_2yrs SMALLINT(2), 
open_acc VARCHAR(20), 
delinq_amnt VARCHAR(100), 
earliest_cr_line VARCHAR(100), 
pub_rec_bankruptcies VARCHAR(100), 
pub_rec VARCHAR(50)
);


INSERT INTO borrower
SELECT id,addr_state,annual_inc,verification_status,home_ownership,last_credit_pull_d,emp_title,emp_length,total_acc,delinq_2yrs,open_acc,delinq_amnt,earliest_cr_line,pub_rec_bankruptcies,pub_rec
FROM raw;

-- call stored procedure 1
CALL getNYTECH();

-- create view 2
DROP VIEW IF EXISTS annual_inc;
CREATE VIEW annual_inc AS
SELECT addr_state, emp_title,emp_length, annual_inc
FROM borrower
ORDER BY annual_inc DESC;

SELECT * FROM annual_inc;


-- bankcard table
DROP TABLE IF EXISTS bankcard;
CREATE TABLE bankcard(
id INT(9) PRIMARY KEY,
mths_since_recent_bc VARCHAR(10),
num_actv_bc_tl INT(9),
num_bc_sats INT(9),
num_bc_tl INT(9),
total_bc_limit INT(9)
);

INSERT INTO bankcard
SELECT id,mths_since_recent_bc,num_actv_bc_tl,num_bc_sats,num_bc_tl,total_bc_limit
FROM raw;


-- inquries table
DROP TABLE IF EXISTS inquries;
CREATE TABLE inquries(
id INT(9) PRIMARY KEY,
inq_fi VARCHAR(10),
inq_last_12m VARCHAR(20),
mths_since_recent_inq VARCHAR(20)
);

INSERT INTO inquries
SELECT id,inq_fi,inq_last_12m,mths_since_recent_inq
FROM raw;

-- installment table
DROP TABLE IF EXISTS installment;
CREATE TABLE installment(
id iNT(9) PRIMARY KEY,
installment DECIMAL(9,3),
mo_sin_old_il_acct VARCHAR(10),
mths_since_rcnt_il VARCHAR(10),
num_il_tl INT(9)
);

INSERT INTO installment
SELECT id,installment,mo_sin_old_il_acct,mths_since_rcnt_il,num_il_tl
FROM raw;

DROP TABLE IF EXISTS reminders;

CREATE TABLE reminders (
    id INT AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- trigger 2
DROP TRIGGER IF EXISTS after_installment_insert;

DELIMITER //
CREATE TRIGGER after_installment_insert
AFTER INSERT
ON installment FOR EACH ROW
BEGIN
    IF NEW.installment IS NULL THEN
        INSERT INTO reminders(id, message)
        VALUES(new.id,CONCAT('Hi',', please update installment.'));
    END IF;
END //

DELIMITER ;

-- test
INSERT INTO installment(id,installment, num_il_tl )
VALUES
    (99999999, null, 3);
    
SELECT * FROM installment;    
SELECT * FROM reminders;    

-- bank_accounts
DROP TABLE IF EXISTS bank_accounts;
CREATE TABLE bank_accounts(
id INT(9) PRIMARY KEY,
mo_sin_rcnt_tl INT(5),
num_accts_ever_120_pd INT(5),
num_sats INT(5),
num_tl_120dpd_2m VARCHAR(10),
num_tl_30dpd INT(5),
num_tl_90g_dpd_24m INT(5),
num_tl_op_past_12m INT(5),
tot_cur_bal INT(9)
);

INSERT INTO bank_accounts
SELECT id,mo_sin_rcnt_tl,num_accts_ever_120_pd,num_sats,num_tl_120dpd_2m,num_tl_30dpd,num_tl_90g_dpd_24m,num_tl_op_past_12m,tot_cur_bal
FROM raw;

-- create trigger 1
USE loan;
DROP TRIGGER IF EXISTS bank_accounts_before_update;

DELIMITER //
CREATE TRIGGER bank_accounts_before_update
BEFORE UPDATE
ON bank_accounts
FOR EACH ROW
BEGIN
IF NEW.tot_cur_bal > 1300000 THEN
SIGNAL	SQLSTATE '22003' 
	SET	MESSAGE_TEXT = 'The total current balance is more than 1300000.', -- error case
    MYSQL_ERRNO = 1264;
ELSEIF NEW.tot_cur_bal BETWEEN 0 AND 1300000	THEN
	SET NEW.tot_cur_bal = NEW.tot_cur_bal;
ELSEIF NEW.tot_cur_bal < 0 THEN
SIGNAL	SQLSTATE '22003'
	SET	MESSAGE_TEXT = 'The total current balance is less than 0.',
    MYSQL_ERRNO = 1264;
END	IF;

END//
DELIMITER ;

-- Test Trigger 1
UPDATE bank_accounts
SET tot_cur_bal= 1400000
WHERE id = 11;

UPDATE bank_accounts
SET tot_cur_bal= 1200000
WHERE id = 11;

UPDATE bank_accounts
SET tot_cur_bal= -200
WHERE id = 11;

