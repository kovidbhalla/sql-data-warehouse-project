TRUNCATE TABLE silver.erp_az12;
INSERT INTO silver.erp_az12 (cid, bdate, gen)
select 
        Case WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
        ELSE cid END as cid,

        Case WHEN bdate > GETDATE() THEN NULL Else bdate END as bdate,

        CASE WHEN UPPER(Trim(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(Trim(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a' END AS gen
        
From bronze.erp_az12

--check to see if there are any keys which dont map to the crm_cust_info table
/*select 
        Case WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
        ELSE cid END as cid,
        bdate, gen
From bronze.erp_az12
WHERE case when cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
        ELSE cid END
        not in (Select distinct cst_key FROM silver.crm_cust_info)

--sanity checks on bdate
SELECT DISTINCT
bdate
FROM bronze. erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()
*/