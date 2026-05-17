CREATE TABLE Customers
    ([ID] int, [CustomerName] varchar(30), [CustomerNumber] varchar(10), [Address] varchar(30), [City] varchar(30), [State] varchar(2), [Zip] varchar(10), [Country] varchar(2), [FamilyID] int)
;

Use EmadeDev
Select *
From Customer


INSERT INTO Customers
    ([ID], [CustomerName], [CustomerNumber], [Address], [City], [State], [Zip], [Country], [FamilyID])
VALUES
('37925182','Bicycles R Us 1','C9879A3','16 Shore St.','Fort Lauderdale','FL','33308','US','1321'),
('37925183','Globex Corporation NY','C6548A6','192 Cypress Lane','La Porte','NY','11741','US','6549'),
('37925184','Hooli East Coast','C2367A5','200 West Purple Finch St.','Johnstown','NC','49509','US','9843'),
('37925185','Ben Johnson','C3984A9','280 Oakland Rd.','Etobicoke','ON','L4C 6B9','CA',''),
('37925186','Hooli West Coast','C3284A5','7233 South James Road','Fayetteville','CA','28303','US','9843'),
('37925187','Globex Corporation CT','C8974A4','7375 Purple Finch Road','Derry','CT','03038','US','6549'),
('37925188','Bicycles R Us 2','C1321A8','7387 Grant Drive','Valley Stream','NY','11580','US','1321'),
('37925189','Hooli Northeast','C6543A7','7693 Marsh Dr.','Atwater','ME','04401','US','9843'),
('37925190','Globex Corporation PA','C6894A3','77 Mayfair Dr.','Taunton','PA','02780','US','6549'),
('37925193','Dylan Coopers','C4897A1','8107 Mayflower Street','Montreal','QC','H4P 1V5','CA','')
;

CREATE TABLE Family
    ([ID] int, [FamilyName] varchar(20), [FamilyNumber] varchar(10));
INSERT INTO Family
    ([ID], [FamilyName], [FamilyNumber])
VALUES
('1321','Bicycles R Us','BIKES100'),
('6549','Globex Corporation','GLOBCORP'),
('9843','Hooli','HOOLI123');

CREATE TABLE Hawb
    ([ID] int, [Hawb] varchar(10), [HawbDate] date, [ServiceCodeID] int, [DueDate] date, [PODDate] date, [ShipperID] int, [ConsigneeID] int, [TotalRevenue] decimal(10,2));
INSERT INTO Hawb
    ([ID], [Hawb], [HawbDate], [ServiceCodeID], [DueDate], [PODDate], [ShipperID], [ConsigneeID], [TotalRevenue])
VALUES
('1656549987','H659124','01/13/2021','101','01/15/2021','01/16/2021','37925182','37925193','37.50'),
('1656549988','H659125','05/21/2021','102','05/25/2021','05/23/2021','37925183','37925193','18.00'),
('1656549989','H659126','06/14/2021','100','06/22/2021','06/21/2021','37925186','37925185','21.00'),
('1656549990','H659127','05/16/2021','101','05/19/2021','05/19/2021','37925187','37925193','16.25'),
('1656549991','H659128','06/30/2021','100','07/01/2021','07/01/2021','37925188','37925185','15.00'),
('1656549992','H659129','05/25/2021','102','05/31/2021','06/01/2021','37925189','37925185','18.00'),
('1656549993','H659130','08/22/2020','100','08/29/2020','08/29/2020','37925190','37925193','21.00'),
('1656549994','H659131','02/26/2021','101','02/28/2021','02/27/2021','37925190','37925185','24.25'),
('1656549995','H659132','05/28/2020','101','05/30/2020','05/30/2020','37925184','37925193','14.00'),
('1656549996','H659133','12/24/2020','100','01/04/2021','01/03/2021','37925183','37925185','18.50'),
('1656549997','H659134','05/01/2021','102','05/09/2021','05/08/2021','37925182','37925185','32.00'),
('1656549998','H659135','07/15/2021','100','07/21/2021',NULL,'37925184','37925193','14.00'),
('1656549999','H659136','05/02/2021','101','05/10/2021','05/09/2021','37925183','37925185','37.50'),
('1656550000','H659137','03/15/2021','101','03/21/2021','03/27/2021','37925182','37925185','19.00'),
('1656550001','H659138','07/09/2021','102','07/15/2021',NULL,'37925183','37925193','27.25');

CREATE TABLE ServiceType
    ([ID] int, [ServiceCode] varchar(5), [ServiceDescription] varchar(15), [ServiceCategoryName] varchar(10));
