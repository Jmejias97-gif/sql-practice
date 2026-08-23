# Data Analysis Practice Handbook

**Joshua Mejias**
*Organized review of SQL, Python, and Pandas practice*

> **Purpose:** A reusable study guide that preserves practice attempts, shows corrected patterns, and highlights skills already built.

Compiled from practice work recorded across study sessions through August 2026. Some repeated exercises were consolidated into the clearest representative version.

## Table of Contents

- [What's Included](#whats-included)
- [How to Use This Handbook](#how-to-use-this-handbook)
- [Current Skill Snapshot](#current-skill-snapshot)
- [Part I — SQL Practice](#part-i--sql-practice)
- [Part II — Python Practice](#part-ii--python-practice)
- [Part III — Pandas Practice](#part-iii--pandas-practice)
- [Part IV — Business Analysis Practice](#part-iv--business-analysis-practice)
- [Part V — Review Plan](#part-v--review-plan)
- [Next Challenge Set](#next-challenge-set)
- [Quick-Reference Syntax](#quick-reference-syntax)

---

## What's Included

- **Part I — SQL:** filtering, aggregation, grouping, ranking, joins, and business analysis.
- **Part II — Python:** loops, functions, dictionaries, list comprehensions, and order analysis.
- **Part III — Pandas:** filtering, calculated columns, groupby, agg, sorting, and merges.
- A progress summary, correction log, and focused next-practice plan.

## How to Use This Handbook

- Cover the corrected answer and try each prompt again.
- Compare structure first: columns → source → filter → grouping → sorting/limit.
- Retype corrected code instead of only reading it.
- Explain the business meaning of every result in one or two sentences.
- Add new attempts beneath the closest matching skill section.

## Current Skill Snapshot

| Area | Working Level | Evidence from Practice |
|---|---|---|
| **SQL** | Intermediate | SELECT, WHERE, GROUP BY, HAVING, aggregates, top-N analysis, and multi-table JOIN reasoning. |
| **Python** | Strong fundamentals | Loops, conditionals, functions, dictionaries, list comprehensions, and order-list analysis. |
| **Pandas** | Developing intermediate | Filtering, calculated columns, groupby, agg, sorting, merging, and customer/category analysis. |

---

## PART I — SQL PRACTICE

> **Core pattern:** `SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT`. Not every query uses every clause, but clauses that appear follow this order.

### Skills Practiced

- Filtering rows with WHERE
- Revenue calculations using quantity × price
- SUM, COUNT, AVG, MIN, and MAX
- GROUP BY for customer, product, city, category, and month
- ORDER BY and LIMIT for top-N results
- INNER and LEFT JOIN logic across customers, orders, products, and stores
- Business interpretation: revenue, loyalty, retention, seasonality, and customer value

### Practice SQL-1

**Return every order with a price above $300.**

Your attempt:
```sql
SELECT * FROM orders WHERE price > 300
```

Corrected / polished version:
```sql
SELECT *
FROM orders
WHERE price > 300;
```

**Key lesson:** Your logic was correct. Format one clause per line to make longer queries easier to debug.

### Practice SQL-2

**Calculate total revenue by customer.**

Your attempt:
```sql
SELECT customer, SUM(quantity * price) AS Revenue FROM orders GROUP BY customer
```

Corrected / polished version:
```sql
SELECT customer,
       SUM(quantity * price) AS revenue
FROM orders
GROUP BY customer
ORDER BY revenue DESC;
```

**Key lesson:** A calculated expression can be aggregated inside SUM. Every non-aggregated selected column belongs in GROUP BY.

### Practice SQL-3

**Find the top three products by revenue.**

Your attempt:
```sql
SELECT product, SUM(quantity * price) AS Revenue GROUP BY product ORDER BY Revenue DESC LIMIT 3
```

Corrected / polished version:
```sql
SELECT product,
       SUM(quantity * price) AS revenue
FROM orders
GROUP BY product
ORDER BY revenue DESC
LIMIT 3;
```

**Key lesson:** The main missing clause was FROM orders. Your grouping, ranking, and top-three logic were correct.

### Practice SQL-4

**Find average order price by city, highest first.**

Your attempt:
```sql
SELECT city, AVG(price) AS order_value FROM orders GROUP BY city ORDER BY order_value DESC
```

Corrected / polished version:
```sql
SELECT city,
       AVG(price) AS average_order_price
FROM orders
GROUP BY city
ORDER BY average_order_price DESC;
```

**Key lesson:** This query was structurally correct. Be precise about the metric name: AVG(price) is average price unless price already represents full order value.

### Practice SQL-5

**Find the month with the highest total revenue.**

Your attempt:
```sql
SELECT month, SUM(quantity * price) AS highest_revenue FROM orders GROUP BY month ORDER BY highest_revenue DESC LIMIT 1
```

Corrected / polished version:
```sql
SELECT month,
       SUM(quantity * price) AS revenue
FROM orders
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;
```

**Key lesson:** The query was correct. Naming the column revenue is clearer because the ORDER BY and LIMIT — not the alias — make it the highest result.

### JOIN Practice

```sql
SELECT c.customer,
       p.product_name,
       o.quantity,
       o.quantity * p.price AS revenue
FROM orders AS o
INNER JOIN customers AS c ON o.customerID = c.customerID
INNER JOIN products AS p ON o.productID = p.productID;
```

**Bridge-table insight:** The orders table connects customers to products. Start with orders when the analysis requires purchase activity, then join descriptive details from customers and products.

### JOIN Patterns You Practiced

```sql
-- Customers who placed orders
SELECT *
FROM customers AS c
INNER JOIN orders AS o ON c.customerID = o.customerID;

-- Keep every customer, including customers with no orders
SELECT *
FROM customers AS c
LEFT JOIN orders AS o ON c.customerID = o.customerID;
```

### Business-Analysis SQL Patterns

**Customer value**
```sql
SELECT c.customer,
       SUM(o.quantity * p.price) AS total_revenue,
       COUNT(DISTINCT o.orderID) AS number_of_orders,
       AVG(o.quantity * p.price) AS average_order_value
FROM orders AS o
JOIN customers AS c ON o.customerID = c.customerID
JOIN products AS p ON o.productID = p.productID
GROUP BY c.customer
ORDER BY total_revenue DESC;
```

**Monthly/category revenue**
```sql
SELECT DATE_TRUNC('month', o.orderDate) AS order_month,
       p.category,
       SUM(o.quantity * p.price) AS revenue
FROM orders AS o
JOIN products AS p ON o.productID = p.productID
GROUP BY DATE_TRUNC('month', o.orderDate), p.category
ORDER BY order_month, revenue DESC;
```

**Filtering grouped results with HAVING**
```sql
SELECT customerID, SUM(quantity * price) AS revenue
FROM orders
GROUP BY customerID
HAVING SUM(quantity * price) > 1000
ORDER BY revenue DESC;
```

**WHERE vs. HAVING:** WHERE filters individual rows before grouping. HAVING filters grouped results after aggregate calculations.

### SQL Correction Log

| Pattern | Common Slip | Fix |
|---|---|---|
| **Missing FROM** | Selected and grouped correctly but omitted the source table. | Check that every query has SELECT and FROM before adding analysis clauses. |
| **Clause order** | Occasional syntax-order problems. | Use the core clause order shown at the beginning of Part I. |
| **Metric naming** | Alias sometimes described the final ranking instead of the calculation. | Name the measure itself: revenue, average_order_value, order_count. |
| **Join key syntax** | Early merge/join attempts mixed dataframe and SQL syntax. | In SQL, use `JOIN table ON left.key = right.key`. |
| **Business precision** | Price and order value were sometimes treated as the same metric. | Define order value explicitly, often quantity × unit price. |

---

## PART II — PYTHON PRACTICE

> **Core idea:** Most Python data practice follows the same cycle: loop through records → test a condition → calculate or store a result → print or return the answer.

### Skills Practiced

- Looping through a list of dictionaries
- Filtering with if statements
- Writing and calling functions
- Using sum, max, len, and list comprehensions
- Counting with dictionaries
- Finding a top customer from accumulated counts
- Separating return values from print statements

### Practice PY-1

**Print every Electronics customer.**

Your attempt:
```python
for i in orders:
    if i['category'] == 'Electronics':
        print(i['customer'])
```

Corrected / polished version:
```python
for order in orders:
    if order['category'] == 'Electronics':
        print(order['customer'])
```

**Key lesson:** Your logic was correct. A descriptive loop variable such as `order` makes the code easier to read than `i`.

### Practice PY-2

**Return the number of orders.**

Your attempt:
```python
def total_orders(orders):
    return len(orders)

print(total_orders(orders))
```

Corrected / polished version:
```python
def total_orders(orders):
    return len(orders)

print(total_orders(orders))
```

**Key lesson:** This was fully correct: the function accepts data, returns a value, and the function call is printed.

### Practice PY-3

**Count how many orders each customer made.**

Your attempt:
```python
customer_counts = {}
for i in orders:
    if i['customer'] in customer_counts:
        customer_counts[i['customer']] += 1
    else:
        customer_counts[i['customer']] = 1
print(customer_counts)
```

Corrected / polished version:
```python
customer_counts = {}
for order in orders:
    customer = order['customer']
    customer_counts[customer] = customer_counts.get(customer, 0) + 1

print(customer_counts)
```

**Key lesson:** Your original dictionary-counting logic was correct. `dict.get` shortens the same initialize-or-increment pattern.

### Practice PY-4

**Find the customer with the highest order count.**

Your attempt:
```python
top_customer = ''
highest_count = 0
for name, count in customer_counts.items():
    if count > highest_count:
        top_customer = name
        highest_count = count
print(top_customer)
```

Corrected / polished version:
```python
top_customer = max(customer_counts, key=customer_counts.get)
highest_count = customer_counts[top_customer]
print(top_customer, highest_count)
```

**Key lesson:** Your loop solution was correct and demonstrated the underlying algorithm. `max(..., key=...)` is the concise Python version.

### Practice PY-5

**Create functions for total revenue, highest price, and average price.**

Your attempt:
```python
def total_revenue():
    return sum([item['price'] for item in orders])

def highest_price():
    return max([item['price'] for item in orders])

def average_price():
    return sum([item['price'] for item in orders]) / len(orders)
```

Corrected / polished version:
```python
def total_revenue(orders):
    return sum(item['price'] for item in orders)

def highest_price(orders):
    return max(item['price'] for item in orders)

def average_price(orders):
    return total_revenue(orders) / len(orders)
```

**Key lesson:** Passing orders as a parameter makes each function reusable. Generator expressions avoid creating an unnecessary temporary list.

### Python Correction Log

- Use `print(function())` with parentheses; `print(function)` displays the function object.
- Use dictionary keys in quotes: `item['product']`, not `item[product]`, unless `product` is a defined variable.
- When a question asks who spent more than $500 overall, first aggregate each customer's purchases; filtering individual orders only answers who had a single purchase above $500.
- Use `return` inside reusable functions and `print` outside when you want to display the result.
- Prefer meaningful names such as `order`, `customer`, `revenue`, and `count`.

**Overall customer-spend pattern**
```python
customer_spend = {}
for order in orders:
    customer = order['customer']
    customer_spend[customer] = customer_spend.get(customer, 0) + order['price']

for customer, total in customer_spend.items():
    if total > 500:
        print(customer, total)
```

---

## PART III — PANDAS PRACTICE

> **Core pattern:** Start with a DataFrame, create or verify the needed columns, filter or group, aggregate the metric, then sort and select the final rows.

### Skills Practiced

- Boolean filtering
- Calculated Revenue columns
- groupby with sum, count, mean, and max
- sort_values and head for ranking
- Multiple metrics with agg
- inner, left, right, and outer merges
- Chained merges across orders, customers, and products

### Practice PD-1

**Create a Revenue column.**

Your attempt:
```python
orders['Revenue'] = orders['quantity'] * orders['price']
```

Corrected / polished version:
```python
orders['Revenue'] = orders['quantity'] * orders['price']
```

**Key lesson:** This was correct and became the foundation for most later Pandas analysis.

### Practice PD-2

**Filter orders from NYC.**

Your attempt:
```python
orders[orders['customer'] == 'NYC']
```

Corrected / polished version:
```python
orders[orders['city'] == 'NYC']
```

**Key lesson:** The filtering syntax was right; the column should match the meaning of NYC. It is normally a city value, not a customer name.

### Practice PD-3

**Calculate revenue by category.**

Your attempt:
```python
orders['category'].sum('Revenue')
```

Corrected / polished version:
```python
orders.groupby('category')['Revenue'].sum()
```

**Key lesson:** Select the grouping column in groupby, then select the numeric metric and apply the aggregate.

### Practice PD-4

**Rank customers by total revenue.**

Your attempt:
```python
orders.groupby('customer')['Revenue'].sum().sort_values(ascending=False)
```

Corrected / polished version:
```python
orders.groupby('customer')['Revenue'].sum().sort_values(ascending=False)
```

**Key lesson:** This was correct: group, aggregate, and sort descending.

### Practice PD-5

**Find the month with the highest average revenue.**

Your attempt:
```python
orders.groupby('month')['Revenue'].mean().sort_values(ascending=False).head(1)
```

Corrected / polished version:
```python
orders.groupby('month')['Revenue'].mean().sort_values(ascending=False).head(1)
```

**Key lesson:** This was correct. Always confirm whether the question wants average order revenue or total monthly revenue.

### Practice PD-6

**Summarize revenue by category with multiple metrics and return the top two categories by total revenue.**

Your attempt:
```python
orders.groupby('category').agg({'Revenue':['sum','count','mean','max']}).sort_values(by=('Revenue','sum') ascending=False).head(2)
```

Corrected / polished version:
```python
(orders.groupby('category')
 .agg({'Revenue': ['sum', 'count', 'mean', 'max']})
 .sort_values(by=('Revenue', 'sum'), ascending=False)
 .head(2))
```

**Key lesson:** Your multi-metric structure was right. The remaining fix was a comma after the `by` argument.

### Merge Practice

```python
# Keep only matching customers and orders
customers.merge(orders, on='customerID', how='inner')

# Keep every customer, even without an order
customers.merge(orders, on='customerID', how='left')

# Keep every row from both tables
customers.merge(orders, on='customerID', how='outer')
```

**Three-table analysis pattern**
```python
merged = (orders
          .merge(customers, on='customerID', how='left')
          .merge(products, on='productID', how='left'))

merged['Revenue'] = merged['quantity'] * merged['price']

top_customers = (merged.groupby('customer')['Revenue']
                  .sum()
                  .sort_values(ascending=False)
                  .head(3))
```

**Merge lesson:** Merge first when the calculation needs columns stored in different tables. Then calculate Revenue from columns in the merged DataFrame — not by multiplying two separate DataFrames that may have different row indexes.

### Pandas Correction Log

- Use `how='outer'`, not `how='full outer'`.
- Put column names in quotes: `on='customerID'`.
- Use `df.merge(other_df, on='key', how='left')`; `leftmerge` is not a Pandas method.
- After multi-metric agg, sort a MultiIndex column with `by=('Revenue', 'sum')`.
- Check whether a label belongs to customer, city, product, or category before filtering.
- Compute values after merging when required columns come from different tables.

---

## PART IV — BUSINESS ANALYSIS PRACTICE

### Retention and Customer-Value KPIs Developed

| KPI | What It Shows |
|---|---|
| **Total revenue per customer over time** | Total monetary contribution and whether value is growing or declining. |
| **Customer tenure** | How long a customer has maintained a relationship with the company. |
| **Number of orders** | Repeat behavior and purchasing frequency. |
| **Average order value** | Separates high-value purchases from frequent low-value purchases. |
| **Revenue trend / recency** | Identifies customers whose purchasing has slowed and who may be at risk. |

### Strongest Analysis Habit

Regularly moving beyond the code to ask what the result means for a decision — e.g., focusing retention spending on valuable or at-risk customers, evaluating Electronics versus Office Supplies performance, investigating weak months, and distinguishing a one-time high spender from a frequent repeat customer.

### A Reusable Interpretation Framework

- **Finding** — What does the result show?
- **Evidence** — Which metric, comparison, or trend supports it?
- **Context** — What time period, category, or customer behavior affects the conclusion?
- **Recommendation** — What action should the business test?
- **Caution** — What additional data would reduce uncertainty?

**Example:** Electronics generated the highest revenue in the observed period. Before recommending more inventory, verify profit margin, stockouts, returns, and whether the pattern persists across more months.

---

## PART V — REVIEW PLAN

### What You Already Do Well

- Translate business questions into SUM, AVG, COUNT, grouping, and ranking tasks.
- Understand that orders often serves as the bridge between customer and product data.
- Write correct core filters, calculated columns, and grouped revenue analyses.
- Explain customer value with more nuance than total revenue alone.
- Persist through syntax corrections and improve the same pattern on later attempts.

### Highest-Priority Improvements

- **SQL:** strengthen multi-table joins, CTEs, window functions, date functions, and conditional aggregation.
- **Python:** practice multi-step aggregation problems without relying on Pandas.
- **Pandas:** strengthen merges, multi-column groupby, named aggregation, missing values, dates, and time-series comparisons.
- **Analysis:** define each KPI precisely before coding and distinguish revenue, profit, price, and order value.

### Suggested Weekly Rotation

| Day | Focus | Output |
|---|---|---|
| **1** | SQL foundations | Five queries: filter, aggregate, group, rank, and HAVING. |
| **2** | Python logic | Three list-of-dictionary problems using loops, functions, and dictionaries. |
| **3** | Pandas analysis | Calculated column, groupby, agg, and ranking. |
| **4** | Joins and merges | Solve one three-table question in both SQL and Pandas. |
| **5** | Business case | Write a finding, evidence, recommendation, and caution. |
| **6** | Review | Retype corrections from memory and explain mistakes. |
| **7** | Portfolio | Add one polished query/notebook result to a project. |

---

## Next Challenge Set

### SQL

- Use a CTE to calculate monthly revenue, then compare each month with the previous month using LAG.
- Rank customers within each city by total revenue using a window function.
- Calculate revenue, order count, and average order value in one customer summary query.

### Python

- From a list of orders, calculate total revenue per customer and return the top three.
- Build a function that flags customers whose last two purchase totals decreased.
- Create a category summary containing revenue, order count, and average order value.

### Pandas

- Merge customers, orders, and products; calculate revenue; produce a city/category pivot table.
- Convert orderDate to datetime and calculate month-over-month revenue growth.
- Use named aggregation to create a customer KPI table, then flag high-value and at-risk segments.

---

## Quick-Reference Syntax

**SQL**
```sql
SELECT group_col, AGG(metric) AS alias
FROM table
WHERE row_condition
GROUP BY group_col
HAVING AGG(metric) > threshold
ORDER BY alias DESC
LIMIT n;
```

**Python**
```python
summary = {}
for record in records:
    key = record['key']
    value = record['value']
    summary[key] = summary.get(key, 0) + value
```

**Pandas**
```python
result = (df.groupby('group_col')
          .agg(total=('metric', 'sum'),
               count=('metric', 'count'),
               average=('metric', 'mean'))
          .sort_values('total', ascending=False))
```

---

*End of handbook*
