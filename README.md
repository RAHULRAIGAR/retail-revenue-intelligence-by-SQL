# Retail Revenue Intelligence — PostgreSQL Project

## Objective
Analyze retail sales, profitability, customer behavior, product performance, returns, and channel trends using PostgreSQL.

## Dataset
Synthetic fictional retail dataset covering Jan 2024–Oct 2026:
- 1,200 customers
- 40 products across 5 categories
- 6,200 orders
- Order line items with quantity, selling price, and discount
- Returns with reason and refund amount

## Files
- `customers.csv`
- `products.csv`
- `orders.csv`
- `order_items.csv`
- `returns.csv`
- `01_create_tables.sql`
- `02_data_quality_checks.sql`

## PostgreSQL setup
1. Create a database named `retail_revenue_intelligence` in pgAdmin.
2. Open Query Tool and execute `01_create_tables.sql`.
3. Import CSV files using pgAdmin Import/Export Data (Format CSV, Header Yes, UTF-8).
4. Import in this order: customers → products → orders → order_items → returns.
5. Execute `02_data_quality_checks.sql`.
6. Save findings before cleaning; document every rule used.

## Business questions
1. What are total gross sales, net sales, estimated gross profit, and margin?
2. Which categories and products contribute most to profit?
3. What is month-over-month revenue growth?
4. Who are the most valuable customers?
5. How do repeat-purchase and return rates vary?
6. Which sales channels and regions perform best?
7. How do discounts relate to margin?

## Important metric definitions
- Line gross sales = quantity × unit_price.
- Line net sales before returns = quantity × unit_price × (1 − discount_pct).
- Estimated product cost = quantity × unit_cost.
- Estimated gross profit before returns = line net sales − estimated product cost.
- For cancelled orders, exclude them from realized sales. Treat processing/shipped separately from delivered when defining realized revenue.
- Returns must be accounted for explicitly; do not subtract refunds twice.
- This dataset is synthetic and does not represent a real company.
