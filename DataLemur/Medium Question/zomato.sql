"""
"""


/*with abc as (select a.order_id as primary_id, a.item as primary_item, b.order_id, b.item from orders as a join orders as b on a.order_id = b.order_id + 1),

def as (select order_id, primary_item as item from abc), 

ghi as (select primary_id as order_id, item from abc)

select * from def union select * from ghi order by order_id

--select * from abc
*/

select LEAD(item, 1) OVER (ORDER BY order_id) from orders