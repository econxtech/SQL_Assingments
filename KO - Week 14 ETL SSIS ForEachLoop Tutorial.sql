SELECT  [id]
      ,[Name]
      ,[Position]
      ,[SocialSecurity]
      ,[DistanceFromHome]
      ,[Department]
  FROM [EmadeDev].[dbo].[EmpWorkInfoAll]


TRUNCATE TABLE [dbo].[EmpWorkInfoAll]

use EmadeDev

Select *
From EmadeDev.dbo.Encounters

Select Distinct ENCOUNTERCLASS
From EmadeDev.dbo.Encounters