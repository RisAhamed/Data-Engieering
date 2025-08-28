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
-- Switch to the mysql database to avoid "No database selected" errors

USE mysql;


-- Drop old attempts if they exist
DROP DATABASE IF EXISTS DataWarehouse;
DROP DATABASE IF EXISTS Bronze;
DROP DATABASE IF EXISTS Silver;
DROP DATABASE IF EXISTS Gold;
DROP DATABASE IF EXISTS DataWarehouse_bronze;
DROP DATABASE IF EXISTS DataWarehouse_silver;
DROP DATABASE IF EXISTS DataWarehouse_gold;

-- Recreate fresh
CREATE DATABASE DataWarehouse_bronze;
CREATE DATABASE DataWarehouse_silver;
CREATE DATABASE DataWarehouse_gold;

-- Verify
SHOW DATABASES;

