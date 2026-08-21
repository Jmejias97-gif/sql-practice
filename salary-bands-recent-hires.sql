WITH cte_1 AS (
SELECT employee_id,department,hire_date,salary, RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank, COUNT(employee_id) OVER(PARTITION BY department) AS recent_hire_count FROM employees WHERE hire_date >= '2020-01-01'
),
cte_2 AS ( 
SELECT *, CASE
WHEN salary > 75000 THEN 'Senior Band'
WHEN salary BETWEEN 60000 AND 75000 THEN 'Mid Band'
ELSE 'Entry Band' 
END AS band_label  FROM cte_1 WHERE recent_hire_count >= 3 AND salary_rank <= 2
)
SELECT employee_id, department, hire_date, salary, salary_rank, recent_hire_count, band_label FROM cte_2;

