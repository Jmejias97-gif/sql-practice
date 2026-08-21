-- Business question:
--   Who is the highest earner in each department, restricted to teams of fewer
--   than 4 people, and only where that person was hired before 2021?
--   (Identifying tenured high-cost headcount on small teams.)
--
-- Technique:
--   Three filter conditions applied after the window functions resolve: rank,
--   department size, and hire date.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank,
        COUNT(employee_id) OVER (PARTITION BY department) AS department_employee_count
    FROM employees
),
cte_2 AS (
    SELECT *
    FROM cte_1
    WHERE salary_rank = 1
      AND hire_date < '2021-01-01'
      AND department_employee_count < 4
)
SELECT employee_id, department, hire_date, salary, salary_rank, department_employee_count
FROM cte_2;
