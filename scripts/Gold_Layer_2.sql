Create VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER (ORDER BY pn.prd_start_date, pn.prd_key) AS product_key,
pn.prd_id product_id,
pn.prd_key product_number,
pn.prd_nm product_name,
pn.cat_id category_id,
pc.category category,
pc.subcategory subcategory,
pn.prd_cost cost,
pc.maintenance,
pn.prd_line product_line,
pn.prd_start_date start_date
FROM silver.crm_prd_info pn

Left Join silver.erp_px_cat_g1v2 pc
On pn.cat_id = pc.cat_id
Where pn.prd_end_date IS NULL                  --Filter out historical data
