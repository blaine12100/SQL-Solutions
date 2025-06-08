"""
This is the same question as problem #1 in the SQL Chapter of Ace the Data Science Interview!

Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

Definition and note:

Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
To avoid integer division, multiply the CTR by 100.0, not 100.
"""

SELECT app_id, ROUND(
        (CAST(SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS NUMERIC) /
         NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0)
        ) * 100,
        2
    ) as ctr FROM eve(CAST(nts where date_part('year', events.timestamp) = '2022' group by app_id