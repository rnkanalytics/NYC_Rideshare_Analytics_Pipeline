-- 1. Creating a virtual warehouse
CREATE WAREHOUSE IF NOT EXISTS UBER_WH
    WITH WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

-- 2. Create the database and schema
CREATE DATABASE IF NOT EXISTS UBER_DB;
CREATE SCHEMA IF NOT EXISTS UBER_DB.ANALYTICS;

-- 3. Use them
USE WAREHOUSE UBER_WH;
USE DATABASE UBER_DB;
USE SCHEMA ANALYTICS;

-- 4. Dimension tables
CREATE OR REPLACE TABLE datetime_dim (
    datetime_id INT,
    tpep_pickup_datetime TIMESTAMP,
    pick_hour INT,
    pick_day INT,
    pick_month INT,
    pick_year INT,
    pick_weekday INT,
    tpep_dropoff_datetime TIMESTAMP,
    drop_hour INT,
    drop_day INT,
    drop_month INT,
    drop_year INT,
    drop_weekday INT
);

CREATE OR REPLACE TABLE passenger_count_dim (
    passenger_count_id INT,
    passenger_count INT
);

CREATE OR REPLACE TABLE trip_distance_dim (
    trip_distance_id INT,
    trip_distance FLOAT
);

CREATE OR REPLACE TABLE rate_code_dim(
    rate_code_id INT,
    RatecodeID INT,
    rate_code_name VARCHAR()
);

CREATE OR REPLACE TABLE pickup_location_dim (
    pickup_location_id INT,
    pickup_longitude FLOAT,
    pickup_latitude FLOAT
);

CREATE OR REPLACE TABLE dropoff_location_dim (
    dropoff_location_id INT,
    dropoff_longitude FLOAT,
    dropoff_latitude FLOAT
);

CREATE OR REPLACE TABLE payment_type_dim (
    payment_type_id INT,
    payment_type INT,
    payment_type_name VARCHAR
);

CREATE OR REPLACE TABLE fact_table (
    VendorID INT,
    datetime_id INT,
    passenger_count_id INT,
    trip_distance_id INT,
    rate_code_id INT,
    pickup_location_id INT,
    dropoff_location_id INT,
    payment_type_id INT,
    fare_amount FLOAT,
    extra FLOAT,
    mta_tax FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    improvement_surcharge FLOAT,
    total_amount FLOAT
);
