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

# Step 10: Evaluate Forecasting Accuracy with Error Metrics

In this step, we measure how well our weather-based energy forecasts align with the actual recorded generation data across **Photovoltaic (PV)**, **Concentrated Solar Power (CSP)**, and **Wind** energy sources.  

By calculating **MAE, RMSE, and MAPE**, we quantify the **forecast accuracy** — which directly impacts both operational planning and financial outcomes for renewable energy investments.

---

## Why Error Metrics Matter

Forecast errors affect:

- **Operational Decisions**  
  Utilities and Independent Power Producers (IPPs) rely on accurate forecasts to plan grid balancing, storage usage, and reserve power requirements.  

- **Financial Performance**  
  Large errors can mean overestimating or underestimating supply, which either forces **load shedding (supply shortfall)** or incurs **penalties and imbalance costs**.  

- **Investor Confidence**  
  Smaller, consistent errors improve investor trust in renewable projects by showing that generation outputs can be reliably forecasted.

---

## Metrics Explained

### 1. **Mean Absolute Error (MAE)**
- **Formula:** Average of the absolute difference between forecasted and actual values.  
- **Interpretation:** On average, how many MW the forecasts are off by.  
- **Results:**  
  - PV = **545.48**  
  - CSP = **79.52**  
  - Wind = **641.62**  

➡️ CSP has the lowest MAE, meaning its forecasts are closest on average. PV and Wind deviate more.  

---

### 2. **Root Mean Squared Error (RMSE)**
- **Formula:** Square root of the average squared difference between forecasted and actual values.  
- **Interpretation:** Penalizes larger errors more heavily. Good for spotting volatility.  
- **Results:**  
  - PV = **817.04**  
  - CSP = **100.89**  
  - Wind = **768.36**  

➡️ CSP again shows strong stability. PV and Wind not only deviate more, but their larger forecasting errors are more volatile.  

---

### 3. **Mean Absolute Percentage Error (MAPE)**
- **Formula:** Average of the absolute percentage errors relative to actual values.  
- **Interpretation:** Shows how big the errors are compared to actual generation, expressed as a percentage.  
- **Results:**  
  - PV = **158,383.67%**  
  - CSP = **9,989.43%**  
  - Wind = **101.22%**  

➡️ CSP and PV show extremely inflated MAPE values due to very small actual generation numbers at certain times (division by values close to zero exaggerates error). Wind shows a more interpretable error rate (~101%).  

---

## Insights for the Project

1. **CSP is the most predictable** of the three, with the lowest MAE and RMSE.  
2. **PV has high error volatility**, which matches the reality of solar being highly sensitive to sudden weather shifts (cloud cover, radiation changes).  
3. **MAPE is unreliable** in cases where actual generation is near zero — but it highlights the risk of underperforming forecasts during low-output periods.  
4. These metrics give **hard evidence** that forecast uncertainty varies by energy source, and that financial models must account for these risks when estimating **returns, penalties, or reserve energy costs**.  

---

# Step 10: Evaluate Model Performance Against Actuals

In this step, we tested how well our regression models (PV, CSP, Wind) performed when compared against **actual Eskom generation data**. This is where our analysis transitioned from pure modeling into validation, helping us assess the reliability of using weather as a predictor of renewable energy output.

---

## Key Evaluation Metrics

We calculated three core error metrics to evaluate each energy type:

- **MAE (Mean Absolute Error):**  
  Measures average absolute error in predictions. Lower values = better accuracy.  

- **RMSE (Root Mean Square Error):**  
  Gives higher weight to large errors, making it sensitive to big misses.  

- **MAPE (Mean Absolute Percentage Error):**  
  Expresses error as a percentage of actual values. Useful for interpretability, though unstable with very small denominators.  

---

## Results

| Energy Type | MAE    | RMSE    | MAPE        |
|-------------|--------|---------|-------------|
| PV          | 545.48 | 817.04  | 158,383.67  |
| CSP         | 79.52  | 100.89  | 9,989.43    |
| Wind        | 641.62 | 768.36  | 101.22      |

