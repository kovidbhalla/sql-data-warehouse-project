-- can be used for all tables by replacing table and column names
-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
Select cst_id, count(*)
From silver.crm_cust_info
Group by cst_id
Having count(*)>1 or cst_id IS NULl

--Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

--Check for unwanted Spaces
--Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

--Data Standardization & Consistency
SELECT DISTINCT cst_material_status
FROM silver. crm_cust_info