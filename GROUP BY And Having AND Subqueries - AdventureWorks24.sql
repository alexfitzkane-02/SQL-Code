--Find products that have never been sold (For this question you technically dont need to solve it by uing a HAVING Or GROUP BY Clause. 
--I demonstrated two ways to solve this problem)

SELECT  P.ProductID
,P.[Name] AS [ProductName]
FROM SalesLT.[Product] AS P
LEFT JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.ProductID = P.ProductID
WHERE SOD.ProductID IS NULL

SELECT  P.ProductID
,P.[Name] AS [ProductName]
,COUNT(DISTINCT SOD.SalesOrderID) AS [SalesCount]
FROM SalesLT.[Product] AS P
LEFT JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.ProductID = P.ProductID
GROUP BY P.ProductID, P.Name
HAVING COUNT(DISTINCT SOD.SalesOrderID) = 0



--Identify customers who have placed more than 5 orders.

SELECT C.CustomerID
,C.FirstName
,C.LastName
,SUM(SOD.OrderQty) AS [OrerQty]
FROM SalesLT.SalesOrderHeader AS SOH
INNER JOIN SalesLT.Customer AS C ON C.CustomerID = SOH.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY C.CustomerID, C.FirstName, C.LastName
HAVING SUM(SOD.OrderQty) > 5


--Find the best-selling product (by total quantity sold).
SELECT TOP 1 * FROM (
SELECT P.ProductID
,P.Name AS [ProductName]
,SUM(SOD.OrderQty) AS [OrerQty]
FROM SalesLT.SalesOrderDetail AS SOD
INNER JOIN SalesLT.Product AS P ON P.ProductID = SOD.ProductID
GROUP BY P.ProductID, P.[Name]
) AS A
ORDER BY A.OrerQty DESC


--Display the total sales per year.
SELECT Year(OrderDate) AS [Year]
,SUM(TotalDue) AS [Sales]
FROM SalesLT.SalesOrderHeader
GROUP BY Year(OrderDate)
ORDER BY YEAR(OrderDate)

--Find sales orders where the order total exceeds the average order total.
DECLARE @AvgOrderTotal MONEY 
SET @AvgOrderTotal = (SELECT AVG(TotalDue) FROM SalesLT.SalesOrderHeader)

SELECT SalesOrderID
,SalesOrderNumber
FROM SalesLT.SalesOrderHeader
WHERE TotalDue > @AvgOrderTotal

--Identify the top 3 customers by total purchase amount.
SELECT TOP 3 * FROM (
SELECT SOH.CustomerID
,C.FirstName
,C.LastName
,SUM(TotalDue) AS [SalesTotal]
FROM SalesLT.SalesOrderHeader AS SOH
INNER JOIN SalesLT.Customer AS C ON C.CustomerID = SOH.CustomerID
GROUP BY SOH.CustomerID
,C.FirstName
,C.LastName
) AS A
ORDER BY A.SalesTotal DESC