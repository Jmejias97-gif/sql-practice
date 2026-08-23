-- Business question:
--   For each employee, what was the previous hire's salary in that department, and
--   what is the percent change between them? (Is the department hiring at higher or
--   lower salaries over time?)
--
-- Technique:
--   ORDER BY hire_date is what makes "previous" mean the person hired before them.
--   Ordering by salary instead would make it the next-lowest-paid employee — a
--   completely different analysis using identical syntax.
--
--   Percent change is (new - old) / old * 100. The denominator is the STARTING
--   value; dividing by the current value instead changes both sign and magnitude.
--   Engineering shows a steady decline here, which is a real finding.
--
--   First hire per department returns NULL, and the arithmetic propagates it —
--   NULL in any operand yields NULL. Correct: 0% would falsely assert flat pay.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        LAG(salary) OVER (PARTITION BY department ORDER BY hire_date ASC) AS prev_hire_salary
    FROM employees
)
SELECT
    employee_id,
    department,
    hire_date,
    salary,
    prev_hire_salary,
    (salary - prev_hire_salary) / prev_hire_salary * 100 AS pct_change
FROM cte_1;
