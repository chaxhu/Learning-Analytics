library(ggplot2)
all_enrollments |>
  ggplot(aes(x = engagement_status)) +
  geom_bar() +
  labs(title = "Engagement status distribution")


all_enrollments |>
  ggplot(aes(x = enrollment_duration)) +
  geom_histogram(binwidth = 30) +
  labs(title = "Time to unenrollment (days)")