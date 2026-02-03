Use EmadeDev

--ETL SSIS Assignment – 4th Assignment 
--Instructions:Write SQL queries for the following business questions:

--1.	How many encounters did we have before the year 2020?
SELECT COUNT(*) AS encounters_before_2020
FROM encounters
WHERE START < '2020-01-01';

--2.	How many distinct patients did we treat before the year 2020?
SELECT COUNT(DISTINCT PATIENT) AS distinct_patients_before_2020
FROM encounters
WHERE START < '2020-01-01';

--3.	How many distinct encounter classes are documented in the encounter table?
SELECT COUNT(DISTINCT ENCOUNTERCLASS) AS distinct_encounter_classes
FROM encounters;

--4.	How many inpatient and ambulatory encounters did we have before 2020?
SELECT ENCOUNTERCLASS, COUNT(ENCOUNTERCLASS) AS encounter_count
FROM encounters
WHERE START < '2020-01-01'
AND ENCOUNTERCLASS IN ('inpatient', 'ambulatory')
GROUP BY ENCOUNTERCLASS;

--5.	What is our patient mix by gender, race and ethnicity?
SELECT gender, race, ethnicity, COUNT(*) AS patient_mix
FROM [dbo].[Flu_Demo_Data]
GROUP BY gender, race, ethnicity
ORDER BY patient_mix DESC;

--6.	How many states and zip codes do we treat patients from?
SELECT COUNT(DISTINCT org_state) AS total_states, COUNT(DISTINCT org_zip) AS total_zips
FROM [dbo].[Healthcare_Demo_Data]

--7.	Which county had the highest number of patients?
SELECT TOP 1 COUNTY, COUNT(*) AS Patient_Count
FROM [dbo].[Flu_shot_2019_Sheet1]
WHERE COUNTY IS NOT NULL
GROUP BY COUNTY
ORDER BY Patient_Count DESC;

--8.	What is our patient mix for patients who had an inpatient encounter in 2019?
SELECT p.race, p.AGE, p.gender, COUNT(DISTINCT p.id) AS patient_count
FROM [dbo].[Flu_shot_2019_Sheet1] p
JOIN encounters e ON p.id = e.patient
WHERE e.encounterclass = 'inpatient' AND YEAR(e.START) = 2019
GROUP BY p.race, p.AGE, p.gender;

SELECT p.race, p.AGE, p.gender, COUNT(DISTINCT p.id) AS patient_count
FROM [dbo].[Flu_shot_2019_Sheet1] p
JOIN encounters e ON p.id = e.patient
WHERE e.encounterclass = 'inpatient' 
  AND e.start BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY p.race, p.AGE, p.gender;

--9.	How many inpatient encounters did we have in the entire dataset where 
--the patient was at least 21 years old at the time of the encounter start?
SELECT COUNT(*) AS InpatientCount
FROM encounters e
JOIN [dbo].[Flu_shot_2019_Sheet1] p ON e.PATIENT = p.PATIENT
WHERE e.ENCOUNTERCLASS = 'Inpatient' 
AND DATEDIFF(YEAR, p.BIRTHDATE, e.START) >= 21;

--10.	How many emergency encounters did we have in 2019? 
SELECT COUNT(*) AS EmergencyEncounterCount2019
FROM encounters
WHERE ENCOUNTERCLASS = 'Emergency' AND YEAR(START) = 2019;

SELECT COUNT(*) AS er_encounters_2019
FROM encounters
WHERE encounterclass = 'emergency' 
  AND start BETWEEN '2019-01-01' AND '2019-12-31';

--11.	What conditions were treated in those encounters?
SELECT DISTINCT c.description, C.START, C.STOP, e.description, e.BASE_ENCOUNTER_COST
FROM conditions c
JOIN encounters e ON c.encounter = e.id
WHERE e.encounterclass = 'emergency' 
  AND e.start BETWEEN '2019-01-01' AND '2019-12-31';

SELECT DESCRIPTION, COUNT(*) AS ConditionCount
FROM encounters
WHERE ENCOUNTERCLASS = 'Emergency' AND YEAR(START) = 2019
GROUP BY DESCRIPTION;

--12.	What was the emergency throughput and how did that vary by condition treated?
SELECT c.DESCRIPTION AS Condition,
       COUNT(*) AS Encounter_Count,
       AVG(DATEDIFF(MINUTE, e.START, e.STOP)) AS Avg_Throughput_Minutes
FROM encounters e
INNER JOIN conditions c ON e.Id = c.ENCOUNTER
WHERE e.ENCOUNTERCLASS = 'emergency'
  AND e.START >= '2019-01-01' AND e.START < '2020-01-01'
GROUP BY c.DESCRIPTION
ORDER BY Avg_Throughput_Minutes DESC;

--13.	How many emergency encounters did we have before 2020?
SELECT COUNT(*) AS EmergencyCount
FROM encounters
WHERE ENCOUNTERCLASS = 'Emergency' AND YEAR(START) < 2020;

