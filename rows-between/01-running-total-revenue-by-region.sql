-- Business question:
--   For each order, what is the cumulative revenue that region has generated from
--   its first order through this one?
--
-- Technique:
--   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW is the explicit form of a
--   running total. Note this is also SQL's DEFAULT frame whenever ORDER BY is
--   present without a frame clause — writing it out makes the choice deliberate
--   rather than incidental. Leaving off ORDER BY entirely instead computes the
--   whole-partition total, a different (and easy to confuse) result.
--
--   ORDER BY must be order_date, not order_amount: a running total only means
--   something in chronological sequence. Ordering by amount produces a
--   smallest-to-largest accumulation with no business meaning.

SELECT
    order_id,
    region,
    order_date,
    order_amount,
    SUM(order_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders;
