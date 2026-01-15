library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(knitr)
library(kableExtra)
library(multcomp)
library(car)


# creating all enrollments
all_enrollments <- all_enrollments %>%
  mutate(
    enrolled_date = as.Date(enrolled_at),
    unenrolled_date = as.Date(unenrolled_at),
    enrollment_duration = as.numeric(unenrolled_date - enrolled_date),
    fully_participated = !is.na(fully_participated_at),
    purchased_statement = !is.na(purchased_statement_at),
    unenrolled = !is.na(unenrolled_at),
    engagement_status = case_when(
      fully_participated ~ "Completed",
      unenrolled ~ "Unenrolled",
      TRUE ~ "Still Active / Unknown"
    ),
    has_demographics = !(gender == "Unknown" |
                           age_range == "Unknown" |
                           highest_education_level == "Unknown" |
                           employment_status == "Unknown")
  )

cat("Data loaded and prepared.\n")
cat("Total enrollments:", nrow(all_enrollments), "\n")
cat("Course runs:", n_distinct(all_enrollments$course_run), "\n")

cat("Feature creation completed\n")

cat("\nEngagement status distribution:\n")
engagement_dist <- all_enrollments %>%
  count(engagement_status) %>%
  mutate(pct = round(n / sum(n) * 100, 2))
print(engagement_dist)

cat("\nCompletion indicator summary:\n")
cat("  Fully participated:", sum(all_enrollments$fully_participated),
    "(", round(mean(all_enrollments$fully_participated) * 100, 2), "%)\n")
cat("  Purchased statement:", sum(all_enrollments$purchased_statement),
    "(", round(mean(all_enrollments$purchased_statement) * 100, 2), "%)\n")
cat("  Unenrolled:", sum(all_enrollments$unenrolled),
    "(", round(mean(all_enrollments$unenrolled) * 100, 2), "%)\n")

cat("\nDuration statistics for unenrolled learners (days):\n")
duration_stats <- all_enrollments %>%
  filter(!is.na(enrollment_duration)) %>%
  summarise(
    mean   = mean(enrollment_duration),
    median = median(enrollment_duration),
    sd     = sd(enrollment_duration),
    min    = min(enrollment_duration),
    max    = max(enrollment_duration)
  )
print(duration_stats)

all_enrollments$enrolled_date <- as.Date(all_enrollments$enrolled_at)

min_date <- min(all_enrollments$enrolled_date, na.rm = TRUE)
max_date <- max(all_enrollments$enrolled_date, na.rm = TRUE)

cat("**Enrollment Date Range:**\n\n")
cat("- Earliest enrollment:", format(min_date, "%B %d, %Y"), "\n")
cat("- Latest enrollment:", format(max_date, "%B %d, %Y"), "\n")
cat("- Time span:", as.numeric(max_date - min_date), "days (~", 
    round(as.numeric(max_date - min_date) / 365, 1), "years)\n")

cat("\nData preparation complete.\n")

##Engagement Status

all_enrollments <- all_enrollments %>%
  mutate(
    fully_participated = fully_participated %in% c(TRUE, 1, "TRUE"),
    unenrolled = unenrolled %in% c(TRUE, 1, "TRUE"),
    engagement_status = case_when(
      fully_participated ~ "Completed",
      unenrolled ~ "Unenrolled",
      TRUE ~ "Still Active / Unknown"
    )
  )

engagement_dist <- all_enrollments %>%
  count(engagement_status) %>%
  mutate(
    Percentage = round(n / sum(n) * 100, 2),
    Cumulative_Pct = round(cumsum(n) / sum(n) * 100, 2)
  ) %>%
  rename("Engagement Status" = engagement_status, "Count" = n)

kable(engagement_dist,
      caption = "Learner Engagement Status",
      align = "lrrr") %>%
  kable_styling(bootstrap_options = c("striped", "hover"),
                full_width = FALSE)