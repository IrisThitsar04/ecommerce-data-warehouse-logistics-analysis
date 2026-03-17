# Marketplace Logistics & Seller Performance Analytics

## Project Overview

This project develops a business intelligence and data warehousing solution to analyze logistics performance, seller efficiency, and delivery reliability in a multi-seller e-commerce marketplace.

The analysis is based on the **Olist E-commerce dataset**, which includes nine relational datasets:

- `olist_orders_dataset`
- `olist_order_items_dataset`
- `olist_order_payments_dataset`
- `olist_order_reviews_dataset`
- `olist_customers_dataset`
- `olist_sellers_dataset`
- `olist_products_dataset`
- `olist_geolocation_dataset`
- `product_category_name_translation_dataset`

These datasets capture marketplace transactions, customer activity, product information, seller operations, payments, reviews, and geographic data.

The project integrates these datasets into a **dimensional data warehouse** and develops business intelligence dashboards to analyze marketplace logistics performance, delivery reliability, and seller operational efficiency.

The final outputs include:

- **Star-schema data warehouse**
- **Data preparation and validation pipeline**
- **SQL analytical views**
- **Interactive Tableau dashboards**
- **Business insights derived from the analysis**

## Analytics Pipeline Overview

The project follows a layered data analytics architecture that transforms raw marketplace data into business intelligence insights.

- Raw marketplace datasets are processed using Python for data preparation and feature engineering.  

- Data quality validation is performed using Great Expectations before the cleaned data is loaded into a PostgreSQL dimensional data warehouse.

- SQL analytical views provide a semantic layer that simplifies complex queries for business intelligence reporting. 

- Finally, Tableau dashboards visualize marketplace logistics performance and seller operational efficiency.

**Pipeline Flow:**
Raw Data -> Data Preparation (Python) -> Data Validation -> Data Warehouse (PostgreSQL) -> SQL Views -> Tableau Dashboards

## Business Questions Addressed
### Primary Business Problem

How can a multi-seller e-commerce marketplace identify seller and logistics inefficiencies that negatively impact operational efficiency, delivery reliability, and customer experience?

### Supplementary Analytical Questions

- Which high-revenue sellers exhibit inefficient logistics performance when shipping costs and delivery reliability are considered?

- Which sellers exhibit the highest late delivery rates and shipping cost inefficiencies that contribute to operational risk in the marketplace?

- How concentrated is marketplace revenue among sellers, and what operational risks may arise from this concentration?

- Which product categories exhibit the highest shipping cost relative to product value, and what does this indicate about logistics efficiency across product types?

- Which customer regions experience the highest frequency of delivery issues?

## Exploratory Data Analysis (EDA)

Exploratory Data Analysis (EDA) was conducted to understand the structure and quality of the raw marketplace datasets before building the analytical pipeline.

Key checks included:

- **Dataset structure inspection**, reviewing column meanings, table relationships, and dataset sizes  
- **Value range analysis**, examining minimum and maximum values for numerical fields and timestamps  
- **Categorical analysis**, assessing unique values and frequency distributions for fields such as order status and payment types  
- **Missing value analysis**, identifying missing fields and evaluating whether they reflected expected operational scenarios (e.g., cancelled orders or optional reviews)  
- **Geographic validation**, verifying consistency of latitude and longitude records in geolocation data  
- **Logical consistency checks**, validating relationships between related fields such as review comments and response timestamps  

These checks ensured the data structure and quality were understood before feature engineering and warehouse integration.

## Data Architecture

The project uses a star schema warehouse design consisting of fact and dimension tables optimized for analytical queries.
![Schema](warehouse_schema.png)
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
| seller_freight_ratio      | Freight cost as a percentage of product revenue for each seller.                     |
| seller_late_delivery_rate   | Late delivery rate for each seller.                                                |
| category_revenue            | Total revenue by product category.                                                 |
| customer_issue_rate         | Delivery issue rate (late or failed orders) by customer state.                     |
| seller_performance          | Combined seller metrics including revenue, freight cost, and delivery performance. |
| seller_revenue              | Total revenue generated by each seller.                                            |
| category_late_delivery_rate | Late delivery rate by product category.                                            |
| order_item_analytics        | Fully joined analytical dataset used for dashboard queries.                        |
These views simplify complex queries and allow BI tools to directly access prepared analytical metrics. The `order_item_analytics` view serves as the **primary analytical dataset for the dashboards**, combining order, product, seller, customer, and delivery information into a single queryable structure for business intelligence analysis.

## Dashboard 1: Marketplace Logistics Performance
![Dashboard 1](dashboards/dashboard1.png)
### Purpose
This dashboard provides a high-level view of marketplace logistics performance. It enables analysis of revenue growth, delivery reliability, and shipping cost efficiency across product categories and geographic regions. It is designed to identify where delivery issues and logistics inefficiencies occur within the marketplace.

### Key Metrics

The dashboard includes high-level KPIs summarizing operational performance:

- **Total Revenue**: €13.59M
- **On-Time Delivery Rate**: 92.26%
- **Order Issue Rate**: 8.22%
- **Average Delivery Delay**: 1 day

### Main Analyses

The dashboard includes several analytical visualizations:

