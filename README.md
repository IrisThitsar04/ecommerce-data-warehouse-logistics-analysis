# Marketplace Logistics & Seller Performance Analytics

## Project Overview
This project develops a business intelligence and data warehousing solution to analyse logistics performance, seller efficiency, and delivery reliability in an e-commerce marketplace.

Raw marketplace transaction data is processed through an analytics pipeline and transformed into a dimensional data warehouse. Data quality validation ensures integrity before the data powers interactive business intelligence dashboards. These dashboards evaluate revenue growth, shipping cost ratios, delivery delays, geographic delivery issues, and seller operational risk across the marketplace.

The final outputs include:
- **A star-schema data warehouse**
- **ETL pipeline with validation**
- **SQL analytical views**
- **Interactive dashboards**
- **Business insights derived from the analysis**

## Analytics Pipeline Overview

The project follows a layered data analytics architecture that transforms raw marketplace data into business intelligence insights.

Raw marketplace datasets are processed using Python for data preparation and feature engineering.  
Data quality validation is performed using Great Expectations before the cleaned data is loaded into a PostgreSQL dimensional data warehouse.

SQL analytical views provide a semantic layer that simplifies complex queries for business intelligence reporting.  
Finally, Tableau dashboards visualize marketplace logistics performance and seller operational efficiency.

**Pipeline Flow**

Raw Data → Python Processing → Data Validation → Data Warehouse (PostgreSQL) → SQL Views → Tableau Dashboards

## Data Architecture

The project uses a star schema warehouse design consisting of fact and dimension tables optimized for analytical queries.

### Dimension Tables

| Table         | Description                                         |
| ------------- | --------------------------------------------------- |
| dim_date      | Date dimension used for all timeline events   |
| dim_customer  | Customer attributes and geographic information      |
| dim_seller    | Marketplace seller information                      |
| dim_product   | Product attributes and category information         |
| dim_geography | Geographic location data (city, state, coordinates) |


### Fact Tables

| Table             | Description                                             |
| ----------------- | ------------------------------------------------------- |
| fact_orders       | Order-level information including delivery performance  |
| fact_order_items  | Individual order items including price and freight cost |
| fact_seller_order | Aggregated seller-level order metrics                   |

These fact tables capture marketplace activity at different levels of granularity:
- order-level events
- item-level transactions
- seller-level performance metrics


## Business Questions Addressed
### Primary Business Problem

How can a multi-seller e-commerce marketplace identify seller and logistics inefficiencies that negatively impact operational efficiency, delivery reliability, and customer experience?

### Supplementary Analytical Questions

- Which high-revenue sellers exhibit inefficient logistics performance when shipping costs and delivery reliability are considered?

- Which sellers exhibit the highest late delivery rates and shipping cost inefficiencies that contribute to operational risk in the marketplace?

- How concentrated is marketplace revenue among sellers, and what operational risks may arise from this concentration?

- Which product categories exhibit the highest shipping cost relative to product value, and what does this indicate about logistics efficiency across product types?

- Which customer regions experience the highest frequency of delivery issues?

These analytical questions are addressed through two business intelligence dashboards.

The **Marketplace Logistics Performance** dashboard examines revenue trends, shipping cost ratios by product category, delivery delays, and geographic delivery issues.

The **Seller Operational Efficiency** dashboard analyzes seller freight ratios and late delivery rates to classify seller risk levels, examine revenue concentration among sellers, and identify high-risk sellers impacting marketplace operations.

## Exploratory Data Analysis (EDA)

Exploratory Data Analysis was conducted to understand the structure and quality of the raw marketplace datasets before building the analytical pipeline through several checks:

- **Structural inspection of datasets**, including column meanings, table relationships, and dataset sizes
- **Value range analysis**, examining minimum and maximum values for numerical fields and timestamp columns to understand data coverage
- **Categorical analysis**, reviewing unique values and frequency distributions for fields such as order status, payment type, and other categorical variables
- **Missing value analysis**, identifying missing fields and assessing whether they reflected expected operational scenarios (e.g., cancelled orders or optional review comments)
- **Geographic data validation**, verifying consistency of latitude and longitude records in geolocation data
- **Logical consistency checks**, validating relationships between related fields such as review comments and response timestamps

These checks helped confirm dataset structure, understand missing data patterns, and ensure the data could be reliably prepared for feature engineering and warehouse integration.

## Data Processing Pipeline

The analytical pipeline follows these stages:

### 1. Data Preparation & Transformation

Raw datasets were prepared and transformed to ensure they could be integrated into the analytical data warehouse.

Key steps included:

- Converting timestamp fields to proper datetime formats
- Standardizing categorical values such as order status indicators and delivery flags  
- Aggregating geographic coordinates by ZIP code prefix to construct the geography dimension  
- Engineering derived features such as delivery duration and delivery delay indicators  
- Preparing intermediate datasets for loading into dimension and fact tables

### 2. Feature Engineering

Additional variables were derived to support logistics analytics.

Examples:
- delivery_duration_days
- delivery_delay_days
- is_delivered_flag
- is_late_delivery
- is_failed_order
- issue_flag

These features allow direct measurement of delivery performance and operational risk.

### 3. Data Validation (Great Expectations)

