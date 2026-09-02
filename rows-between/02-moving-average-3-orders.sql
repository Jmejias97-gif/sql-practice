-- Business question:
--   What is the 3-order moving average of order amount per region, smoothing out
--   single-order spikes to reveal the underlying trend?
--
-- Technique:
--   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW gives a 3-row window: two rows back
--   plus the current row.
--
--   A frame does not require its full row count to exist. On each region's first
--   row there are zero preceding rows, so the frame shrinks to just the current
--   row (AVG of one value = that value). On the second row it shrinks to two rows.
--   Only from the third row onward is it a genuine 3-order average. This is
--   fundamentally different from LAG/LEAD, which either finds an exact target row
--   or returns NULL outright — a frame never fails, it just narrows.

SELECT
    order_id,
    region,
    order_date,
    order_amount,
    AVG(order_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM orders;