--14.	Other than nulls (where no condition was documented), which condition was most 
--documented for emergency encounters before 2020?
SELECT Top 1 c.description, COUNT(*) AS frequency
FROM conditions c
JOIN encounters e ON c.encounter = e.id
WHERE e.encounterclass = 'emergency' 
  AND e.start < '2020-01-01'
  AND c.description IS NOT NULL
GROUP BY c.description
ORDER BY frequency DESC;

--15.	How many conditions for emergency encounters before 2020 had 
--average ER throughputs above 100 minutes? 

SELECT COUNT(*) AS Conditions_Above_100min
FROM (
    SELECT c.DESCRIPTION
    FROM encounters e
    INNER JOIN conditions c ON e.Id = c.ENCOUNTER
    WHERE e.ENCOUNTERCLASS = 'emergency'
      AND e.START < '2020-01-01'
    GROUP BY c.DESCRIPTION
    HAVING AVG(DATEDIFF(MINUTE, e.START, e.STOP)) > 100
) AS High_Throughput_Conditions;

--16.	What is total claim cost for each encounter in 2019?
SELECT Id AS Encounter_Id, TOTAL_CLAIM_COST, [DESCRIPTION],[START]
FROM encounters
WHERE start BETWEEN '2019-01-01' AND '2019-12-31'
ORDER BY TOTAL_CLAIM_COST DESC;

--17.	What is total payer coverage for each encounter in 2019?
SELECT Id AS Encounter_Id, payer_coverage, [DESCRIPTION],[START]
FROM encounters
WHERE start BETWEEN '2019-01-01' AND '2019-12-31'
ORDER BY PAYER_COVERAGE DESC;

--18.	Which encounter types had the highest cost?
SELECT ENCOUNTERCLASS, 
SUM(CAST(TOTAL_CLAIM_COST AS DECIMAL(18,2))) AS Total_Cost
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY Total_Cost DESC;

--19.	Which encounter types had the highest cost covered by payers?
SELECT ENCOUNTERCLASS, 
SUM(CAST(PAYER_COVERAGE AS DECIMAL(18,2))) AS Total_Payer_Coverage
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY Total_Payer_Coverage DESC;

--20.	Which payer had the highest claim coverage percentage 
--(total payer coverage/ total claim cost) for encounters before 2020?

SELECT TOP 1 payer,
    AVG(
        CAST(payer_coverage AS DECIMAL(18,2)) 
        / 
        CAST(total_claim_cost AS DECIMAL(18,2))
    ) * 100 AS coverage_pct
FROM encounters
WHERE start < '2020-01-01'
  AND TRY_CAST(total_claim_cost AS DECIMAL(18,2)) > 0
GROUP BY payer
ORDER BY coverage_pct DESC;

--21.	Which payer had the highest claim coverage percentage 
--(total payer coverage / total claim cost) for ambulatory encounters before 2020?
SELECT TOP 1 payer, 
        AVG(
            CAST(payer_coverage AS DECIMAL(18,2)) 
            / 
            CAST(total_claim_cost AS DECIMAL(18,2))
          ) * 100 AS coverage_pct
FROM encounters
WHERE encounterclass = 'ambulatory' AND start < '2020-01-01' 
AND CAST(total_claim_cost AS DECIMAL(18,2)) > 0
GROUP BY payer
ORDER BY coverage_pct DESC;

--22.	How many different types of procedures did we perform in 2019?
SELECT COUNT(DISTINCT [DESCRIPTION]) AS different_procedure_types_2019
FROM conditions
WHERE START >= '2019-01-01' 
    AND START < '2020-01-01';

--23.	How many procedures were performed across each care setting (inpatient/ambulatory)?
SELECT e.ENCOUNTERCLASS AS Care_Setting, COUNT(c.code) AS Procedure_Count
FROM conditions c
JOIN encounters e ON c.ENCOUNTER = e.Id
WHERE e.ENCOUNTERCLASS IN ('inpatient', 'ambulatory')
GROUP BY e.ENCOUNTERCLASS;

--24.	Which organizations performed the most inpatient procedures in 2019?
SELECT ORGANIZATION,
COUNT(*) AS procedure_count
FROM encounters WHERE ENCOUNTERCLASS = 'inpatient'
AND START BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY ORGANIZATION
ORDER BY procedure_count DESC;

--25.	How many Colonoscopy procedures were performed before 2020?
-- Colonoscopy Reference N/A IN DATESET CHECKED ALL TABLES USING 

SELECT [DESCRIPTION], COUNT([DESCRIPTION]) AS ProceduresReason
FROM [dbo].[encounters]
GROUP BY [DESCRIPTION]

--26.	Compare our total number of procedures in 2018 to 2019. Did we perform more procedures in 2019 or less?
SELECT 
    SUM(CASE WHEN YEAR(CAST(START AS DATE)) = 2018 THEN 1 ELSE 0 END) AS procedures_2018,
    SUM(CASE WHEN YEAR(CAST(START AS DATE)) = 2019 THEN 1 ELSE 0 END) AS procedures_2019,
    CASE 
        WHEN SUM(CASE WHEN YEAR(CAST(START AS DATE)) = 2019 THEN 1 ELSE 0 END) > 
             SUM(CASE WHEN YEAR(CAST(START AS DATE)) = 2018 THEN 1 ELSE 0 END) 
        THEN 'INCREASE' 
        ELSE 'DECREASE' 
    END AS comparison_result
