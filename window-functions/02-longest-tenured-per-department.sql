-- Business question:
--   Who is the longest-tenured employee in each department, restricted to
--   departments with more than 5 employees?
--
-- Technique:
--   Two chained CTEs. ORDER BY hire_date ASC is what makes rank 1 the *earliest*
--   hire — DESC would silently return the newest employee instead.
--   COUNT() OVER supplies the department size without collapsing rows.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        RANK() OVER (PARTITION BY department ORDER BY hire_date ASC) AS earliest_hire,
        COUNT(employee_id) OVER (PARTITION BY department) AS employee_per_department
    FROM employees
),
cte_2 AS (
    SELECT *
    FROM cte_1
    WHERE employee_per_department > 5
      AND earliest_hire = 1
)
SELECT employee_id, department, hire_date, earliest_hire, employee_per_department
FROM cte_2;
