"""
https://datalemur.com/questions/user-retention

This is the same question as problem #23 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint:

An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
"""

/*"""
Approach:

1) Split dataset into 2 frames: 1 for June 2022 and 1 for july 2022.
2) The problem then becomes counting distinct users who appear in both sets.
"""
*/

With june_cte as (
select distinct(user_id) as dj from user_actions where event_date < '2022-07-01' and event_date >= '2022-01-06'
),

july_cte as (
select distinct(user_id) as dji from user_actions where event_date < '2022-08-01' and event_date >= '2022-07-01'
),

combined_cte as (
select count(dj) as monthly_active_users from june_cte where dj in (select * from july_cte)
)

SELECT '7' as month, monthly_active_users FROM combined_cte;