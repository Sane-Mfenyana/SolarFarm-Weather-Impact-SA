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
