-- Business question:
--   How many days elapsed between each hire and the previous hire into the same
--   department? (Measuring hiring pace per team.)
--
-- Technique:
--   LAG() over hire_date, partitioned by department.
--
--   Date arithmetic requires julianday(). SQLite has no date type — hire_date is
--   TEXT, so `hire_date - prev_hire` coerces each string to an integer by reading
--   digits until a non-digit, turning '2020-01-10' into 2020. That returns a small
--   plausible number instead of an error, which makes it a dangerous silent bug.
--   julianday() converts to a continuous day count where subtraction is valid.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        LAG(hire_date) OVER (PARTITION BY department ORDER BY hire_date ASC) AS prev_hire
    FROM employees
)
SELECT
    employee_id,
    department,
    hire_date,
    prev_hire,
    julianday(hire_date) - julianday(prev_hire) AS days_since_prev_hire
FROM cte_1;