**Interpretation:**  
- CSP showed the **lowest error across all metrics**, meaning its relationship with weather was captured more reliably by the model.  
- PV and Wind models displayed **large errors**, suggesting higher variability and that more features (or better geographic alignment of data) may be required to improve predictions.  

---

## Visualization

We created a grouped bar chart to summarize the error metrics across energy types.

### Static Preview
<img width="777" height="659" alt="Error Metrics by Technology_ Comparing Model vs Actual Power Output" src="https://github.com/user-attachments/assets/03916447-3748-4faa-8092-385f898c4a91" />


### Interactive Dashboard
[View Interactive Tableau Dashboard](https://public.tableau.com/views/ErrorMetricsComparisonAcrossRenewableTechnologies/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

This dual approach allows immediate readability through the static chart, while also demonstrating interactivity and BI skill via Tableau Public.

---

## Why This Matters

Validating models against **real-world energy data** bridges the gap between theory and practice. For renewable energy stakeholders, this type of evaluation:  
- Highlights which technologies (PV, CSP, Wind) are more predictable based on weather.  
- Identifies where **financial forecasting is more stable** (e.g.CSP) versus where risk is higher (PV, Wind).  
- Sets the stage for translating weather-driven performance into **economic impacts and decision-making value**.  

---

# Step 11: Time-of-Day Analysis of Forecast Errors

In this step, we assessed how model accuracy varied by **time of day**, breaking the results into the buckets defined earlier: *Morning, Midday, Afternoon, Evening, Night*. This helped us understand whether systematic over- or under-prediction occurred during certain periods.

---

## Query: Time-of-Day Error Metrics (MAE)

We grouped forecast errors by energy type and time bucket, then calculated the **Mean Absolute Error (MAE)**:

```sql
CREATE OR REPLACE TABLE analysis.error_by_time_bucket AS
SELECT
  energy_type,
  time_bucket,
  AVG(ABS(predicted_output - actual_output)) AS mae
FROM `analysis.model_vs_actual_long`
GROUP BY energy_type, time_bucket
ORDER BY energy_type, time_bucket;
```
## Visualization

We created a grouped bar chart, comparing MAE across different time buckets for each renewable type (PV, CSP & Wind).

### Static Preview
<img width="1119" height="667" alt="Forecast Error by Time of Day and Energy Type" src="https://github.com/user-attachments/assets/0c6d3d1a-7b7e-4ab9-a871-e5448797f297" />

### Interactive Dashboard
https://public.tableau.com/views/ForecastErrorbyTimeofDayandEnergytype/Sheet1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

## Interpretation of Results

- PV (Solar Photovoltaic):
  - Error peaked at Midday (MAE ~1400), when solar generation is highest and weather-driven variability is strongest.
  - Morning (893) and Afternoon (573) also showed higher errors compared to Night or Evening, reflecting model difficulty in capturing ramp-up and ramp-down.
  - Evening (82) and Night (54) had very low errors, as expected, since PV output is nearly zero and easy to predict.
- CSP (Concentrated Solar Power):
  - Errors were highest in the Evening (103) and Afternoon (101), showing difficulty in capturing thermal storage/release effects.
  - Morning (67) and Midday (79) had moderate errors, aligning with the sun's rising and peak activity.
  - Night (54) again showed the lowest error.
- Wind:
  - Errors were relatively more stable across the day but peaked at Midday (801) and Morning (686).
  - Afternoon (618) and Night (587) were slightly better, while Evening (553) showed the lowest error.
  - This reflects the complex and less predictable diurnal wind patterns.
 
## Why This Matters

This analysis demonstrates that forecast errors are not evenly distributed across the day:
  - Solar (PV, CSP) models struggle most when generation is highest (midday, afternoon).
  - Wind has less predictable daytime variability, but nighttime predictions are relatively more reliable.
These insights tie back to the project’s broader goal:
  - Grid Operators can use this to anticipate when renewable forecasts are least reliable (e.g., midday solar peaks).
  - Financial Planners can better price risks around periods of high uncertainty.
  - Future Model Improvements could focus specifically on these high-error windows, rather than uniformly across all hours.

