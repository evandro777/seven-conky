#!/bin/bash
cd "$(dirname "$(realpath "$0")")"
. ./WeatherConfig.sh; #Configs

mkdir -p /tmp/conky-weather/cache/
#curl -s "api.openweathermap.org/data/2.5/forecast/daily?APPID=$weatherKey&id=$weatherCityId&units=$weatherUnit&lang=$weatherLanguage" -o /tmp/conky-weather/cache/forecast.json
curl -s "api.openweathermap.org/data/2.5/weather?appid=$weatherKey&id=$weatherCityId&units=$weatherUnit&lang=$weatherLanguage" -o /tmp/conky-weather/cache/weather.json
curl -s "api.openweathermap.org/data/2.5/forecast/daily?appid=$weatherKey&lat="$(jq -r ".coord.lat" /tmp/conky-weather/cache/weather.json)"&lon="$(jq -r ".coord.lon" /tmp/conky-weather/cache/weather.json)"&units=$weatherUnit&lang=$weatherLanguage" -o /tmp/conky-weather/cache/forecast.json

# This one bellow is not on free tier anymore
#curl -s "api.openweathermap.org/data/2.5/onecall?exclude=minutely,hourly&appid=$weatherKey&lat="$(jq -r ".coord.lat" /tmp/conky-weather/cache/weather.json)"&lon="$(jq -r ".coord.lon" /tmp/conky-weather/cache/weather.json)"&units=$weatherUnit&lang=$weatherLanguage" -o /tmp/conky-weather/cache/onecall.json

# Copy weather image
cp -f icons/$(jq .weather[0].id /tmp/conky-weather/cache/weather.json).png /tmp/conky-weather/cache/current.png

# Copy weather forecast image
#cp -f icons/$(jq ".daily[1].weather[0].id" /tmp/conky-weather/cache/onecall.json).png /tmp/conky-weather/cache/forecast-tomorrow.png
