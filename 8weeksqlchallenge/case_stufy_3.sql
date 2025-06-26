/*
On boarding journey

For customer 1, they started a trial on 2020-08-01 and transitioned to a basic plan on the 8th of the same month (1 week trial)

Customer 2 started a trial but on the same day (2020-09-20), transitioned to a pro annual fan.

Short summary is that most people go from a trial to a pro monthly / annual plan. There are lesser number of people who go from a basic to a higher plan or go from no plan to churn (Leave the service)
*/

SELECT * FROM foodie_fi.subscriptions where customer_id in (1, 2, 11, 13, 15, 16, 18, 19)