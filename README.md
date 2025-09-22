# Impact of Weather Variability on Renewable Energy Output in South Africa

A comprehensive data analysis project investigating how weather factors drive the performance of solar (PV and CSP) and wind farms in South Africa. Using statistical analysis and machine learning regression models, this project quantifies key relationships to provide actionable insights for grid operators, investors, and energy planners.

## 📊 Project Overview

### 🎯 The Mission
To determine the primary weather drivers of solar and wind energy generation and to evaluate the accuracy of weather-based forecasting models. The goal is to translate meteorological data into strategic insights for operational planning, risk assessment, and investment decisions.

### 🔑 Key Questions
- How do temperature, solar irradiance, and cloud cover correlate with energy output from PV and CSP technologies?
- How accurate are weather-based forecasts for predicting renewable generation?
- How does forecast accuracy and energy output vary by season and time of day?
- What are the practical implications for grid stability and financial planning?

### 📁 Data Sources
- **Open-Meteo Historical API**: Hourly weather data (temperature, solar radiation, cloud cover, wind speed).
- **Eskom**: Actual historical energy generation data for PV, CSP, and Wind.

### 🛠️ Tools & Technologies
- **Google BigQuery**: Data storage, cleaning, and analysis using SQL.
- **BigQuery ML**: Building and evaluating linear regression models.
- **Tableau**: Data visualization and dashboard creation.

---

## 1. Laying the Foundation: Data Acquisition & Preparation

The foundation of any robust analysis is clean, reliable data. We started by ensuring our dataset was accurate and ready for analysis.

- **Data Validation**: Verified the integrity of the hourly weather dataset, ensuring full annual coverage (8,778 records) and consistent formatting.
- **Schema Standardization**: Renamed columns in BigQuery for clarity and compatibility (e.g., `temperature_2m (°C)` became `temperature_2m_c`).
- **Quality Checks**: Conducted checks for missing values and generated summary statistics to understand data distributions.

---

## 2. Finding the Patterns: How Weather Drives Solar Power

We began by asking a fundamental question: which weather factors have the strongest influence on solar radiation? We used scatter plots and correlation analysis to find out.

### 2.1. Cloud Cover is an Unreliable Predictor on Its Own
Our first test was to see if cloud cover alone could predict solar radiation. The result was clear: **the relationship is weak and statistically insignificant.**

*   **In plain terms:** You cannot reliably forecast solar power generation using only cloud cover. Some cloudy days still have decent output, and some clear days underperform.
*   **Technical evidence:** A scatter plot revealed a Pearson correlation coefficient of just -0.065.
*   **Implication:** This finding immediately ruled out a simple, single-variable model and necessitated a more robust, multi-factor analysis.

### 2.2. The Daily Cycle: Sunlight Peaks Before Temperature
To model energy production accurately, we needed to understand the daily patterns of our key variables. We discovered a consistent lag between peak sunlight and peak temperature.

*   **In plain terms:** The sun is strongest around midday, but the day doesn't get hottest until a few hours later, as the earth and air absorb the heat.
*   **Technical evidence:** We visualized this using a dual-axis line chart (Figure 1), clearly showing solar radiation peaking in the "Late Morning" while temperature peaks in the "Afternoon."
*   **Implication:** This lag is a critical physical phenomenon that any accurate energy forecast model must account for.

![Daily Solar Radiation and Temperature Patterns]<img width="1099" height="849" alt="Daily Solar Radiation and Temperature Patterns (1)" src="https://github.com/user-attachments/assets/f3a80320-e409-4f6c-9ce9-86a2a8649630" />
***Figure 1**: Dual-axis chart showing the lag between peak solar radiation (Late Morning) and peak temperature (Afternoon).*

### 2.3. Key Weather Drivers During Daylight Hours
We segmented the day into logical buckets to analyze relationships specifically during active generation periods.

*   **In plain terms:** The connection between weather and solar power changes throughout the day. Higher temperatures correlate with energy output, but this relationship is strongest during peak sunlight hours.
*   **Technical evidence:** Scatter plots (Figure 2) show a positive correlation between temperature and radiation, strongest during peak sun hours (10-15), and a clear inverse relationship between cloud cover and radiation.
*   **Implication:** Solar farm performance models must consider the time of day to be accurate, as the influence of weather variables is not constant.

![Temperature and Cloud Cover vs. Shortwave Radiation]<img width="999" height="799" alt="Dashboard 1" src="https://github.com/user-attachments/assets/4b0187d1-6066-4072-96cc-8d788eefdcc9" />
***Figure 2**: Scatter plots showing the relationship between temperature/cloud cover and solar radiation during daylight hours.*

---

## 3. Building the Forecast: A Model for Each Technology

With the relationships understood, we moved to quantify them precisely and build predictive models.

### 3.1. Quantifying Relationships with Correlation Analysis
We calculated correlation coefficients to measure the strength of the linear relationship between weather factors and actual energy output.

*   **In plain terms:** We measured how closely changes in weather "move together" with changes in energy output. A value close to 1 or -1 means a strong relationship.
*   **Technical evidence:** The analysis (Figure 3) revealed that shortwave radiation is the strongest driver for PV (correlation: 0.89). For CSP, both radiation (0.67) and temperature (0.61) are important.
*   **Implication:** PV output is almost directly tied to sunlight intensity, while CSP performance is also significantly boosted by heat.

![Correlation of Weather Factors With CSP vs PV Energy Output]<img width="862" height="605" alt="Correlation of Weather Factors With CSP vs PV Energy Output (1)" src="https://github.com/user-attachments/assets/ab5d58a4-aa60-42d4-ab6e-25c15176038b" />
***Figure 3**: Correlation analysis between weather factors and energy output for PV and CSP technologies.*

