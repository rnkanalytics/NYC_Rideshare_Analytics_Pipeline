CREATE OR REPLACE TABLE `project-9e8fe6e9-80e0-472b-b51.uber.uber_analytics` AS (
SELECT 
f.VendorID,
f.trip_id,
f.payment_type_id,
CAST(d.tpep_pickup_datetime AS TIMESTAMP) as tpep_pickup_datetime,
CAST(d.tpep_dropoff_datetime AS TIMESTAMP) as tpep_dropoff_datetime,
pc.passenger_count,
t.trip_distance,
r.rate_code_name,
pl.pickup_latitude,
pl.pickup_longitude,
dl.dropoff_latitude,
dl.dropoff_longitude,
pt.payment_type_name,
f.fare_amount,
f.extra,
f.mta_tax,
f.tip_amount,
f.tolls_amount,
f.improvement_surcharge
FROM `project-9e8fe6e9-80e0-472b-b51.uber.fact_table` f
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.datetime_dim` d ON f.datetime_id = d.datetime_id
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.payment_type_dim` pt ON f.payment_type_id = pt.payment_type_id
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.dropoff_location_dim` dl ON f.dropoff_location_id = dl.dropoff_location_id
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.pickup_location_dim` pl ON f.pickup_location_id = pl.pickup_location_id
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.rate_code_dim` r ON f.rate_code_id = r.rate_code_id
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.trip_distance_dim` t ON f.trip_distance_id = t.trip_distance_id
JOIN `project-9e8fe6e9-80e0-472b-b51.uber.passenger_count_dim` pc ON f.passenger_count_id = pc.passenger_count_id
WHERE 
    NOT (pl.pickup_latitude = 37.3894157409668 AND pl.pickup_longitude = -121.9331512451172)
    AND NOT (pl.pickup_latitude = 40.760498046875 AND pl.pickup_longitude = -7.5876069068908691)
    AND NOT (pl.pickup_latitude = 37.389472961425774 AND pl.pickup_longitude = -121.93332672119141)
    AND NOT (pl.pickup_latitude = 37.389389038085938 AND pl.pickup_longitude = -121.93325042724608)
);
