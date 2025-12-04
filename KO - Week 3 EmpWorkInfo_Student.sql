use EmadeDev

drop table if exists EmpWorkInfo
create table EmpWorkInfo
(
id int not null, 
Name varchar(50), 
Position varchar(50) null, 
SocialSecurity int not null, 
DistanceFromHome varchar(50), 
Department varchar(50)
) 

insert into EmpWorkInfo
(id,Name,Position,SocialSecurity,DistanceFromHome,Department)
 values
(1,'Usama','Junior Engineer',222222222,20,'Marketing'),
(2,'Safwan','Junior Engineer',333333333,8,'Finance'),
(3,'Gulraiz','Senior Engineer',444444444,15,'Finance'),
(4,'Ayesha','Intern',888888888,32,'Technical'),
(5,'Anas','Intern',987654321,25,'Marketing'),
(6,'Areeha','Junior Engineer',444444444,6,'Finance'),
(7,'Raza', 'Senior Engineer',123456789,23,'Technical'),
(8,'Eeman','Senior Engineer',080808080,53,'Technical'),
(9,'Faseeh', 'Senior Engineer',343434343,36,'Finance'),
(10,'Hassan','Junior Engineer',565665656,20,'Marketing')

SELECT *
FROM EmpWorkInfo;

--1 EMPLOYEES HAVING 0-10 , MILES FROM HOME SHOULD BE CATEGORIZED AS POOR, 20 AND BELOW AS GOOD,  BELOW 30 THEN BETTER, ELSE BEST
SELECT
id,
[Name], 
Position, 
SocialSecurity,  
DistanceFromHome, 
Department,
CASE 
    WHEN DistanceFromHome BETWEEN 0 AND 10 THEN 'POOR' 
    WHEN DistanceFromHome BETWEEN 11 AND 20 THEN 'GOOD' 
    WHEN DistanceFromHome BETWEEN 21 AND 29 THEN 'BETTER' 
    Else 'BEST' 
    END AS DistanceCategory
FROM EmpWorkInfo


--2 Show records having position for all the Senior Engineer
SELECT *
FROM EmpWorkInfo
WHERE Position = 'Senior Engineer'


--3 Write a query to show the people in the technical department
SELECT *
FROM EmpWorkInfo
WHERE Department = 'Technical'


--4 Write a query to show the highest distanceFromHome. 
SELECT *
FROM EmpWorkInfo
WHERE DistanceFromHome = (Select Max(DistanceFromHome) From EmpWorkInfo)

--Note: Please include all the fields like ID, Name, Position, SocialSecurity, distanceFromHome, Department
--5 Write a query to show the highest distanceFromHome. 
SELECT *
FROM EmpWorkInfo
WHERE DistanceFromHome = (Select Max(DistanceFromHome) From EmpWorkInfo)

--Note: Please include all the fields like ID, Name, Position, SocialSecurity, distanceFromHome, Department