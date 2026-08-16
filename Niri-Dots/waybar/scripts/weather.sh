#!/usr/bin/env bash

# Fetch weather data from wttr.in in JSON format
# format=j1 gives detailed JSON output

WEATHER_DATA=$(curl -s "https://wttr.in/?format=j1")

if [[ $? -ne 0 ]]; then
    echo '{"text": "󰖐", "tooltip": "Weather unavailable"}'
    exit 1
fi

# Extract current temperature and weather description
TEMP=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].temp_C')
DESC=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherDesc[0].value')
FEELS_LIKE=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].FeelsLikeC')
HUMIDITY=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].humidity')
WIND_SPEED=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].windspeedKmph')

# Map weather descriptions to icons
case "$DESC" in
    "Sunny" | "Clear") ICON="󰖙" ;;
    "Partly cloudy") ICON="󰖕" ;;
    "Cloudy" | "Overcast") ICON="󰖐" ;;
    "Mist" | "Fog" | "Haze") ICON="󰖑" ;;
    "Patchy rain possible" | "Light rain" | "Moderate rain") ICON="󰖗" ;;
    "Heavy rain") ICON="󰖖" ;;
    "Patchy snow possible" | "Light snow" | "Moderate snow") ICON="󰖘" ;;
    "Heavy snow") ICON="󰼶" ;;
    "Thundery outbreaks possible" | "Thunderstorm") ICON="󰖓" ;;
    *) ICON="󰖐" ;;
esac

echo "{\"text\": \"$ICON $TEMP°C\", \"tooltip\": \"$DESC\nFeels like: $FEELS_LIKE°C\nHumidity: $HUMIDITY%\nWind: $WIND_SPEED km/h\"}"
