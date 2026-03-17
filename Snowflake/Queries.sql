-- ============================================================
-- Uber Trip Analytics - Snowflake
-- Replicates dashboard: Uber Trip Analytics in NYC
-- ============================================================
 
USE WAREHOUSE UBER_WH;
USE DATABASE UBER_DB;
USE SCHEMA ANALYTICS;
 
-- ============================================================
-- KPI METRICS
-- ============================================================
 
-- Total number of trips
SELECT COUNT(*) AS total_trips
FROM FACT_TABLE;
 
-- Average trip distance (miles)
SELECT ROUND(AVG(t.trip_distance), 1) AS avg_trip_distance_mi
FROM FACT_TABLE f
JOIN TRIP_DISTANCE_DIM t ON f.TRIP_DISTANCE_ID = t.TRIP_DISTANCE_ID;
 
-- Average fare charged (USD)
SELECT ROUND(AVG(f.fare_amount), 2) AS avg_fare_usd
FROM FACT_TABLE f;
 
-- Average toll charged (USD)
SELECT ROUND(AVG(f.tolls_amount), 2) AS avg_toll_usd
FROM FACT_TABLE f;
 
-- ============================================================
-- PICKUP DISTRIBUTION BY RATE TYPE
-- (Used for the map visualization)
-- ============================================================
 
SELECT
    pl.pickup_latitude,
    pl.pickup_longitude,
    rc.rate_code_name,
    COUNT(*) AS trip_count
FROM FACT_TABLE f
JOIN PICKUP_LOCATION_DIM pl ON f.PICKUP_LOCATION_ID = pl.PICKUP_LOCATION_ID
JOIN RATE_CODE_DIM rc ON f.RATE_CODE_ID = rc.RATE_CODE_ID
GROUP BY
    pl.pickup_latitude,
    pl.pickup_longitude,
    rc.rate_code_name
ORDER BY trip_count DESC;
 
-- ============================================================
-- TIP AMOUNT BY PASSENGER COUNT
-- ============================================================
 
SELECT
    pc.passenger_count,
    ROUND(AVG(f.tip_amount), 1) AS avg_tip_amount
FROM FACT_TABLE f
JOIN PASSENGER_COUNT_DIM pc ON f.PASSENGER_COUNT_ID = pc.PASSENGER_COUNT_ID
GROUP BY pc.passenger_count
ORDER BY avg_tip_amount DESC;
 
-- ============================================================
-- PAYMENT TYPE DISTRIBUTION
-- ============================================================
 
SELECT
    pt.payment_type_name,
    COUNT(*) AS trip_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM FACT_TABLE f
JOIN PAYMENT_TYPE_DIM pt ON f.PAYMENT_TYPE_ID = pt.PAYMENT_TYPE_ID
GROUP BY pt.payment_type_name
ORDER BY trip_count DESC;
 
-- ============================================================
-- ADDITIONAL ANALYSIS
-- ============================================================
 
-- Trips by hour of day
SELECT
    d.pick_hour,
    COUNT(*) AS trip_count
FROM FACT_TABLE f
JOIN DATETIME_DIM d ON f.DATETIME_ID = d.DATETIME_ID
GROUP BY d.pick_hour
ORDER BY d.pick_hour;
 
-- Trips by day of week
SELECT
    CASE d.pick_weekday
        WHEN 0 THEN 'Monday'
        WHEN 1 THEN 'Tuesday'
        WHEN 2 THEN 'Wednesday'
        WHEN 3 THEN 'Thursday'
        WHEN 4 THEN 'Friday'
        WHEN 5 THEN 'Saturday'
        WHEN 6 THEN 'Sunday'
    END AS day_of_week,
    COUNT(*) AS trip_count
FROM FACT_TABLE f
JOIN DATETIME_DIM d ON f.DATETIME_ID = d.DATETIME_ID
GROUP BY d.pick_weekday
ORDER BY d.pick_weekday;
 
-- Average fare by rate code
SELECT
    rc.rate_code_name,
    COUNT(*) AS trip_count,
    ROUND(AVG(f.fare_amount), 2) AS avg_fare,
    ROUND(AVG(f.tip_amount), 2) AS avg_tip,
    ROUND(AVG(f.total_amount), 2) AS avg_total
FROM FACT_TABLE f
JOIN RATE_CODE_DIM rc ON f.RATE_CODE_ID = rc.RATE_CODE_ID
GROUP BY rc.rate_code_name
ORDER BY trip_count DESC;
 
-- Top 10 busiest pickup locations
SELECT
    pl.pickup_latitude,
    pl.pickup_longitude,
    COUNT(*) AS trip_count
FROM FACT_TABLE f
JOIN PICKUP_LOCATION_DIM pl ON f.PICKUP_LOCATION_ID = pl.PICKUP_LOCATION_ID
GROUP BY pl.pickup_latitude, pl.pickup_longitude
ORDER BY trip_count DESC
LIMIT 10;
 
-- Revenue breakdown
SELECT
    ROUND(SUM(fare_amount), 2) AS total_fare,
    ROUND(SUM(tip_amount), 2) AS total_tips,
    ROUND(SUM(tolls_amount), 2) AS total_tolls,
    ROUND(SUM(mta_tax), 2) AS total_mta_tax,
    ROUND(SUM(improvement_surcharge), 2) AS total_surcharge,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM FACT_TABLE;
