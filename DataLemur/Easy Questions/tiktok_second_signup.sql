"""
Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.

Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

https://datalemur.com/questions/second-day-confirmation

Actual Solution:

SELECT DISTINCT user_id
FROM emails 
INNER JOIN texts
  ON emails.email_id = texts.email_id
WHERE texts.action_date = emails.signup_date + INTERVAL '1 day'
  AND texts.signup_action = 'Confirmed';

Note: I wasn't aware that we could do date + time interval like in timedelta
"""

With abc as 
(
SELECT emails.user_id, texts.email_id, texts.signup_action, ROW_NUMBER() OVER(PARTITION by emails.email_id order by action_date  asc) as rank_order from emails left join texts on emails.email_id = texts.email_id
)

select user_id from abc where rank_order = 2 and signup_action = 'Confirmed'