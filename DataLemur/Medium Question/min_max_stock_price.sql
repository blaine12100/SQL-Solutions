"""
The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. As a Data Analyst at Bloomberg, you have access to historical data on stock performance.

Currently, you're analyzing the highest and lowest open prices for each FAANG stock by month over the years.

For each FAANG stock, display the ticker symbol, the month and year ('Mon-YYYY') with the corresponding highest and lowest open prices (refer to the Example Output format). Ensure that the results are sorted by ticker symbol.
"""

SELECT ticker, TO_CHAR(date, 'YYYY-MM') as sample_date, MAX(open) OVER(partition by ticker order by TO_CHAR(date, 'YYYY-MM') desc) FROM stock_prices