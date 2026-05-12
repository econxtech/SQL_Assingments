DROP TABLE IF EXISTS EMADE_HOSPITAL;

create table EMADE_HOSPITAL 
( emp_id int
, action varchar(10)
, time datetime
);

insert into EMADE_HOSPITAL values ('1', 'in', '2019-12-22 09:00:00');
insert into EMADE_HOSPITAL values ('1', 'out', '2019-12-22 09:15:00');
insert into EMADE_HOSPITAL values ('2', 'in', '2019-12-22 09:00:00');
insert into EMADE_HOSPITAL values ('2', 'out', '2019-12-22 09:15:00');
insert into EMADE_HOSPITAL values ('2', 'in', '2019-12-22 09:30:00');
insert into EMADE_HOSPITAL values ('3', 'out', '2019-12-22 09:00:00');
insert into EMADE_HOSPITAL values ('3', 'in', '2019-12-22 09:15:00');
insert into EMADE_HOSPITAL values ('3', 'out', '2019-12-22 09:30:00');
insert into EMADE_HOSPITAL values ('3', 'in', '2019-12-22 09:45:00');
insert into EMADE_HOSPITAL values ('4', 'in', '2019-12-22 09:45:00');
insert into EMADE_HOSPITAL values ('5', 'out', '2019-12-22 09:40:00');

Select *
From EMADE_HOSPITAL

-- 1: Write a SQL query to find out the number of people present inside the EMADE_HOSPITAL?

WITH last_action AS (
    SELECT 
        emp_id,
        action,
        time,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY time DESC) AS rn
    FROM EMADE_HOSPITAL
)
SELECT COUNT(*) AS People_Inside
FROM last_action
WHERE rn = 1
  AND action = 'in';
