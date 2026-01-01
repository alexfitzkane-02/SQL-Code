BEGIN TRAN
INSERT INTO [SalesLT].[ProductCategory] (ParentProductCategoryID, Name, rowguid, ModifiedDate)
SELECT 1, 'Trike', NEWID(), GETDATE()
COMMIT
-------------------------------------------
BEGIN TRAN
UPDATE T
SET T.Name = 'Trikes'
FROM [SalesLT].[ProductCategory] AS T
WHERE ProductCategoryID = 42
COMMIT
-------------------------------------------
BEGIN TRAN
DELETE T
FROM [SalesLT].[ProductCategory] AS T
WHERE ProductCategoryID = 42
COMMIT
-------------------------------------------
SELECT * INTO #SourceData FROM (
SELECT 'Trike' AS [Product]
) AS A

MERGE [SalesLT].[ProductCategory] AS Target
USING #SourceData AS Source
ON Source.[Product] = Target.Name
--INSERTS
WHEN NOT MATCHED BY Target THEN
    INSERT (ParentProductCategoryID, [Name], rowguid, ModifiedDate) 
    VALUES (NULL, Source.Product, NEWID(), GETDATE())
--UPDATES
WHEN MATCHED THEN UPDATE 
SET Target.ModifiedDate = GETDATE()
--DELETES
WHEN NOT MATCHED BY Source THEN
DELETE;
