--DATA MIGRATION

USE EmadeDev

--Migrating data from EmadeDev to EmadeTest

Select *
Into EmadeTest.[dbo].[Movies]
From EmadeDev.[dbo].[Movies]
Where [No] between 1 and 5

-- validating data migration
Select *
From EmadeTest.[dbo].[Movies]

--Gap Analysis
Select 'Dev' as source, Count (*) as Total
From EmadeDev.[dbo].[Movies]
Union
Select 'Test' as source,Count (*) as Total
From EmadeTest.[dbo].[Movies]


Drop Table If Exists EmadeTest.[dbo].[Movies]


Select *
From [dbo].[encounters]