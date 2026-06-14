TRUNCATE TABLE silver.erp_px_cat_g1v2;
INSERT INTO silver.erp_px_cat_g1v2
(cat_id, category, subcategory, maintenance)

SELECT
cat_id,
category,
subcategory,
maintenance
FROM bronze.erp_px_cat_g1v2
