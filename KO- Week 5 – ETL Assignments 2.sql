/**Week 5 – ETL Asssignments
Instructions:
1. Write queries to answer the questions below:
Show total
number of records for each file. **/

USE EmadeDev

SELECT 'EmadeCategories' AS TableName, 
COUNT(*) AS RecordCount FROM EmadeCategories
UNION ALL
SELECT 'EmadeStores', 
COUNT(*) FROM EmadeStores
UNION ALL
SELECT 'EmadeStocks', 
COUNT(*) FROM EmadeStocks
UNION ALL
SELECT 'EmadeBrands', 
COUNT(*) FROM EmadeBrands
UNION ALL
SELECT 'EmadeOrderItems', 
COUNT(*) FROM EmadeOrderItems
UNION ALL
SELECT 'EmadeProducts', 
COUNT(*) FROM EmadeProducts
UNION ALL
SELECT 'EmadeOrders', 
COUNT(*) FROM EmadeOrders
UNION ALL
SELECT 'EmadeStaffs', 
COUNT(*) FROM EmadeStaffs
UNION ALL
SELECT 'EmadeCustomers', 
COUNT(*) FROM EmadeCustomers
ORDER BY TableName;

/**2 How many
different categories of products are there?**/

SELECT COUNT(DISTINCT category_id) AS DifferentCategories
FROM EmadeProducts;


/**3 List all the
customers who are from New York city.**/

SELECT customer_id, first_name, last_name, city, [state],zip_code
FROM EmadeCustomersBulk 
WHERE city = 'New York'
ORDER BY last_name, first_name;

/**4 What are the
top 5 products with the highest prices?**/

SELECT TOP 5 product_id, product_name, list_price
FROM EmadeProducts
ORDER BY CAST(list_price AS DECIMAL(10,2)) DESC;

/**5 What cities are
the customers from? Note: show only unique values by removing duplicates in the
results.**/

SELECT DISTINCT city
FROM EmadeCustomers
ORDER BY city;

/**6 Find the
customer IDs who ordered the first 10 days in October 2018. Hint: Use the
table: EmadeOrders**/

SELECT DISTINCT customer_id
FROM EmadeOrders
WHERE order_date BETWEEN '2018-10-01' AND '2018-10-10';

SELECT DISTINCT customer_id
FROM EmadeOrdersBulk
WHERE order_date >= '2018-10-01'
  AND order_date <= '2018-10-10';

Select *
FROM EmadeOrdersBulk
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-10';

/**7 Find all the
Trek bicycles from 2017 model. Hint: Use the table: EmadeProducts**/

SELECT *
FROM EmadeProducts
WHERE brand_id = '9' AND model_year = '2017';


/**8 What are the
total number of customers in the Customers table? Hint: Use the table:
EmadeCustomers **/

SELECT COUNT(*) AS TotalCustomers
FROM EmadeCustomers;

/**9 What is the
total quantity of the products sold? Hint: Use the table: EmadeOrderItems**/

SELECT SUM(CAST(quantity AS INT)) AS TotalQuantitySold
FROM EmadeOrderItems;

/**10 Which product
has the highest price? Hint: Use the table: EmadeOrderItems

Upload (sql) files to GitHub.
Deliverables:- Screenshot of queries/your solutions via google classroom
Due Date: Dec 16, 2025 **/

SELECT TOP 1 product_id, product_name, list_price
FROM EmadeProducts
ORDER BY CAST(list_price AS DECIMAL(10,2)) DESC;
