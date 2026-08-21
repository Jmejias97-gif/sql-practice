-- Business question:
--   Who is the lowest-paid employee in each department, restricted to departments
--   whose average salary exceeds $60,000? (Checking for pay compression at the
--   bottom of otherwise well-compensated teams.)
--
-- Technique:
--   Two window functions in one pass over the same partition: RANK() ordered ASC
--   so rank 1 is the lowest earner, and AVG() OVER for the department benchmark.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary ASC) AS salary_rank,
        AVG(salary) OVER (PARTITION BY department) AS avg_salary
    FROM employees
),
cte_2 AS (
    SELECT *
    FROM cte_1
    WHERE salary_rank = 1
      AND avg_salary > 60000
)
SELECT employee_id, department, salary, salary_rank, avg_salary
FROM cte_2;
