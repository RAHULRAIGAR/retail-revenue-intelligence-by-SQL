-- Retail Revenue Intelligence | PostgreSQL
-- Step 1: Create database in pgAdmin, then connect to it and run this script.

CREATE TABLE customers (
    customer_id       INTEGER PRIMARY KEY,
    customer_name     TEXT,
    email             TEXT,
    city              TEXT,
    region            TEXT,
    signup_date       DATE,
    customer_segment  TEXT
);

CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  TEXT,
    category      TEXT,
    list_price    NUMERIC(12,2),
    unit_cost     NUMERIC(12,2),
    launch_date   DATE
);

CREATE TABLE orders (
    order_id       INTEGER PRIMARY KEY,
    customer_id    INTEGER REFERENCES customers(customer_id),
    order_date     DATE,
    order_status   TEXT,
    sales_channel  TEXT,
    payment_method TEXT
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER REFERENCES orders(order_id),
    product_id    INTEGER REFERENCES products(product_id),
    quantity      INTEGER,
    unit_price    NUMERIC(12,2),
    discount_pct  NUMERIC(6,4)
);

CREATE TABLE returns (
    return_id      INTEGER PRIMARY KEY,
    order_item_id  INTEGER REFERENCES order_items(order_item_id),
    return_date    DATE,
    return_reason  TEXT,
    refund_amount  NUMERIC(12,2)
);

-- Next: import CSV files using pgAdmin's Import/Export Data dialog.
-- Import order: customers, products, orders, order_items, returns.
-- For CSV import, set Header = Yes, Format = CSV, Encoding = UTF8.
