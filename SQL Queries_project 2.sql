--- genderanalysis 

SELECT Gender, COUNT(*) AS CustomerCount
FROM customers
GROUP BY Gender;


--- CustomerLocationAnalysis 

SELECT City, State, Country, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City, State, Country
ORDER BY CustomerCount DESC;

---ContinentCustomerAnalysis

SELECT Continent, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY Continent
ORDER BY CustomerCount DESC;

---ProductPurchaseAnalysis

SELECT p.`Product Name`, COUNT(s.`Order Number`) AS PurchaseCount
FROM sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`
ORDER BY PurchaseCount DESC;

---GenderAgeAnalysis

SELECT Gender, YEAR(CURDATE()) - YEAR(Birthday) AS Age, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY Gender, Age
ORDER BY CustomerCount DESC;


---CustomerOrderAnalysis /PurchaseFrequency

SELECT s.CustomerKey, 
       ROUND(AVG(p.`Unit Price USD`), 2) AS AvgOrderValue, 
       COUNT(s.`Order Number`) AS PurchaseFrequency
FROM sales s
INNER JOIN products p
ON s.ProductKey = p.ProductKey 
GROUP BY s.CustomerKey
ORDER BY PurchaseFrequency DESC;

---MonthlySalesProfit 

SELECT DATE_FORMAT(s.`Order Date`, '%Y-%m') AS YearMonth, 
       SUM(s.Quantity * p.`Unit Price USD` * COALESCE(er.Exchange, 1)) AS TotalSalesInLocalCurrency,
       SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`) * COALESCE(er.Exchange, 1)) AS TotalProfit
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
LEFT JOIN exchange_rates er 
       ON s.`Order Date` = er.Date 
       AND s.`Currency Code` = er.Currency
GROUP BY DATE_FORMAT(s.`Order Date`, '%Y-%m')
ORDER BY YearMonth;

---ProductSalesProfitAnalysis

SELECT p.`Product Name`, 
       p.Brand, 
       p.Category, 
       p.Subcategory, 
       SUM(s.Quantity) AS TotalUnitsSold, 
       SUM(s.Quantity * p.`Unit Price USD` * COALESCE(er.Exchange, 1)) AS TotalSalesInLocalCurrency, 
       SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`) * COALESCE(er.Exchange, 1)) AS TotalProfit
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
LEFT JOIN exchange_rates er 
       ON s.`Order Date` = er.Date 
       AND s.`Currency Code` = er.Currency
GROUP BY p.ProductKey, p.`Product Name`, p.Brand, p.Category, p.Subcategory
ORDER BY TotalSalesInLocalCurrency DESC;

---StoreSalesAnalysis

SELECT st.StoreKey, 
       st.Country, 
       st.State, 
       SUM(s.Quantity * p.`Unit Price USD` * COALESCE(er.Exchange, 1)) AS TotalSalesInLocalCurrency
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
INNER JOIN stores st ON s.StoreKey = st.StoreKey
LEFT JOIN exchange_rates er 
       ON s.`Order Date` = er.Date 
       AND s.`Currency Code` = er.Currency
GROUP BY st.StoreKey, st.Country, st.State
ORDER BY TotalSalesInLocalCurrency DESC;

---CurrencySalesAnalysis

SELECT s.`Currency Code`, 
       ROUND(SUM(s.Quantity * p.`Unit Price USD` * COALESCE(er.Exchange, 1)), 2) AS TotalSalesInLocalCurrency
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
LEFT JOIN exchange_rates er 
       ON s.`Order Date` = er.Date 
       AND s.`Currency Code` = er.Currency
GROUP BY s.`Currency Code`
ORDER BY TotalSalesInLocalCurrency DESC;

---ProductProfitAnalysis

SELECT p.`Product Name`, 
       p.Brand, 
       p.Category, 
       p.Subcategory, 
       SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`)) AS TotalProfit
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.`Product Name`, p.Brand, p.Category, p.Subcategory
ORDER BY TotalProfit DESC;


---CategorySubcategoryAnalysis 

SELECT p.Category, 
       p.Subcategory, 
       SUM(s.Quantity) AS TotalUnitsSold, 
       ROUND(SUM(s.Quantity * p.`Unit Price USD`), 2) AS TotalRevenue, 
       ROUND(SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`)), 2) AS TotalProfit
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category, p.Subcategory
ORDER BY TotalRevenue DESC;


---StorePerformanceAnalysis

SELECT st.StoreKey, 
       st.Country, 
       st.State, 
       SUM(s.Quantity) AS TotalUnitsSold, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalRevenue, 
       SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`)) AS TotalProfit
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
INNER JOIN stores st ON s.StoreKey = st.StoreKey
GROUP BY st.StoreKey, st.Country, st.State
ORDER BY TotalRevenue DESC;


---CountryStatePerformanceAnalysis 

SELECT st.Country, 
       st.State, 
       SUM(s.Quantity) AS TotalUnitsSold, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalRevenue, 
       SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`)) AS TotalProfit
FROM sales s
INNER JOIN products p ON s.ProductKey = p.ProductKey
INNER JOIN stores st ON s.StoreKey = st.StoreKey
GROUP BY st.Country, st.State
ORDER BY TotalRevenue DESC;
