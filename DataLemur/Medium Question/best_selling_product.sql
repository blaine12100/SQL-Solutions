"""
Write an SQL query to find the best-selling product in each product category. If there are two or more products with the same sales quantity, go by whichever product which has the higher review rating.

Return the category name and product name in alphabetical order of the category.

https://datalemur.com/questions/best-selling-products

Approach:

Create first CTE to aggregate sales, ratings for products.

Rank sales per category based on sales and reviews to eliminate ties

Get record with max rank
"""

with base_cte as (
select p.product_name, p.category_name, sum(prod.sales_quantity) as sales, sum(prod.rating) as rate from products as p left join product_sales as prod on p.product_id = prod.product_id
group by p.product_name, p.category_name
),

rank_cte as (
select *, rank() over (partition by base_cte.category_name order by base_cte.sales desc, base_cte.rate desc) as temp_rank from base_cte
)

select product_name, category_name from rank_cte where temp_rank = 1 order by category_name asc