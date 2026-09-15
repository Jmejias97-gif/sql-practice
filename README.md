# SQL Practice

A working record of my SQL skill development as I train toward a data analyst role.
Every query here was written from scratch under active-recall conditions — no notes,
no lookups — against a seeded SQLite practice database.

Each file states the business question it answers before the code, because a query
without its question is just syntax.

## Repository structure

```
window-functions/    Ranking, partitioning, and aggregate window functions
lag-lead/            Row-to-row comparisons (period-over-period analysis)
schema/              Table definitions and seed data to reproduce these queries
```

## Practice schema

**orders**
| column | type |
|---|---|
| order_id | INTEGER |
| customer_id | INTEGER |
| region | TEXT |
| order_date | TEXT (ISO 8601) |
| order_amount | REAL |

**employees**
| column | type |
|---|---|
| employee_id | INTEGER |
| department | TEXT |
| hire_date | TEXT (ISO 8601) |
| salary | REAL |

Run `schema/seed.sql` against a fresh SQLite database to reproduce any query here.

## Techniques covered

- `RANK()` and `DENSE_RANK()` with `PARTITION BY`
- Chained CTEs, including three-deep dependency chains
- Multiple window functions computed in a single pass
- Pool-defining filters (inside the CTE, before ranking) vs. post-rank filters (outer query)
- `CASE WHEN` labeling applied after window logic resolves
- `LAG()` and `LEAD()` for row-to-row comparison
- Date arithmetic with `julianday()`
- ROWS BETWEEN (running totals, moving averages,centered/trailing/following windows)

## Notes on dialect

Written for SQLite. Dates are stored as TEXT, so day-count arithmetic uses
`julianday(a) - julianday(b)` rather than direct subtraction — subtracting the raw
strings coerces them to integers and silently returns wrong answers.
