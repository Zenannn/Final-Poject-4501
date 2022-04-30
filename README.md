# Uber and Taxi data comparison study
#### UNIs: [zz2907, zw2807]                       Project Group 10
<br>

## The Object
For this project, we use the data of [Uber](https://drive.google.com/file/d/1F7D82w1D5151GXCR6BTEk7mNQ_YnPNDk/view) and [Yellow Taxi](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page) to demonstrate some intersting topics like: **How the weather impact the amount of tips?** and **Which area is the most popular for Taxi and Uber passengers?** etc.

## Package Implemented
For this project, we use **request** and **bs4** to download all the data required, and use **pandas** and **SQL** to organize all the huge amount of data. After that we use **matplotlib** and **folium** to visualize the data. Here are the package we needed listed as followed:

```Python
import math
import numpy as np
import bs4
import matplotlib.pyplot as plt
import pandas as pd
import requests
import sqlalchemy as db

import datetime
import os
import csv

import folium
from folium import plugins
```
## Part 1: Data Preprocessing
In this part, we need to clean and aggregate our data. We implement following procedures:
> For Taxi Data
> > * Remove unnecessary columns
> > * Remove invalid data points (Nan Value)
> > * Normalize column names
> > * Remove trips that start and/or end outside the designated [coordinate box](http://bboxfinder.com/#40.560445,-74.242330,40.908524,-73.717047)

We use Uber data as example to illustrate how we preprocessing dataset:
```Python
def get_and_clean_month_taxi_data(url, i):
    response = requests.get(url)
    with open('out.csv', 'w') as f:
        writer = csv.writer(f)
        for line in response.iter_lines():
            writer.writerow(line.decode('utf-8').split(','))
    data = pd.read_csv('out.csv',low_memory = False)
    data = data.drop(['RateCodeID', 'store_and_fwd_flag', 'payment_type', 'improvement_surcharge', 'mta_tax', 'tolls_amount', 'total_amount'], axis=1)
    data.dropna(inplace=True)
    data = data.loc[(data['pickup_longitude'] <=  -73.717047) & (data['pickup_longitude'] >=  -74.242330)\
                    & (data['dropoff_longitude'] <=  -73.717047) & (data['dropoff_longitude'] >=  -74.242330)
                    & (data['pickup_latitude'] <=  40.908524) & (data['pickup_latitude'] >=  40.560445) \
                    & (data['dropoff_latitude'] <=  40.908524) & (data['dropoff_latitude'] >=  40.560445)]
    sample = data.sample(b[i])
    sample = sample.sort_values(by='tpep_pickup_datetime',ascending=True).reset_index()
    sample = sample.drop(['index'], axis=1)
    data_csv = sample.to_csv(path_or_buf=f'/Users/wang/Desktop/TFA-Project/Final_project/taxi/month_{i}.csv')
```
    
> For Uber Data
> > * The same as we did to Taxi data

And we need to clean another dataset called Weather in order to discover the impact of weather to taxi and uber passengers.
> For Weather Data
> > * Split into two `pandas` DataFrames: one for hourly data, and one for the daily daya.

To split the weather data, we use following func:
```Python
def clean_month_weather_data_hourly():
    csv_list = []
    for i in range(1,8):
        df = pd.read_csv(f'/Users/wang/Desktop/TFA-Project/Final_project/weather/{i}_weather.csv')
        csv_list.append(df)
    weather = pd.concat(csv_list,axis = 0)
    clean = weather[['DATE','LATITUDE','LONGITUDE','HourlyPrecipitation','HourlyPresentWeatherType','HourlyRelativeHumidity','HourlyVisibility','HourlyWindDirection','HourlyWindGustSpeed','HourlyWindSpeed','Sunrise','Sunset','HourlyDryBulbTemperature']]
    clean.fillna('0', inplace=True)
    clean.index = range(len(clean))
    clean['DATE'] = pd.to_datetime(clean['DATE'])
    clean['HourlyPrecipitation'] = clean['HourlyPrecipitation'].apply(pd.to_numeric, errors='coerce').fillna(0.0)
    return clean
   ```
After data cleaning, we can generate following 4 Dataframe:
```Python
uber_data, b = load_and_clean_uber_data(csv_file='/Users/wang/Desktop/TFA-Project/Final_project/TFA-Project 2/uber_rides_sample.csv')
cal_straight_distance(uber_data)
taxi_data = get_and_clean_taxi_data()
weather_hourly = clean_month_weather_data_hourly()
weather_daily = clean_month_weather_data_daily()
```

## Part 2: Storing Cleaned Data
First, we need to create an engine
```Python
engine = db.create_engine(f'sqlite:///contacts.db',echo = True)
```

Then, we need to convert Dataframe to SQL
```Python
uber_data.to_sql('uber_data', con=engine)
taxi_data.to_sql('taxi_data', con=engine)
weather_hourly.to_sql('weather_hourly', con=engine)
weather_daily.to_sql('weather_daily', con=engine)
```
## Part 3: Understanding Data
In this part, we answer following questions:
* For 01-2009 through 06-2015, what hour of the day was the most popular to take a yellow taxi? The result should have 24 bins.
* For the same time frame, what day of the week was the most popular to take an uber? The result should have 7 bins.
* What is the 95% percentile of distance traveled for all hired trips during July 2013?
* What were the top 10 days with the highest number of hired rides for 2009, and what was the average distance for each day?
* Which 10 days in 2014 were the windiest, and how many hired trips were made on those days?
* During Hurricane Sandy in NYC (Oct 29-30, 2012) and the week leading up to it, how many trips were taken each hour, and for each hour, how much precipitation did NYC receive and what was the sustained wind speed?

We use Q1 as example to demonstrate how we do the query:
```Python
QUERY_1 = """
SELECT COUNT("index"),strftime ('%H',pickup_datetime) hour
FROM taxi_data
GROUP BY strftime ('%H',pickup_datetime)
"""
query1 = engine.execute(QUERY_1).fetchall()
```

## Part 4: Visualizing the Data
In this part, we generate differents kinds of graph to answer the following questions:
* Create an appropriate visualization for the first query/question in part 3
* Create a visualization that shows the average distance traveled per month (regardless of year - so group by each month). Include the 90% confidence interval around the mean in the visualization
* Define three lat/long coordinate boxes around the three major New York airports: LGA, JFK, and EWR (you can use bboxfinder to help). Create a visualization that compares what day of the week was most popular for drop offs for each airport.
* Create a heatmap of all hired trips over a map of the area. Consider using KeplerGL or another library that helps generate geospatial visualizations.
* Create a scatter plot that compares tip amount versus distance.
* Create another scatter plot that compares tip amount versus precipitation amount.
* Come up with 3 questions on your own that can be answered based on the data in the 4 tables. Create at least one visualization to answer each question. At least one visualization should require data from at least 3 tables.

Same old same old, we use Q1 as example:
```Python
def plot_visual_1(query_res):
    data = [i[0] for i in query1]
    x_var = [i[1] for i in query1]

    plt.title('Graph_1')
    plt.bar(x_var, data)
    plt.plot(x_var, data, color='red')
    plt.show()
    
plot_visual_1(query1)
```
We can get following output:
![Output 1](/Users/wang/Desktop/g1)
