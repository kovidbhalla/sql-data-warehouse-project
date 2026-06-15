

Print '--Truncating Table : silver.crm_cust_info -- '
TRUNCATE TABLE silver.crm_cust_info;
Print '--Inserting data into table : silver.crm_cust_info -- '
INSERT INTO silver.crm_cust_info (
                                    cst_id,
                                    cst_key,
                                    cst_firstname,
                                    cst_lastname,
                                    cst_material_status,
                                    cst_gndr,
                                    cst_create_date)

Select cst_id, cst_key, TRIM(cst_firstname) cst_firstname, TRIM(cst_lastname) cst_lastname, 
        CASE WHEN UPPER(TRIM(cst_material_status)) = 'M' Then 'Married'
            WHEN UPPER(TRIM(cst_material_status)) = 'S' Then 'Single'
            ELSE 'n/a' END cst_material_status,
        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' Then 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' Then 'Female'
            ELSE 'n/a' END cst_gndr,
        cst_create_date
From(
Select *,
ROW_NUMBER() OVER(Partition By cst_id ORDER BY cst_create_date DESC) AS flag_last
From bronze.crm_cust_info
)t
Where flag_last =1
Print '--Truncating Table : silver.crm_prd_info -- '
TRUNCATE TABLE silver.crm_prd_info;
Print '--Inserting data into table : silver.crm_prd_info -- '
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

Print '--Truncating Table : silver.crm_sales_details -- '
TRUNCATE TABLE silver.crm_sales_details;
Print '--Inserting data into table : silver.crm_sales_details -- '
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

Print '--Truncating Table : silver.erp_az12 -- '
TRUNCATE TABLE silver.erp_az12;
Print '--Inserting data into table : silver.erp_az12 -- '

INSERT INTO silver.erp_az12 (cid, bdate, gen)
select 
        Case WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
        ELSE cid END as cid,

        Case WHEN bdate > GETDATE() THEN NULL Else bdate END as bdate,

        CASE WHEN UPPER(Trim(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(Trim(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a' END AS gen
        
From bronze.erp_az12

Print '--Truncating Table : silver.erp_loc_a101 -- '
TRUNCATE TABLE silver.erp_loc_a101;
Print '--Inserting data into table : silver.erp_loc_a101 -- '
INSERT INTO silver.erp_loc_a101
(cid, country)

Select REPLACE(cid, '-', '') cid,
        CASE WHEN TRIM(country) = 'DE' THEN 'Germany'
        WHEN TRIM(country) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(country) = '' OR country IS NULL THEN 'n/a'
        ELSE TRIM(country) END AS country
        from bronze.erp_loc_a101

Print '--Truncating Table : silver.erp_px_cat_g1v2 -- '
TRUNCATE TABLE silver.erp_px_cat_g1v2;
Print '--Inserting data into table : silver.erp_px_cat_g1v2 -- '
INSERT INTO silver.erp_px_cat_g1v2
(cat_id, category, subcategory, maintenance)

SELECT
cat_id,
category,
subcategory,
maintenance
FROM bronze.erp_px_cat_g1v2