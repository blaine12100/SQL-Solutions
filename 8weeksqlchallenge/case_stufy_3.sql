/*
On boarding journey

For customer 1, they started a trial on 2020-08-01 and transitioned to a basic plan on the 8th of the same month (1 week trial)

Customer 2 started a trial but on the same day (2020-09-20), transitioned to a pro annual fan.

Short summary is that most people go from a trial to a pro monthly / annual plan. There are lesser number of people who go from a basic to a higher plan or go from no plan to churn (Leave the service)
*/

--SELECT * FROM foodie_fi.subscriptions where customer_id in (1, 2, 11, 13, 15, 16, 18, 19)

/*
On boarding journey

For customer 1, they started a trial on 2020-08-01 and transitioned to a basic plan on the 8th of the same month (1 week trial)

Customer 2 started a trial but on the same day (2020-09-20), transitioned to a pro annual fan.

Short summary is that most people go from a trial to a pro monthly / annual plan. There are lesser number of people who go from a basic to a higher plan or go from no plan to churn (Leave the service)
*/

--How many customers has Foodie-Fi ever had?
--select count(distinct(customer_id)) from foodie_fi.subscriptions

--What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value (Per month per date distribution is I think what the question is asking so the group by should be on both of them)

/*
select EXTRACT(month from start_date) as month, EXTRACT(day from start_date) as day, count(*) from foodie_fi.subscriptions where plan_id = 0 group by month, day
*/