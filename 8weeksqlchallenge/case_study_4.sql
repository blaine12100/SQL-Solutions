-- Q1
/*select count(distinct(node_id)) as unique_count from customer_nodes*/

--Q2 No of nodes per region

/*select regions.region_name, count(distinct customer_nodes.node_id) as node_count_region from customer_nodes join regions on regions.region_id = customer_nodes.region_id group by regions.region_name 
*/

--Q3 How many customers are allocated to each region?

/*select r.region_name, count(distinct cn.customer_id) as temp_count from customer_nodes as cn join regions as r on cn.region_id = r.region_id group by r.region_name*/

--Q4 How many days on average are customers reallocated to a different node?
/* For this, we need to calculate the difference between the start date and end date and then group by per customer and sum that difference divided by the count of customer_id. This is across regions
*/

with base_cte as (select customer_id, end_date - start_date as difference from customer_nodes where end_date != '9999-12-31')
