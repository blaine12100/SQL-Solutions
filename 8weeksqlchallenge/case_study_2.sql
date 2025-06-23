"""
Update database column types

CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

-- Fix runner order table
-- Distance is in KM duration is in minutes

update runner_orders
set cancellation = 'N/A'
where cancellation = '' or cancellation is NULL or cancellation = 'null';

update runner_orders
set duration = 0
where duration is NULL or duration = '' or duration = 'null';

update runner_orders
set duration = split_part(duration, ' ', 1)
where duration like '% ';

update runner_orders
set duration = split_part(duration, 'mins', 1)
where duration like '%mins';

update runner_orders
set duration = split_part(duration, 'minute', 1)
where duration like '%minute';

update runner_orders
set duration = split_part(duration, 'minutes', 1)
where duration like '% minutes' or duration like '%minutes';

update runner_orders
set distance = 0
where distance is NULL or distance = '' or distance = 'null';

update runner_orders
set distance = split_part(distance, 'km', 1)
where distance like '%km' or distance like '% km';

update runner_orders
set pickup_time = '1970-01-01 00:00:00'
where pickup_time is NULL or pickup_time = '' or pickup_time = 'null';

ALTER TABLE runner_orders
ALTER COLUMN duration TYPE INTEGER USING duration::INTEGER;

ALTER TABLE runner_orders
ALTER COLUMN distance TYPE DECIMAL USING distance::DECIMAL;

ALTER TABLE runner_orders
ALTER COLUMN pickup_time TYPE TIMESTAMP USING pickup_time::TIMESTAMP;

-- Fix customer orders table

-- 0 is topping id which is not present in topppings table
update customer_orders
set exclusions = 0
where exclusions = '' or exclusions is null or exclusions = 'null';

update customer_orders
set extras = 0
where extras = '' or extras is null or extras = 'null';
"""

-- Pizza Delivery questions solved

--Schema SQL Query SQL ResultsEdit on DB Fiddle
-- Example Query:
/*SELECT
	runners.runner_id,
    runners.registration_date,
	COUNT(DISTINCT runner_orders.order_id) AS orders
FROM pizza_runner.runners
INNER JOIN pizza_runner.runner_orders
	ON runners.runner_id = runner_orders.runner_id
WHERE runner_orders.cancellation IS NOT NULL
GROUP BY
	runners.runner_id,
    runners.registration_date;
 */
 
/*update runner_orders
set cancellation = 'N/A'
where cancellation = '' or cancellation = NULL or cancellation = 'null'
*/
--select * from customer_orders
--*/

--select * from pizza_toppings

-- Queries start from here

-- Pizza metrics
-- How many pizzas were ordered?
--select count(pizza_id) from customer_orders

--How many unique customer orders were made?
--select count(distinct order_id) from customer_orders

--How many successful orders were delivered by each runner?
-- We've set N/A where cancellation is not present / applicable so only they need to be considered

/*select runner_id, count(*) from runner_orders where cancellation = 'N/A' group by runner_id
*/

-- How many of each type of pizza was delivered
-- Get not cancelled orders and then join to customer order.
-- Count distinct pizza type (group by) and then join to pizza
-- table for name

/*select p.pizza_name, count(*) from runner_orders as ro left join customer_orders as co on ro.order_id = co.order_id
left join pizza_names as p on
co.pizza_id = p.pizza_id
where ro.cancellation = 'N/A' -- non cancelled order
group by p.pizza_name
*/

--How many Vegetarian and Meatlovers were ordered by each customer?

-- Group by on customer by pizza type. Assuming here
-- that since the question says ordered, we are
-- also considering orders which could have been cancelled (As question did not say delivered).Use previous query

/*select co.customer_id, p.pizza_name, count(*) from customer_orders as co
left join pizza_names as p on
co.pizza_id = p.pizza_id
--where ro.cancellation = 'N/A' -- non cancelled order
group by co.customer_id, p.pizza_name
order by co.customer_id
*/

--What was the maximum number of pizzas delivered in a single order?

-- Get delivered orders. This implies successfull orders without cancellation, group by order

/*select co.order_id, count(*) from runner_orders as ro left join customer_orders as co on ro.order_id = co.order_id
where ro.cancellation = 'N/A' -- non cancelled order
group by co.order_id
order by count(*) desc limit 1
*/

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

