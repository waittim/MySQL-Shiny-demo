-- Name: Jiayi Wang
-- Email: jiayi.wang.2@vanderbilt.edu
-- Project2

-- create database

DROP DATABASE IF EXISTS loan;
CREATE DATABASE loan;
USE loan;

DROP TABLE IF exists raw;
CREATE table raw(
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

-- lode data

LOAD DATA INFILE '/Users/jiayiwang/Desktop/projects/database/project2/loan.csv'
INTO TABLE raw
character set latin1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'; 


-- create tables with UML diagrams

DROP TABLE IF EXISTS loan;
CREATE TABLE loan(
id INT(9) PRIMARY KEY,
int_rate DECIMAL(4,2),
grade CHAR(2),
loan_amnt INT(9),
loan_status VARCHAR(20),
disbursement_method VARCHAR(20)  CHECK (disbursement_method IN ('CASH', 'DIRECT_PAY')),
title VARCHAR(200),
zip_code VARCHAR(50),
funded_amnt VARCHAR(20),
funded_amnt_inv INT(9),
initial_list_status VARCHAR(10) CHECK(initial_list_status IN ('W','F')),
purpose VARCHAR(50)
);

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

DROP TABLE IF EXISTS bankcard;
CREATE TABLE bankcard(
id INT(9) PRIMARY KEY,
mths_since_recent_bc INT(9),
num_actv_bc_tl INT(9),
num_bc_sats INT(9),
num_bc_tl INT(9),
total_bc_limit INT(9)
);


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

DROP TABLE IF EXISTS inquries;
CREATE TABLE inquires(
id INT(9) PRIMARY KEY,
inq_fi VARCHAR(10),
inq_last_12m VARCHAR(20),
mths_since_recent_inq VARCHAR(20)
);

DROP TABLE IF EXISTS installment;
CREATE TABLE installment(
id iNT(9) PRIMARY KEY,
installment DECIMAL(9,3),
mo_sin_old_il_acct VARCHAR(10),
mths_since_rcnt_il VARCHAR(10),
num_il_tl INT(9)
);






