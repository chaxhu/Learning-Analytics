all_enrollments %>%
  count(engagement_status) %>%
  mutate(engagement_status = factor(engagement_status, 
                                    levels = c("Completed", "Unenrolled", "Still Active / Unknown"))) %>%
  ggplot(aes(x = reorder(engagement_status, -n), y = n, fill = engagement_status)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_text(aes(label = paste0(n, "\n(", round(n/sum(n)*100, 1), "%)")),
            vjust = -0.5, size = 4) +
  labs(
    title = "Learner Engagement Status Distribution",
    x = "Engagement Status",
    y = "Number of Learners",
    caption = "Total enrollments: 37,296"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 15, hjust = 1),
    plot.title = element_text(face = "bold", size = 14)
  )

# Completion Funnel

funnel_data <- tibble(
  Stage = c("Enrolled", "Fully Participated", "Purchased Statement"),
  Count = c(
    nrow(all_enrollments),
    sum(all_enrollments$fully_participated),
    sum(all_enrollments$purchased_statement)
  )
) %>%
  mutate(
    Percentage = round(Count / nrow(all_enrollments) * 100, 2),
    Stage = factor(Stage, levels = c("Enrolled", "Fully Participated", "Purchased Statement"))
  )

ggplot(funnel_data, aes(x = Stage, y = Count, fill = Stage)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_text(aes(label = paste0(Count, "\n(", Percentage, "%)")),
            vjust = -0.5, size = 4, fontface = "bold") +
  labs(
    title = "Course Completion Funnel",
    subtitle = "Drop-off at each progression stage",
    x = "Progression Stage",
    y = "Number of Learners"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 15, hjust = 1),
    plot.title = element_text(face = "bold", size = 14)
  )

# Duration distribution
all_enrollments %>%
  filter(!is.na(enrollment_duration) & enrollment_duration > 0) %>%
  ggplot(aes(x = enrollment_duration)) +
  geom_histogram(binwidth = 30, fill = "#2E86AB", alpha = 0.8, color = "white") +
  geom_vline(aes(xintercept = median(enrollment_duration, na.rm = TRUE)),
             color = "#A23B72", linetype = "dashed", size = 1, label = "Median") +
  geom_vline(aes(xintercept = mean(enrollment_duration, na.rm = TRUE)),
             color = "#F18F01", linetype = "dashed", size = 1, label = "Mean") +
  labs(
    title = "Time to Unenrollment Distribution",
    x = "Days from Enrollment to Unenrollment",
    y = "Number of Learners",
    caption = "Excludes 0-day unenrollments (same-day drop)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14)
  ) +
  scale_x_continuous(breaks = seq(0, 900, 150))

# Unenrollment by duration quartile
all_enrollments %>%
  filter(!is.na(enrollment_duration)) %>%
  mutate(
    Duration_Quartile = case_when(
      enrollment_duration <= 7 ~ "≤ 1 week (0-7 days)",
      enrollment_duration <= 30 ~ "1-4 weeks (8-30 days)",
      enrollment_duration <= 72 ~ "1-10 weeks (31-72 days)",
      enrollment_duration <= 180 ~ "2-6 months (73-180 days)",
      TRUE ~ "> 6 months (>180 days)"
    ),
    Duration_Quartile = factor(Duration_Quartile,
                               levels = c("≤ 1 week (0-7 days)",
                                          "1-4 weeks (8-30 days)",
                                          "1-10 weeks (31-72 days)",
                                          "2-6 months (73-180 days)",
                                          "> 6 months (>180 days)"))
  ) %>%
  count(Duration_Quartile) %>%
  mutate(Percentage = round(n / sum(n) * 100, 1)) %>%
  ggplot(aes(x = Duration_Quartile, y = n, fill = Duration_Quartile)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_text(aes(label = paste0(n, "\n(", Percentage, "%)")),
            vjust = -0.5, size = 3.5) +
  labs(
    title = "Unenrollment by Duration Quartile",
    x = "Time to Unenrollment",
    y = "Count"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1),
    plot.title = element_text(face = "bold", size = 14)
  )

# Completion date by run
all_enrollments %>%
  group_by(course_run) %>%
  summarise(
    Completion_Rate = sum(fully_participated) / n() * 100,
    Enrollments = n()
  ) %>%
  ggplot(aes(x = course_run, y = Completion_Rate, fill = course_run)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_text(aes(label = paste0(round(Completion_Rate, 2), "%")),
            vjust = -0.5, size = 4, fontface = "bold") +
  labs(
    title = "Course Completion Rate by Run",
    x = "Course Run",
    y = "Completion Rate (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(size = 11)
  ) +
  scale_y_continuous(limits = c(0, max(all_enrollments %>%
                                         group_by(course_run) %>%
                                         summarise(Completion_Rate = sum(fully_participated) / n() * 100) %>%
                                         pull(Completion_Rate)) * 1.15))

# Boxplot for Distribution of enrollment duration by course run
all_enrollments %>%
  filter(!is.na(enrollment_duration), enrollment_duration >= 0, enrollment_duration <= 500) %>%
  ggplot(aes(x = factor(course_run), y = enrollment_duration, fill = factor(course_run))) +
  geom_boxplot(alpha = 0.7, show.legend = FALSE) +
  geom_jitter(width = 0.2, alpha = 0.2, size = 1) +
  labs(
    title = "Enrollment Duration Distribution by Course Run",
    x = "Course Run",
    y = "Days from Enrollment to Unenrollment",
    caption = "Note: Outliers >500 days excluded for clarity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.text.x = element_text(size = 11)
  )

