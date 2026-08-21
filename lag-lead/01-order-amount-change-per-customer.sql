-- Business question:
--   For every order, how much did the customer's spend change compared to their
--   previous order? (Positive means they spent more this time.)
--
-- Technique:
--   LAG() pulls a value from the preceding row. PARTITION BY customer_id bounds the
--   lookback so it resets at each customer rather than reaching across into someone
--   else's history. ORDER BY order_date defines what "previous" means — ordering by
--   amount instead would answer an entirely different question.
--
--   The first order per customer returns NULL, and the arithmetic propagates that
--   NULL. This is correct: no prior order exists, so no change value exists.
--   Substituting 0 would falsely imply flat spend.

WITH cte_1 AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_amount,
        LAG(order_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
    FROM orders
)
SELECT
    order_id,
    customer_id,
    order_date,
    order_amount,
    prev_amount,
    order_amount - prev_amount AS amount_change
FROM cte_1;
