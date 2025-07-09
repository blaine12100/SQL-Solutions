/*
For each user, first we need to get their most recent transaction date. This can be done using a 
CTE with window functions (row_number) 

Then, for these users, I need to perform a groupby based on transaction date and user_id
*/

--/*

with recent_date as (
select transaction_date, user_id, row_number() over(partition by user_id order by transaction_date desc) as temp_rank
from user_transactions
),

top_transaction_date as(
select transaction_date, user_id from recent_date where temp_rank = 1
)

select t.transaction_date, t.user_id, count(*) as purchase_count from top_transaction_date as t left join user_transactions as u on t.transaction_date = u.transaction_date and t.user_id = u.user_id
group by t.transaction_date, t.user_id
--*/

--*/
-- Query to check output

--select transaction_date, user_id, count(*) from user_transactions where user_id = 159 and transaction_date = '07/12/2022 10:00:00' group by transaction_date, user_id
