use EmadeDev

drop table if exists Business
--Create table Business
create table Business
(
ID int not null,
[NAME] varchar (50) null,
AGE int not null,
[ADDRESS] varchar (50) null,
SALARY int not null
)

--Load data
insert into Business
(
ID,
[NAME],
AGE,
[ADDRESS],
SALARY
)

values
(1, 'Ramesh', 32, 'Ahmedabad', 2000),
(2, 'Khilan', 25, 'Delhi', 1500),
(3, 'Kaushik', 23, 'Kota', 2000),
(4, 'Chaitali', 25, 'Mumbai', 6500),
(5, 'Hardik', 27, 'Bhopal', 8500),
(6, 'Komal', 22, 'MP', 4500),
(7, 'Muffy', 24, 'Indore', 10000)

 --display business table
select *
from Business

/**1 
if customer age > or = 25 then Senior Developer
if customer age < 25 then Intern
if customer age > and = 25 but also < and = 27 then Associate Engineer
Name field as JobPosition
**/

SELECT
ID,
[NAME],
AGE,
[ADDRESS],
SALARY,
CASE 
    WHEN AGE >= 25 AND AGE <= 27 THEN 'Associate Engineer'  -- More specific condition first
    WHEN AGE >= 25 THEN 'Senior Developer'                   -- This will catch ages 28+
    WHEN AGE < 25 THEN 'Intern'
    END AS JobPosition
FROM Business

/**2 
If customer age is more than 30 then Gen X
If customer age is 23,24,25 then Gen Z
If customer age is 22 then Gen Alpha
If customer age is 27 then Gen Y
name field as Generation
**/

SELECT
ID,
[NAME],
AGE,
[ADDRESS],
SALARY,
CASE 
    WHEN AGE > 30 THEN 'Gen X' 
    WHEN AGE IN (23, 24, 25) THEN 'Gen Z' 
    WHEN AGE = 22 THEN 'Gen Alpha' 
    WHEN AGE = 27 THEN 'Gen Y' 
    END AS Generation
FROM Business