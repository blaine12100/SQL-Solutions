"""
https://datalemur.com/questions/marketing-touch-streak

As a Data Analyst on Snowflake's Marketing Analytics team, your objective is to analyze customer relationship management (CRM) data and identify contacts that satisfy two conditions:

Contacts who had a marketing touch for three or more consecutive weeks.
Contacts who had at least one marketing touch of the type 'trial_request'.
Marketing touches, also known as touch points, represent the interactions or points of contact between a brand and its customers.

Your goal is to generate a list of email addresses for these contacts.
"""

/*
Approach:

First thought is for each contact, get a rank of events order them by the week they happend in

Then, take a lead on them to see if for each contact, do we have events for a trial_reuqest type AND
events happened in those 3 weeks.

If they did, join to the email table to get the email id.
*/

with base_cte as (
select contact_id, event_type, event_date, DATE_TRUNC('week', event_date) as week_date, 
LAG(DATE_TRUNC('week', event_date)) OVER (PARTITION BY contact_id ORDER BY event_date) as lag_rank, 
LEAD(DATE_TRUNC('week', event_date)) OVER (PARTITION BY contact_id ORDER BY event_date) as lead_rank from marketing_touches
),

second_cte as (
 select * from base_cte where (week_date + Interval '7 day' = lead_rank) and (week_date - interval '7 day' = lag_rank)
)

select c.email as email from second_cte as s join crm_contacts as c on s.contact_id = c.contact_id where s.contact_id in (select contact_id from marketing_touches where event_type = 'trial_request')