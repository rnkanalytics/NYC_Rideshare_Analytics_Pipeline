# Uber Trip Analytics

## Project Overview
Data engineering project: ETL pipeline built with Python, Mage AI, Google Cloud Storage, BigQuery, and Looker Studio to analyze 100,000+ Uber trips in NYC. The project transforms raw trip data into a star schema data warehouse and visualizes key insights through an interactive dashboard. This was my first time using maze and I must say the tool is very sleek and easy to use.

## Dashboard
🔗 [View Live Dashboard](https://lookerstudio.google.com/reporting/9fb56b9d-87f2-4fa7-a47e-5999c5619920)

![Dashboard](images/Uber_Trip_Analytics_Dashboard.png)

## Data Model
![ERD Diagram](images/Uber_ERD_Diagram.png)

## Architecture
The pipeline follows these steps:
1. Raw Uber trip data stored in **Google Cloud Storage**
2. **Mage AI** orchestrates the ETL pipeline
3. Data transformed into a **star schema** with fact and dimension tables
4. Loaded into **BigQuery** for analysis
5. Visualized in **Looker Studio**

## Tech Stack
- **Python** — data transformation and pipeline logic
- **Mage AI** — ETL pipeline orchestration
- **Google Cloud Storage** — raw data lake
- **BigQuery** — data warehouse
- **Looker Studio** — data visualization

## Project Structure
```
Uber_Trip_Analytics/
├── README.md
├── images/
│   ├── Uber_ERD_Diagram.png
│   └── Uber_Trip_Analytics_Dashboard.png
├── mage/
│   ├── Extract_Uber_Data.py
│   ├── Transform_Uber_Data.py
│   └── Load_Uber_Data.py
└── bigquery/
    └── uber_analytics.sql
```

## Key Insights
- **100K+** Uber trips analyzed
- **66.5%** of payments made by Credit Card
- **Average fare** of $13.25 per trip
- **Average trip distance** of 3.0 miles
- **Manhattan** is the busiest pickup location

## Dataset
The dataset contains NYC Uber trip records including:
- Pickup and dropoff datetime
- Pickup and dropoff coordinates
- Passenger count
- Trip distance
- Fare amount, tip, tolls
- Payment type
- Rate code

## Contact
- 🔗 [LinkedIn](https://www.linkedin.com/in/ramiz-khatib/)
- 🐙 [GitHub](https://github.com/rnkanalytics-prog)
