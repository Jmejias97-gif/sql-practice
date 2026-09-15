-- Business question:
--   Which distinct customers have placed at least one order over $400 — a "has
--   this customer ever been a big spender" question, not "show me their big
--   orders"?
--
-- Technique:
--   EXISTS answers a fundamentally different question than every subquery above:
--   not "what value does this row's group have," but "does at least one matching
--   row exist at all." The subquery's own output is discarded entirely — SELECT 1
--   is idiomatic specifically because the content never matters, only whether a
--   row came back.
--
--   Since orders sits on the "many" side of customer-to-orders, and the outer
--   query selects from orders rather than a one-row-per-customer table, a
--   qualifying customer's ID would print once per their order row without
--   DISTINCT. The condition inside EXISTS must be qualified to the inner alias
--   (o2.order_amount), not left ambiguous between o1 and o2.

SELECT DISTINCT customer_id
FROM orders o1
WHERE EXISTS (
    SELECT 1 FROM orders o2 WHERE o2.customer_id = o1.customer_id AND o2.order_amount > 400
);
