/** Business Scenario:
The City Department of Motor Vehicle Security (DMVS) wants to identify vehicle theft patterns to enhance law enforcement planning and public awareness. Your goal is to analyze vehicle theft data and present actionable insights through an interactive Power BI dashboard.


Instructions:

1. Load or import the excel (Stolen_Vehicle_Dataset.xlsx) into SQL server database: EMADE_DEV.

2. Build visuals and dashboard in Power BI:  


Use Cases
**/

--1. Identify theft hotspots by city.
SELECT 
    City,
    COUNT(*) AS TheftCount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS PercentageOfTotal
FROM Stolen_Vehicle_Dataset
GROUP BY City
ORDER BY TheftCount DESC;


--2. Determine which vehicle makes and models are most frequently stolen.
SELECT 
    Make,
    Model,
    COUNT(*) AS TheftCount
FROM Stolen_Vehicle_Dataset
GROUP BY Make, Model
ORDER BY TheftCount DESC;


--3. Analyze theft trends over time.
SELECT 
    YEAR(DateStolen) AS TheftYear,
    MONTH(DateStolen) AS TheftMonth,
    COUNT(*) AS TheftCount
FROM Stolen_Vehicle_Dataset
GROUP BY YEAR(DateStolen), MONTH(DateStolen)
ORDER BY TheftYear, TheftMonth;

--Optional: Add trend visualization with running average:
SELECT 
    TheftYear,
    TheftMonth,
    TheftCount,
    AVG(CAST(TheftCount AS FLOAT)) OVER (
        ORDER BY TheftYear, TheftMonth 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS ThreeMonthAvg
FROM (
    SELECT 
        YEAR(DateStolen) AS TheftYear,
        MONTH(DateStolen) AS TheftMonth,
        COUNT(*) AS TheftCount
    FROM Stolen_Vehicle_Dataset
    GROUP BY YEAR(DateStolen), MONTH(DateStolen)
) AS MonthlyData
ORDER BY TheftYear, TheftMonth;

--Business Questions

--How many vehicles were stolen each year or month?
--By Year
SELECT 
    YEAR(DateStolen) AS TheftYear,
    COUNT(*) AS TotalThefts
FROM Stolen_Vehicle_Dataset
GROUP BY YEAR(DateStolen)
ORDER BY TheftYear;

--By Month (across all years)
SELECT 
    DATENAME(MONTH, DATEFROMPARTS(2000, MONTH(DateStolen), 1)) AS MonthName,
    MONTH(DateStolen) AS MonthNumber,
    COUNT(*) AS TotalThefts
FROM Stolen_Vehicle_Dataset
GROUP BY MONTH(DateStolen)
ORDER BY MonthNumber;

--By Year-Month Combination
SELECT 
    FORMAT(DateStolen, 'yyyy-MM') AS YearMonth,
    COUNT(*) AS TotalThefts
FROM Stolen_Vehicle_Dataset
GROUP BY FORMAT(DateStolen, 'yyyy-MM')
ORDER BY YearMonth;


--Which cities have the highest theft rates?
SELECT TOP 10
    City,
    COUNT(*) AS TheftCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Stolen_Vehicle_Dataset), 2) AS PercentOfTotal
FROM Stolen_Vehicle_Dataset
GROUP BY City
ORDER BY TheftCount DESC;


--What are the top 10 most stolen vehicle makes and models?
SELECT TOP 10
    Make,
    Model,
    COUNT(*) AS TheftCount
FROM Stolen_Vehicle_Dataset
GROUP BY Make, Model
ORDER BY TheftCount DESC;


--What percentage of vehicles are recovered?
SELECT 
    ROUND(
        CAST(SUM(CASE WHEN Recovered = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 
        2
    ) AS RecoveryRatePercent,
    COUNT(*) AS TotalVehicles,
    SUM(CASE WHEN Recovered = 1 THEN 1 ELSE 0 END) AS RecoveredVehicles,
    SUM(CASE WHEN Recovered = 0 THEN 1 ELSE 0 END) AS UnrecoveredVehicles
FROM Stolen_Vehicle_Dataset;

--Breakdown by City
SELECT 
    City,
    COUNT(*) AS TotalThefts,
    SUM(CASE WHEN Recovered = 1 THEN 1 ELSE 0 END) AS Recovered,
    ROUND(
        SUM(CASE WHEN Recovered = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS RecoveryRatePercent
FROM Stolen_Vehicle_Dataset
GROUP BY City
ORDER BY RecoveryRatePercent DESC;

--How long does it take, on average, to recover a vehicle?
SELECT 
    Make,
    COUNT(*) AS RecoveredCount,
    ROUND(AVG(DATEDIFF(DAY, DateStolen, RecoveryDate)), 2) AS AvgRecoveryDays
FROM Stolen_Vehicle_Dataset
WHERE Recovered = 1 AND RecoveryDate IS NOT NULL
GROUP BY Make
ORDER BY AvgRecoveryDays DESC;


Select *
From Stolen_Vehicle_Dataset

-- Key Metrics Summary
