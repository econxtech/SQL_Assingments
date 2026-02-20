USE EmadeDev;

Select *
From [dbo].[EMADE_PLANS]

Select *
From [dbo].[EMADE_SUBSCRIPTIONS]

--1:How many customers has EMADE_SUBSCRIPTIONS ever had?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM EMADE_SUBSCRIPTIONS;

--2: What is the monthly distribution of trial plan start_date values for our dataset?

SELECT
YEAR(start_date) AS trial_year,
MONTH(start_date) AS trial_month,
COUNT(*) AS trial_signups
FROM EMADE_SUBSCRIPTIONS
WHERE plan_id = 0 
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY trial_year, trial_month;

--3: What plan start_date values occur after the year 2020 for our dataset?

SELECT
s.customer_id,
p.plan_name,
s.start_date
FROM EMADE_SUBSCRIPTIONS s
JOIN EMADE_PLANS p ON p.plan_id = s.plan_id
WHERE YEAR(s.start_date) > 2020
ORDER BY s.start_date, s.customer_id;

--4: What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

SELECT
SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END) AS churned_customers,
COUNT(DISTINCT customer_id) AS total_customers,
ROUND(
100.0 * SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END)
/ COUNT(DISTINCT customer_id),
1
) AS churn_pct
FROM EMADE_SUBSCRIPTIONS;


--5: How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

WITH customer_plans AS (
SELECT
customer_id,
plan_id,
LEAD(plan_id) OVER (
PARTITION BY customer_id
ORDER BY start_date
) AS next_plan_id
FROM EMADE_SUBSCRIPTIONS
)
SELECT
COUNT(*) AS immediate_churners,
ROUND(
100.0 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM EMADE_SUBSCRIPTIONS),
0
) AS pct_of_total
FROM customer_plans
WHERE plan_id = 0 
AND next_plan_id = 4; 


--6: What is the number and percentage of customer EMADE_PLANS after their initial free trial?

WITH post_trial AS (
    SELECT 
        customer_id, 
        plan_id,
        LEAD(plan_id) OVER (
            PARTITION BY customer_id 
            ORDER BY start_date
        ) AS next_plan_id
    FROM EMADE_SUBSCRIPTIONS
    WHERE plan_id = 0 
)
SELECT 
    p.plan_name,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 
        1
    ) AS pct
FROM post_trial pt
JOIN EMADE_PLANS p ON p.plan_id = pt.next_plan_id
GROUP BY p.plan_name;

--7: What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31

WITH ranked AS (
    SELECT
        customer_id,
        plan_id,
        start_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY start_date DESC
        ) AS rn
    FROM EMADE_SUBSCRIPTIONS
    WHERE start_date <= '2020-12-31' -- Changed from &lt;= to <=
)
SELECT
    p.plan_name,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        1
    ) AS pct
FROM ranked r
JOIN EMADE_PLANS p ON p.plan_id = r.plan_id
WHERE r.rn = 1
GROUP BY p.plan_name, r.plan_id
ORDER BY r.plan_id;

--8: How many customers have upgraded to an annual plan in 2020?

SELECT COUNT(DISTINCT customer_id) AS annual_upgrades_2020
FROM EMADE_SUBSCRIPTIONS
WHERE plan_id = 3 
AND YEAR(start_date) = 2020;

--9: How many days on average does it take for a customer to upgrade to an annual plan from the day they join EMADE_SUBSCRIPTIONS?

WITH trial_dates AS (
SELECT customer_id, start_date AS trial_start
FROM EMADE_SUBSCRIPTIONS
WHERE plan_id = 0
),
annual_dates AS (
SELECT customer_id, start_date AS annual_start
FROM EMADE_SUBSCRIPTIONS

WHERE plan_id = 3
)
SELECT
COUNT(*) AS customers_upgraded,
AVG(DATEDIFF(day, t.trial_start, a.annual_start)) AS avg_days_to_annual
FROM trial_dates t
JOIN annual_dates a ON a.customer_id = t.customer_id;

--10: Can you further breakdown this average value into 30 day periods as below:
/**
0-30 days, 31-60 days, 91-120 days, 121-150 days
,151-180 days, 181-210 days, 211-240 days, 241-270 days, 
271-300 days, 301-330 days 311-360 days. 
Show these period as a derived column: upgrade_category)?
**/

WITH trial_dates AS (
    SELECT customer_id, start_date AS trial_start
    FROM [dbo].[EMADE_SUBSCRIPTIONS] WHERE plan_id = 0
),
annual_dates AS (
    SELECT customer_id, start_date AS annual_start
    FROM [dbo].[EMADE_SUBSCRIPTIONS] WHERE plan_id = 3
),
days_calc AS (
    SELECT
        t.customer_id,
        DATEDIFF(day, t.trial_start, a.annual_start) AS days_to_upgrade
    FROM trial_dates t 
    JOIN annual_dates a ON a.customer_id = t.customer_id
)
SELECT
    CASE
        WHEN days_to_upgrade <= 30 THEN '0-30 days'
        WHEN days_to_upgrade <= 60 THEN '31-60 days'
        WHEN days_to_upgrade <= 90 THEN '61-90 days'
        WHEN days_to_upgrade <= 120 THEN '91-120 days'
        WHEN days_to_upgrade <= 150 THEN '121-150 days'
        WHEN days_to_upgrade <= 180 THEN '151-180 days'
        WHEN days_to_upgrade <= 210 THEN '181-210 days'
        WHEN days_to_upgrade <= 240 THEN '211-240 days'
        WHEN days_to_upgrade <= 270 THEN '241-270 days'
        WHEN days_to_upgrade <= 300 THEN '271-300 days'
        WHEN days_to_upgrade <= 330 THEN '301-330 days'
        ELSE '331-360 days'
    END AS upgrade_category,
    COUNT(*) AS customer_count
FROM days_calc
GROUP BY 
    CASE
        WHEN days_to_upgrade <= 30 THEN '0-30 days'
        WHEN days_to_upgrade <= 60 THEN '31-60 days'
        WHEN days_to_upgrade <= 90 THEN '61-90 days'
        WHEN days_to_upgrade <= 120 THEN '91-120 days'
        WHEN days_to_upgrade <= 150 THEN '121-150 days'
        WHEN days_to_upgrade <= 180 THEN '151-180 days'
        WHEN days_to_upgrade <= 210 THEN '181-210 days'
        WHEN days_to_upgrade <= 240 THEN '211-240 days'
        WHEN days_to_upgrade <= 270 THEN '241-270 days'
        WHEN days_to_upgrade <= 300 THEN '271-300 days'
        WHEN days_to_upgrade <= 330 THEN '301-330 days'
        ELSE '331-360 days'
    END
ORDER BY MIN(days_to_upgrade);



--11: How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH plan_transitions AS (
SELECT
customer_id,
plan_id,
start_date,
LEAD(plan_id) OVER (
PARTITION BY customer_id
ORDER BY start_date
) AS next_plan_id,
LEAD(start_date) OVER (
PARTITION BY customer_id
ORDER BY start_date
) AS next_start_date
FROM EMADE_SUBSCRIPTIONS
)
SELECT COUNT(*) AS downgrades_2020
FROM plan_transitions
WHERE plan_id = 2
AND next_plan_id = 1 
AND YEAR(next_start_date) = 2020; 