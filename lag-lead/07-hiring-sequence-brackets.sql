-- Business question:
--   For each employee, what did the person hired immediately before and immediately
--   after them in the same department earn? Flag whether the employee sits inside
--   the department's hiring sequence or at one of its edges.
--
-- Technique:
--   LAG() and LEAD() over the same partition and ordering, computed in one pass.
--
--   Each condition around AND needs its own complete comparison:
--   `prev IS NOT NULL AND next IS NOT NULL`, not `prev AND next IS NOT NULL`.
--   The shorthand parses as a bare column read as a truth value, which happens to
--   work when the value is non-zero and breaks silently when it isn't.
--
--   Marketing has only two employees, so both are Boundary and neither is
--   Bracketed — a partition too small to have a middle.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        hire_date,
        salary,
        LAG(salary) OVER (PARTITION BY department ORDER BY hire_date ASC) AS previous_hire_salary,
        LEAD(salary) OVER (PARTITION BY department ORDER BY hire_date ASC) AS next_hire_salary
    FROM employees
),
cte_2 AS (
    SELECT *,
        CASE
            WHEN previous_hire_salary IS NOT NULL AND next_hire_salary IS NOT NULL THEN 'Bracketed'
            ELSE 'Boundary'
        END AS flag
    FROM cte_1
)
SELECT
    employee_id,
    department,
    hire_date,
    salary,
    previous_hire_salary,
    next_hire_salary,
    flag
FROM cte_2;
