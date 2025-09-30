# Data Sources

This project utilizes two primary data sources to analyze the relationship between weather and renewable energy output in South Africa.

## 1. Weather Data
- **Source:** [Open-Meteo Historical Weather API](https://open-meteo.com/)
- **Description:** Hourly historical weather data for a location in South Africa.
- **Key Variables Used:**
  - `temperature_2m` (°C)
  - `shortwave_radiation` (W/m²)
  - `cloud_cover` (%)
  - `wind_speed_10m` (km/h)
- **Time Period:** 2024

## 2. Energy Generation Data
- **Source:** Eskom (data received via email after request).
- **Description:** Actual historical energy generation data for South Africa.
- **Technologies:**
  - Solar Photovoltaic (PV)
  - Concentrated Solar Power (CSP)
  - Wind
- **Format:** Aggregated.
- **Time Period:** 2024

## Note on Data Integration
The weather and energy datasets were joined using timestamp fields to create an integrated dataset for analysis in Google BigQuery.
