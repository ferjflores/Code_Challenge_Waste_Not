-- List of products available to a customer with CustomerId = 1
-- Should return 4 rows

SELECT
	DISTINCT P.ProductId,
	ProductName,
	ProductPrice
FROM
	Product P
JOIN Visibility V ON
	(P.VisibilityId = V.VisibilityId)
JOIN CatalogProduct CP on
	(P.ProductId = CP.ProductId)
LEFT JOIN CatalogCustomer CC on
	(CP.CatalogId = CC.CatalogId)
WHERE
	(CC.CustomerId = 1
		AND CC.CatalogId IS NOT NULL)
	OR V.VisibilityId = 1

-- List of products available to a customer with CustomerId = 2
-- Should return 11 rows

SELECT
	DISTINCT P.ProductId,
	ProductName,
	ProductPrice
FROM
	Product P
JOIN Visibility V ON
	(P.VisibilityId = V.VisibilityId)
JOIN CatalogProduct CP on
	(P.ProductId = CP.ProductId)
LEFT JOIN CatalogCustomer CC on
	(CP.CatalogId = CC.CatalogId)
WHERE
	(CC.CustomerId = 2
		AND CC.CatalogId IS NOT NULL)
	OR V.VisibilityId = 1



-- List of products available to a customer with CustomerId = 4
-- Should return 18 rows

SELECT
	DISTINCT P.ProductId,
	ProductName,
	ProductPrice
FROM
	Product P
JOIN Visibility V ON
	(P.VisibilityId = V.VisibilityId)
JOIN CatalogProduct CP on
	(P.ProductId = CP.ProductId)
LEFT JOIN CatalogCustomer CC on
	(CP.CatalogId = CC.CatalogId)
WHERE
	(CC.CustomerId = 2
		AND CC.CatalogId IS NOT NULL)
	OR V.VisibilityId = 1