This is the same question as problem #11 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

transactions Table:
Column Name	Type
user_id	integer
spend	decimal
transaction_date	timestamp
transactions Example Input:
user_id	spend	transaction_date
111	100.50	01/08/2022 12:00:00
111	55.00	01/10/2022 12:00:00
121	36.00	01/18/2022 12:00:00
145	24.99	01/26/2022 12:00:00
111	89.60	02/05/2022 12:00:00
Example Output:
user_id	spend	transaction_date
111	89.60	02/05/2022 12:00:00
The dataset you are querying against may have different input & output - this is just an example!

Solution:

/*
Logic

Use partition by to separate records for each user separately. Then, orderby transaction date asc to get transactions
in order. Then use limit 3 to get top 3 and then get the third one for each group. 

The assumption here is that each user will have atleast 3 transactions.

Edit. The top 3 logic won't work here. I need to use the row_number function here to number the rows within the 
partitions per user and then get the 3rd row
*/

With base_cte as (SELECT
    user_id,
    spend,
    transaction_date,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) as rn
    FROM
        TRANSACTIONS
)

select user_id, spend, transaction_date from base_cte where rn = 3