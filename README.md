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

## 📊 Step 3: Data Cleaning & Preparation

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

