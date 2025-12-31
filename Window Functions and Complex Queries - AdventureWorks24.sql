--Rank products by total sales amount within each product category.
SELECT RANK () OVER (ORDER BY A.Total DESC) AS [Rank_No]
,* FROM (
SELECT SOD.ProductID
,SUM(SOD.LineTotal) AS [Total]
FROM SalesLT.SalesOrderDetail AS SOD
INNER JOIN SalesLT.[Product] AS P ON P.ProductID = SOD.ProductID
INNER JOIN SalesLT.ProductCategory AS PC ON PC.ProductCategoryID = P.ProductCategoryID
GROUP BY SOD.ProductID
) AS A

--Calculate running total sales by order date.
SELECT DISTINCT SOD.OrderDate
,SUM(SOD.TotalDue) OVER (ORDER BY SOD.OrderDate) AS [RunningTotal]
FROM SalesLT.SalesOrderHeader AS SOD
ORDER BY SOD.OrderDate ASC


--Identify customers who placed orders in consecutive years.
WITH CustomerYears AS (
    SELECT DISTINCT
        CustomerID,
        YEAR(OrderDate) AS OrderYear
    FROM
        SalesLT.SalesOrderHeader
),
ConsecutiveYears AS (
    SELECT
        CustomerID,
        OrderYear,
        LAG(OrderYear, 1) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderYear
        ) AS PrevOrderYear
    FROM
        CustomerYears
)

SELECT DISTINCT
    CustomerID
FROM
    ConsecutiveYears
WHERE
    OrderYear - PrevOrderYear = 1;


--For each state, find the month with the highest sales.

SELECT StateProvince,
       OrderMonth,
       OrderYear,
       SalesRow
FROM
    (
    SELECT
         A.StateProvince
        ,YEAR(SOH.OrderDate) AS [OrderYear]
        ,MONTH(SOH.OrderDate) AS [OrderMonth]
        ,ROW_NUMBER() OVER (
            PARTITION BY YEAR(OrderDate), MONTH(OrderDate), A.StateProvince
            ORDER BY SUM(TotalDue) DESC                        
        ) as SalesRow
    FROM
        SalesLT.SalesOrderHeader AS SOH
        LEFT JOIN SalesLT.Address AS A ON A.AddressID = SOH.ShipToAddressID
        GROUP BY A.StateProvince, YEAR(SOH.OrderDate), MONTH(SOH.OrderDate)
    ) AS SUBQ
WHERE
    SalesRow = 1



--Show year-over-year sales growth percentage.

WITH YearlySales AS (
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(TotalDue) AS SalesTotal
    FROM
        SalesLT.SalesOrderHeader AS SOH
    GROUP BY
        YEAR(OrderDate)
)

SELECT
    SalesYear,
    SalesTotal,
    LAG(SalesTotal, 1) OVER (ORDER BY SalesYear) AS PreviousYearSales,
    ROUND(
        (
            (SalesTotal - LAG(SalesTotal, 1) OVER (ORDER BY SalesYear))
            / LAG(SalesTotal, 1) OVER (ORDER BY SalesYear)
        ) * 100,
        2
    ) AS yoy_growth_pct
FROM
    YearlySales
ORDER BY
    SalesYear;
