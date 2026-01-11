library(dplyr)

all_enrollments <- all_enrollments %>%
  mutate(
    fully_participated   = !is.na(fully_participated_date),
    purchased_statement  = !is.na(purchased_statement_date),
    unenrolled           = !is.na(unenrolled_date),
    enrollment_duration  = as.numeric(unenrolled_date - enrolled_date),
    engagement_status = case_when(
      fully_participated        ~ "Completed",
      unenrolled                ~ "Unenrolled",
      TRUE                      ~ "Still Active / Unknown"
    ),
    has_demographics = !(
      is.na(gender) |
        is.na(age_range) |
        is.na(highest_education_level) |
        is.na(employment_status)
    )
  )

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

cat("\nData preparation complete.\n")