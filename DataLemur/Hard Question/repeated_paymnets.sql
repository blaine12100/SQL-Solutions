/*
For repeated payments, we need to use a window function for partitioning based on merchant_id, 
credit_card_id, amount  and order them by transaction timestamp. Then I need to implement a 
lag function on a pair of transactions and see if the difference is within 10 mins. If yes, we mark that
transaction as repeated and we use it in our output
*/

with repeated_transactions as (
select merchant_id, credit_card_id, amount, transaction_timestamp, lag(transaction_timestamp, 1) over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp) from transactions
),

lag_time_difference as (
select *, lag - transaction_timestamp from repeated_transactions where lag is not null and EXTRACT(EPOCH FROM (transaction_timestamp - lag)) / 60 <= 10
)

select count((merchant_id, credit_card_id, amount)) as payment_count from lag_time_difference