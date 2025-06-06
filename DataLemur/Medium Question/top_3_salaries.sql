"""
As part of an ongoing analysis of salary distribution within the company, your manager has requested a report identifying high earners in each department. A 'high earner' within a department is defined as an employee with a salary ranking among the top three salaries within that department.

You're tasked with identifying these high earners across all departments. Write a query to display the employee's name along with their department name and salary. In case of duplicates, sort the results of department name in ascending order, then by salary in descending order. If multiple employees have the same salary, then order them alphabetically.

https://datalemur.com/questions/sql-top-three-salaries

Note: Initial solution was wrong due to me including the sorting conditions within the ranking logic which
causes similar salary employees to be ranked differently. Had to use Gemini to understand that sorting should be done
after the CTE
"""

WITH top_3_salary AS (
SELECT d.department_name, emp.name, emp.salary, DENSE_RANK() OVER(PARTITION BY d.department_name ORDER BY emp.salary DESC) AS number FROM employee AS emp LEFT JOIN department AS d ON emp.department_id = d.department_id
)
SELECT department_name, name, salary FROM top_3_salary WHERE number <= 3 ORDER BY department_name ASC, salary DESC, name ASC;