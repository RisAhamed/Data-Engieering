use datawarehouse_silver;

create table datawarehouse_silver.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
dwh_create_data datetime default NOW()
);

CREATE TABLE datawarehouse_silver.crm_prod_info (
    prd_id INT NULL,
    prd_key NVARCHAR(50) NULL,
    prd_nm NVARCHAR(50) NULL,
    prd_cost DECIMAL(10,2) NULL,
    prd_line NVARCHAR(50) NULL,
    prd_start_dt DATE NULL,
    prd_end_dt DATE NULL,
dwh_create_data datetime default NOW()
);




CREATE TABLE datawarehouse_silver.crm_sales_details_info (
    sls_ord_num      NVARCHAR(50),
    sls_prd_key      NVARCHAR(50),
    sls_cust_id      INT,
    sls_order_dt     DATE,         -- better than INT if dates are real
    sls_ship_dt      DATE,
    sls_due_dt       DATE,
    sls_sales        DECIMAL(15,2),   -- allows large & decimal sales values
    sls_quantity     INT,
    sls_price        DECIMAL(15,2),   -- safer for price handling
dwh_create_data datetime default NOW()
);

ALTER TABLE datawarehouse_silver.crm_sales_details_info
    MODIFY sls_order_dt INT,
    MODIFY sls_ship_dt INT,
    MODIFY sls_due_dt INT;



-- =====================================================
-- 1. DROP all existing tables (if they exist)
-- =====================================================

DROP TABLE IF EXISTS datawarehouse_silver.erp_loc_a101;
DROP TABLE IF EXISTS datawarehouse_silver.erp_cust_az12;
DROP TABLE IF EXISTS datawarehouse_silver.erp_px_cat_g1v2;

-- =====================================================
-- 2. RECREATE them with NULL default values
-- =====================================================

-- ERP Location
CREATE TABLE datawarehouse_silver.erp_loc_a101 (
    cid    NVARCHAR(50) DEFAULT NULL,
    cntry  NVARCHAR(50) DEFAULT NULL,
dwh_create_data datetime default now()
);

-- ERP Customer
CREATE TABLE datawarehouse_silver.erp_cust_az12 (
    cid    NVARCHAR(50) DEFAULT NULL,
    bdate  DATE         DEFAULT NULL,
    gen    NVARCHAR(50) DEFAULT NULL,
dwh_create_data datetime default NOW()
);

-- ERP Product Category
CREATE TABLE datawarehouse_silver.erp_px_cat_g1v2 (
    id           NVARCHAR(50) DEFAULT NULL,
    cat          NVARCHAR(50) DEFAULT NULL,
    subcat       NVARCHAR(50) DEFAULT NULL,
    maintenance  NVARCHAR(50) DEFAULT NULL,
dwh_create_data datetime default Now()
);
