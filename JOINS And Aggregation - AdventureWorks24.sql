--Show each product’s name and its product category.
SELECT TOP 10 P.Name AS [Name]
,PC.[Name] AS [ProductCategory]
FROM SalesLT.Product AS P
LEFT JOIN SalesLT.ProductCategory AS PC ON PC.ProductCategoryID = P.ProductCategoryID

--List all customers and the total number of orders they have placed.
SELECT SOH.CustomerID
,C.FirstName
,C.LastName
,COUNT(DISTINCT SOH.SalesOrderID) AS [NumberOfOrders]
FROM SalesLT.SalesOrderHeader AS SOH
INNER JOIN SalesLT.Customer AS C ON C.CustomerID = SOH.CustomerID
GROUP BY SOH.CustomerID, C.FirstName, C.LastName

--Find the top 10 most expensive products by ListPrice.
SELECT TOP 10 ProductID
,[Name] AS [Name]
,ProductNumber
,ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC

--Display each sales order with:Order ID,Order Date,Customer Name
SELECT TOP 10 SOH.SalesOrderID AS [Order ID]
,SOH.OrderDate
,CONCAT(C.FirstName, ' ', C.LastName) AS [Customer Name]
FROM SalesLT.SalesOrderHeader AS SOH
INNER JOIN SalesLT.Customer AS C ON C.CustomerID = SOH.CustomerID


--Find the total sales amount per sales state.
SELECT A.StateProvince
,SUM(SOD.LineTotal) AS [Total]
FROM SalesLT.SalesOrderHeader AS SOH
INNER JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOD.SalesOrderID
LEFT JOIN SalesLT.[Address] AS A ON A.AddressID = SOH.ShipToAddressID
GROUP BY A.StateProvince

--Show the average list price of products in each product category.
SELECT PC.[Name] AS [ProductCategory]
,AVG(P.ListPrice) AS [AvgListPrice]
FROM SalesLT.[Product] AS P
LEFT JOIN SalesLT.ProductCategory AS PC ON PC.ProductCategoryID = P.ProductCategoryID
GROUP BY PC.[Name]
