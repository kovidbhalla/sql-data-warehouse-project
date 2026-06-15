


Create View gold.dim_customers AS
--Select cst_id, count(*) from(                --query to check for duplicates
Select
        ROW_NUMBER() OVER(Order by cst_id) As customer_key,
        ci.cst_id customer_id,
        ci.cst_key customer_number,
        ci.cst_firstname first_name,
        ci.cst_lastname last_name,
        la.country,
        ci.cst_material_status marital_status,
        CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info
        ELSE COALESCE(ca.gen, 'n/a')
        END AS gender,
        ca.bdate birthdate,
        ci.cst_create_date create_date

From silver.crm_cust_info ci

Left Join silver.erp_az12 ca
On ci.cst_key = ca.cid

Left Join silver.erp_loc_a101 la  
On ci.cst_key = la.cid

--)t group by cst_id
--HAVING count(*)>1