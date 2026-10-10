# Grocery_Store
## Project Overview
This repository contains a relational database schema and a robust set of SQL queries designed to manage and analyze operations for a grocery store. The project covers data integrity checks, data cleaning, and deep analytical insights spanning customer behavior, product performance, sales trends, supplier contributions, and employee metrics.

## Database Schema & Architecture:
The database consists of 7 core relational tables designed to handle inventory, staff, suppliers, and transactions:

supplier: Stores supplier details (ID, name, address).

categories: Categorizes products into groups (ID, name).

employees: Tracks store staff and hire dates.

customers: Manages customer contact and address details.

products: Maintains item catalogs, pricing, and foreign keys linked to suppliers and categories.

orders: Records order transactions tied to customers and employees.

order_details: Itemized breakdown of each order, including quantities, unit prices, and total calculations.

## Data Quality & Integrity Checks
Before running analytical queries, the script performs data validation checks:

Primary Key Verification: Scans for duplicate entries across all table primary keys.

NULL Value Audits: Ensures mandatory fields across tables do not contain missing values.

Foreign Key Integrity: Validates referential integrity using LEFT JOIN checks to spot orphaned records.

## Key Analytical Insights Covered
The SQL script provides actionable business metrics across several domains:

Customer Insights

Tracks unique customer counts and identifies top-tier buyers by total purchase amount using window functions (DENSE_RANK()).

Calculates total and average purchase value per customer.

Product Performance

Evaluates inventory distribution and average pricing across categories.

Identifies top-selling products by volume and total revenue generated (using custom SQL views like product_sales_summary).

Analyzes sales variations grouped by category and supplier.

Sales & Order Trends

Computes overall order volume, average order values, and peak ordering dates.

Breaks down monthly revenue trends and compares weekday versus weekend purchasing patterns.

Supplier Contribution

Determines which suppliers provide the highest product counts and drive the most revenue.

Employee Performance

Measures active employee workload, total sales processed, and average order values handled per staff member.

Order Details Deep Dive

Examines relationships between quantities ordered, catalog unit prices, and actual total prices.

## Tech Stack & Prerequisites
DBMS: MySQL / Relational Database Management System compatible with standard SQL.

Tools: Any SQL client (MySQL Workbench, DBeaver, VS Code with SQL extensions).
