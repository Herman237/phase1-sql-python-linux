# Telecom Operator XYZ SQL Project

This folder contains the SQL database and Python scripts for generating **synthetic telecom data** for 100,000+ subscribers.

## How to generate data

1. Run the Python scripts in the following order:
   - `generate_subscribers.py` → produces `subscribers_data.csv`
   - `generate_plans.py` → produces `plans.csv`
   - `generate_subscriber_plans.py` → produces `subscriber_plans.csv`
   - `generate_network_logs.py` → produces `network_logs.csv`

2. Import CSVs into PostgreSQL:

\COPY subscribers(subscriber_id, name, age, gender, region, msisdn, imei) 
FROM 'path_to_csv/subscribers_data.csv' DELIMITER ',' CSV HEADER;

\COPY plans(plan_id, plan_name, monthly_fee, data_limit)
FROM 'path_to_csv/plans.csv' DELIMITER ',' CSV HEADER;

\COPY subscriber_plans(subscriber_id, plan_id, start_date, end_date)
FROM 'path_to_csv/subscriber_plans.csv' DELIMITER ',' CSV HEADER;

\COPY network_logs(log_id, timestamp, subscriber_id, event_type, value)
FROM 'path_to_csv/network_logs.csv' DELIMITER ',' CSV HEADER;
