--Scenario:
--The business wants to simulate a gradual price increase for products in a specific category instead of a single bulk update.

/*
Task

Write a SQL script that:
1. Targets all products in the “Road Frames” product category.
2. Increases each product’s ListPrice by 1% per iteration.
3. Repeats the increase until the average ListPrice of Road Frames increases by 20% compared to its original average.
4. Tracks: Number of iterations performed ,Final average price, Stops automatically once the condition is met.

*/
DROP TABLE IF EXISTS #TempCurrentProductPrices
SELECT * INTO #TempCurrentProductPrices FROM (
SELECT ProductID, [Name], ListPrice
FROM SalesLT.Product
WHERE ProductCategoryID = 18
) AS A


DECLARE @StartAvgPrice DECIMAL(18,2) = (SELECT AVG(ListPrice) FROM #TempCurrentProductPrices) -- 780.04
DECLARE @FinalAvgPrice DECIMAL(18,2) = 0.00

DECLARE @FinalPercentageIncrease DECIMAL(18,2) = 0.00

DECLARE @CurrentPercentage DECIMAL(18,2) = 0.00
DECLARE @IterationsPerformed INT = 0 

WHILE(@FinalPercentageIncrease < 20 )
BEGIN 

SET @CurrentPercentage = @CurrentPercentage + 0.01
SET @IterationsPerformed = @IterationsPerformed + 1

DROP TABLE IF EXISTS #HoldingResults
SELECT * INTO #HoldingResults FROM (
SELECT ProductID, (CAST(ListPrice AS DECIMAL(18,2)) * @CurrentPercentage) + CAST(ListPrice AS DECIMAL(18,2)) AS [NewPrice] FROM #TempCurrentProductPrices
) AS B

SET @FinalAvgPrice = (SELECT AVG(CAST(NewPrice AS DECIMAL(18,2))) FROM #HoldingResults)
SET @FinalPercentageIncrease = (SELECT ((@FinalAvgPrice - @StartAvgPrice)/@StartAvgPrice)*100)

END

SELECT @FinalAvgPrice AS [FinalAvgPrice]
SELECT @IterationsPerformed AS [IterationsPerformed]

