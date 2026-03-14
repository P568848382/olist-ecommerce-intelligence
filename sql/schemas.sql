-- ============================================================
-- Olist E-Commerce Intelligence — Database Schema
-- Author:Pradeep Kumar
-- Created: 2026
-- Description: Star schema for Brazilian e-commerce analysis
-- ============================================================

-- Drop tables if they exist (useful for re-running)
DROP TABLE IF EXISTS order_reviews CASCADE;
DROP TABLE IF EXISTS order_payments CASCADE;
DROP TABLE IF EXISTS order_itemst CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS sellers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS geolocation CASCADE;
DROP TABLE IF EXISTS product_category_translation CASCADE;

-- 1. Customers dimension
CREATE TABLE customers (
    customer_id            VARCHAR(50) PRIMARY KEY, 
    customer_unique_id     VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city          VARCHAR(100),
    customer_state         VARCHAR(5)
);

-- 2. Sellers dimension
CREATE TABLE sellers (
    seller_id         VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city       VARCHAR(100),
    seller_state      VARCHAR(5)
);

-- 3. Product category translation
CREATE TABLE product_category_translation (
    product_category_name            VARCHAR(100) PRIMARY KEY,
    product_category_name_english    VARCHAR(100)
);

-- 4. Products dimension
CREATE TABLE products (
    product_id                 VARCHAR(50) PRIMARY KEY,
    product_category_name      VARCHAR(100),
    product_name_length        INT,
    product_description_length INT,
    product_photos_qty         INT,
    product_weight_g           NUMERIC,
    product_length_cm          NUMERIC,
    product_height_cm          NUMERIC,
    product_width_cm           NUMERIC,
    FOREIGN KEY (product_category_name)
        REFERENCES product_category_translation(product_category_name)
);

-- 5. Geolocation (reference table)
CREATE TABLE geolocation (
    geolocation_zip_code_prefix  VARCHAR(10),
    geolocation_lat       NUMERIC(10,6),
    geolocation_lng       NUMERIC(10,6),
    geolocation_city      VARCHAR(100),
    geolocation_state     VARCHAR(5)
);

-- 6. Orders — the central FACT table
CREATE TABLE orders (
    order_id                      VARCHAR(50) PRIMARY KEY,
    customer_id                   VARCHAR(50),
    order_status                  VARCHAR(30),
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 7. Order items (fact: one row per item in an order)
CREATE TABLE order_items (
    order_id            VARCHAR(50),
    order_item_id       INT,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2),
    freight_value       NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id)  REFERENCES sellers(seller_id)
);

-- 8. Order payments
CREATE TABLE order_payments (
    order_id             VARCHAR(50),
    payment_sequential   INT,
    payment_type         VARCHAR(30),
    payment_installments INT,
    payment_value        NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 9. Order reviews
CREATE TABLE order_reviews (
    review_id               VARCHAR(50) PRIMARY KEY,
    order_id                VARCHAR(50),
    review_score            INT,
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Confirm all tables created
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
