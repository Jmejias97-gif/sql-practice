-- Business question:
--   For each order, how many days pass until the next order arrives in that same
--   region? (Measuring how long regions go quiet between orders.)
--
-- Technique:
--   LEAD() looks forward to the following row. The NULL lands on each region's most
--   recent order — nothing has come after it yet, which is the honest answer.
--
--   Date subtraction is later-minus-earlier. With LEAD the lead value IS the later
--   one, so it goes first: julianday(next) - julianday(current). This reverses the
--   LAG pattern, where the current row is the later value.
--
--   Note on framing: LAG would surface the same set of gaps attached to different
--   rows. LAG says "this order arrived N days after the last one." LEAD says "after
--   this order, the region went quiet for N days." Same data, different subject —
--   LEAD matches the shape of a monitoring question.

WITH cte_1 AS (
    SELECT
        order_id,
        region,
        order_date,
        LEAD(order_date) OVER (PARTITION BY region ORDER BY order_date ASC) AS next_order_date
    FROM orders
)
SELECT
    order_id,
    region,
    order_date,
    next_order_date,
    julianday(next_order_date) - julianday(order_date) AS days_until_next_order
FROM cte_1;
