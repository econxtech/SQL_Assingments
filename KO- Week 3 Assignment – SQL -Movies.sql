
--Week 3 Assignment – SQL -Movies
use EmadeDev

drop table if exists Movies
create table Movies
([No] int not null,
[Name] varchar (50) null,
[Type] varchar (50) null,
Rating varchar (5) null,
Stars varchar (50) null,
Qty int not null, 
Price dec(10, 2) not null)

insert into Movies
([No],[Name],[Type],Rating,Stars,Qty,Price)
values
(1,'Gone With Wind','Drama','G','Gable',4,39.95),
(2,'Friday the 13th','Horror','R','Jason',2,60.95),
(3,'Top Gun','Drama','PG','Cruise',7,49.95),
(4,'Splash','Comedy','PG13','Hanks',3,29.95),
(5,'Independent Day','Drama','R','Turner',3,19.95),
(6,'Risk Business','Comedy','R','Cruise',2,44.95),
(7,'Cocoon','Sci-fi','PG','Ameche',2,31.95),
(8,'Crocodile','Comedy','PG13','Harris',2,69.95),
(9,'101 Dalmatians','Comedy','G','Hoffman',3,59.95),
(10,'Tootsie','Comedy','PG','Croft',1,29.95)

SELECT *
FROM Movies

--1 Find the total number of records available in the type which is Drama

SELECT COUNT(*) AS TotalDramaMovies
FROM Movies
WHERE [Type] = 'Drama';
--2 Display a list of all movies with price over 20 and sorted by price

SELECT *
FROM Movies
WHERE Price > 20
ORDER BY Price ASC;

--3 Display all the movies sorted by QTY in decreasing order

SELECT *
FROM Movies
ORDER BY Qty DESC;

--4 Display a report listing total by movie type, current value, and replacement value for each movie type. 

SELECT 
    [Type],
    COUNT(*) AS TotalMovies,
    SUM(Qty * Price) AS CurrentValue,
    SUM(Qty * Price * 1.15) AS ReplacementValue
FROM Movies
GROUP BY [Type];

--5 Calculate the replacement value for all movies as QTY*Price*1.15

SELECT 
    *,
    (Qty * Price * 1.15) AS ReplacementValue
FROM Movies;

--6 Count the number of movies where rating is not "G". 

SELECT COUNT(*) AS NonGMoviesCount
FROM Movies
WHERE Rating != 'G';


--7 Insert a new movie in the table and make it Name:Nollywood, Type should be SuperStory, Ratings as R, Stars as Regina, Qty as 10 in Movie table were price > 30
INSERT INTO Movies ([No], [Name], [Type], Rating, Stars, Qty, Price)
SELECT MAX([No]) + 1, 'Nollywood', 'SuperStory', 'R', 'Regina', 10, MAX(Price) + 1
FROM Movies


SELECT *
FROM Movies;

