---

## 📍 Part A – Predictive Modeling of NYC Stop-and-Frisk (2008–2016)

### 🎯 Objective
Build and evaluate logistic regression models to predict if a weapon was found during a stop. Focus is placed on **temporal generalization** and AUC (Area Under Curve) analysis.

### 🔨 Data Processing Pipeline (`Stop and Frisk-A.R`)

#### `clean_sqf()`
- Filters to `suspected.crime == "cpw"` (criminal possession of a weapon)
- Removes Precinct 121 and incomplete rows
- Selects critical columns:
  - Stop circumstances (e.g., `additional.*`, `stopped.bc.*`)
  - Subject demographics (age, build, sex, height, weight)
  - Location/time indicators
- Converts `time.period` and `precinct` to factors

#### `split_sqf_data()`
- Restricts to data from 2013–2015
- Splits into:
  - `sqf_pre_train`: training set (2013–2014)
  - `sqf_pre_test`: testing set (2013–2014)
  - `sqf_2015`: held-out set for forward validation
- Ensures no leakage by **not using random shuffling across years**

---

### 🤖 Logistic Regression Models

#### `logistic_model_1()`
- Trained on `sqf_pre_train`  
- Predicts weapon possession using all variables  
- Evaluated using **AUC** on:
  - `sqf_pre_test` (in-time validation)
  - `sqf_2015` (forward generalization)

📊 **AUC Results**

![AUC Table](./screenshots/auc_summary_table.png)

#### Insight:
AUC was significantly lower on the 2015 data, indicating that even a robust model may generalize poorly across years due to changes in policy, community behavior, or data collection.

---

#### `logistic_model_2()`
- Trains model only on 2008 data  
- Applies model to each year (2009–2016)  
- Returns a **yearly AUC trend**



📈 **Trend Visualization**

<img width="1153" alt="Screenshot 2025-06-05 at 16 24 22" src="https://github.com/user-attachments/assets/1ed40378-a502-46af-8904-bbc6eef170d0" />

🧠 **Interpretation**:
The steady decline in AUC from 2009 to 2016 highlights how the model becomes increasingly outdated as data evolves. This supports the importance of retraining and adapting models over time for law enforcement analytics.

---

## 🌆 Part B – Scraping & Analyzing Boston Crime Data

### 🎯 Objective
Scrape structured crime reports by hour and neighborhood from [Universal Hub](https://www.universalhub.com/crime/home.html) to analyze temporal crime patterns.

### 🕸️ Web Scraping Workflow (`Stop and Frisk-B.R`)

#### `scrape_data()`
- Loops through 20 Boston neighborhoods
- Extracts:
  - `crime` type
  - `hour` (from timestamps using `lubridate`)
  - `nbhd` (standardized to lowercase with hyphens)
- Cleans known typos and blanks (e.g., `"Stabbin"` → `"Stabbing"`, empty → `NA`)
- Returns a cleaned tibble with all incidents


### ⏰ Visualizing Temporal Crime Patterns

#### Total Crimes by Hour

<img width="1109" alt="Screenshot 2025-06-05 at 16 27 16" src="https://github.com/user-attachments/assets/39b3499b-8dda-42fc-8983-3fa9561a4cf0" />

📌 *Insight*: Peak activity occurs around 9 PM, with a clear rise in late evening hours across neighborhoods.

#### Top 6 Crime Types by Hour (`facet_wrap()` plot)

<img width="1159" alt="Screenshot 2025-06-05 at 16 27 59" src="https://github.com/user-attachments/assets/99f3dea5-a4e7-4a38-885c-ab41b55d3205" />


📌 *Insight*: Most crime types follow a similar temporal profile, emphasizing risk concentration at night.

---

## 🧠 Key Learnings

- **Temporal data splitting** is critical for realistic model evaluation in policy and public safety datasets
- **Generalization drops over time**, even for logistic models with good internal validation
- **Web data is messy**: Requires thoughtful cleaning, standardization, and error correction
- **Crime is time-sensitive**: Time-of-day patterns are consistent across crime types and locations

---

## 💼 Use Cases & Applications

- **Law enforcement**: Improve resource allocation by time/location-based crime predictions
- **Public policy**: Evaluate stop-and-frisk model reliability over time
- **Web scraping pipeline**: Scalable for any multi-page, semi-structured data source

---

## 📌 Next Steps

- Add **Random Forest** and **XGBoost** models for better nonlinear performance
- Explore **geospatial analysis** using `leaflet` or `sf`
- Develop **automated retraining pipeline** to monitor model decay over time
- Visualize **neighborhood-specific trends** in both NYC and Boston

---


## 📝 License

This project is for academic and portfolio purposes. No real-time predictions are made or advised based on the content herein.
