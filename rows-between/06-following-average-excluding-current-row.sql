-- Business question:
--   How does each order compare to the average of the next two orders in that
--   region (not including itself)? Flag as declining trend when the current order
--   exceeds that following average by more than 15%.
--
-- Technique:
--   Mirror image of the trailing-average query: ROWS BETWEEN 1 FOLLOWING AND
--   2 FOLLOWING excludes the current row on the forward side. The boundary order
--   still runs earlier-edge-first, later-edge-second — 1 FOLLOWING (nearer) to
--   2 FOLLOWING (farther) — the same left-to-right rule as every other frame here,
--   just shifted to the other side of CURRENT ROW.
--
--   The existence check (LEAD(order_amount, 2)) must share the exact same
--   PARTITION BY and ORDER BY as the AVG() it validates. If the two window
--   functions describe different sequences, the existence check is validating
--   against the wrong ordering and the filter becomes meaningless.
--
--   Percent-change direction stays consistent with every other rep: the value
--   being evaluated (order_amount) is "new," the benchmark (following_avg_2) is
--   "old" — (new - old) / old * 100.

WITH cte_1 AS (
    SELECT
        order_id,
        region,
        order_date,
        order_amount,
        AVG(order_amount) OVER (
            PARTITION BY region
            ORDER BY order_date
            ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING
        ) AS following_avg_2,
        LEAD(order_amount, 2) OVER (PARTITION BY region ORDER BY order_date) AS order_amount_2_forward
    FROM orders
),
cte_2 AS (
    SELECT *,
        (order_amount - following_avg_2) / following_avg_2 * 100 AS pct_vs_following
    FROM cte_1
    WHERE order_amount_2_forward IS NOT NULL
)
SELECT
    order_id,
    region,
    order_date,
    order_amount,
    following_avg_2,
    pct_vs_following,
    CASE
        WHEN pct_vs_following > 15 THEN 'Declining Trend'
        ELSE 'Stable'
    END AS flag
FROM cte_2;
