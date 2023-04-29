#########################################
# MSc data visualisation project examining energy demand over time
# and the impact of covid-19
#
# Author: Shepherd_220225638
# Date: 2023-04-23
# Description: Data visualisation file for generating chart and exporting to png
#########################################

#########################################
# Setup and import data for analysis 
#########################################

source(here::here("script", "config.R"))

processed_data = read_csv(processed_data_path,
                       col_types = cols(year = col_double(),
                                        period_start = col_date(),
                                        average_per_month = col_double()))

processed_unique_years = read_csv(processed_unique_years_path,
                          col_types = cols(year = col_double(),
                                           month_count = col_double()))

#########################################
# Run visualisation
#########################################

visualisation <- ggplot()

for(i in 1:nrow(processed_unique_years)){
  row <- processed_unique_years[i, ]
  row_data <- filter(processed_data, year == row$year)
  visualisation <-
    visualisation + geom_line(data = row_data,
                              aes(
                                x = period_start,
                                y = average_per_month,
                                group = year,
                                color = as.factor(year)
                              ))
}

visualisation <-
  visualisation + scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  labs(x = "Month", y = "Average monthly demand (In thousand GW)", color = "Year")

plot(visualisation)

#saving the plot
ggsave(filename=here(figs_dir, "visualisation.png"), width = 8, height = 5)
