-- Business question:
--   Which employees sit within 10% of their department's top salary — near-top
--   earners, not just the single highest — alongside department headcount for
--   context?
--
-- Technique:
--   Two independent correlated subqueries in the same CTE, each needing its own
--   distinct alias (e2 for the MAX lookup, e3 for the COUNT lookup) since both
--   correlate back to the same outer row (e1) but scan the table separately.
--
--   "Within 10% of the max" means salary >= max * 0.9, not salary < max. The
--   department's own top earner is trivially within 10% of themselves and should
--   be included — a `<` comparison would incorrectly exclude the person the
--   question is centered on.

WITH cte_1 AS (
    SELECT
        employee_id,
        department,
        salary,
        (SELECT MAX(salary) FROM employees e2 WHERE e2.department = e1.department) AS dept_max_salary,
        (SELECT COUNT(employee_id) FROM employees e3 WHERE e3.department = e1.department) AS dept_headcount
    FROM employees e1
)
SELECT employee_id, department, salary, dept_max_salary, dept_headcount
FROM cte_1
WHERE salary >= dept_max_salary * 0.9;
