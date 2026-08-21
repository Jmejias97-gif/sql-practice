-- Seed data for the practice database.
-- Run against a fresh SQLite database to reproduce every query in this repository:
--   sqlite3 practice.db < schema/seed.sql

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER,
    region       TEXT,
    order_date   TEXT,
    order_amount REAL
);

INSERT INTO orders VALUES
    (1,  101, 'West',  '2025-01-05', 240.00),
    (2,  102, 'West',  '2025-01-09',  89.50),
    (3,  101, 'West',  '2025-02-14', 310.25),
    (4,  103, 'West',  '2025-02-20',  55.00),
    (5,  104, 'West',  '2025-03-01', 420.00),
    (6,  102, 'West',  '2025-03-15', 175.00),
    (7,  201, 'East',  '2025-01-11', 610.00),
    (8,  202, 'East',  '2025-01-22',  95.00),
    (9,  201, 'East',  '2025-02-02', 275.50),
    (10, 203, 'East',  '2025-02-18', 130.00),
    (11, 204, 'East',  '2025-03-05', 340.00),
    (12, 202, 'East',  '2025-03-19',  60.00),
    (13, 301, 'South', '2025-01-08', 150.00),
    (14, 302, 'South', '2025-01-30', 420.75),
    (15, 301, 'South', '2025-02-11', 210.00),
    (16, 303, 'South', '2025-02-25',  95.00),
    (17, 304, 'South', '2025-03-09', 500.00),
    (18, 302, 'South', '2025-03-22',  60.00),
    (19, 401, 'North', '2025-01-14', 330.00),
    (20, 402, 'North', '2025-02-01', 145.00),
    (21, 401, 'North', '2025-02-27', 275.00),
    (22, 403, 'North', '2025-03-12',  80.00),
    (23, 101, 'West',  '2025-04-01', 450.00),
    (24, 201, 'East',  '2025-04-05', 150.00),
    (25, 402, 'North', '2025-01-20', 200.00),
    (26, 402, 'North', '2025-02-15', 250.00),
    (27, 402, 'North', '2025-03-25', 300.00);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    department  TEXT,
    hire_date   TEXT,
    salary      REAL
);

INSERT INTO employees VALUES
    (1,  'Engineering', '2018-03-01', 98000),
    (2,  'Engineering', '2019-07-15', 91000),
    (3,  'Engineering', '2020-01-10', 87000),
    (4,  'Engineering', '2021-05-22', 82000),
    (5,  'Engineering', '2022-02-14', 79000),
    (6,  'Engineering', '2023-06-01', 75000),
    (7,  'Engineering', '2023-11-19', 73000),
    (8,  'Sales',       '2019-04-01', 68000),
    (9,  'Sales',       '2020-09-12', 65000),
    (10, 'Sales',       '2022-03-03', 60000),
    (11, 'Marketing',   '2021-01-20', 62000),
    (12, 'Marketing',   '2022-08-08', 58000),
    (13, 'HR',          '2017-06-01', 71000),
    (14, 'HR',          '2020-02-17', 64000),
    (15, 'HR',          '2021-09-09', 60000),
    (16, 'HR',          '2022-04-04', 57000),
    (17, 'HR',          '2023-01-01', 55000),
    (18, 'HR',          '2023-08-15', 53000);
