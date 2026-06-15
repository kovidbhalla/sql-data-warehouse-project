Drop TABLE bronze.crm_cust_info;
Create Table bronze.crm_cust_info(  
  cst_id INT,
  cst_key NVARCHAR(50),
  cst_firstname NVARCHAR(50),
  cst_lastname NVARCHAR(50),
  cst_material_status NVARCHAR(50),
  cst_gndr NVARCHAR(50),
  cst_create_date DATE
);
Drop TABLE bronze.crm_prd_info;
Create Table bronze.crm_prd_info(  
  prd_id INT,
  prd_key NVARCHAR(50),
  prd_nm NVARCHAR(50),
  prd_cost INT,
  prd_line NVARCHAR(50),
  prd_start_date DATETIME,
  prd_end_date DATETIME
);
Drop TABLE bronze.crm_sales_details;
Create Table bronze.crm_sales_details(  
  sls_ord_num NVARCHAR(50),
  sls_prd_key NVARCHAR(50),
  sls_cust_id INT,
  sls_order_date INT,
  sls_ship_date INT,
  sls_due_date INT,
  sls_sales INT,
  sls_quantity INT,
  sls_price INT
);

--erp tables now
Drop TABLE bronze.erp_az12;
Create Table bronze.erp_az12(  
  cid NVARCHAR(50),
  bdate DATE,
  gen NVARCHAR(50)
);
Drop TABLE bronze.loc_a101;
Create Table bronze.loc_a101(  
  cid NVARCHAR(50),
  country NVARCHAR(50)
);
Drop TABLE bronze.px_cat_g1v2;
Create Table bronze.px_cat_g1v2(  
  cat_id  NVARCHAR(50),
  category NVARCHAR(50),
  subcategory NVARCHAR(50),
  maintenance NVARCHAR(50)
);
