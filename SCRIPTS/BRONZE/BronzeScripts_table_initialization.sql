
/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

use datawarehouse_bronze;

create table datawarehouse_bronze.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);

CREATE TABLE datawarehouse_bronze.crm_prod_info (
    prd_id INT NULL,
    prd_key NVARCHAR(50) NULL,
    prd_nm NVARCHAR(50) NULL,
    prd_cost DECIMAL(10,2) NULL,
    prd_line NVARCHAR(50) NULL,
    prd_start_dt DATE NULL,
    prd_end_dt DATE NULL
);




CREATE TABLE datawarehouse_bronze.crm_sales_details_info (
    sls_ord_num      NVARCHAR(50),
    sls_prd_key      NVARCHAR(50),
    sls_cust_id      INT,
    sls_order_dt     DATE,         -- better than INT if dates are real
    sls_ship_dt      DATE,
    sls_due_dt       DATE,
    sls_sales        DECIMAL(15,2),   -- allows large & decimal sales values
    sls_quantity     INT,
    sls_price        DECIMAL(15,2)    -- safer for price handling
);

ALTER TABLE datawarehouse_bronze.crm_sales_details_info
    MODIFY sls_order_dt INT,
    MODIFY sls_ship_dt INT,
    MODIFY sls_due_dt INT;



-- =====================================================
-- 1. DROP all existing tables (if they exist)
-- =====================================================

DROP TABLE IF EXISTS datawarehouse_bronze.erp_loc_a101;
DROP TABLE IF EXISTS datawarehouse_bronze.erp_cust_az12;
DROP TABLE IF EXISTS datawarehouse_bronze.erp_px_cat_g1v2;

-- =====================================================
-- 2. RECREATE them with NULL default values
-- =====================================================

-- ERP Location
CREATE TABLE datawarehouse_bronze.erp_loc_a101 (
    cid    NVARCHAR(50) DEFAULT NULL,
    cntry  NVARCHAR(50) DEFAULT NULL
);

-- ERP Customer
CREATE TABLE datawarehouse_bronze.erp_cust_az12 (
    cid    NVARCHAR(50) DEFAULT NULL,
    bdate  DATE         DEFAULT NULL,
    gen    NVARCHAR(50) DEFAULT NULL
);

-- ERP Product Category
CREATE TABLE datawarehouse_bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50) DEFAULT NULL,
    cat          NVARCHAR(50) DEFAULT NULL,
    subcat       NVARCHAR(50) DEFAULT NULL,
    maintenance  NVARCHAR(50) DEFAULT NULL
);
