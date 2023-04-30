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

processed_data = read_csv(
  processed_data_path,
  col_types = cols(
    year = col_double(),
    group_month = col_date(),
    average_per_month = col_double()
  )
)

processed_unique_years = read_csv(
  processed_unique_years_path,
  col_types = cols(year = col_double(),
                   month_count = col_double())
)

#########################################
# Run visualisation
#########################################

visualisation <- ggplot()

for (i in 1:nrow(processed_unique_years)) {
  row <- processed_unique_years[i,]
  row_data <- filter(processed_data, year == row$year)
  
  visualisation <-
    visualisation + geom_line(
      data = row_data,
      aes(
        x = group_month,
        y = average_per_month,
        group = year,
        color = as.factor(year),
        text = paste(
          "Date: ",
          format(group_month, "%b"),
          year,
          "<br>Demand: ",
          format(round(average_per_month, 2), nsmall = 2),
          "GW"
        )
      )
    )
}

visualisation <-
  visualisation + scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  labs(x = "Month", y = "Average monthly demand (GW)", color = "Year", 
       title = "Electrical demand on the national grid \n before, during and after Covid-19 lockdowns") +
  theme_bw() +
  theme(
    text = element_text(family = "Times New Roman"),
    plot.title = element_text(hjust = 0.5, size = 20),
    panel.grid.major.y = element_blank(), #removing the horizontal background lines
    panel.grid.minor.y = element_blank(), 
    plot.margin = margin(20, 10, 20, 10, "mm") #creating more space around the graph
  )

ggplotly(visualisation, tooltip = c("text"))

#saving the plot
ggsave(
  filename = here(figs_dir, "final.png")
#   width = 8,
#   height = 5
 )
