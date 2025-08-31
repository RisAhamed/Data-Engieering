
use datawarehouse_bronze;


truncate table  crm_cust_info; /* to make the table empty before ingesting data*/

SHOW GLOBAL VARIABLES LIKE 'local_infile'; /* if this is off use the next command to trun on temporarly */
SHOW GLOBAL VARIABLES LIKE 'secure_file_priv'; /* if this is off use the next command to trun on temporarly */
SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM crm_cust_info;
show tables;
/*-----------------------------------------------------------------------------------------------------------------*/
TRUNCATE TABLE crm_sales_details_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_details_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'     -- important on Windows
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
SET
  sls_ord_num   = NULLIF(TRIM(@sls_ord_num)  ,''),
  sls_prd_key   = NULLIF(TRIM(@sls_prd_key)  ,''),
  sls_cust_id   = NULLIF(TRIM(@sls_cust_id)  ,''),
  sls_order_dt  = NULLIF(TRIM(@sls_order_dt) ,''),
  sls_ship_dt   = NULLIF(TRIM(@sls_ship_dt) ,''),
  sls_due_dt    = NULLIF(TRIM(@sls_due_dt)  ,''),
  sls_sales     = IF(@sls_sales    IS NULL OR TRIM(@sls_sales)    = '', 0, CAST(TRIM(@sls_sales) AS SIGNED)),
  sls_quantity  = IF(@sls_quantity IS NULL OR TRIM(@sls_quantity) = '', 0, CAST(TRIM(@sls_quantity) AS UNSIGNED)),
  sls_price = CASE
	WHEN @sls_price IS NULL OR TRIM(@sls_price) = '' THEN 0
	WHEN TRIM(@sls_price) = '-' THEN 0
	WHEN TRIM(@sls_price) REGEXP '^-?[0-9]+(\.[0-9]+)?$' THEN
		-- handle numeric values
		CASE 
			WHEN CAST(TRIM(@sls_price) AS DECIMAL(10,2)) < 0 THEN 0  -- clamp negatives to 0
			WHEN CAST(TRIM(@sls_price) AS DECIMAL(10,2)) > 9999999999 THEN 9999999999  -- clamp too-large values
			ELSE CAST(TRIM(@sls_price) AS DECIMAL(10,2))
		END
	ELSE 0  -- non-numeric junk → default to 0
END;

  
select count( *) from crm_sales_details_info; 
/*-----------------------------------------------------------------------------------------------------------------*/

Truncate  table  datawarehouse_bronze.crm_prod_info;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE datawarehouse_bronze.crm_prod_info
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(prd_id, prd_key, prd_nm, @prd_cost, prd_line, @prd_start_dt, @prd_end_dt)
SET
  prd_cost = NULLIF(TRIM(REPLACE(@prd_cost, CHAR(13), '')), ''),
  prd_start_dt = CASE
	  WHEN TRIM(REPLACE(REPLACE(@prd_start_dt, CHAR(13), ''), CHAR(160), '')) IN ('','0','0000-00-00') THEN NULL
	  ELSE STR_TO_DATE(TRIM(REPLACE(@prd_start_dt, CHAR(13), '')), '%Y-%m-%d')
  END,
  prd_end_dt = CASE
	  WHEN TRIM(REPLACE(REPLACE(@prd_end_dt, CHAR(13), ''), CHAR(160), '')) IN ('','0','0000-00-00') THEN NULL
	  ELSE STR_TO_DATE(TRIM(REPLACE(@prd_end_dt, CHAR(13), '')), '%Y-%m-%d')
  END;

select count(*) from datawarehouse_bronze.crm_prod_info;
/*-----------------------------------------------------------------------*/

select * from erp_cust_az12;
truncate table erp_cust_az12
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
INTO TABLE datawarehouse_bronze.erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select count(*) from erp_cust_az12;

/*------------------------------------------------------------------------------*/
truncate table erp_loc_a101;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
INTO TABLE datawarehouse_bronze.erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select count(*) from erp_loc_a101;

/*-----------------------------------------------------------------------------------*/
truncate table erp_px_cat_g1v2;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
INTO TABLE datawarehouse_bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select count(*) from erp_px_cat_g1v2;

