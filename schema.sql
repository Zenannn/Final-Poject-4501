
CREATE TABLE weather_hourly (
    "index" BIGINT, 
    "DATE" DATETIME, 
    "LATITUDE" FLOAT, 
    "LONGITUDE" FLOAT, 
    "HourlyPrecipitation" FLOAT, 
    "HourlyPresentWeatherType" TEXT, 
    "HourlyRelativeHumidity" FLOAT, 
    "HourlyVisibility" FLOAT, 
    "HourlyWindDirection" TEXT, 
    "HourlyWindGustSpeed" FLOAT, 
    "HourlyWindSpeed" FLOAT, 
    "Sunrise" TEXT, 
    "Sunset" TEXT, 
    "HourlyDryBulbTemperature" FLOAT
)

CREATE TABLE weather_daily (
    "DATE" TEXT, 
    "DailyVisibility" FLOAT, 
    "DailyPrecipitation" FLOAT, 
    "DailyRelativeHumidity" FLOAT, 
    "DailyWindGustSpeed" FLOAT, 
    "DailyWindSpeed" FLOAT, 
    "DailyDryBulbTemperature" FLOAT, 
    "LATITUDE" TEXT, 
    "LONGITUDE" TEXT
)

CREATE TABLE taxi_data (
    "index" BIGINT, 
    pickup_datetime DATETIME, 
    dropoff_datetime DATETIME, 
    passenger_count BIGINT, 
    trip_distance FLOAT, 
    pickup_longitude FLOAT, 
    pickup_latitude FLOAT, 
    dropoff_longitude FLOAT, 
    dropoff_latitude FLOAT, 
    fare_amount FLOAT, 
    tip_amount FLOAT
)

CREATE TABLE uber_data (
    "index" BIGINT, 
    passenger_count BIGINT, 
    date DATETIME, 
    raw_date TEXT, 
    fare_amount FLOAT, 
    pickup_longitude FLOAT, 
    pickup_latitude FLOAT, 
    dropoff_longitude FLOAT, 
    dropoff_latitude FLOAT, 
    dates TEXT, 
    week_name TEXT
)

CREATE TABLE sunrise_sunset (
    "index" BIGINT, 
    "DATE" DATETIME, 
    "Sunrise" TEXT, 
    "Sunset" TEXT
)
