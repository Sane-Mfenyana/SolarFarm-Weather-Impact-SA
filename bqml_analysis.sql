-------------------------------------------------------------------------------
-- SolarFarm-Weather-Impact-SA
-- Core SQL Queries for BigQuery ML Analysis
-- Demonstrates data validation, correlation analysis, and model creation.
-- Author: Sanelisiwe Mfenyana.
-------------------------------------------------------------------------------

-- DATA QUALITY & EXPLORATION
-- Check the range and completeness of the primary dataset

SELECT
  MIN(time) AS start_date,
  MAX(time) AS end_date,
  COUNT(*) AS total_records,
  COUNTIF(shortwave_radiation_watts_per_m2 IS NULL) AS missing_radiation
FROM `your_project.open_meteo.meteo_hourly`;

-- CORRELATION ANALYSIS
-- Calculate correlation coefficients between weather factors and energy output

WITH correlations AS (
  SELECT
    'Cloud Cover (%)' AS factor,
    'PV' AS technology,
    CORR(solar_pv_mw, cloud_cover_percent) AS correlation
  FROM `your_project.analysis.energy_weather_joined`
  UNION ALL
  SELECT
    'Cloud Cover (%)' AS factor,
    'CSP' AS technology,
    CORR(solar_csp_mw, cloud_cover_percent) AS correlation
  FROM `your_project.analysis.energy_weather_joined`
  UNION ALL
  SELECT
    'Shortwave Radiation (W/m2)' AS factor,
    'PV' AS technology,
    CORR(solar_pv_mw, shortwave_radiation_watts_per_m2) AS correlation
  FROM `your_project.analysis.energy_weather_joined`
  UNION ALL
  SELECT
    'Shortwave Radiation (W/m2)' AS factor,
    'CSP' AS technology,
    CORR(solar_csp_mw, shortwave_radiation_watts_per_m2) AS correlation
  FROM `your_project.analysis.energy_weather_joined`
  UNION ALL
  SELECT
    'Temperature (°C)' AS factor,
    'PV' AS technology,
    CORR(solar_pv_mw, temperature_2m_C) AS correlation
  FROM `your_project.analysis.energy_weather_joined`
  UNION ALL
  SELECT
    'Temperature (°C)' AS factor,
    'CSP' AS technology,
    CORR(solar_csp_mw, temperature_2m_C) AS correlation
  FROM `your_project.analysis.energy_weather_joined`
)
SELECT * FROM correlations
ORDER BY technology, factor;

-- CREATE PV OUTPUT PREDICTION MODEL
-- Linear regression model to predict PV energy output

CREATE OR REPLACE MODEL `your_project.renewable.energy_pv_regression`
OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['solar_pv_mw']
) AS
SELECT
  solar_pv_mw,
  shortwave_radiation_watts_per_m2 AS shortwave_radiation,
  temperature_2m_C AS temperature,
  cloud_cover_percent AS cloud_cover
FROM
  `your_project.renewable.eskom_weather_joined`
WHERE
  solar_pv_mw IS NOT NULL;

-- CREATE CSP OUTPUT PREDICTION MODEL
-- Linear regression model to predict CSP energy output

CREATE OR REPLACE MODEL `your_project.renewable.energy_csp_regression`
OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['solar_csp_mw']
) AS
SELECT
  solar_csp_mw,
  shortwave_radiation_watts_per_m2 AS shortwave_radiation,
  temperature_2m_C AS temperature,
  cloud_cover_percent AS cloud_cover
FROM
  `your_project.renewable.eskom_weather_joined`
WHERE
  solar_csp_mw IS NOT NULL;

-- EVALUATE MODEL PERFORMANCE
-- Get key error metrics for the PV model
SELECT * FROM ML.EVALUATE(MODEL `your_project.renewable.energy_pv_regression`);

-- GET FEATURE WEIGHTS (Model Coefficients)
-- Understand which factors most influence PV output

SELECT * FROM ML.WEIGHTS(MODEL `your_project.renewable.energy_pv_regression`);

-- TIME-OF-DAY ERROR ANALYSIS
-- Calculate MAE for different time buckets (used for visualization)

SELECT
  energy_type,
  time_bucket,
  AVG(ABS(predicted_output - actual_output)) AS mae
FROM `your_project.analysis.model_vs_actual_long`
GROUP BY energy_type, time_bucket
ORDER BY energy_type, time_bucket;
