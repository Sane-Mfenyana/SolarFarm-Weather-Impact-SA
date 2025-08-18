# SolarFarm-Weather-Impact-SA
Data analysis of how weather variability impacts solar farm performance in South Africa, using long-term irradiance baselines and hourly weather data for actionable insights.

## Step 1: Understanding the Weather Context

### 🧠 Objective

To examine how temperature and solar irradiance affect solar farm output. This step establishes a foundational understanding of weather patterns so that downstream performance analysis reflects the true driving factors — not just surface-level trends.

### 🎯Why This Step Matters

Understanding weather patterns is important because it allows us to examine the relationship between weather variability and solar farm performance. It also helps determine whether dips in performance are due to natural conditions or hardware issues. Without this context, analysis risks drawing misaligned conclusions. The goal here is to build a weather-performance baseline that supports clearer detection of underperformance.

## ☀️ Step 2: Weather Data Context

### 🧠 Purpose
Understanding weather patterns is important because it allows us to examine the possible relationship between weather variability and solar farm performance. This helps us determine whether fluctuations in output are due to natural weather conditions (like cloud cover or solar irradiance) or hardware issues on-site.

By building a weather baseline, we ensure the analysis is grounded in the environmental conditions that drive performance. This prevents misattributing underperformance and enables more accurate insights aligned with the true causes of output variability.

---

### 📊 Data Sources & Their Role

| Dataset | Purpose |
|--------|---------|
| **Solargis (GHI LTAy Daily Totals GeoTIFF)** | Provides **long-term solar irradiance averages** (LTAy) to serve as a **baseline** for expected solar performance at a geographic location. Helps detect persistent underperformance compared to historical norms. |
| **Global Solar Atlas (South Africa – GHI daily totals GeoTIFF LTAy)** | Offers a **validated, World Bank-backed source** of long-term solar irradiance data. Acts as a **cross-reference** to Solargis data to ensure accuracy and consistency in baseline solar resource assessments. |
| **Open-Meteo Hourly Forecasts** | Supplies **short-term hourly weather data** (e.g. temperature, irradiance, cloud cover). Enables **granular daily analysis** of weather’s effect on solar output. Useful for identifying **daily fluctuations and anomalies**. |

## 📊 Step 4: Data Cleaning & Preparation

### Overview

With our weather and solar irradiance datasets acquired, the next step is to prepare the data for analysis. This involves cleaning, formatting, and aligning the datasets so they can be compared over time and across variables.

### Tasks Completed

#### 1. Validated Open-Meteo Hourly Weather Data
- Verified that all key columns (`time`, `temperature_2m`, `relative_humidity_2m`, `wind_speed_10m`) contain usable hourly values.
- Confirmed the dataset spans 8,778 rows, ensuring full annual coverage.

#### 2. Assessed File Structure & Metadata
- Identified that timezone information is consistent but only provided for a single row.
- UTC offset and timezone abbreviation will be used later to ensure time alignment across sources if needed.

#### 3. Confirmed Integrity of Solargis GHI LTAy Daily Totals (GeoTIFF)
- This dataset remains untouched for now; we’ll convert and match it to our weather dataset's format in the next step.
- Solargis serves as our long-term solar irradiance benchmark.

#### 4. Global Solar Atlas GHI Daily Totals (GeoTIFF)
- Downloaded and validated. Will be used in comparison to Solargis and Open-Meteo to test model robustness and regional irradiance variation.

### Why This Step Matters

Without consistent formatting and structure, we can’t perform accurate time-series analysis. Cleaning ensures we’re not modeling based on missing, misaligned, or misinterpreted data. The hourly weather data gives us granularity; the long-term GHI GeoTIFFs provide historical grounding.

## 🗺️ Step 4.1: Attempt to Extract SolarGIS GeoTIFF Data

As part of this project, I aimed to incorporate long-term average solar irradiance data from SolarGIS (in GeoTIFF format). This data was expected to provide a spatial view of solar potential across South Africa.

