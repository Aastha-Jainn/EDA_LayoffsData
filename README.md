# EDA_LayoffsData

# Layoffs Data Cleaning & Exploratory Data Analysis (COVID-19 Era)

## 📌 Project Overview
This project focuses on cleaning and exploring a real-world dataset of global company layoffs recorded during the COVID-19 pandemic. Using MySQL, raw, messy data is transformed into a clean, analysis-ready dataset, followed by exploratory analysis to uncover trends in layoffs across companies, industries, countries, and time.

## 🎯 Objectives
- Clean and standardize a raw layoffs dataset containing duplicates, inconsistent formatting, and missing values.
- Build a reliable staging table to preserve raw data integrity while enabling safe transformations.
- Perform exploratory data analysis (EDA) to identify patterns in layoffs by company, industry, location, and time period.

## 🛠️ Tools & Technologies
- MySQL (MySQL Workbench)
- SQL Window Functions (`ROW_NUMBER()`, `PARTITION BY`)
- String and Date functions (`STR_TO_DATE`, `TRIM`)

## 🧹 Data Cleaning Process

1. **Staging Table Creation**
   - Created a `layoffs_staging` table as a working copy of the raw `layoffs` table to avoid modifying original source data.

2. **Duplicate Removal**
   - Used `ROW_NUMBER()` with `PARTITION BY` across all relevant columns to identify exact duplicate rows.
   - Removed rows where `row_num > 1`, keeping only the first occurrence of each duplicate set.

3. **Standardizing Data**
   - Trimmed whitespace from text fields (e.g., company names) to prevent mismatches caused by formatting inconsistencies.
   - Standardized inconsistent representations of missing values (e.g., blank strings vs. `NULL`).

4. **Handling Null / Blank Values**
   - Identified and reviewed `NULL` and empty-string values across key columns to distinguish genuinely missing data from formatting inconsistencies.

5. **Date Formatting**
   - Converted the `date` column from text to a proper `DATE` type using `STR_TO_DATE()`, accounting for varying date formats (`%m/%d/%Y` vs `%m/%d/%y`) present in the raw data.

6. **Removing Irrelevant Columns/Rows**
   - Dropped helper columns (e.g., `row_num`) used only for the cleaning process once no longer needed.

## 📊 Exploratory Data Analysis
Post-cleaning, the dataset was explored to answer questions such as:
- Which companies and industries saw the highest number of layoffs?
- How did layoffs trend over time during the COVID-19 period?
- Which countries/locations were most affected?
- Is there a relationship between company funding raised and layoff scale?

## 📁 Repository Structure
```
├── layoffs_cleaning.sql     # SQL script for data cleaning steps
├── layoffs_eda.sql          # SQL script for exploratory analysis queries
└── README.md                # Project documentation
```

## 🚀 Key Takeaways
This project demonstrates practical, real-world data cleaning techniques using SQL — including deduplication with window functions, handling inconsistent nulls, and standardizing date formats — as a foundation for reliable downstream analysis.