/*
select co.customer_id, sum(case when co.extras is not null or co.exclusions is not null then 1 else 0 end) as atleast_1_change, sum(case when co.extras is NULL and co.exclusions is NULL then 1 else 0 end) as no_change from runner_orders as ro left join customer_orders as co on ro.order_id = co.order_id
where ro.cancellation = 'N/A'
group by co.customer_id
*/

-- How many pizzas were delivered that had both exclusions and extras?

/*
select sum(case when co.extras is not null and co.exclusions is not null then 1 else 0 end) as atleast_1_change from runner_orders as ro left join customer_orders as co on ro.order_id = co.order_id
where ro.cancellation = 'N/A'
*/

-- What was the total volume of pizzas ordered for each hour of the day?

/*
select DATE(order_time) as days, extract(hour from order_time) as times, count(*) from customer_orders group by DATE(order_time), extract(hour from order_time)
order by days, times
*/

-- What was the volume of orders for each day of the week?

/*
select DATE(order_time) as days, count(*) from customer_orders group by days
order by days
*/

----------------------------------------------------------------------------

-- Runners and customer experience questions

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

/*
select MOD(CAST (extract('week' from registration_date) AS NUMERIC), 53) as weeks, count (*) from runners group by MOD(CAST (extract('week' from registration_date) AS NUMERIC), 53)
order by weeks
*/

-- What was the average distance travelled for each customer?

/*
select co.customer_id, ROUND(sum(ro.distance) / count(co.customer_id), 2) as avg_distance from runner_orders as ro left join customer_orders as co on ro.order_id = co.order_id where ro.cancellation = 'N/A' group by co.customer_id
/*

-- What was the difference between the longest and shortest delivery times for all orders? (Tale difference of amx and min times across all orders (no group by requried since order id is completely unique)

/*select (max(duration) - min(duration)) as shortest_diff from runner_orders 
*/

-- What is the successful delivery percentage for each runner? (Coun of deliveries where cancellation = 'N/A' / count of deliveries where cacncellation could be anything) group by runner_id
-- Casting issues are bothersome

SELECT
    runner_id,
    round((CAST(SUM(CASE WHEN cancellation = 'N/A' THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) / COUNT(*)) * 100, 2) AS delivery_percentage
FROM
    runner_orders
GROUP BY
    runner_id;

-----------------------------------------------------------------------------

-- Ingredient optimization

--What are the standard ingredients for each pizza?
-- For each pizza, do a intersection operation on the toppings columns?

-- Get all toppings separately
With abc as (select pizza_id, CAST(TRIM(unnest(string_to_array(toppings, ','))) as INTEGER) as single_topping from pizza_recipes
),

-- Self join to get common distinct topppings
def as (
  select distinct a.single_topping from abc as a join abc as b on a.pizza_id != b.pizza_id and a.single_topping = b.single_topping
  ),
  
 -- Get name for distinct toppings across pizzas
 ghi as (
   select d.single_topping as topping_id, g.topping_name as topping_name from def as d join pizza_toppings as g on d.single_topping = g.topping_id
 )
   
select * from ghi

-- What was the most commonly added extra? (Get customer orders where extra is != N/A. separate them ang group by extra topping id and then get it's name
Similar to the first question

with abc as (
  select * from customer_orders where extras != '0'
),

def as (
  select CAST(TRIM(unnest(string_to_array(extras, ','))) as INTEGER) as single_topping from abc
),

ghi as (select single_topping, count(*) from def group by single_topping order by count(*) desc limit 1
)

select d.single_topping as topping_id, g.topping_name as topping_name from ghi as d join pizza_toppings as g on d.single_topping = g.topping_id

--What was the most common exclusion?

with abc as (
  select * from customer_orders where exclusions != '0'
),

def as (
  select CAST(TRIM(unnest(string_to_array(exclusions, ','))) as INTEGER) as single_topping from abc
),

ghi as (select single_topping, count(*) from def group by single_topping order by count(*) desc limit 1
)

select d.single_topping as topping_id, g.topping_name as topping_name from ghi as d join pizza_toppings as g on d.single_topping = g.topping_id
