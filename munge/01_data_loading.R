library(readr)
library(dplyr)
library(purrr)
library(stringr)

# 1) List all enrollment_*.csv files in data/
files <- list.files(
  path = "data",
  pattern = "^enrollment_.*\\.csv$",
  full.names = TRUE
)

# 2) Read and combine, adding course_run from filename
all_enrollments <- files |>
  purrr::map_df(function(f) {
    run_id <- str_extract(basename(f), "\\d+")  # gets 1,2,... from filename
    read_csv(f, show_col_types = FALSE) |>
      mutate(course_run = run_id)
  })