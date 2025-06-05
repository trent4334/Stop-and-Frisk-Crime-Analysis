---

## 📊 Part 1: Predictive Modeling on NYC Stop-and-Frisk Data

Using data from 2008–2016, I built a logistic regression model to predict whether a weapon was found during a police stop. The data was filtered to focus on stops involving a suspected criminal possession of a weapon (`cpw`), and cleaned to ensure completeness.

### ✅ Data Preprocessing

- Filtered for `cpw` stops
- Removed stops with missing values
- Selected key features (stop circumstances, subject demographics, etc.)
- Converted time-based features into factors

### 📁 Data Split Strategy

To avoid data leakage in this time-series context:

- Train/test split was **time-based** (not random)
- Training: 2013–2014  
- Validation: 2015

### ⚙️ Model 1 – Trained on 2013–2014

This model was evaluated using AUC on both the 2013–2014 test set and the held-out 2015 data.

📊 **AUC Scores**

![Table 1: AUC values](./screenshots/Screenshot_2025-06-05_at_16.16.17.png)

📈 **Insight**: The AUC on the 2015 set was noticeably lower, suggesting that predictive power drops over time due to changing patterns in policing or stop conditions.

---

### 📉 Model 2 – Trained on 2008, Tested Year-by-Year

A second model was trained only on 2008 data and tested across 2009–2016 to assess generalization over time.

📊 **AUC by Year**

![Table 2: AUC by Year](./screenshots/Screenshot_2025-06-05_at_16.16.28.png)

📈 **AUC Trend**

![Figure: AUC line plot](./screenshots/Screenshot_2025-06-05_at_16.16.39.png)

🔎 **Observation**: AUC declines steadily after 2008, reflecting possible structural changes in stop patterns or community dynamics.

---

## 🌇 Part 2: Web Scraping and Crime Trend Analysis (Boston)

I scraped reported crime data from [Universal Hub](https://www.universalhub.com/crime/home.html) for 20 neighborhoods in Boston. The dataset includes:

- **Crime type**
- **Time of day (hour)**
- **Neighborhood**

### 🧹 Cleaning Highlights

- Converted timestamps to hour (0–23)
- Standardized neighborhood names (e.g., `back-bay`)
- Fixed typos like `"Stabbin"` → `"Stabbing"` and `"dangeous"` → `"dangerous"`
- Encoded blanks as `NA`

📊 **Sample Data Preview**

![Sample scraped table](./screenshots/Screenshot_2025-06-05_at_16.16.17.png)

---

### ⏰ Hourly Crime Patterns

I aggregated all crimes to visualize trends by hour.

📈 **Total Crimes by Hour**

![Hourly crime pattern](./screenshots/Screenshot_2025-06-05_at_16.16.28.png)

🧠 **Observation**: Crime incidents spike in the late evening, peaking around 9 PM, consistent with low-light, high-activity periods.

---

### 🔍 Crime Type Breakdown (Top 6)

To explore specific behaviors, I plotted hourly trends for the six most frequent crimes using `facet_wrap`.

📈 **Hourly Trend by Crime Type**

![Top 6 crime types](./screenshots/Screenshot_2025-06-05_at_16.16.39.png)

🧠 **Takeaway**: Despite some variation, all major crime types show similar peaks in the late evening, reinforcing the importance of time-based policing strategies.

---

## 🎯 Key Learnings

- **Temporal evaluation matters**: For real-world data like policing, random splits can mislead model performance.
- **Data changes over time**: Even strong models degrade with policy or behavioral shifts.
- **Scraping real-world data** teaches resilience: Inconsistent structures, typos, and formatting issues are the norm.
- **Visualization reveals patterns** not obvious from raw tables.

---

## 🧑‍💻 Author

**Trent Yu**  
Data Analytics Graduate Student | R | Python | Tableau  
New York, NY  
📫 [LinkedIn](https://linkedin.com/in/your-profile) • [GitHub](https://github.com/your-profile)

---

## 📌 Next Steps

- Try ensemble models like Random Forest or XGBoost on the stop-and-frisk data
- Expand the crime scraper to include sentiment analysis from article content
- Use time series modeling to predict hourly crime rates in Boston neighborhoods
