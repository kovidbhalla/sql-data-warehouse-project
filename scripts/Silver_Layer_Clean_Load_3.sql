
TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (
                                        sls_ord_num,
                                        sls_prd_key,
                                        sls_cust_id,
                                        sls_order_date,
                                        sls_ship_date,
                                        sls_due_date,
                                        sls_sales,
                                        sls_quantity,
                                        sls_price)

Select 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_date = 0 OR LEN(sls_order_date) != 8 THEN NULL
    ELSE CAST(CAST(sls_order_date AS VARCHAR) AS DATE) END AS sales_order_date,

    CASE WHEN sls_ship_date = 0 OR LEN(sls_ship_date) != 8 THEN NULL
    ELSE CAST(CAST(sls_ship_date AS VARCHAR) AS DATE) END AS sales_ship_date,

    CASE WHEN sls_due_date = 0 OR LEN(sls_due_date) != 8 THEN NULL
    ELSE CAST(CAST(sls_due_date AS VARCHAR) AS DATE) END AS sales_due_date,
    
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
    THEN sls_quantity * ABS(sls_price)                                           --derived column
    ELSE sls_sales END AS sls_sales,
    sls_quantity,
    CASE WHEN sls_price iS NULL OR sls_price <= 0
    THEN sls_sales / NULLIF(sls_quantity, 0)
    ELSE sls_price END AS sls_price
    
From bronze.crm_sales_details


--select*from silver.crm_sales_details
/*
-- Check for Invalid Dates
SELECT
sls_order_date
FROM bronze.crm_sales_details
WHERE NULLIF(sls_order_date,0)  < 0 or LEN(sls_order_date) !=8

SELECT
*

FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price


*/