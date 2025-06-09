"""
Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights, you're analyzing how many credit cards were issued each month.

Write a query that outputs the name of each credit card and the difference in the number of issued cards between the month with the highest issuance cards and the lowest issuance. Arrange the results based on the largest disparity.

My solution went over CTE and ranking which has made it very complicated. The below is the accepted solution

SELECT 
  card_name, 
  MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;
"""

With abc as (SELECT card_name, sum(issued_amount) as amount_sum, ROW_NUMBER() OVER(partition by card_name order by sum(issued_amount) desc) FROM monthly_cards_issued group by card_name, issue_month),

highest_earners as (select card_name, amount_sum, row_number from abc where row_number = 1),

lowest_earners as (select distinct card_name, max(row_number) OVER(PARTITION by card_name) from abc),

combined_v1 as (select lowest_earners.card_name, abc.amount_sum from lowest_earners left join abc on lowest_earners.card_name = abc.card_name and lowest_earners.max = abc.row_number),

combined_v2 as (select combined_v1.card_name, (highest_earners.amount_sum - combined_v1.amount_sum) as difference from combined_v1 left join highest_earners on combined_v1.card_name = highest_earners.card_name)

select * from combined_v2 order by difference desc