#########################################
# MSc data visualisation project examining energy demand over time
# and the impact of covid-19
#
# Author: 220225638
# Date: 2023-04-23
# Description: Data management file for raw data import, cleaning and export
#########################################

#########################################
# Setup and import raw data for manipulation
#########################################

source(here::here("script", "config.R"))

# Merge all csv files into one csv file
merged_data <- raw_dir %>%
  #list all csv files within raw directory
  list.files(pattern = '(?i)\\.csv$', full.names = TRUE) %>%
  #set file names ignoring the file extension
  set_names(tools::file_path_sans_ext(basename(.))) %>%
  #read file one by one into dataframe and create a new column called file name
  map_dfr(read.csv,
          col.names = c("id", "timestamp", "demand"),
          .id = "filename")

# Remove duplicate by id
formatted_data <- distinct(merged_data, id, .keep_all = TRUE)

#########################################
# Data wrangling, cleaning and then export processed data
#########################################

# Convert date column to date format
formatted_data = formatted_data %>%
  mutate(date = convert_date(timestamp, new_format = "%Y-%m-%d")) %>%
  mutate(year = strftime(timestamp, format = "%Y"))

# Select subset of columns
formatted_data = formatted_data %>%
  select(date, demand, year)

#creating a new column called group month
formatted_data <-
  mutate(formatted_data, group_month = convert_date(date, "%2023-%m-01"))
#grouping by group month and year and getting the mean average per month
formatted_data <-
  formatted_data %>% group_by(year, group_month) %>% 
  summarise(average_per_month = mean(demand /1000), .groups = "drop") #.group is to override a summarise warning

#creating a unique list of years and counting the number of months within the years
unique_years_list <-
  formatted_data %>% group_by(year) %>% summarise(month_count = n_distinct(group_month)) %>%
  arrange(desc("year"))

# Export processed data
write_csv(merged_data, processed_merge_data_path)
write_csv(formatted_data, processed_data_path)
write_csv(unique_years_list, processed_unique_years_path)
