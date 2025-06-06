"""
A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category listed in the products table.

Write a query that identifies the customer IDs of these Supercloud customers.
"""

-- Basically, the problem boils down to getting the distinct category count,
-- joining on product to get the purchased products and getting the DISTINCT
-- category count and matching it with the first count

with def as (select customer_contracts.customer_id, count(distinct(products.product_category)) as temp_count from products left join 
customer_contracts on customer_contracts.product_id = products.product_id group by customer_contracts.customer_id)

select customer_id from def where temp_count >= (SELECT count(distinct(product_category)) FROM products)