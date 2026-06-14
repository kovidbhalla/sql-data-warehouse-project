TRUNCATE TABLE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_date,
prd_end_date
)

SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- extracting category ID (derived column)
SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,      -- extracting product key(derived column)
prd_nm,
ISNULL(prd_cost,0) prd_cost,
CASE UPPER(TRIM(prd_line))                         -- data normalization
WHEN 'M' THEN 'Mountain'
WHEN 'R' THEN 'Road'
WHEN 'S' THEN 'Other Sales'
WHEN 'T' THEN 'Touring'
ELSE 'n/a'
END AS prd_line,
-- cleaning the date issues, 1st we used a window function to
-- replace the faulty end dates by the latest start dates for a particular product key (data enrichment)
-- then we converted DATETIME to DATE (data type casting)
CAST(prd_start_date AS DATE) prd_start_date, 
CAST(LEAD(prd_start_date) OVER( PARTITION BY prd_key ORDER BY prd_start_date) -1 AS DATE) prd_end_date
FROM bronze.crm_prd_info

Select*From silver.crm_prd_info