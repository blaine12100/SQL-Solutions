"""
In an effort to identify high-value customers, Amazon asked for your help to obtain data about users who go on shopping sprees. A shopping spree occurs when a user makes purchases on 3 or more consecutive days.

List the user IDs who have gone on at least 1 shopping spree in ascending order.
"""

-- Use a row_number function to get records in order. Then use 2 lead function.
-- One with the next row and one with 2 ahead. They both need to have a 
-- difference of 1 and 2 respectively for them to be counted in a spree
-- Even for counting, the same user can go on multiple sprees so a DISTINCT
-- count is required as well

with abc as (
select user_id, transaction_date, LEAD(transaction_date, 1) over(PARTITION by user_id order by transaction_date) as first_lead,
lead(transaction_date, 2) over (partition by user_id order by transaction_date) as second_lead from transactions
)

select user_id from abc where first_lead::date - transaction_date::date = 1 and second_lead::date - transaction_date::date = 2 order by user_id