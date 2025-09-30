# Weather's Impact on South Africa's Renewable Energy

### A Business Intelligence Analysis using BigQuery ML & Tableau

[[View Full Analysis on GitHub](./README.md)]

---

## The Challenge
Renewable energy is crucial for South Africa, but its output is at the mercy of the weather. How can grid operators and investors make reliable decisions when their primary sources of power are so variable?

This project dives into the data to find the answers.

## Key Insights at a Glance

### Not All Solar is Created Equal
<img width="809" height="633" alt="Feature Importance_ How Weather Factors Influence CSP vs PV (Regression Coefficients) (1)" src="https://github.com/user-attachments/assets/89e36008-76f2-4db1-866a-ae1734bda5bd" />

A critical finding: **higher temperatures BOOST CSP output but REDUCE PV efficiency.** This means technology choice is highly dependent on local climate.

### Forecasts Fail When It Matters Most
<img width="999" height="799" alt="Dashboard 1 (2)" src="https://github.com/user-attachments/assets/494bb0de-6c66-4fd1-b94b-f96957f2da56" />

**Prediction errors spike at midday**—precisely when solar generation is highest and the grid is most vulnerable. This reveals a major risk window for operators.

### The Power of a Diversified Portfolio
<img width="999" height="799" alt="Dashboard 1 (3)" src="https://github.com/user-attachments/assets/29cdfdfb-78ab-408a-a4bf-7cb2ad64cbde" />

**Wind is the backbone but volatile. Solar is predictable but seasonal.** The data clearly shows that a mix of both is essential for a stable, year-round energy supply.

---

## Explore the Project

- **[Full Technical Write-Up & Methodology](./README.md)**
- **[SQL Code & BigQuery ML Models](./sql_code/bqml_analysis.sql)**

*This project was built with Google BigQuery, BigQuery ML, SQL, and Tableau.*