- **Marketplace Revenue Growth Over Time** : Yearly marketplace revenue growth
- **Shipping Cost vs Revenue by Top 10 Product Categories** : Freight cost as a percentage of product revenue across major product categories
- **Order Issue Rate by Customer State** : Geographic variation in delivery issues (late deliveries or failed orders)
- **Order Distribution by Delivery Delay** : Breakdown of delivery delay ranges across orders
  
### Key Insights

**Marketplace Revenue Growth Over Time**: 
Marketplace revenue increased substantially between 2016 and 2017 and continued to grow in 2018. This trend indicates rapid platform expansion, indicating increased transaction volume and marketplace activity over time.

**Shipping Cost vs Revenue by Top 10 Product Categories**: 
Shipping costs vary significantly across product categories. Several categories exceed 20% of product revenue, with the highest reaching approximately 24%. Categories such as furniture_decor, housewares, garden_tools, and bed_bath_table show the highest shipping ratios, likely due to larger or more fragile items requiring specialized packaging and transportation.

**Order Issue Rate by Customer State**: 
Delivery issue rates vary considerably across customer states. The two states with the highest issue rates exceed 20%, while most other states show lower but still notable issue levels. Late deliveries occur more frequently than failed orders, indicating that delivery delays are the primary contributor to order issues.

**Order Distribution by Delivery Delay**: 
Overall delivery performance is strong, with 93.55% of orders delivered on time or early. However, a small proportion of deliveries experience delays:
* 0–1 day delay: 0.83% of orders
* 1–3 days delay: 1.04%
* 3–7 days delay: 1.78%
* 7+ days delay: 2.79%
  
Although delayed deliveries represent a relatively small share of total orders, delays exceeding seven days account for nearly 3% of deliveries, which may significantly impact customer satisfaction.

## Dashboard 2: Seller Operational Efficiency & Risk Analysis
![Dashboard 2](dashboards/dashboard2.png)
### Purpose
This dashboard analyzes seller-level logistics performance to identify operational inefficiencies and classify sellers based on shipping cost and delivery reliability.
It supports the identification of high-risk sellers and evaluates how seller performance impacts overall marketplace revenue and operational risk.

### Key Metrics
The dashboard includes high-level KPIs summarizing seller operational performance:
- **Total Active Sellers**: 3,095
- **Average Freight Ratio**: 16.57%
- **Average Late Delivery Rate**: 7.74%
- **High-Risk Sellers**: 16.19%

### Main Analyses
The dashboard includes several analytical visualizations:
- **Revenue Concentration Among Top 20 Sellers** : Revenue contribution of the highest-performing marketplace sellers
- **Seller Operational Efficiency Matrix** : Scatter plot comparing freight ratio and late delivery rate to classify seller risk levels
- **Top High-Risk Sellers** : Ranked list of sellers with the highest logistics risk based on shipping cost ratios and delivery delays
- **Revenue Distribution by Seller Risk Level** : Comparison of revenue generated by sellers across different operational risk categories

### Key Insights

**Revenue Concentration Among Top 20 Sellers:**
Approximately 21.09% of total marketplace revenue is generated by the top 20 sellers. This indicates moderate revenue concentration, where a relatively small group of sellers contributes a substantial share of platform revenue.

**Seller Operational Efficiency:**
Seller logistics performance varies considerably across the marketplace. While many sellers maintain low freight ratios and reliable delivery performance, others exhibit both high shipping costs and high late delivery rates, placing them in the high-risk operational quadrant.

**Top High-Risk Sellers:**
The analysis of the top high-risk sellers shows that many exceed the 17% freight ratio benchmark, often by a substantial margin. In several cases, shipping costs exceed the value of the product itself, with some sellers exceeding 100% freight-to-revenue ratios. This indicates inefficient logistics relative to product value.

**Revenue by Seller Risk Level:**
Efficient sellers generate the largest share of marketplace revenue, contributing approximately €4.5M. Sellers classified as High Delay Risk and High Shipping Cost generate similar revenue levels (around €3.4M and €3.3M respectively), while High-Risk sellers contribute the smallest share (approximately €2.3–€2.5M).
This suggests that operational inefficiencies persist even among sellers generating meaningful revenue, highlighting opportunities to improve overall marketplace logistics efficiency.

## Linking Insights to Business Questions

The two dashboards collectively address the analytical questions defined earlier.

- The **Marketplace Logistics Performance dashboard** provides a marketplace-level perspective on delivery reliability, shipping efficiency, and geographic distribution of delivery issues.

- The **Seller Operational Efficiency dashboard** provides a seller-level perspective, identifying high-risk sellers and evaluating how logistics inefficiencies impact revenue contribution.

Together, these dashboards connect operational performance with business impact, enabling identification of inefficiencies at both marketplace and seller levels.

## Technologies Used

- **Data Processing**: Python (pandas, numpy)
- **Data Storage**: PostgreSQL
- **Data Validation**: Great Expectations
- **Business Intelligence**: Tableau Desktop
- **Development Environment**: Jupyter Notebook

## Conclusion

This project demonstrates how raw e-commerce data can be transformed into a structured analytical solution using a dimensional data warehouse and business intelligence dashboards.

By integrating multiple datasets, validating data quality, and modeling key performance metrics, the analysis provides actionable insights into logistics efficiency, delivery reliability, and seller performance.

While overall marketplace performance is strong, the results highlight that operational inefficiencies persist among certain sellers and product categories, presenting clear opportunities for targeted optimization.
