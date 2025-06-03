# Stop and Frisk Crime Analysis

This project explores patterns of weapon possession and urban crime using public datasets from New York City and Boston. The analysis includes logistic regression modeling, AUC evaluation, and web scraping. 

> **Note:** This project was originally developed as part of a university machine learning course and has been adapted for portfolio presentation.

## Project Overview

This project explores crime data through two lenses: police stops in NYC (2008–2016) and recent community-reported crimes in Boston. I used R to conduct logistic regression modeling, evaluate model performance using AUC, and visualize crime trends over time. I also performed web scraping to gather real-world crime data from multiple Boston neighborhoods.

The goal was to assess the predictive power of stop-and-frisk data across years and to uncover temporal patterns in urban crime reporting.

Key skills demonstrated include:
- Data cleaning and preprocessing with tidyverse
- Model training and AUC evaluation with ROCR
- Time-aware train/test splits
- Web scraping using rvest and foreach
- Visualization using ggplot2

  - **Logistic Regression + AUC Evaluation** on NYC Stop-and-Frisk data (2008–2016)
  - **Temporal train/test splits** for realistic model performance
  - **Data scraping + cleaning** from Universal Hub for recent Boston crime data
  - **Visualizations** of crime trends by hour and type

## Features

- Written entirely in base R + tidyverse + ROCR + rvest + foreach
- Modular code structure (each function written in `.R` files)
- Fully reproducible RMarkdown report

## Key Results

### 1. Predicting Weapon Possession (NYC Stop-and-Frisk)
- Logistic regression model trained on 2013–2014 data achieved:
  - AUC on 2013–2014 test set: **0.81**
  - AUC on 2015 data: **0.75**
- Performance drop indicates temporal shifts in policing or suspect behavior.

### 2. AUC Over Time (2009–2016)
- AUC declined year-over-year when applying a 2008-trained model to later years.
- Suggests need for regular model retraining due to changing real-world conditions.

### 3. Boston Crime Patterns
- Web-scraped incident reports from 20+ neighborhoods.
- Crimes consistently peaked around **9 PM**, lowest around **5–7 AM**.
- Top crimes: Stabbing, Gunfire, Assault — all follow similar temporal patterns.



## Files

- `assignment4_workflow.Rmd`: Source RMarkdown report
- `assignment4_workflow.pdf`: Knitted PDF report with plots and writeups
- `assignment4A.R`: Modeling and evaluation functions
- `assignment4B.R`: Web scraping and visualization functions

## Note

Due to file size, the original dataset (`sqf_08_16.csv`) is not included. Please contact me if you'd like to replicate the analysis.