INSERT INTO ServiceType
    ([ID], [ServiceCode], [ServiceDescription], [ServiceCategoryName])
VALUES
('100','S200','Express','Courier'),
('101','S400','Canada LTL','LTL'),
('102','S300','Ground','Courier');

--Write a query that shows sum of total revenue per family for May 2021. Only include completed shipments.
--Hints: Join on ShipperID.  Revenue should be based on Hawb Date.

/* ==========================================
   1. Sum of Total Revenue per Family for May 2021
      (Only completed shipments, join on ShipperID)
   ========================================== */
SELECT 
    F.FamilyName,
    SUM(H.TotalRevenue) AS TotalRevenue_May2021
FROM Hawb H
INNER JOIN Customers C ON H.ShipperID = C.ID
INNER JOIN Family F ON C.FamilyID = F.ID
WHERE H.HawbDate >= '2021-05-01' AND H.HawbDate < '2021-06-01'
  AND H.PODDate IS NOT NULL
GROUP BY F.FamilyName
ORDER BY TotalRevenue_May2021 DESC;
GO



-- For each record in the Hawb table calculate the delivery days.  Be sure to account for Hawbs that are still en-route.
/* ==========================================
   2. Delivery Days per Hawb (Accounts for En-Route)
   ========================================== */
SELECT 
    H.Hawb,
    H.HawbDate,
    H.PODDate,
    DATEDIFF(DAY, H.HawbDate, COALESCE(H.PODDate, CAST(GETDATE() AS DATE))) AS DeliveryDays
FROM Hawb H
ORDER BY H.HawbDate;
GO




--Calculate the number of late delivery days and the value of those deliveries grouped by family.
/* ==========================================
   3. Late Delivery Days & Value Grouped by Family
   ========================================== */
SELECT 
    F.FamilyName,
    SUM(CASE WHEN H.PODDate > H.DueDate 
             THEN DATEDIFF(DAY, H.DueDate, H.PODDate) 
             ELSE 0 END) AS TotalLateDeliveryDays,
    SUM(CASE WHEN H.PODDate > H.DueDate 
             THEN H.TotalRevenue 
             ELSE 0 END) AS TotalLateDeliveryValue
FROM Hawb H
INNER JOIN Customers C ON H.ShipperID = C.ID
INNER JOIN Family F ON C.FamilyID = F.ID
WHERE H.PODDate IS NOT NULL
GROUP BY F.FamilyName
ORDER BY F.FamilyName;
GO




--Create a pivot with the Service Code concatenated with Service Category Name as the column headers, Total Revenue as the data values, and grouped by consignee name.
--Only include shipments already delivered.
/* ==========================================
   4. Pivot: Service Code + Category as Columns
      Grouped by Consignee Name (Delivered only)
   ========================================== */
SELECT 
    C.CustomerName AS ConsigneeName,
    SUM(CASE WHEN CONCAT(S.ServiceCode, S.ServiceCategoryName) = 'S200Courier' THEN H.TotalRevenue ELSE 0 END) AS [S200Courier],
    SUM(CASE WHEN CONCAT(S.ServiceCode, S.ServiceCategoryName) = 'S400LTL'   THEN H.TotalRevenue ELSE 0 END) AS [S400LTL],
    SUM(CASE WHEN CONCAT(S.ServiceCode, S.ServiceCategoryName) = 'S300Courier' THEN H.TotalRevenue ELSE 0 END) AS [S300Courier]
FROM Hawb H
INNER JOIN Customers C ON H.ConsigneeID = C.ID
INNER JOIN ServiceType S ON H.ServiceCodeID = S.ID
WHERE H.PODDate IS NOT NULL
GROUP BY C.CustomerName
ORDER BY C.CustomerName;
GO




--Write a query that shows all Hawb values with their revenue, a column with the sum of ALL revenue, and another column with the % of sum total revenue. 
--Hint: Using a SQL window function to calculate the ALL revenue column if you know how.

/* ==========================================
   5. Hawb Revenue, Total Sum, & % of Total (Window Function)
   ========================================== */
SELECT 
    H.Hawb,
    H.TotalRevenue,
    SUM(H.TotalRevenue) OVER() AS SumOfAllRevenue,
    CAST(ROUND((H.TotalRevenue * 100.0) / SUM(H.TotalRevenue) OVER(), 2) AS DECIMAL(10,2)) AS PercentOfTotalRevenue
FROM Hawb H
ORDER BY H.HawbDate;
GO


--