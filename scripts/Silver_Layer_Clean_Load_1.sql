TRUNCATE TABLE silver.crm_cust_info;
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

select* from silver.crm_cust_info