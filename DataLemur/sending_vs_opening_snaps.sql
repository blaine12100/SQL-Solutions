This is the same question as problem #25 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Notes:

Calculate the following percentages:
time spent sending / (Time spent sending + Time spent opening)
Time spent opening / (Time spent sending + Time spent opening)
To avoid integer division in percentages, multiply by 100.0 and not 100.
Effective April 15th, 2023, the solution has been updated and optimised.

activities Table
Column Name	Type
activity_id	integer
user_id	integer
activity_type	string ('send', 'open', 'chat')
time_spent	float
activity_date	datetime
activities Example Input
activity_id	user_id	activity_type	time_spent	activity_date
7274	123	open	4.50	06/22/2022 12:00:00
2425	123	send	3.50	06/22/2022 12:00:00
1413	456	send	5.67	06/23/2022 12:00:00
1414	789	chat	11.00	06/25/2022 12:00:00
2536	456	open	3.00	06/25/2022 12:00:00
age_breakdown Table
Column Name	Type
user_id	integer
age_bucket	string ('21-25', '26-30', '31-25')
age_breakdown Example Input
user_id	age_bucket
123	31-35
456	26-30
789	21-25
Example Output
age_bucket	send_perc	open_perc
26-30	65.40	34.60
31-35	43.75	56.25
Explanation
Using the age bucket 26-30 as example, the time spent sending snaps was 5.67 and the time spent opening snaps was 3.

To calculate the percentage of time spent sending snaps, we divide the time spent sending snaps by the total time spent on sending and opening snaps, which is 5.67 + 3 = 8.67.

So, the percentage of time spent sending snaps is 5.67 / (5.67 + 3) = 65.4%, and the percentage of time spent opening snaps is 3 / (5.67 + 3) = 34.6%.

Solution:

-- SELECT * FROM activities LIMIT 5;
-- Check if any user does not have a age bracket

-- select a.user_id from activities as a left join age_breakdown as ab on a.user_id = ab.user_id where ab.user_id is null
-- All user have a valid age bracket here. So an inner join would work

-- Table to get user and it's age bracket

With base_cte as (select a.activity_type, a.time_spent, ab.age_bucket from activities as a join age_breakdown as ab on a.user_id = ab.user_id where a.activity_type != 'chat')

-- Calculate sum based on case
select age_bucket, round((sum(case when activity_type = 'open' then time_spent else 0 end) / sum(time_spent)) * 100.0, 2) as open_perc, round((sum(case when activity_type = 'send' then time_spent else 0 end) / sum(time_spent)) * 100.0, 2) as send_perc from base_cte group by age_bucket