Data quality validation was performed before loading the data into the warehouse.

Validation rules ensured:
- Uniqueness of primary or composite identifiers
- Non-null constraints for required fields
- Valid numeric ranges for quantitative attributes
- Correct data types for fields such as timestamps
- Valid categorical values and formats (e.g., payment types and state codes)

This step prevents incomplete, inconsistent, or invalid data from entering the analytical layer.

### 4. Loading Data into the Data Warehouse

After validation, cleaned datasets were loaded into:

- Dimension tables
- Fact tables

Surrogate keys were used for efficient joins and analytical querying.


## Analytical SQL Views (Semantic Layer)

To simplify analytical queries and support BI reporting, several SQL views were created:

| View                            | Purpose                                                                            |
| ------------------------------- | ---------------------------------------------------------------------------------- |
| seller_freight_ratio      | Freight cost as a percentage of product revenue for each seller.                    |
| seller_late_delivery_rate   | Late delivery rate for each seller.                                                |
| category_revenue            | Total revenue by product category.                                                 |
| customer_issue_rate         | Delivery issue rate (late or failed orders) by customer state.                     |
| seller_performance          | Combined seller metrics including revenue, freight cost, and delivery performance. |
| seller_revenue              | Total revenue generated by each seller.                                            |
| category_late_delivery_rate | Late delivery rate by product category.                                            |
| order_item_analytics        | Fully joined analytical dataset used for dashboard queries.                        |
These views simplify complex queries and allow BI tools to directly access prepared analytical metrics.

## Dashboard 1: Marketplace Logistics Performance

### Purpose

This dashboard evaluates overall marketplace logistics performance, focusing on delivery reliability, shipping cost efficiency, and revenue trends across the platform.

### Key Metrics

The dashboard includes high-level KPIs summarizing operational performance:

- **Total Revenue**: €13.59M
- **On-Time Delivery Rate**: 92.26%
- **Order Issue Rate**: 8.22%
- **Average Delivery Delay**: 1 day

### Main Analyses

The dashboard includes several analytical visualizations:

- **Revenue Trend Analysis** : Monthly marketplace revenue growth
- **Shipping Cost Efficiency by Product Category** : Freight cost as a percentage of product revenue
- **Delivery Issue Distribution by State** : Geographic variation in delivery issues
- **Delivery Delay Severity Distribution** : Breakdown of delay durations across orders

### Key Insights

**Revenue Growth**: 
Marketplace revenue increased significantly between 2016 and 2018, indicating rapid platform expansion and increasing transaction volume.

**Shipping Cost Efficiency by Product Category**: 
Shipping cost ratios vary considerably across product categories. Several categories exceed 20% of product revenue, particularly furniture and home-related items that require larger or more fragile shipping.

**Geographic Distribution of Delivery Issues**: 
Delivery issue rates vary across states, with some regions exceeding 20%. Late deliveries are the primary contributor to these issues.

**Delivery Delay Severity**: 
Although the majority of orders are delivered on time, approximately 3% of deliveries experience delays exceeding seven days, which may negatively impact customer satisfaction.

## Dashboard 2: Seller Operational Efficiency & Risk Analysis
### Purpose

This dashboard evaluates seller logistics performance across the marketplace, focusing on shipping cost efficiency, delivery reliability, and operational risk among sellers.

### Key Metrics

The dashboard includes high-level KPIs summarizing seller operational performance:
- **Total Active Sellers**: 3,095
- **Average Freight Ratio**: 16.57%
- **Average Late Delivery Rate**: 7.74%
- **High-Risk Sellers**: 16.19%

### Main Analyses

The dashboard includes several analytical visualizations:
- **Revenue Concentration Analysis** : Revenue contribution of the top marketplace sellers
- **Seller Operational Efficiency Matrix** : Scatter plot comparing freight ratio and late delivery rate to classify seller risk levels
- **Top High-Risk Sellers** : Ranked list of sellers with the highest logistics risk based on shipping cost ratios and delivery delays
- **Revenue Distribution by Seller Risk Level** : Comparison of marketplace revenue generated by sellers across different operational risk categories

### Key Insights

**Revenue Concentration:**
The top 20 sellers generate approximately 21.09% of total marketplace revenue, indicating a moderate concentration of revenue among high-performing sellers.

**Seller Operational Efficiency:**
Seller logistics performance varies significantly across the marketplace. Some sellers operate with low shipping costs and reliable delivery performance, while others show inefficiencies such as high freight ratios or delivery delays.

**High-Risk Sellers:**
Several sellers exceed the 17% freight ratio benchmark, with some cases where shipping costs exceed the value of the product itself. These sellers represent operational risk due to inefficient logistics relative to product value.

**Revenue by Seller Risk Level:**
Efficient sellers generate the largest share of marketplace revenue, contributing approximately €4.5M. Sellers classified as High Delay Risk and High Shipping Cost still contribute substantial revenue, while sellers categorized as High Risk generate the smallest share.

## Technologies Used

- **Data Processing**: Python (pandas, numpy)
- **Data Storage**: PostgreSQL
- **Data Validation**: Great Expectations
- **Business Intelligence**: Tableau Desktop
- **Development Environment**: Jupyter Notebook
