-- Business question:
--   Compare each employee's salary to a centered 3-person window (previous hire,
--   this hire, next hire) within their department — but only where the full
--   3-person window actually exists.
--
-- Technique:
--   ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING looks in both directions, not just
--   backward — new relative to every prior frame in this set.
--
--   A frame cannot be directly tested for "did this have 3 rows." Existence is
--   checked indirectly with LAG/LEAD on the same partition and ordering: if a
--   previous or next hire doesn't exist, the window at that row is necessarily
--   partial, so those rows are filtered out.
--
--   Departments with 2 or fewer employees return zero rows here — every position
--   is an edge, so no row can ever have both a predecessor and a successor.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        AVG(salary) OVER (
            PARTITION BY department
            ORDER BY hire_date
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
        ) AS window_avg_salary
    FROM employees
),
cte_2 AS (
    SELECT *,
        LAG(employee_id) OVER (PARTITION BY department ORDER BY hire_date) AS prev_employee,
        LEAD(employee_id) OVER (PARTITION BY department ORDER BY hire_date) AS next_employee
    FROM cte_1
)
SELECT employee_id, department, hire_date, salary, window_avg_salary
FROM cte_2
WHERE prev_employee IS NOT NULL
  AND next_employee IS NOT NULL;
