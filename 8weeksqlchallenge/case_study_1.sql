/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
/*SELECT
  	product_id,
    product_name,
    price
FROM dannys_diner.menu
ORDER BY price DESC
LIMIT 5;
*/

-- Q1 Total amount each customer spent
/*
For this, we need to do a join on the menu table to get the pricers per item, then, group by customer
and do a sum of the price to get the amount each customer spent
*/

/*select customer_id, sum(menu.price) from sales join menu on sales.product_id = menu.product_id group by customer_id
*/

-- Q2 

/*
For this, we need to group by customer in sales and get a count of the distinct order dates per customer
*/

/*
select customer_id, count(distinct(order_date)) from sales group by customer_id
*/

-- Q3

/*
For this, we need to partition by customer, order by date asc and get the first record
*/

/*with numbered_data as (
  select customer_id, ROW_NUMBER() over (partition by customer_id order by order_date asc), product_id from sales
 )
 
 select customer_id, product_id from numbered_data where row_number = 1 
 */
 
 --Q4
 
 /*
 For this, we need to group by product_id in sales and order by the count to get the most popular item. Join this on the menu table to get the name of the item as well
 */
 
 /*select sales.product_id, count(sales.product_id), menu.product_name from sales join menu on sales.product_id = menu.product_id group by sales.product_id, menu.product_name order by count(*) desc limit 1
 */
 
 --Q5
 /*
 In this, we need to find the top purchased item for each customer. We will need to partition by customer, do a count and then rank by count and get the first rank
 
 I was trying to do both at the same time and I was getting the wrong asnwer
 */
 
/*WITH product_counts AS (
    SELECT
        customer_id,
        product_id,
        COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id, product_id
),
ranked_products AS (
    SELECT
        customer_id,
        product_id,
        purchase_count,
        RANK() OVER (PARTITION BY customer_id ORDER BY purchase_count DESC) AS rank_num
    FROM product_counts
)
SELECT
    customer_id,
    product_id,
    purchase_count
FROM ranked_products
WHERE rank_num = 1;
*/

-- Q6

/*
For this, I need to get the customers join date and then filter records after the join date. Then, I need to order by join date in asc order and get the first rank. CTE and partition approach
*/

/*With base_cte as (select sales.customer_id, sales.product_id, sales.order_date from sales join members on sales.customer_id = members.customer_id where members.join_date > sales.order_date
),

second_cte as (select customer_id, product_id, DENSE_RANK() over(partition by customer_id order by order_date) as dr from base_cte 
)

select sc.customer_id, sc.product_id, menu.product_name from second_cte as sc join menu on sc.product_id = menu.product_id where dr = 1 order by customer_id
*/

--Q7

/*
Same as above, only the rank doesn't need to be used but calculated
*/


/*With base_cte as (select sales.customer_id, sales.product_id, sales.order_date from sales join members on sales.customer_id = members.customer_id where sales.order_date < members.join_date
),

second_cte as (select customer_id, product_id, order_date, ROW_NUMBER() over(partition by customer_id order by order_date) as rn from base_cte 
)

select sc.customer_id, sc.order_date, menu.product_name from second_cte as sc join menu on sc.product_id = menu.product_id order by customer_id
*/

--Q8

/*With base_cte as (select sales.customer_id, sales.product_id, count(sales.product_id), count(sales.product_id) * menu.price as amount from sales join members on sales.customer_id = members.customer_id join menu on sales.product_id = menu.product_id where sales.order_date < members.join_date group by sales.customer_id, sales.product_id, menu.price
)

select customer_id, count(*), sum(amount) as fa from base_cte group by customer_id
*/        

--Q9
/*
Use Q1 output and tweak it
select customer_id, sum(case when menu.product_name = 'sushi' then menu.price * 20 else menu.price * 10 end) as point_sum from sales join menu on sales.product_id = menu.product_id group by customer_id
*/

--Q10
/*
select sales.customer_id, sum(case when sales.order_date >= members.join_date and sales.order_date <= members.join_date + INTERVAL '7 days' then menu.price * 20 
                              when menu.product_id = 1 then menu.price * 20 
                              else menu.price * 10
                              end) as point_sum from sales join menu on sales.product_id = menu.product_id join members on sales.customer_id = members.customer_id where sales.order_date between '2021-01-01' and '2021-01-31' group by sales.customer_id 
*/

/*For the bonus question, the solution was there but not all so had to see the actual answer:

With base_cte as (select sales.customer_id, sales.order_date, menu.product_name, menu.price, case when sales.order_date >= members.join_date then 'Y' else 'N' end as member from sales join menu on sales.product_id = menu.product_id join members on sales.customer_id = members.customer_id)

select customer_id, order_date, product_name, price, member, case when member = 'N' then null else dense_rank() over (partition by customer_id, member order by order_date) end as rank from base_cte

*/
