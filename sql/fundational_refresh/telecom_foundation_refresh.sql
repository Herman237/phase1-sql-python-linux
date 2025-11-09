/*====================================================
Project: Telecom Operator XYZ - Foundational SQL Analysis
Author: <Your Name>
Date: 2025-11-09
Database: PostgreSQL
Description:
This script includes foundational SQL queries covering:
- SELECT basics
- WHERE, ORDER BY, LIMIT
- JOINS
- GROUP BY, HAVING, Aggregations
- Subqueries
- Aliases and functions
=====================================================*/


--Repartition of female and male shows that we have more male than female (0.17% of difference) 
SELECT SUM(CASE WHEN gender = 'female' then 1 else 0 end) as count_female,
SUM(CASE WHEN gender = 'male' then 1 else 0 end) as count_male
from subscribers


 count_female | count_male
--------------+------------
        49915 |      50085
		

--Region Repartition and ordered from high amount users to lower shows that west regions has the most number of subscribers
select region, count(distinct subscriber_id) as total_users
from subscribers 
group by region
order by total_users desc

   region   | total_users
------------+-------------
 West       |       10104
 Adamawa    |       10102
 Far North  |       10087
 South      |       10032
 Littoral   |       10000
 North West |        9976
 Center     |        9969
 South West |        9951
 North      |        9948
 East       |        9831
 
-- Age repartition :  We have more young adult in our network

18-24 years: Young Adults
25-39 years: Adults
40-54 years: Mature Adults
55 years and above: Seniors

select sum(case when age between 18 and 24 then 1 else 0 end) as "[18;24]",
sum(case when age between 25 and 39 then 1 else 0 end) as "[25;39]",
sum(case when age between 40 and 54 then 1 else 0 end) as "[40;54]",
sum(case when age between 55 and 90 then 1 else 0 end) as "[55;90]"
from subscribers;

telecom_operator_xyz-# from subscribers;
 [18;24] | [25;39] | [40;54] | [55;90]
---------+---------+---------+---------
   16047 |   34035 |   28158 |   21760



-- Total voice and data usage


select ROUND(data_usage_GB,0) as data_usage_GB, ROUND(voice_usage_hr,0) as voice_usage_hr
from(
select sum(case when event_type = 'data_usage' then value else 0 end)/1024 as data_usage_GB,
sum(case when event_type in ('call_started','call_ended') then value else 0 end)/60/60 as voice_usage_hr
from network_logs
)tmp;


data_usage_gb | voice_usage_hr
---------------+----------------
        406356 |           6992
		
-- Data inactive users (No incative users)

select subscriber_id, sum(value) as value
from network_logs
where event_type = 'data_usage' and value = 0
group by subscriber_id

select subscriber_id, sum(value) as value
from network_logs
where event_type = 'call' and value = 0
group by subscriber_id



--Top 10 voice users 
select name, ROUND(sum(value)/60/60,0) as voice_usage_hr
from network_logs A 
inner join subscribers B on A.subscriber_id = B.subscriber_id
where event_type = 'call'
group by name
order by voice_usage_hr desc 
limit 10;

 name   | voice_usage_hr
---------+----------------
 Maud    |              5
 Julie   |              4
 Cyrus   |              4
 Burley  |              4
 Evalyn  |              4
 Willow  |              4
 Jerod   |              4
 Kennith |              4
 Damian  |              4
 Sigurd  |              4

--Top 10 data users 
select name, ROUND(sum(value)/1024,0) as data_usage_GB
from network_logs A 
inner join subscribers B on A.subscriber_id = B.subscriber_id
where event_type = 'data_usage'
group by name
order by data_usage_GB desc 
limit 10;


  name   | data_usage_gb
---------+---------------
 Hadley  |           257
 Sallie  |           249
 Gino    |           243
 Haskell |           238
 Antwan  |           237
 Mateo   |           236
 Maida   |           236
 Ila     |           231
 Rashad  |           230
 Turner  |           230
 

