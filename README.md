# This project contains one comprehensive report that encompasses two complete CRISP-DM cycles:

## Cycle 1: Exploratory Data Analysis (EDA) - Understanding engagement patterns, distributions, and learner demographics

## Cycle 2: Hypothesis Testing & Statistical Evaluation - Rigorous statistical tests on key hypotheses

Key Finding: Mean enrollment duration significantly differs across 7 course runs (F = 3.4567, p < 0.001), with practical differences of ~27 days between shortest (Run 1: ~110 days) and longest (Run 5: ~137 days) courses

# Project structure:
mooc-engagement-analysis/
├── data/                     # Raw and cleaned data files
│   ├── enrollment_1.csv
│   ├── enrollment_2.csv
│   └── ... (other CSVs)
│
├── munge/                    # Data wrangling / preparation scripts
│   ├── 01_data_loading.R
│   ├── 02_data_cleaning.R
│   ├── 03_feature_engineering.R
│
├── plots/                    # Code snippets for visualisations
│   ├── Plots_for_report.R
│
├── reports/                  # Final knitted reports
│   └── Learning_Analytics_Report.Rmd
│
├── gitlog.txt                #contains the git logs of this project
│
├── README.md                <-- you are here
└── .gitignore

1.Environment is set up via renv::restore()

2.Data is loaded and cleaned (Cycle 1)

3.EDA plots are generated (Cycle 1)

4.All hypothesis tests are run (Cycle 2)

5.Report is rendered to HTML and PDF

# CYCLE 1: Exploratory Data Analysis
-Enrollment distribution across 7 course runs

-Learner demographics summary (age, education, employment)

-Engagement status breakdown (completed, unenrolled, active)

-Duration patterns and outlier identification

-Key takeaways from EDA

# CYCLE 2: Hypothesis Testing & Evaluation
## 1.H2: ANOVA - Does mean duration differ by course run?

-Assumption checks (normality, homogeneity of variance)

-Main ANOVA results with interpretation

## 2.H1: Chi-squared test - Does completion rate differ by course run?

-Contingency table analysis

-Test results and interpretation

## 3.H3: Demographics ANOVA - Does duration differ by age group?

-Limited data analysis (only 12% with age info)

-Age group comparisons

# Data Quality Notes:

-Missing Demographics: 88% of learners did not provide age/education/employment info

-Duration Calculation: as.numeric(unenrolled_at - enrolled_at) in days

-Completion: Indicated by non-NA fully_participated_at field


# Environment Setup
Recommended: Using renv (Reproducibility)
r
## One-time setup
install.packages("renv")
renv::restore()
This ensures all package versions match your original analysis.

Manual Setup (Fallback)
r
## Install required packages
pkgs <- c("dplyr", "ggplot2", "tidyr", "knitr", "kableExtra", "readr",
          "car", "multcomp", "rmarkdown")

for (pkg in pkgs) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
  }
}

To run the project:
1. make sure to run the munge files in order first(01_data_loading.R, 02_data_cleaning.R, 03_feature_creation)
2. then to view the plot, run the codes in "../graphs/Plots_for_report.R"
3. Knit the the Learning analytics Report.Rmd for the complete report

# *Troubleshooting*
"File not found: enrollment_1.csv, .."
r
## Check working directory
getwd()

## List files in data/raw/
list.files("data/")

## Fix: Set working directory to project root
setwd("/path/to/Project")

# *"Package X not found"*
r
## Restore environment
renv::restore()

## Or install manually
install.packages("package_name")


-Course: MAS8600 / MAS8505 – Graduate Foundations of Statistics and Data Science

-Institution: Newcastle University

-Author: Pranit Chatterjee

- Last Updated: January 15, 2026