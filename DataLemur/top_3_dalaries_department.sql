-- Use Dense Rank as it avoids gaps between the ranking and order by department name asc, salary desc and emp name asc

WITH top_3_salary as (
select d.department_name, emp.name, emp.salary, DENSE_RANK() OVER(PARTITION BY d.department_name order by d.department_name asc, emp.salary desc, emp.name asc) from employee as emp left join department as d on emp.department_id = d.department_id
)

SELECT department_name, name, salary FROM top_3_salary where dense_rank <= 3