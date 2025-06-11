"""
CVS Health wants to gain a clearer understanding of its pharmacy sales and the performance of various products.

Write a query to calculate the total drug sales for each manufacturer. Round the answer to the nearest million and report your results in descending order of total sales. In case of any duplicates, sort them alphabetically by the manufacturer name.

Since this data will be displayed on a dashboard viewed by business stakeholders, please format your results as follows: "$36 million".

Round has negative argument to round to that number (Didn't know this before)
"""

SELECT manufacturer, '$' || CAST(round(round(sum(total_sales), -6) / 1000000, 0) as TEXT) || ' million' as sale FROM pharmacy_sales group by manufacturer order by sum(total_sales) desc, manufacturer asc