---

## 📍 Part A – Predictive Modeling of NYC Stop-and-Frisk (2008–2016)

### 🎯 Objective

This project aims to explore how historical police stop data can be used to **predict the likelihood that a weapon will be found** during a stop-and-frisk encounter in New York City. Specifically, I focused on:

- Building interpretable models using **logistic regression**
- Evaluating model generalization across time using **temporal cross-validation**
- Quantifying performance with **AUC (Area Under the ROC Curve)**

The core objective is not just to build a predictive model, but to **investigate how model accuracy degrades over time** due to shifting policies, behaviors, or enforcement patterns — an issue often overlooked in public safety analytics.

This analysis also raises a broader question: _Can a model trained on historic police behavior continue to make fair and accurate predictions in a changing social and legal landscape?_


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

The second part of this project focuses on developing a **custom web scraper** to collect unstructured crime data from a local Boston news aggregator. The goal was to:

- Extract structured information (crime type, neighborhood, time) from semi-structured HTML pages
- Clean and standardize inconsistent entries and timestamp formats
- Analyze **hourly crime trends** across neighborhoods and crime types

Ultimately, this part of the project demonstrates how **raw web data can be turned into actionable insights**, especially in contexts where official datasets are limited or delayed. It highlights the value of:

- **Open-source intelligence (OSINT)** for public safety
- **Temporal pattern detection** for resource allocation
- **Custom scraping pipelines** for replicable data acquisition across city-specific websites


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