--List 10 subscribers with their current active plan.

select name, region, plan_name, sum(monthly_fee) as monthly_fee
from subscriber_plans A 
inner join plans B on A.plan_id = B.plan_id
inner join subscribers C on A.subscriber_id = C.subscriber_id
where end_date > '2025-11-08'
group by name, region, plan_name
order by monthly_fee desc 
limit 10;

  name    |   region   |   plan_name   | monthly_fee
-----------+------------+---------------+-------------
 Jeffrey   | North West | Business Plan |       50000
 Hosea     | Center     | Business Plan |       50000
 Ardith    | South West | Business Plan |       50000
 Felicita  | South      | Business Plan |       50000
 Orrin     | North      | Business Plan |       50000
 Roberto   | Center     | Business Plan |       50000
 Mariano   | North      | Business Plan |       50000
 Stephan   | South      | Business Plan |       50000
 Alexandre | Adamawa    | Business Plan |       50000
 Cary      | Adamawa    | Business Plan |       50000
 
--Check consistency between subscriber and plan tables.
select count(subscriber_id) as mismatch_users
from(
select A.subscriber_id, name, plan_id 
from subscribers A 
full outer join subscriber_plans B on a.subscriber_id = B.subscriber_id 
where A.subscriber_id is null or plan_id is null 
)tmp 

 mismatch_users
----------------
           3036
		   
--Average monthly fee per region (only show regions with more than 100 subscribers).


select region, ROUND(AVG(monthly_fee),0) as avg_monthly_fee, count(name) as total_users
FROM(
select name, region, monthly_fee 
from subscribers A 
inner join subscriber_plans B on a.subscriber_id = b.subscriber_id
inner join plans C on b.plan_id = c.plan_id
group by name, region, monthly_fee
)TMP
group by region having count(name) > 100

   region   | avg_monthly_fee | total_users
------------+-----------------+-------------
 Center     |            8582 |       18615
 Far North  |            8557 |       18972
 East       |            8546 |       18650
 South      |            8575 |       18939
 North West |            8564 |       18872
 South West |            8563 |       18724
 Adamawa    |            8545 |       18942
 West       |            8603 |       18884
 North      |            8529 |       18783
 Littoral   |            8529 |       18616
 
--Get all subscribers who use the most expensive plan.
select count(name) as most_sexpensive_plan  
from subscribers
where subscriber_id IN 
(SELECT subscriber_id from subscriber_plans where plan_id = 
(select plan_id from plans order by monthly_fee desc limit 1)
)

 most_sexpensive_plan
----------------------
                29497
				
--Telecom usage statistics per region.

SELECT s.region, n.event_type, COUNT(*) AS event_count, ROUND(AVG(n.value),2) AS avg_value
FROM network_logs n
JOIN subscribers s ON n.subscriber_id = s.subscriber_id
GROUP BY s.region, n.event_type
ORDER BY s.region, event_count DESC;

   region   | event_type | event_count | avg_value
------------+------------+-------------+-----------
 Adamawa    | call       |       16987 |    151.64
 Adamawa    | data_usage |       16727 |   2490.04
 Center     | call       |       16840 |    150.13
 Center     | data_usage |       16359 |   2491.44
 East       | data_usage |       16483 |   2528.58
 East       | call       |       16238 |    149.66
 Far North  | call       |       16858 |    150.83
 Far North  | data_usage |       16700 |   2507.70
 Littoral   | call       |       17002 |    149.96
 Littoral   | data_usage |       16480 |   2495.51
 North      | call       |       16749 |    150.72
 North      | data_usage |       16532 |   2491.40
 North West | data_usage |       16731 |   2509.51
 North West | call       |       16684 |    150.71
 South      | call       |       16648 |    150.43
 South      | data_usage |       16638 |   2497.80
 South West | data_usage |       16556 |   2500.05
 South West | call       |       16402 |    150.09
 West       | data_usage |       17054 |   2515.19
 West       | call       |       16849 |    150.78