### 3.2. Building Predictive Models with BigQuery ML
We used machine learning to create models that could predict energy output based on weather inputs.

```sql
CREATE OR REPLACE MODEL `renewable.energy_pv_regression`
OPTIONS(model_type = 'linear_reg') AS
SELECT
  solar_pv_mw,
  shortwave_radiation_watts_per_m2 AS shortwave_radiation,
  temperature_2m_C AS temperature,
  cloud_cover_percent AS cloud_cover
FROM `renewable.eskom_weather_joined`;
```

### 3.3. Interpreting the Models: A Tale of Two Technologies
The models revealed a critical difference in how CSP and PV technologies operate.

*   **In plain terms:** CSP plants, which use heat to generate power, perform better on hotter days. Conversely, PV panels become less efficient as they get hotter, so their output can decrease during heatwaves.
*   **Technical evidence:** The regression coefficients (Figure 4) show temperature has a strong positive effect on CSP (+6.79) but a strong negative effect on PV (-15.71).
*   **Implication:** Technology choice is highly climate-dependent. CSP is ideal for hot, sunny regions, while PV may require cooling solutions in similar environments.

![Feature Importance: How Weather Factors Influence CSP vs PV]<img width="809" height="633" alt="Feature Importance_ How Weather Factors Influence CSP vs PV (Regression Coefficients) (1)" src="https://github.com/user-attachments/assets/89e36008-76f2-4db1-866a-ae1734bda5bd" />
***Figure 4**: Regression coefficients (feature weights) from the linear regression models.*

---

## 4. Stress-Testing Our Models: How Accurate Are the Forecasts?

A model is only useful if it's accurate. We rigorously tested our forecasts against actual historical data.

### 4.1. Overall Forecast Error Metrics
We evaluated model performance using standard error metrics: Mean Absolute Error (MAE), Root Mean Square Error (RMSE), and Mean Absolute Percentage Error (MAPE).

*   **In plain terms:** We measured the average size of the forecast errors. Lower numbers are better. MAE tells us the average error, while RMSE penalizes large errors more heavily.
*   **Technical evidence:** CSP was the most predictable (lowest MAE/RMSE). PV and Wind models showed higher errors, indicating greater real-world volatility (Figure 5).
*   **Implication:** Forecasts for CSP are more reliable for financial planning. The higher volatility of PV and Wind requires more conservative risk management and backup plans.

![Error Metrics by Technology]<img width="999" height="799" alt="Dashboard 1 (2)" src="https://github.com/user-attachments/assets/494bb0de-6c66-4fd1-b94b-f96957f2da56" />
***Figure 5**: Error metrics (MAE, RMSE, MAPE) across the three renewable technologies.*

### 4.2. When Do the Forecasts Fail? Analyzing Errors by Time of Day
We discovered that forecast accuracy is not constant; it varies significantly throughout the day.

*   **In plain terms:** Our solar forecasts are least accurate exactly when it matters most—in the middle of the day when the sun is brightest and generation is highest. This is when unexpected clouds or weather changes have the biggest impact.
*   **Technical evidence:** The time-of-day error analysis (Figure 6) shows that PV forecast errors (MAE) peak dramatically at midday.
*   **Implication:** Grid operators need to be most cautious and have reserves ready during peak solar hours, as this is when forecasting uncertainty is greatest.

![Forecast Error by Time of Day and Energy Type]<img width="1119" height="667" alt="Forecast Error by Time of Day and Energy Type (1)" src="https://github.com/user-attachments/assets/3a58af13-8598-4ee9-b184-b6d92ad06394" />
***Figure 6**: Analysis of forecast errors (MAE) broken down by time of day and energy type.*

---

## 5. The Big Picture: Seasonal Performance and Risks

The final analysis consolidates everything into a strategic, high-level view of performance and reliability across the entire year.

*   **In plain terms:** Each technology has a "season." Solar power is strong in summer but weak in winter. Wind energy is a major contributor year-round but is highly unpredictable. A diversified mix is essential.
*   **Technical evidence:** The seasonal dashboard (Figure 7) shows PV output drops by ~60% in winter, while wind maintains higher but more variable output. CSP shows strong summer performance but with notable variability.
*   **Implication:** Relying on a single technology creates seasonal gaps and reliability issues. A portfolio combining solar and wind can provide a more stable year-round supply.

![Seasonal Renewable Output: Averages & Variability]<img width="999" height="799" alt="Dashboard 1 (3)" src="https://github.com/user-attachments/assets/29cdfdfb-78ab-408a-a4bf-7cb2ad64cbde" />
***Figure 7**: Seasonal analysis showing average output and variability across different technologies.*

---

## 6. Conclusion & Actionable Insights: A Guide for Decision-Makers

This analysis provides clear, data-driven insights for different stakeholders:

- **For Grid Operators:** Forecasts are least accurate during peak generation periods (midday for PV). This is when the risk of a supply-demand mismatch is highest, necessitating ready access to reserve power or storage.
- **For Investors & Project Planners:** Technology choice is critical. CSP is excellent for hot, sunny, cloud-free environments but is a poor fit for cloudy regions. PV is more versatile but requires an understanding of local temperature profiles. Wind offers high output but demands financial models that can handle its volatility.
- **For Energy Policy:** The complementary profiles of solar (summer-peaking) and wind suggest a diversified renewable portfolio is essential for a resilient and stable grid throughout the year.
