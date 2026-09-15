-- Business question:
--   Which employees earn above their own department's average salary — who is
--   outperforming their peer group?
--
-- Technique:
--   A correlated subquery re-runs once per outer row, referencing that row's own
--   column (e1.department) to recompute the comparison value fresh each time.
--   This is the same question a window function answers with
--   AVG(salary) OVER (PARTITION BY department) — same output, different mechanism.
--   A window function computes each partition's average once and hands every row
--   its value; a correlated subquery recomputes the average from scratch for every
--   single outer row, which is structurally identical to a nested loop in Python:
--   the outer loop iterates rows, the inner loop rebuilds the group aggregate on
--   every pass. This is also why window functions tend to outperform correlated
--   subqueries at scale — one pass over the data versus one re-scan per row.
--
--   Two aliases (e1, e2) are required even though it's the same table twice: e1 is
--   "the current outer row," e2 is "the group being aggregated over." Without
--   distinct aliases, `department` inside the subquery is ambiguous.

SELECT employee_id, department, salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.department = e1.department
);
