-- Business question:
--   How does each order compare to the order from two positions back in the same
--   region? (Smoothing out single-order noise when reading regional rhythm.)
--
-- Technique:
--   LAG() takes an optional second argument for offset — LAG(col, 2) reaches two
--   rows back instead of one. Default is 1.
--
--   ORDER BY order_date, not order_amount: "two orders ago" is a sequence position,
--   not a size ranking. Ordering by amount would answer "second-smallest below
--   this one," which is a different question with identical syntax.
--
--   Each region loses its first two rows to the NULL filter — the expected shape
--   when offsetting by 2.

WITH cte_1 AS (
    SELECT
        order_id,
        customer_id,
        region,
        order_date,
        order_amount,
        LAG(order_amount, 2) OVER (PARTITION BY region ORDER BY order_date ASC) AS amount_two_orders_ago
    FROM orders
),
cte_2 AS (
    SELECT *,
        order_amount - amount_two_orders_ago AS amount_diff
    FROM cte_1
)
SELECT
    order_id,
    customer_id,
    region,
    order_date,
    order_amount,
    amount_two_orders_ago,
    amount_diff
FROM cte_2
WHERE amount_two_orders_ago IS NOT NULL;
