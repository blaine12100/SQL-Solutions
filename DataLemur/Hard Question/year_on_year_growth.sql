/*
For this, I'm thinking of partitioning the data by year and product id. Group by year and produc then sum
Do a lag function for year and product id to see if we have same product sold last year or not

If yes, do subtraction. If not, keep it as null (as spend cannot be calculated then)
*/

with initial_spend as (
select extract(year from transaction_date) as transaction_year, product_id, sum(spend) as product_spend, LAG(sum(spend)) OVER(partition by product_id order by extract(year from transaction_date) asc) as temp_rank from user_transactions group by product_id, extract(year from  transaction_date)
)

select transaction_year as year, product_id, product_spend as curr_year_spend, temp_rank as prev_year_spend, round(((product_spend - temp_rank) / temp_rank) * 100, 2) as yoy_rate from initial_spend