FROM conditions
WHERE YEAR(CAST(START AS DATE)) IN (2018, 2019);


--27.	Which organizations performed the most Auscultation of the fetal heart procedures before 2020? Give answer with Organization ID.
--Auscultation Reference N/A IN DATESET CHECKED ALL TABLES USING 
SELECT [REASONDESCRIPTION], COUNT([REASONDESCRIPTION]) AS ProceduresReason
FROM [dbo].[careplans]
GROUP BY [REASONDESCRIPTION]

--28.	Which race had the highest number of procedures done in 2019?
SELECT TOP 1 p.RACE, COUNT(DISTINCT P.PATIENT) AS Procedure_Count
FROM [dbo].[encounters] pr
INNER JOIN [dbo].[Flu_shot_2019_Sheet1] p ON pr.PATIENT = p.Id
WHERE pr.START >= '2019-01-01' AND pr.START < '2020-01-01'
GROUP BY p.RACE
ORDER BY Procedure_Count DESC;


--29.	Which race had the highest number of Colonoscopy procedures performed before 2020?
-- Colonoscopy Reference N/A IN DATESET CHECKED ALL TABLES USING 

SELECT [DESCRIPTION], COUNT([DESCRIPTION]) AS ProceduresReason
FROM [dbo].[encounters]
GROUP BY [DESCRIPTION]

--30.	How many patients had documented uncontrolled hypertension at any time in 
--2018 and 2019? (140/90 is cutoff)
SELECT F.[REASONDESCRIPTION], COUNT(DISTINCT F.[PATIENT]) AS Patient_Count
FROM [dbo].[careplans] f
JOIN encounters e ON f.patient = e.PATIENT
WHERE F.[REASONDESCRIPTION] = 'Hypertension'
AND e.START BETWEEN '2018-01-01' AND '2019-12-31'
GROUP BY F.[REASONDESCRIPTION];

SELECT F.[REASONDESCRIPTION], COUNT(DISTINCT F.[PATIENT]) AS Patient_Count
FROM [dbo].[medications] f
WHERE F.[REASONDESCRIPTION] = 'Hypertension'
AND F.START BETWEEN '2018-01-01' AND '2019-12-31'
GROUP BY F.[REASONDESCRIPTION];

--31.	Which providers treated patients with uncontrolled hypertension in 2018 and 2019?
--/**Logic: 
--i.	In the table: [observations], use the fields: DESCRIPTION and VALUE
--ii.	Build a data flow logic to show:
--iii.	Diastolic Blood Pressure would be value not up to 90
--iv.	Systolic Blood Pressure  would be value more than up 140
--**/


--32.	What medications were given to patients with uncontrolled hypertension?

SELECT [DESCRIPTION], [REASONDESCRIPTION], COUNT(DISTINCT [REASONDESCRIPTION]) AS Patient_Count
FROM [dbo].[medications] f
WHERE F.[REASONDESCRIPTION] = 'Hypertension'
GROUP BY [DESCRIPTION],[REASONDESCRIPTION];

--33.	What was the most commonly prescribed medication to the patients with hypertension (as identified as having a BP over 140/90 at any point in 2018 or 2019)?
SELECT TOP 1 [DESCRIPTION], [REASONDESCRIPTION],
COUNT(DISTINCT [PATIENT]) AS Patient_Count
FROM [dbo].[medications] f
WHERE [REASONDESCRIPTION] = 'Hypertension'
AND START BETWEEN '2018-01-01' AND '2019-12-31'
GROUP BY [DESCRIPTION],[REASONDESCRIPTION];

--34.	Which race had the highest total number of patients with a BP of 140/90 before 2020?
SELECT TOP 1 p.RACE, COUNT(DISTINCT P.PATIENT) AS Patients_Count
FROM [dbo].[encounters] pr
INNER JOIN [dbo].[Flu_shot_2019_Sheet1] p ON pr.PATIENT = p.Id
WHERE pr.START >= '2019-01-01' AND pr.START < '2020-01-01'
GROUP BY p.RACE
ORDER BY Patients_Count DESC;

SELECT TOP 1 p.[enc_type], p.RACE, COUNT(DISTINCT P.patient_id) AS Patients_Count
FROM [dbo].[Healthcare_Demo_Data] p 
WHERE p.START >= '2020-01-01' and p.[enc_type] = 'Check-up'
GROUP BY p.[enc_type], p.RACE
ORDER BY Patients_Count DESC;

--35.	Which race had the highest percentage of blood pressure readings that were above 140/90 and taken before 2020?
--Blood pressure readings Reference N/A IN DATESET CHECKED ALL TABLES


--2. Upload your (sql) files to your GitHub.
--Deliverables:
--- Screenshot of queries/your solutions via google classroom

--Due Date: 2/3/2026