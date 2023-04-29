#source(here::here("script", "config.R"))

#demand_data = read_csv(processed_data_path,
                       #col_types = cols(date = col_datetime(),
                                        #demand = col_double()))


# Plot demand over time 
demand_data %>%
  ggplot(aes(x = date, y = demand)) +
  geom_line() +
  scale_x_datetime(date_labels = "%Y") +
  labs(x = "Date", y = "Demand (MW)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save plot 
ggsave(filename=here(figs_dir, "demand_over_time.png"))

########################################

pd_data <- demand_data %>% group_by(date) %>% summarise(avg_dpd =mean(demand)) #dpd is demand per day

pd_data <- mutate(pd_data, year = strftime(date, format = "%Y"), month = strftime(date, format = "%b"))

pd_data <- mutate(pd_data, format_date= as.POSIXct(strftime(date, format= '2020-%m-%d')))

unique_year <- unique(pd_data$year)

#plot point from 2011 to 2023 overlapping each other
pd_plot <- ggplot()
for(y in unique_year){
  pd_plot <- pd_plot + geom_line(data= filter(pd_data, year== y), aes(x= format_date, y= avg_dpd, group= year, color = year))
}
pd_plot <- pd_plot + scale_x_datetime(date_labels= "%b", date_breaks = "1 month")
plot(pd_plot)

ggsave(filename=here(figs_dir, "amazing.png"))

#######################################
# all years overlapping. month on x axis. average demand per month. 
pd_data2 <- mutate(demand_data, avg_month = as.Date(strftime(date, "%Y-%m-01")), demand=demand)
pd_data2 <- pd_data2 %>% group_by(avg_month) %>% summarise(avg_dpm =mean(demand)) #dpd is demand per month

pd_data2 <- mutate(pd_data2, year = strftime(avg_month, format = "%Y"))

pd_data2 <- mutate(pd_data2, format_date= as.Date(strftime(avg_month, format= '2020-%m-%d')))

unique_year <- unique(pd_data2$year)

#plot point from 2011 to 2023 overlapping each other
pd_plot2 <- ggplot()
for(y in unique_year){
  pd_plot2 <- pd_plot2 + geom_line(data= filter(pd_data2, year== y), aes(x= format_date, y= avg_dpm, group= year, color = year))
}
pd_plot2 <- pd_plot2 + scale_x_date(date_labels= "%b", date_breaks = "1 month")
plot(pd_plot2)

ggsave(filename=here(figs_dir, "amazing2.png"))

#######################################
# Plot of years on x axis and average monthly demand on y axis. Line graph.

plot <- mutate(demand_data, year_month = as.Date(strftime(date, "%Y-%m-01")))
plot <- plot %>% group_by(year_month) %>% summarise(average_per_month = mean(demand))

plot %>%
  ggplot(aes(x = year_month, y = average_per_month)) +
  geom_line() +
  scale_x_date(date_labels = "%Y") +
  labs(x = "Year", y = "Average demand") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(filename=here(figs_dir, "plot.png"))

#######################################
# Plot of years on x axis and average yearly demand on y axis. Line graph.

plot2 <- mutate(demand_data, year_month = as.Date(strftime(date, "%Y-01-01")))
plot2 <- plot2 %>% group_by(year_month) %>% summarise(average_per_month = mean(demand))

plot2 %>%
  ggplot(aes(x = year_month, y = average_per_month)) +
  geom_line() +
  scale_x_date(date_labels = "%Y") +
  labs(x = "Year", y = "Average demand") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(filename=here(figs_dir, "plot2.png"))
