# 🛒 E-commerce Analytics with PostgreSQL and Power BI

# 📌 Project Overview

End-to-end e-commerce analytics solution built using PostgreSQL as the analytical data warehouse and Power BI for visualization and business reporting.

Designed using a star schema to support scalable reporting, performant joins, and ad-hoc analytical queries.

Transforms raw transactional data into analytics-ready dimension and fact tables, enabling robust business intelligence and time-series analysis.

# 🗂️ Schema Architecture
# 🔹 Raw Schema (raw_schema)

Stores source-aligned transactional data with minimal transformation.

customers – customer master and demographic data

category – product category reference data

products – product master data including pricing and inventory

orders – customer order headers

order_items – order-level line items

# 🔹 Analytics Schema (analytics_schema)

Optimized for reporting, aggregation, and BI consumption.

# 📐 Dimension Tables
## dim_customers

Customer profile and demographic attributes:

Age and age group derivations

Customer tenure and lifecycle stage

Loyalty and repeat-purchase segmentation

## dim_products

Denormalized product and category dimension:

Product and category attributes

Sale price, cost price, profit per unit

Margin percentage calculations

Stock status and price tier segmentation

## dim_date

Centralized calendar dimension supporting time-series analysis:

Date, year, quarter, month, week, and weekday

Weekend vs. weekday flags

Seasonality indicators

Holiday flags (configurable)

# 📊 Fact Table
## fact_sales

Grain: One row per order item per order per day

Derived from:

orders

order_items

dim_products

dim_customers

dim_date

Key metrics:

Gross sales amount

Net sales amount

Discount value

Cost and profit

Margin analysis

Order size classification (small / medium / large)

# ⭐ Key Features

Star schema–based analytical data model

Production-ready PostgreSQL SQL

Data cleansing and standardization logic

Business-driven feature engineering

Surrogate keys and date-key-based analysis

Optimized for Power BI ingestion and performance

Supports incremental refresh and slicing across dimensions

# Key Business Insights
## 🔹 Overview & Revenue Intelligence

Month-wise Total Sales, Previous Month Sales, MoM Change & MoM %

Net Sales by Order Size (Single, Small, Bulk orders)

Net Sales by Margin Category to assess revenue quality

City-wise Gross Sales, Net Sales, Net Profit & Profit % for regional performance analysis

👉 Helps leadership track growth momentum, profitability, and geographic concentration risk.

## 🔹 Product Performance Analysis

Product-wise COGS, Net Sales, Net Profit & Profit %

Top 5 Products by Net Sales and by Profit (not always the same)

Price Segment vs Net Sales (Luxury, Premium, Economy performance)

Top 5 Category Revenue Share % to understand category dependency

👉 Enables pricing optimization, assortment strategy, and margin protection decisions.

## 🔹 Customer Performance & Engagement

Customer-wise Total Orders, AOV, Purchase Quantity & CLTV

Customer Price Segment Affinity with AOV and Total Spend

Distinct Products Purchased & Engagement Level (Single vs Multi-product buyers)

Net Sales by Age Group for targeted marketing insights

👉 Highlights high-value customers, cross-sell opportunities, and retention focus areas.

# 📈 Analytics Use Cases

Sales, revenue, and growth trend analysis

Product and category performance evaluation

Customer purchasing behavior and cohort analysis

Discount effectiveness and pricing impact analysis

Profitability and margin reporting

Executive-level KPI dashboards in Power BI

# 🛠️ Technology Stack

PostgreSQL (Data Warehouse & Analytics Layer)

SQL (Transformations and Feature Engineering)

Power BI (Data Modeling, DAX, Dashboards & Reporting)

# 📌 Purpose

Demonstrates real-world analytics engineering and BI modeling concepts

Suitable for data analyst, BI developer, and analytics engineer portfolios

Designed for interview-ready business and technical discussions

Showcases end-to-end pipeline from raw data to executive dashboards
