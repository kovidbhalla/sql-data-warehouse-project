-- loading the csv/raw files into tables and making sure they map correctly to the given columns
Create OR Alter Procedure bronze.load_bronze AS 
Begin
DECLARE @start_time DATETIME, @end_time DATETIME
DECLARE @start_time_whole_batch DATETIME, @end_time_whole_batch DATETIME
Begin TRY 
PRINT '------------------------------';
PRINT 'Loading Bronze Layer';
PRINT '------------------------------';
SET @start_time_whole_batch = GETDATE();

PRINT '------------------------------';
PRINT 'Loading CRM Tables';
PRINT '------------------------------';
SET @start_time = GETDATE();
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\KOVID\OneDrive\Documents\sql-data-warehouse-project-main\sql-data-warehouse-project-main - Copy\datasets\source_crm\cust_info.csv'
WITH(FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
    );

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT  bronze.crm_prd_info
FROM 'C:\Users\KOVID\OneDrive\Documents\sql-data-warehouse-project-main\sql-data-warehouse-project-main - Copy\datasets\source_crm\prd_info.csv'
WITH(FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
    );
TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT  bronze.crm_sales_details
FROM 'C:\Users\KOVID\OneDrive\Documents\sql-data-warehouse-project-main\sql-data-warehouse-project-main - Copy\datasets\source_crm\sales_details.csv'
WITH(FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
    );
PRINT '------------------------------';
PRINT 'Loading ERP Tables';
PRINT '------------------------------';
TRUNCATE TABLE bronze.erp_az12;
BULK INSERT  bronze.erp_az12
FROM 'C:\Users\KOVID\OneDrive\Documents\sql-data-warehouse-project-main\sql-data-warehouse-project-main - Copy\datasets\source_erp\CUST_AZ12.csv'
WITH(FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
    );
TRUNCATE TABLE bronze.loc_a101;
BULK INSERT  bronze.loc_a101
FROM 'C:\Users\KOVID\OneDrive\Documents\sql-data-warehouse-project-main\sql-data-warehouse-project-main - Copy\datasets\source_erp\LOC_A101.csv'
WITH(FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
    );
TRUNCATE TABLE bronze.px_cat_g1v2;
BULK INSERT  bronze.px_cat_g1v2
FROM 'C:\Users\KOVID\OneDrive\Documents\sql-data-warehouse-project-main\sql-data-warehouse-project-main - Copy\datasets\source_erp\PX_CAT_G1V2.csv'
WITH(FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
    );
SET @end_time_whole_batch = GETDATE();
PRINT '>> Load Duration for whole batch: ' + CAST(DATEDIFF(second, @start_time_whole_batch, @end_time_whole_batch) AS NVARCHAR) + ' seconds';
End TRY 

Begin CATCH
PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
PRINT 'Error Message' + ERROR_MESSAGE();
PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
End CATCH
END
-- note: for succesfully executing the stored procedure command cut and paste the command
-- below to top of the file and then run the quety
EXEC bronze.load_bronze;
