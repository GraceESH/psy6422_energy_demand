#########################################
# MSc data visualisation project examining energy demand over time
# and the impact of covid-19
#
# Author: Shepherd_220225638
# Date: 2023-04-23
# Description: Data management file for raw data import, cleaning and export
#########################################

#########################################
# Setup and import raw data for manipulation
#########################################

source(here::here("script", "config.R"))

formatted_data = read_csv(
  raw_data_path,
  col_types = cols(
    id = col_double(),
    demand = col_double(),
    timestamp = col_datetime()
  )
)

#########################################
# Data wrangling, cleaning and then export processed data
#########################################

# Convert date column to date format
formatted_data = formatted_data %>%
  mutate(date = convert_date(timestamp, previous_format = "%Y-%m-%d %H:%M:%S", new_format = "%Y-%m-%d")) %>%
  mutate(year = strftime(timestamp, format = "%Y"))

#filtering out the incomplete years
formatted_data = formatted_data %>% filter(year != "2011" &
                                             year != "2023")

# Select subset of columns
formatted_data = formatted_data %>%
  select(date, demand, year)

#creating a new column called period start and grouping by period start
formatted_data <-
  mutate(formatted_data, period_start = as.Date(strftime(date, "%2023-%m-01")))

formatted_data <-
  formatted_data %>% group_by(year, period_start) %>% summarise(average_per_month = mean(demand))

#creating a unique list of years and counting the number of months within the years
unique_years_list <-
  formatted_data %>% group_by(year) %>% summarise(month_count = n_distinct(period_start)) %>%
  arrange(desc("year"))

# Export processed data
write_csv(formatted_data, processed_data_path)
write_csv(unique_years_list, processed_unique_years_path)
