"""
You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (item_count table) and the corresponding number of orders for each item count (order_occurrences table).

Round casting was a bit of a hassle to handle
"""

with abc as (SELECT (sum(order_occurrences * item_count) / sum(order_occurrences)) as mean FROM items_per_order)

select round(cast(mean as NUMERIC), 1) from abc