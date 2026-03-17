CREATE TABLE dim.dim_date(
date_sk INT NOT NULL PRIMARY KEY,
full_date DATE NOT NULL UNIQUE,
day SMALLINT NOT NULL,
month SMALLINT NOT NULL,
month_name VARCHAR(20) NOT NULL,
quarter SMALLINT NOT NULL,
year SMALLINT NOT NULL,
day_of_week SMALLINT NOT NULL,
is_weekend BOOLEAN NOT NULL
);


CREATE TABLE dim.dim_geography(
geo_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
zip_code_prefix INT NOT NULL UNIQUE,
city VARCHAR(100),
state VARCHAR(50),
lat DOUBLE PRECISION NULL,
lng DOUBLE PRECISION NULL
);


CREATE TABLE dim.dim_customer(
customer_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_unique_id VARCHAR(100) NOT NULL UNIQUE,
customer_zip_code_prefix INT,
customer_city VARCHAR(100),
customer_state VARCHAR(50),
customer_geo_sk INT,
CONSTRAINT fk_customer_geo FOREIGN KEY(customer_geo_sk) REFERENCES dim.dim_geography(geo_sk)
);


CREATE TABLE dim.dim_seller(
seller_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
seller_id VARCHAR(100) NOT NULL UNIQUE,
seller_zip_code_prefix INT,
seller_city VARCHAR(100),
seller_state VARCHAR(50),
seller_geo_sk INT,
CONSTRAINT fk_seller_geo
FOREIGN KEY (seller_geo_sk)
REFERENCES dim.dim_geography(geo_sk)
);



CREATE TABLE dim.dim_product(
product_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
product_id VARCHAR(100) NOT NULL UNIQUE,
product_category_name VARCHAR(100),
product_category_name_english VARCHAR(100),
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT,
product_photos_qty INT,
product_name_length INT,
product_description_length INT
);


CREATE TABLE fact.fact_orders (
    order_id VARCHAR(100) NOT NULL PRIMARY KEY,
    customer_id VARCHAR(100) NOT NULL,

    customer_sk INT NOT NULL,
    purchase_date_sk INT NOT NULL,
    approved_date_sk INT,
    carrier_handoff_date_sk INT,
    delivered_customer_date_sk INT,
    estimated_delivery_date_sk INT NOT NULL,

    order_status VARCHAR(50) NOT NULL,

    delivery_duration_days DOUBLE PRECISION,
    delivery_delay_days DOUBLE PRECISION,

    is_delivered_flag BOOLEAN NOT NULL,
    is_late_delivery BOOLEAN NOT NULL,
    is_failed_order BOOLEAN NOT NULL,
    issue_flag BOOLEAN NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dim.dim_customer(customer_sk),

    CONSTRAINT fk_orders_purchase_date
        FOREIGN KEY (purchase_date_sk)
        REFERENCES dim.dim_date(date_sk),

    CONSTRAINT fk_orders_approved_date
        FOREIGN KEY (approved_date_sk)
        REFERENCES dim.dim_date(date_sk),

    CONSTRAINT fk_orders_carrier_date
        FOREIGN KEY (carrier_handoff_date_sk)
        REFERENCES dim.dim_date(date_sk),

    CONSTRAINT fk_orders_delivered_date
        FOREIGN KEY (delivered_customer_date_sk)
        REFERENCES dim.dim_date(date_sk),

    CONSTRAINT fk_orders_estimated_date
        FOREIGN KEY (estimated_delivery_date_sk)
        REFERENCES dim.dim_date(date_sk)
);



CREATE TABLE fact.fact_order_items(
order_id VARCHAR(100) NOT NULL,
order_item_id INT NOT NULL,

product_sk INT NOT NULL,
seller_sk INT NOT NULL,
customer_sk INT NOT NULL,
purchase_date_sk INT NOT NULL,
shipping_limit_date_sk INT NOT NULL,

price DOUBLE PRECISION NOT NULL,
freight_value DOUBLE PRECISION NOT NULL,
item_total_value DOUBLE PRECISION NOT NULL,

CONSTRAINT pk_fact_order_items
    PRIMARY KEY (order_id, order_item_id),

CONSTRAINT fk_items_seller
    FOREIGN KEY (seller_sk)
    REFERENCES dim.dim_seller(seller_sk),

CONSTRAINT fk_items_product
    FOREIGN KEY (product_sk)
    REFERENCES dim.dim_product(product_sk),

CONSTRAINT fk_items_customer
    FOREIGN KEY (customer_sk)
    REFERENCES dim.dim_customer(customer_sk),

CONSTRAINT fk_items_purchase_date
    FOREIGN KEY (purchase_date_sk)
    REFERENCES dim.dim_date(date_sk),

CONSTRAINT fk_items_shipping_date
    FOREIGN KEY (shipping_limit_date_sk)
    REFERENCES dim.dim_date(date_sk)
);



CREATE TABLE fact.fact_seller_order(
    order_id    VARCHAR(100) NOT NULL,
    seller_sk   INT NOT NULL,

    customer_sk       INT NOT NULL,
    purchase_date_sk  INT NOT NULL,

    seller_order_revenue     DOUBLE PRECISION NOT NULL,
    seller_order_freight     DOUBLE PRECISION NOT NULL,
    seller_order_items_count INT NOT NULL,

    is_delivered_flag   BOOLEAN NOT NULL,
    is_late_delivery    BOOLEAN NOT NULL,
    is_failed_order     BOOLEAN NOT NULL,
    delivery_delay_days DOUBLE PRECISION NOT NULL,
    
    CONSTRAINT pk_fact_seller_order
        PRIMARY KEY (order_id, seller_sk),

    CONSTRAINT fk_seller_order_seller
        FOREIGN KEY (seller_sk)
        REFERENCES dim.dim_seller(seller_sk),

    CONSTRAINT fk_seller_order_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dim.dim_customer(customer_sk),

    CONSTRAINT fk_seller_order_purchase_date
        FOREIGN KEY (purchase_date_sk)
        REFERENCES dim.dim_date(date_sk)
);



