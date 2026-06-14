TRUNCATE TABLE silver.erp_loc_a101;
INSERT INTO silver.erp_loc_a101
(cid, country)

Select REPLACE(cid, '-', '') cid,
        CASE WHEN TRIM(country) = 'DE' THEN 'Germany'
        WHEN TRIM(country) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(country) = '' OR country IS NULL THEN 'n/a'
        ELSE TRIM(country) END AS country
        from bronze.erp_loc_a101
select * from silver.erp_loc_a101
/*
select cst_key from silver.crm_cust_info

--Data Standardization & Consistency
SELECT DISTINCT country
FROM bronze.erp_loc_a101
ORDER BY country

*/