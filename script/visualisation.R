#########################################
# MSc data visualisation project examining energy demand over time
# and the impact of covid-19
#
# Author: 220225638
# Date: 2023-04-23
# Description: Data visualisation file for generating chart and exporting to png
#########################################

#########################################
# Setup and import data for analysis
#########################################

source(here::here("script", "config.R"))

# Reading processed data into a dataframe and specifying the column types
# Processed data is average demand of each month in each year
processed_data = read_csv(
  processed_data_path,
  col_types = cols(
    year = col_double(),
    group_month = col_date(),
    average_per_month = col_double()
  )
)

# Reading unique years data into dataframe and specifying column types
processed_unique_years = read_csv(
  processed_unique_years_path,
  col_types = cols(year = col_double(),
                   month_count = col_double())
)

#########################################
# Run visualisation
#########################################

visualisation <- ggplot()

visualisation_title <- "A Decade of Demand on the National Grid"

visualisation_subtitle <- "Shown is the average monthly electrical demand on the national grid, measured in gigawatts (GW), spanning the years before, during and after Covid-19 lockdowns."

# going through each year by getting the number of rows within processed unique years (puy) data
for (i in 1:nrow(processed_unique_years)) {
  row <-
    processed_unique_years[i, ] #retrieve a row from puy for each iteration
  row_data <-
    filter(processed_data, year == row$year) #filter by the year and return a subset of processed data
  
  #drawing a plot for each year
  visualisation <-
    visualisation + geom_line(
      #line chart
      data = row_data,
      #using row data created above
      aes(
        x = group_month,
        y = average_per_month,
        group = year,
        color = as.factor(year),
        #as.factor so year is seen as categorical not continuous
        
        #setting text for the tooltip
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
  labs(
    x = "Month",
    y = "Average monthly demand (GW)", #labeling the x and y axis 
    color = "Year", #adding the key heading
    caption = "Source: GridWatch", #adding a caption
    title = str_wrap(
      visualisation_title,
      width = rel(55) #making the width relative
    ),
    subtitle = str_wrap(
      visualisation_subtitle,
      width = rel(90)
    )
  ) +
  theme_bw() +
  theme(
    text = element_text(family = "Times New Roman"), #changing the font
    plot.title = element_text(
      hjust = 0,
      size = rel(1.5),
      margin = margin(0, 0, 5, 0)
    ), #adjusting placement and making the title bigger
    plot.subtitle = element_text(
      size = rel(0.9),
      margin = margin(0, 0, 20, 0) #adjusting placement of subtitle 
    ),
    plot.caption = element_text(hjust = 0), #adjusting placement of caption
    panel.grid.major.y = element_blank(), #removing the horizontal background lines
    panel.grid.minor.y = element_blank(), #removing the lighter horizontal background lines
    panel.grid.minor.x = element_blank(), #removing the minor vertical background lines
    panel.border = element_blank(),#removing the black border
    plot.margin = margin(20, 10, 20, 10, "mm"), #creating more space around the graph
    axis.title.y = element_text(margin = margin(0, 10, 0, 0)),#made more space between the y axis text and the label
    axis.title.x = element_text(margin = margin(10, 0, 0, 0)) #made more space between the x axis text and label
  ) +
  theme(axis.line = element_line(color = "black")) #adding black axis lines

ggplotly(
  visualisation,
  tooltip = c("text") #using tooltip
) %>%
  layout(title = list(
    text = paste0(
      visualisation_title,
      "<br>",
      "<span style='font-size:16px;'>",
      str_wrap(visualisation_subtitle, width = rel(120)),
      "</span>"
    )
  )) #layout needed because plotly is not including subtitle 

#saving the plot
ggsave(filename = here(figs_dir, "viz220225638.png"))
