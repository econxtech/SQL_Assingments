--HealthcareInsuranceAnalysis_Project 2 – SQL Reporting Queries
Use EmadeDev

Select *
From [dbo].[InterviewHospitalisationDetails]

Select *
From [dbo].[InterviewMedicalExaminations]

Select *
From [dbo].[InterviewNames]

--1-Retrieve information about people who are diabetic and have heart problems with
--their average age, the average number of dependent children, average BMI, and
--average hospitalization costs.

WITH DiabeticHeartPatients AS
(
    SELECT 
        [Customer ID] AS CustomerID,
        TRY_CAST(BMI AS FLOAT) AS BMI,
        TRY_CAST(HBA1C AS FLOAT) AS HBA1C,
        [Heart Issues]
    FROM dbo.InterviewMedicalExaminations
    WHERE TRY_CAST(HBA1C AS FLOAT) >= 6.5
      AND ([Heart Issues] = 'Yes' OR [Heart Issues] = 'True' OR [Heart Issues] = '1')
),

PatientDetails AS
(
    SELECT 
        dhp.CustomerID,
        dhp.BMI,
        TRY_CAST(ihd.children AS FLOAT) AS children,
        TRY_CAST(ihd.charges AS FLOAT) AS charges,
        (YEAR(GETDATE()) - TRY_CAST(ihd.year AS FLOAT)) AS Age
    FROM DiabeticHeartPatients AS dhp
    INNER JOIN dbo.InterviewHospitalisationDetails AS ihd
          ON dhp.CustomerID = ihd.[Customer ID]
)

SELECT
    AVG(Age)      AS AvgAge,
    AVG(children) AS AvgDependentChildren,
    AVG(BMI)      AS AvgBMI,
    AVG(charges)  AS AvgHospitalisationCharges
FROM PatientDetails
WHERE Age IS NOT NULL;

--2-Find the average hospitalization cost for each hospital tier and each city level.
SELECT 
    [Hospital tier],
    [City tier],
    AVG(TRY_CAST(charges AS FLOAT)) AS AvgHospitalisationCharges
FROM [dbo].[InterviewHospitalisationDetails]
GROUP BY 
    [Hospital tier], 
    [City tier]
ORDER BY 
    [Hospital tier] ASC, 
    [City tier] ASC;

--3-Determine the number of people who have had major surgery with a history of cancer.
SELECT 
    COUNT([Customer ID]) AS PatientCount
FROM [dbo].[InterviewMedicalExaminations]
WHERE 
    ([Cancer history] = 'Yes' OR [Cancer history] = '1' OR [Cancer history] = 'True')
    AND TRY_CAST([NumberOfMajorSurgeries] AS INT) > 0;

--4-Determine the number of tier-1 hospitals in each state
SELECT 
    [State ID], 
    COUNT(*) AS NumberOfTier1Hospitals
FROM [dbo].[InterviewHospitalisationDetails]
WHERE 
    ([Hospital tier] = 'tier - 1' OR [Hospital tier] = '1' OR [Hospital tier] = 'Tier 1')
GROUP BY 
    [State ID]
ORDER BY 
    NumberOfTier1Hospitals DESC;

