--Week 5 – ETL Assignments

Use EmadeDev

/** Week 5 – ETL Assignments

Objective:

Create database tables in EmdeDev

A: Load the data files to SQL Server DB using Import Utility tool.

Name each table by their file name. For example, EmadeBrands.csv will have a table named EmadeBrands
in the EmadeDev database. **/



/**B: Load the data files to SQL Server DB using the Bulk Insert Script/Process.

Name each table by their file name. For example, EmadeBrands.csv will have a table named EmadeBrandsBulk
in the EmadeDev database. **/

/**--KO: Load the data files to DB
using the Bulk Insert Script/Process.
By rightclick on any dbo.[sample],-Script
table as,-Create to,- New QE window,-Edit
params,-Drop Table if exists [sample],-
run bulk insert script, quote flat file path
**/

--EmadeCategoriesBulk

USE [EmadeDev]
GO

/****** Object:  Table [dbo].[EmadeCategories]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeCategoriesBulk]
CREATE TABLE [dbo].[EmadeCategoriesBulk](
	[category_id] [varchar](50) NULL,
	[category_name] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeCategoriesBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeCategories.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeCategoriesBulk

--File 2 - EmadeStoresBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeStores]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeStoresBulk]
CREATE TABLE [dbo].[EmadeStoresBulk](
	[store_id] [varchar](50) NULL,
	[store_name] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[street] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[zip_code] [nvarchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeStoresBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeStores.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeStoresBulk

--File 3 - EmadeStocksBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeStocks]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeStocksBulk]
CREATE TABLE [dbo].[EmadeStocksBulk](
	[store_id] [varchar](50) NULL,
	[product_id] [varchar](50) NULL,
	[quantity] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeStocksBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeStocks.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeStocksBulk

--File 4 - EmadeBrandsBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeBrands]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeBrandsBulk]
CREATE TABLE [dbo].[EmadeBrandsBulk](
	[brand_id] [varchar](50) NULL,
	[brand_name] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeBrandsBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeBrands.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeBrandsBulk


--File 5 - EmadeOrderItemsBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeOrderItems]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeOrderItemsBulk]
CREATE TABLE [dbo].[EmadeOrderItemsBulk](
	[order_id] [varchar](50) NULL,
	[item_id] [varchar](50) NULL,
	[product_id] [varchar](50) NULL,
	[quantity] [varchar](50) NULL,
	[list_price] [varchar](50) NULL,
	[discount] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeOrderItemsBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeOrderItems.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeOrderItemsBulk


--File 6 - EmadeProductsBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeProducts]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeProductsBulk]
CREATE TABLE [dbo].[EmadeProductsBulk](
	[product_id] [varchar](max) NULL,
	[product_name] [varchar](max) NULL,
	[brand_id] [varchar](max) NULL,
	[category_id] [varchar](max) NULL,
	[model_year] [varchar](max) NULL,
	[list_price] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

bulk insert EmadeProductsBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeProducts.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeProductsBulk

--File 7 - EmadeOrdersBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeOrders]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeOrdersBulk]
CREATE TABLE [dbo].[EmadeOrdersBulk](
	[order_id] [varchar](50) NULL,
	[customer_id] [varchar](50) NULL,
	[order_status] [varchar](50) NULL,
	[order_date] [varchar](50) NULL,
	[required_date] [varchar](50) NULL,
	[shipped_date] [varchar](50) NULL,
	[store_id] [varchar](50) NULL,
	[staff_id] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeOrdersBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeOrders.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeOrdersBulk


--File 8 - EmadeStaffsBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeStaffs]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeStaffsBulk]
CREATE TABLE [dbo].[EmadeStaffsBulk](
	[staff_id] [varchar](50) NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[active] [varchar](50) NULL,
	[store_id] [varchar](50) NULL,
	[manager_id] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeStaffsBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeStaffs.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeStaffsBulk

--File 9 - EmadeCustomersBulk
USE [EmadeDev]
GO
/****** Object:  Table [dbo].[EmadeCustomers]    Script Date: 10/12/2025 03:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Drop Table if Exists [EmadeCustomersBulk]
CREATE TABLE [dbo].[EmadeCustomersBulk](
	[customer_id] [varchar](50) NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[street] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[zip_code] [varchar](50) NULL
) ON [PRIMARY]
GO

bulk insert EmadeCustomersBulk
 from 'C:\Users\WORK-PC\Documents\ETL Training\Inbound\Data\EmadeCustomers.csv'
with
(format='csv', firstrow = 2,
fieldterminator=',',
rowterminator='0x0a'
)
;

Select *
From EmadeCustomersBulk


