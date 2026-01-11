library(dplyr)
library(tidyr)
library(tibble)

# Check for missing values
cat("\nMissing values by column:\n")
missing_summary <- all_enrollments %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "column", values_to = "missing_count") %>%
  filter(missing_count > 0) %>%
  arrange(desc(missing_count))

# Check for "Unknown" values in categorical fields
cat("\n'Unknown' values in categorical fields:\n")
unknown_summary <- tibble(
  field = c("gender", "age_range", "highest_education_level", "employment_status"),
  unknown_count = c(
    sum(all_enrollments$gender == "Unknown"),
    sum(all_enrollments$age_range == "Unknown"),
    sum(all_enrollments$highest_education_level == "Unknown"),
    sum(all_enrollments$employment_status == "Unknown")
  ),
  pct_total = round(unknown_count / nrow(all_enrollments) * 100, 1)
)

print(unknown_summary)

# Convert date strings to Date
cat("\nConverting date fields to Date objects\n")

all_enrollments <- all_enrollments %>%
  mutate(
    enrolled_date = as.Date(enrolled_at),
    unenrolled_date = as.Date(unenrolled_at),
    fully_participated_date = as.Date(fully_participated_at),
    purchased_statement_date = as.Date(purchased_statement_at),
    course_run = as.character(course_run)
  )

cat("Date range:\n")
cat(" Earliest enrollment:(no. of days since 1970-01-01)",as.Date(min(all_enrollments$enrolled_date, na.rm = TRUE), origin = "1970-01-01"))
cat(" Latest enrollment: (no. of days since 1970-01-01)",max(all_enrollments$enrolled_date, na.rm = TRUE), "\n")

as.Date(16890, origin = "1970-01-01")
as.Date(17836, origin = "1970-01-01")
