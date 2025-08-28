# Data-Engieering


# 📌 MySQL CSV Data Import Guide

This project ingests CSV files into MySQL using the `LOAD DATA INFILE` command. Since MySQL enforces the **`secure_file_priv`** restriction, you must follow the steps below to successfully import data.

---

## ⚙️ 1. Check MySQL Settings

Run these queries to confirm configuration:

```sql
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW GLOBAL VARIABLES LIKE 'secure_file_priv';
```

* `local_infile` should be `ON`.
* `secure_file_priv` shows the **only directory allowed for file imports**. Example:

```
secure_file_priv | C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
```

---

## 📂 2. Place Your CSV Files

* All CSVs **must be copied into the folder** shown by `secure_file_priv`.

* Example path:

  ```
  C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
  ```

* You can organize subfolders inside `Uploads`, e.g.:

  ```
  C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\datasets\source_crm\cust_info.csv
  ```

---

## 📥 3. Import Data Into Table

Example: load `cust_info.csv` into table `crm_cust_info`.

```sql
USE datawarehouse_bronze;

-- Clear table before ingesting
TRUNCATE TABLE crm_cust_info;

-- Import CSV from secure_file_priv path
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify row count
SELECT COUNT(*) FROM crm_cust_info;
```

---

## 🛠️ 4. Common Errors & Fixes

* **Error 1290: secure-file-priv restriction**
  → Solution: move your CSV file into the `Uploads` directory shown by `secure_file_priv`.

* **Error 2068: LOAD DATA LOCAL INFILE rejected**
  → Solution: do not use `LOCAL` when `secure_file_priv` is enforced. Use plain `LOAD DATA INFILE`.

* **Path Issues (Windows)**
  → Always use `/` forward slashes in SQL path:

  ```
  C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/file.csv
  ```

---

## TO-Check

* Always check `secure_file_priv`.
* Copy CSVs inside that folder.
* Use `LOAD DATA INFILE` (without `LOCAL`).
* Clean and re-import data as needed.
*important: If in the server , if any row numer or name is being mentioned on Improer value or null, try to remove the corresponding data and try to run the ingestion commands again

