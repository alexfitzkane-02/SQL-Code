--List all products with their Name, ProductNumber, and ListPrice.
SELECT TOP 10 [Name] AS [Name]
,ProductNumber  
,ListPrice
FROM SalesLT.Product

--Find all products that cost more than $1000.
SELECT TOP 10 [Name] AS [Name]
,ProductNumber  
,ListPrice
FROM SalesLT.Product
WHERE ListPrice > 1000

--List customers who have a company name (not individual consumers).
SELECT TOP 10 CustomerID
,FirstName
,LastName
,CompanyName
FROM SalesLT.Customer
WHERE CompanyName IS NOT NULL

--Find all products whose name starts with “Road”.

SELECT TOP 10 ProductID
,[Name] AS [Name]
,ProductNumber
FROM SalesLT.Product
WHERE Name LIKE 'Road%'

--Display all sales orders placed in 2008.
SELECT TOP 10 SalesOrderID
,OrderDate
,SalesOrderNumber
,PurchaseOrderNumber
,CustomerID
FROM [SalesLT].[SalesOrderHeader]
WHERE YEAR(OrderDate) = 2008