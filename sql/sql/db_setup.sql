CREATE DATABASE telecom_operator_xyz;
\c telecom_operator_xyz;


--Open psql terminal:

psql -U your_user -d telecom_operator_xyz


--Use \COPY to import CSV files (adjust paths):

\COPY subscribers(subscriber_id, name, age, gender, region, msisdn, imei) 
FROM 'D:\GITHUB PROJECTS\subscribers_data.csv' DELIMITER ',' CSV HEADER;

\COPY plans(plan_id, plan_name, monthly_fee, data_limit)
FROM 'D:\GITHUB PROJECTS\plans.csv' DELIMITER ',' CSV HEADER;

\COPY subscriber_plans(subscriber_id, plan_id, start_date, end_date)
FROM 'D:\GITHUB PROJECTS\subscriber_plans.csv' DELIMITER ',' CSV HEADER;

\COPY network_logs(log_id, timestamp, subscriber_id, event_type, value)
FROM 'D:\GITHUB PROJECTS\network_logs.csv' DELIMITER ',' CSV HEADER;


--Check your data:

SELECT COUNT(*) FROM subscribers;
SELECT COUNT(*) FROM network_logs;
SELECT COUNT(*) FROM plans;
SELECT COUNT(*) FROM subscriber_plans;