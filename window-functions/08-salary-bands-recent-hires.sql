-- Business question:
--   Among employees hired in 2020 or later, who are the top two earners in each
--   department — restricted to departments with at least 3 recent hires — and what
--   compensation band does each fall into?
--
-- Technique:
--   The hire-date filter sits INSIDE cte_1, before the window functions run. This
--   is a pool-defining filter: earlier hires are on a different comp structure and
--   must be excluded from the analysis entirely, not merely hidden from the output.
--   Filtering in cte_2 instead would rank and count across all employees and then
--   suppress rows — producing correct-looking output with wrong numbers.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank,
        COUNT(employee_id) OVER (PARTITION BY department) AS recent_hire_count
    FROM employees
    WHERE hire_date >= '2020-01-01'
),
cte_2 AS (
    SELECT *,
        CASE
            WHEN salary > 75000 THEN 'Senior Band'
            WHEN salary BETWEEN 60000 AND 75000 THEN 'Mid Band'
            ELSE 'Entry Band'
        END AS band_label
    FROM cte_1
    WHERE recent_hire_count >= 3
      AND salary_rank <= 2
)
SELECT employee_id, department, hire_date, salary, salary_rank, recent_hire_count, band_label
FROM cte_2;
