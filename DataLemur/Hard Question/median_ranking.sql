"""
https://datalemur.com/questions/median-search-freq

Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

The approach below is correct but for some reason, it isn't working on the datalemur editor.
"""

/*
Create a temporary view which has num users * searches reocrds in it as a list. The calcualte the length of the TABLE
based on the length it's either the middle element or the middle element + middle elemnt + 1 / 2 for median
*/

with cte as
(SELECT searches, GENERATE_SERIES(1, num_users)
FROM search_frequency
order by searches)

select PERCENTILE_CONT(0.5) WITHIN group (order by searches) from cte;