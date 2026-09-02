-- Business question:
--   How does each employee's salary compare to the trailing average of the two
--   people hired immediately before them (not including themselves)? Flag anyone
--   more than 20% above that trailing average as overpaid relative to recent trend.
--
-- Technique:
--   ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING excludes the current row entirely —
--   both boundaries sit before it. This is different from every prior frame in
--   this set, which all included CURRENT ROW as one edge.
--
--   Frame clauses (ROWS BETWEEN) belong only to aggregate window functions like
--   AVG/SUM — they scan a range. Offset functions like LAG/LEAD jump to one
--   specific row via a row-count argument and cannot take a frame clause. The two
--   are not interchangeable, and mixing them (attaching ROWS BETWEEN to a LAG)
--   is a parse error, not a stylistic choice.
--
--   Existence of a full trailing window is checked via LAG(salary, 2), a direct
--   offset lookup, rather than checking whether the AVG() result is NULL — a
--   partial-window average can still return a non-NULL value even when the full
--   window doesn't exist, so the aggregate itself is not a reliable existence test.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        AVG(salary) OVER (
            PARTITION BY department
            ORDER BY hire_date
            ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING
        ) AS trailing_avg_2,
        LAG(salary, 2) OVER (PARTITION BY department ORDER BY hire_date) AS salary_2_back
    FROM employees
),
cte_2 AS (
    SELECT *,
        (salary - trailing_avg_2) / trailing_avg_2 * 100 AS pct_vs_trend
    FROM cte_1
    WHERE salary_2_back IS NOT NULL
)
SELECT
    employee_id,
    department,
    hire_date,
    salary,
    trailing_avg_2,
    pct_vs_trend,
    CASE
        WHEN pct_vs_trend > 20 THEN 'Overpaid vs. Recent Trend'
        ELSE 'In Line'
    END AS flag
FROM cte_2;