### 🔍 What I Tried:
- Uploaded the `.tif` file to [geotiff.io](https://geotiff.io), but the visual rendering was limited. The raster displayed only in grayscale and lacked the expected color gradient or metadata overlay.
- Attempted to find alternative open-source, **web-based tools** to parse and extract the raster values (e.g. Mapshaper, GeoTIFF viewer plugins, etc.) but found that most tools require desktop GIS software (like QGIS), which I wanted to avoid for this step.

### ⚠️ Limitation:
Since this portfolio project is designed to be executed without installing external software, I made the decision to **pause this part** and proceed with the rest of the analysis using the **Open-Meteo hourly weather dataset** — which is sufficient for answering the main research question.

### ✅ Moving Forward:
The project will still maintain its integrity and value without this spatial layer, as the core focus remains on analyzing **temporal performance variability** in solar and wind energy systems using **real-time weather inputs**.

## 🧪 Step 5: Data Exploration and Quality Check — Weather Data

### 🎯 Objective  
To understand the structure, quality, and statistical properties of the hourly weather dataset sourced from Open-Meteo. This ensures the data is clean, consistent, and usable for analyzing the impact of weather conditions on solar energy performance in South Africa.

---

### 📂 Dataset Info  
The file `open-meteo-28.44S21.27E805m.csv` was uploaded to BigQuery and renamed using the following naming conventions to remove unsupported characters and improve clarity:

| Original Field Name                     | Revised Field Name                     |
|----------------------------------------|----------------------------------------|
| `time`                                 | `time`                                 |
| `temperature_2m (°C)`                  | `temperature_2m_c`                     |
| `relative_humidity_2m (%)`             | `relative_humidity_2m_percent`         |
| `dew_point_2m (°C)`                    | `dew_point_2m_c`                       |
| `apparent_temperature (°C)`            | `apparent_temperature_c`               |
| `precipitation_sum (mm)`              | `precipitation_sum_mm`                 |
| `rain_sum (mm)`                        | `rain_sum_mm`                          |
| `wind_speed_10m (km/h)`                | `wind_speed_10m_km_per_h`              |
| `wind_direction_10m (°)`               | `wind_direction_10m_deg`               |
| `shortwave_radiation_sum (MJ/m²)`     | `shortwave_radiation_sum_mj_per_m2`    |
| `et0_fao_evapotranspiration (mm)`     | `et0_fao_evapotranspiration_mm`        |

---

### 🔍 Key Checks Performed

#### 5.1. **Sample Preview**  
We pulled the first 10 rows to verify schema, column types, and value formats:

```sql
SELECT * 
FROM `bi-tutrial-401008.open_meteo.meteo_hourly_2`
LIMIT 10;
```
### 5.2. **Time Range & Record Frequency**
Confirmed the dataset's coverage and granularity:

```sql
SELECT 
  MIN(time) AS start_date,
  MAX(time) AS end_date,
  COUNT(*) AS total_records,
  COUNT(DISTINCT time) AS unique_timestamps
FROM `bi-tutrial-401008.open_meteo.meteo_hourly_2`;
```
### 5.33. **Missing Data Check**
Check for any null values in the three primary weather metrics:

```sql
SELECT
  COUNTIF(temperature_2m_C IS NULL) AS missing_temperature,
  COUNTIF(relative_humidity_2m_percent IS NULL) AS missing_humidity,
  COUNTIF(wind_speed_10m_km_per_hour IS NULL) AS missing_wind_speed
FROM `bi-tutrial-401008.open_meteo.meteo_hourly_2`;
```
### 5.4. **Summary Statistics**
Generated min, max, average values for key metrcis:

```sql
SELECT
  MIN(temperature_2m_C) AS min_temp,
  MAX(temperature_2m_C) AS max_temp,
  AVG(temperature_2m_C) AS avg_temp,
  
  MIN(relative_humidity_2m_percent) AS min_humidity,
  MAX(relative_humidity_2m_percent) AS max_humidity,
  AVG(relative_humidity_2m_percent) AS avg_humidity,
  
  MIN(wind_speed_10m_km_per_hour) AS min_wind,
  MAX(wind_speed_10m_km_per_hour) AS max_wind,
  AVG(wind_speed_10m_km_per_hour) AS avg_wind
FROM `bi-tutrial-401008.open_meteo.meteo_hourly_2`;
```

## 📊 Step 6: Visualizing the Relationship Between Cloud Cover and Solar Radiation

### 🧠 Objective  
To explore whether **cloud cover (`cloud_cover_percentage`)** is a reliable predictor of **shortwave solar radiation (`shortwave_radiation_watts_per_m2`)** — a key variable affecting solar energy generation.

---

### 🛠️ Tools Used
- **BigQuery**: SQL queries to filter and sample data  
- **Tableau Desktop**: Visualized the relationship using a scatter plot  
- **Open-Meteo API data**: Provided hourly weather observations

---

### 🔍 Method  
We extracted a **random sample of 1,000 hourly rows** using BigQuery, limited to the time period between 2024-01-01 and 2024-06-30:

```sql
SELECT
cloud_cover_percentage,
  shortwave_radiation_watts_per_m2
FROM
  `bi-tutrial-401008.open_meteo.meteo_hourly_2`
WHERE
  DATE(datetime) BETWEEN '2024-01-01' AND '2024-06-30'
ORDER BY RAND()
LIMIT 1000;
```
This was exported and visualized in Tableau using a scatter plot where:
- X-axis = `cloud_cover_percent`
- Y-axis = `shortwave_radiation_watts_per_m2`

### 📈 Finding
The relationship is visually weak and statistically insignificant, with a Pearson correlation coefficient of -0.065. This implies:
- Cloud cover has some negative effect, but not enough to act as a standalone predictor.
- The scatter plot showed high variability in radiation even at similar cloud cover levels.

### 💡 Business Implication
**Relying solely on cloud cover to estimate solar performance is unreliable.**
Energy analysts or solar operations managers should not base decisions on cloud cover alone. Other weather variables (e.g. humidity, temperature, air pressure, precipitation) must be considered. 
This insight helps narrow the modeling focus for building more robust predictors of solar generation performance.

## 📊 Step 7: Time-Bucketed Wind Speed vs Solar Radiation Analysis

### 🎯 Objective
To investigate whether wind speed has a significant correlation with solar radiation and whether this relationship is influenced by the time of day — particularly during daylight hours when solar energy generation is most active.

### 🛠️ Method
1. **Data Queried** from Open-Meteo hourly weather data:
   ```sql
   SELECT
     DATE(time) AS day,
     EXTRACT(HOUR FROM time) AS hour,
     wind_speed_10m_km_per_hour,
     shortwave_radiation_watts_per_m2
   FROM
     `bi-tutorial-401008.open_meteo.meteo_hourly_2`
   WHERE
     shortwave_radiation_watts_per_m2 > 0
   ```
2. **Calculated Field in Tableau:
   IF [hour] >= 6 AND [hour] <= 9 THEN "06–09"
   ELSEIF [hour] >= 10 AND [hour] <= 12 THEN "10–12"
   ELSEIF [hour] >= 13 AND [hour] <= 15 THEN "13–15"
   ELSEIF [hour] >= 16 AND [hour] <= 18 THEN "16–18"
   ELSE "Other"
   END
3. **Visualisation:
   A scatter plot was created:
  - X-axis: `wind_speed_10m_km_per_hour`
  - Y-axis: `shortwave_radiation_watts_per_m2`
  - Color: Hour Bucket (calculated field)
  - Filtered to exclude "Other" time groups (non-daylight hours).

## 📈 Key Insight
- When viewed as a whole, no strong linear correlation is observed between wind speed and solar radiation.
- However, clear daylight patterns emerge:
  - Midday hours (10–15) concentrate the highest solar radiation, regardless of wind speed.
  - Morning and late afternoon show lower radiation levels, consistent with expected sun angle and exposure.
 
This reveals that solar performance analysis must account for time-of-day effects, and that meteorological correlations may only appear when data is     appropriately segmented.

## ✅ Next Step
We now move on to analyze temperature and cloud cover effects on solar radiation, maintaining the same hourly segmentation to isolate meaningful patterns across weather variables.
  
## 📊 Step 8: Exploratory Analysis — Weather vs Solar Radiation

In this step, we visually explored how temperature and cloud cover affect solar irradiance (shortwave radiation) across key daylight hours. This helped us assess how weather variability might explain fluctuations in solar energy potential.

---

### 🔍 Objectives

- Examine **how temperature correlates** with shortwave radiation throughout the day.
- Investigate **how cloud cover affects solar radiation**, especially during peak sunlight hours.
- Begin identifying **hourly patterns** that can impact solar farm efficiency.

---

### 🔁 Hour Buckets Defined

To observe clear intra-day trends, we grouped the data into 4 logical time segments:

| Hour Bucket | Time Range       |
|-------------|------------------|
| 06–09       | Early Morning    |
| 10–12       | Late Morning     |
| 13–15       | Early Afternoon  |
| 16–18       | Late Afternoon   |

---

### 📈 Visualizations

#### 1. Temperature vs Shortwave Radiation

This scatter plot reveals a **positive correlation** between air temperature and solar radiation — but the strength of this relationship changes depending on the hour bucket. Notably:
- Radiation increases with temperature up to a saturation point (~28–35°C).
- Earlier hours (06–09) show lower radiation despite rising temperatures — consistent with the sun’s position.

#### 2. Cloud Cover vs Shortwave Radiation

This second plot highlights a clear **inverse relationship** between cloud cover and radiation:
- High radiation levels are more likely when cloud cover is **low (0–20%)**.
- There’s a wide radiation range even with partial cloud cover, suggesting other variables (like humidity, elevation, or haze) may also play a role.

---

### 🧠 Key Insights

- **Morning sunlight hours are less productive**, even if the temperature is rising — likely due to lower sun angles.
- **High radiation occurs most consistently between 10:00 and 15:00**, especially on clear days.
- **Cloud cover >80% almost always results in minimal solar radiation**, indicating potential downtime for solar panel output.

---

## Step 9: Visualization of Hourly Weather Patterns – Box Plots & Dual-Axis Chart

### 🎯 Goal
To visualize and compare **temperature** and **shortwave radiation** distributions across different times of day, and to explore the lag effect between radiation peaks and temperature peaks.

---

### 🛠 Methods & Micro Steps

#### 1. **Data Source**
- Used previously extracted **non-aggregated hourly weather dataset** from BigQuery.
- Columns used:  
  - `datetime` – Timestamp of reading  
  - `temperature_C` – Air temperature (°C)  
  - `shortwave_radiation` – Solar radiation (W/m²)  
  - `windspeed_kph` – Wind speed (km/h)

---

#### 2. **Time-of-Day Buckets (Tableau Calculated Field)**
Created a calculated field to group hours into logical daily periods:
```tableau
IF DATEPART('hour', [datetime]) >= 0 AND DATEPART('hour', [datetime]) <= 5 THEN 'Night'
ELSEIF DATEPART('hour', [datetime]) >= 6 AND DATEPART('hour', [datetime]) <= 9 THEN 'Early Morning'
ELSEIF DATEPART('hour', [datetime]) >= 10 AND DATEPART('hour', [datetime]) <= 13 THEN 'Late Morning'
ELSEIF DATEPART('hour', [datetime]) >= 14 AND DATEPART('hour', [datetime]) <= 17 THEN 'Afternoon'
ELSEIF DATEPART('hour', [datetime]) >= 18 AND DATEPART('hour', [datetime]) <= 21 THEN 'Evening'
ELSE 'Late Night'
END
```
- Applied custom sort to ensure buckets follow a chronological order.

### 3. **Box Plot Creation**
- First Box Plot: Temperature vs Time of Day.
  - Measure: `temperature_C` aggregated as AVG.
- Second Box Plot: Shortwave Radiation vs Time of Day
  - Measure: `shortwave_radiation` aggregated as AVG.
 
### 4. **Dual-Axis Line Chart**
- Plotted Temperature and Shortwave Radiation against `time_of_day_bucket`.
- Set Temperature on primary axis and Shortwave Radiation on secondary axis.
- Renamed axes:
  - Temperature C
  - Shortwave Radiation (W/m2)

### 5. **Annotations**
- Added annotation boxes to highlight Late Morning and Afternoon as periods of peak shortwave radiation.
- Noted lag between radiation peak and temperature peak.

### 6. **Dashboard Layout Finalization**
- Placed legend above visualizations for clarity and to reduce vertical spacing.
- Added descriptive dashboard title.
- Arranged both box plots and dual-axis chart to maximize comparative readability.

### 📊 **Insights**
- Peak solar radiation consistently occurs in Late Morning to Early Afternoon.
- Temperature peaks lag behind radiation peaks, likely due to the time it takes for the environment to absorb and re-radiate heat.
- Box plots reveal greater variability in shortwave radiation than temperature, especially in transitional periods (morning and evening).
- The dual-axis chart confirms a clear correlation between radiation and temperature, but also shows that weather conditions can cause daily deviations.

