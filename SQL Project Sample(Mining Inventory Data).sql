SELECT TOP (1000) [Date]
      ,[Product Name]
      ,[Stock In]
      ,[Stock Out]
      ,[Current Stock]
      ,[Supplier]
      ,[Category]
  FROM [Project Sample(Mining Inventory Data)].[dbo].[mining_inventory_data]



   --DATA CLEANING

  --Checking For Missing Values:

 SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS MissingDate,
    SUM(CASE WHEN [Product Name] IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN [Stock In] IS NULL THEN 1 ELSE 0 END) AS MissingStockIn,
    SUM(CASE WHEN [Stock Out] IS NULL THEN 1 ELSE 0 END) AS MissingStockOut,
    SUM(CASE WHEN [Current Stock] IS NULL THEN 1 ELSE 0 END) AS MissingCurrentStock,
    SUM(CASE WHEN [Supplier] IS NULL THEN 1 ELSE 0 END) AS MissingSupplier,
    SUM(CASE WHEN [Category] IS NULL THEN 1 ELSE 0 END) AS MissingCategory
FROM [dbo].[mining_inventory_data];


  --Checking for Duplicates:

SELECT [Date], [Product Name], [Supplier],[Stock In], COUNT(*) AS DuplicateCount
FROM [dbo].[mining_inventory_data]
GROUP BY [Date], [Product Name], [Supplier],[Stock In]
HAVING COUNT(*) > 1;


  --How much a supplier delivered in total on a specific day:

SELECT [Date], [Product Name], [Supplier], SUM([Stock In]) AS TotalStockIn
FROM [dbo].[mining_inventory_data]
GROUP BY [Date], [Product Name], [Supplier];


  -- To check if dates are properly stored as DATETIME:

 SELECT [Date]
FROM [dbo].[mining_inventory_data]
WHERE ISDATE([Date]) = 0;

select * from mining_inventory_data

  --Changeing/Altering The Date Formate To DD-MM-YY:

  ALTER TABLE mining_inventory_data  
ALTER COLUMN [Date] DATE;



  --To Check For Negative Values:

  SELECT * FROM mining_inventory_data WHERE [Stock In] < 0;
  SELECT * FROM mining_inventory_data WHERE [Stock Out] < 0;




  --STOCK MOVEMENT ANALYSIS


  --Check Total Stock In and Stock Out for Each Product:

  SELECT 
    [Product Name], 
    SUM([Stock In]) AS Total_Stock_Received, 
    SUM([Stock Out]) AS Total_Stock_Dispatched
FROM mining_inventory_data
GROUP BY [Product Name];


  -- Check the Current Stock Level:

   --Total Stock current level,
  SELECT 
    [Product Name], 
    SUM([Stock In]) - SUM([Stock Out]) AS Current_Stock_Level
FROM mining_inventory_data
GROUP BY [Product Name];

  --Individual  current stock level,

SELECT [Product Name],[Date],[Supplier], ([Stock In] - [Stock Out]) AS Current_Stock
FROM mining_inventory_data
WHERE ([Stock In] - [Stock Out]) < 50;

  --Find the Most Frequently Supplied Products:

  SELECT 
    [Product Name], 
    COUNT(*) AS Supply_Frequency
FROM mining_inventory_data
GROUP BY [Product Name]
ORDER BY Supply_Frequency DESC;




  -- INVENTORY PERFORMANCE REPORT

  --Find the Most Reliable Suppliers:

  SELECT 
    [Supplier], 
    COUNT(DISTINCT [Product Name]) AS Unique_Products_Supplied, 
    SUM([Stock In]) AS Total_Stock_Provided
FROM mining_inventory_data
GROUP BY [Supplier]
ORDER BY Total_Stock_Provided DESC;

  -- Check Products with Frequent Stock Shortages:

  SELECT 
    [Product Name], 
    SUM([Stock Out]) AS Total_Times_Out_of_Stock
FROM mining_inventory_data
WHERE [Stock In] = 0
GROUP BY [Product Name]
ORDER BY Total_Times_Out_of_Stock DESC;



  --FORCASTING STOCK NEEDS

  --Predicting Next Month's Stock Demands:

  SELECT 
    [Product Name], 
    AVG([Stock Out]) AS Avg_Monthly_Demand
FROM mining_inventory_data
WHERE [Date] >= DATEADD(MONTH, -3, GETDATE())  -- Last 3 months data
GROUP BY [Product Name];



