-- Business question:
--   Which customers have placed orders, but have never once ordered from the
--   'East' region — active buyers entirely absent from that market, and possible
--   targets for an East-region promotion?
--
-- Technique:
--   NOT EXISTS is the "find the gap" pattern with no window function equivalent:
--   PARTITION BY can only describe rows that exist in the dataset, while this
--   question is about the absence of a row matching a condition. Structurally
--   identical to the EXISTS query above, just negated with the condition flipped
--   to region = 'East'.
--
--   DISTINCT is still required for the same reason as the EXISTS query: orders is
--   row-per-order, so a qualifying customer with several non-East orders would
--   otherwise print once per order rather than once per customer.
--
--   General note: NOT EXISTS is preferred over NOT IN for "find missing rows"
--   queries in production SQL, because NOT IN silently returns zero rows for the
--   entire query if the subquery's result set contains even one NULL. NOT EXISTS
--   has no such landmine.

SELECT DISTINCT customer_id
FROM orders o1
WHERE NOT EXISTS (
    SELECT 1 FROM orders o2 WHERE o2.customer_id = o1.customer_id AND o2.region = 'East'
);
