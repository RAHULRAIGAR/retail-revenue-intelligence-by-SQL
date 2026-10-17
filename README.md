
# Retail Revenue Intelligence — SQL & Excel Analytics

## Project Overview

Retail Revenue Intelligence is a portfolio project that uses PostgreSQL to analyze retail sales, product performance, profitability, customer behavior, and product returns. SQL query results are visualized in Microsoft Excel through charts and a dashboard.

## Tools & Technologies

- PostgreSQL
- pgAdmin 4
- SQL
- Microsoft Excel
- GitHub

## Dataset

This project uses a synthetic retail dataset covering January 2024 to October 2026.

- 1,200 customers
- 40 products across 5 categories
- 6,200 orders
- Order items with quantity, selling price, and discounts
- Returns with return reasons and refund amounts

The dataset is fictional and does not represent a real company.

## Project Files

### Data Files
- `customers.csv`
- `products.csv`
- `orders.csv`
- `order_items.csv`
- `returns.csv`

### SQL Scripts
- `01_create_tables.sql` — Creates database tables and relationships.
- `02_data_quality_checks.sql` — Checks data quality and identifies potential issues.
- `03_business_analysis.sql` — Business analysis queries using aggregations, joins, CTEs, and window functions.

### Excel Dashboard
- `Retail_Revenue_Intelligence.xlsx` — Excel workbook containing analysis data and visual charts.

## Business Analysis

The project answers questions such as:

1. How does revenue change month over month?
2. Which products generate the highest revenue?
3. Which product categories generate the most revenue and estimated profit?
4. Who are the highest-value customers?
5. What is the return rate and total refund amount?
6. How do product categories rank by estimated profit?

## Excel Visualizations

The Excel workbook includes charts for:

- Monthly revenue trends
- Category-wise revenue and estimated profit
- Top 10 products by revenue
- Top 10 customers by revenue

## Key SQL Concepts

- JOINs
- GROUP BY and aggregate functions
- CASE expressions
- Common Table Expressions (CTEs)
- Window functions and ranking
- Data quality checks
- Revenue and estimated profit calculations

## Database Setup

1. Create a PostgreSQL database in pgAdmin.
2. Execute `01_create_tables.sql`.
3. Import the CSV files in this order:
   `customers` → `products` → `orders` → `order_items` → `returns`.
4. Run `02_data_quality_checks.sql`.
5. Execute the business analysis queries in `03_business_analysis.sql`.
6. Export selected query results to CSV and use them in Excel.
7. Open the Excel workbook to explore the charts and dashboard.

## Metric Definitions

- Net sales before returns = quantity × unit price × (1 − discount percentage).
- Estimated product cost = quantity × unit cost.
- Estimated profit before returns = net sales before returns − estimated product cost.
- Cancelled orders should be excluded from realized revenue.
- Returns and refunds should be analyzed separately to avoid double counting.

## Author

Rahul Raigar

GitHub: https://github.com/RAHULRAIGAR
