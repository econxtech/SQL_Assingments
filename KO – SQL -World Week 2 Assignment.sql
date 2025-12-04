--Assignment 1 -  Week 2: World
use EmadeDev

 
--create table named World
DROP TABLE IF EXISTS World
CREATE TABLE World
(
CountryName varchar (50) null,
Continent varchar (50) null,
Area int  not null,
"Population" int not null,
Gdp bigint not null
)

--insert values to the Worlds table
INSERT INTO World
(
CountryName,
Continent,
Area,
"Population",
Gdp
)
VALUES
('Afghanistan', 'Asia', 652230, 25500100, 20343000000),
('Albania', 'Europe', 28748, 2831741, 12960000000),
('Algeria', 'Africa', 2381741, 37100000, 188681000000),
('Andorra', 'Europe', 468, 78115, 3712000000),
('Angola', 'Africa', 1246700, 20609294, 100990000000)

--display the Worlds table
SELECT *
FROM World

--Write SQL Queries to answer the questions below:
--1: Show the area of 468
SELECT * 
FROM World 
WHERE Area = 468

--2: Show the county name of Angola
SELECT * 
FROM World 
WHERE CountryName = 'Angola'

--3: Show the country with the lowest Gdp 
SELECT * 
FROM World 
WHERE Gdp = (SELECT MIN(Gdp) FROM World)

--4: Create a view named vwlowGdpCountries to only include record with the lowest GDP
CREATE VIEW vwlowGdpCountries AS
SELECT * 
FROM World 
WHERE Gdp = (SELECT MIN(Gdp) FROM World)

--5: Create a view named vwOldGames to only include records showing year before 2008
-- NULL

--6: Check the view vwlowGdpCountries
SELECT *
FROM vwlowGdpCountries

--7: Show the number of records in the world table
SELECT COUNT(*) AS TotalRecords 
FROM World

--8: Write a query which result to exclude Continents of Asia and Africa 
SELECT * 
FROM World 
WHERE Continent NOT IN ('Asia', 'Africa');