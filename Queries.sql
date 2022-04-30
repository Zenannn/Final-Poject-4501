-- query 1
SELECT COUNT("index"),strftime ('%H',pickup_datetime) hour
FROM taxi_data
GROUP BY strftime ('%H',pickup_datetime)


-- query 2
SELECT COUNT("index"),week_name
FROM uber_data
GROUP BY week_name
ORDER BY COUNT("index")

-- query 3
SELECT "Trip_distance"
FROM 
(SELECT "Trip_distance"
FROM uber_data
WHERE strftime ('%Y-%m',date) == '2013-07'
UNION ALL
SELECT trip_distance
FROM taxi_data 
WHERE strftime ('%Y-%m',pickup_datetime) == '2013-07')
ORDER BY "Trip_distance" ASC
LIMIT 1
OFFSET (SELECT
         COUNT(*)
        FROM 
(SELECT "Trip_distance"
FROM uber_data
WHERE strftime ('%Y-%m',date) == '2013-07'
UNION ALL
SELECT trip_distance
FROM taxi_data 
WHERE strftime ('%Y-%m',pickup_datetime) == '2013-07')    
    ) * 18 / 20 - 1

-- query 4
SELECT a.time, avg(a."Trip_distance"), count(a.time)
FROM
(SELECT strftime ('%Y-%m-%d', date) as time, "Trip_distance"
FROM uber_data
WHERE strftime ('%Y',date) == '2009'
UNION ALL
SELECT strftime ('%Y-%m-%d', pickup_datetime) as time, trip_distance
FROM taxi_data 
WHERE strftime ('%Y',pickup_datetime) == '2009') as a
GROUP BY time
ORDER BY count(time) DESC
LIMIT 10

-- query 5
SELECT b.b_time, b.rides, weather_daily."DailyWindSpeed"
FROM
(SELECT a.time as b_time, count(a.time) as rides
FROM
(SELECT strftime ('%Y-%m-%d', date) as time, "Trip_distance"
FROM uber_data
WHERE strftime ('%Y',date) == '2014'
UNION ALL
SELECT strftime ('%Y-%m-%d', pickup_datetime) as time, trip_distance
FROM taxi_data 
WHERE strftime ('%Y',pickup_datetime) == '2014') as a
GROUP BY time) as b 
JOIN weather_daily
ON b.b_time = weather_daily."DATE"
ORDER BY weather_daily."DailyWindSpeed" DESC
LIMIT 10

-- query 6
SELECT hour3, count3, pre, wind
FROM
(SELECT hour2 as hour3, sum(count2) as count3
FROM
(WITH RECURSIVE dates(x,y) AS ( 
            SELECT '2012-10-22 00:00' , 0
                UNION ALL 
            SELECT DATETIME(x, '+1 HOURS') ,0 FROM dates WHERE x<'2012-11-07 00:00' 
) 
SELECT strftime ('%Y-%m-%d-%H',x) as hour2, y as count2 FROM dates 
UNION
SELECT hour1, count1
FROM
(SELECT a.date as hour1, COUNT(a.distance) as count1
FROM
(SELECT strftime ('%Y-%m-%d-%H',raw_date) as date, "Trip_distance" as distance
FROM uber_data
WHERE raw_date between '2012-10-22 00:00' and '2012-11-07 00:00'
UNION ALL
SELECT strftime ('%Y-%m-%d-%H',pickup_datetime),trip_distance
FROM taxi_data 
WHERE pickup_datetime between '2012-10-22 00:00' and '2012-11-07 00:00') as a
GROUP BY date))
GROUP BY hour2)
LEFT JOIN
(SELECT strftime ('%Y-%m-%d-%H', DATE) as hour, avg("HourlyPrecipitation") as pre, avg("HourlyWindSpeed") as wind
FROM weather_hourly
WHERE hour between '2012-10-22' and '2012-11-07'
GROUP BY hour)
ON hour3 = hour
