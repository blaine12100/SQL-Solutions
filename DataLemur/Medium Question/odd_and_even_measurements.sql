"""
This is the same question as problem #28 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

Definition:

Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.
"""

with abc as (SELECT date_trunc('day', measurement_time) as measurement_day, measurement_value, ROW_NUMBER() OVER(partition by date_trunc('day', measurement_time) order by measurement_time) FROM measurements
)

select measurement_day, sum(case when row_number % 2 != 0 then measurement_value else 0 end) as odd_sum, sum(case when row_number % 2 = 0 then measurement_value else 0 end) as even_sum from abc group by measurement_day