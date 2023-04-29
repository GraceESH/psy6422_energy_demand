#########################################
# MSc data visualisation project examining energy demand over time
# and the impact of covid-19
#
# Author: Shepherd_220225638
# Date: 2023-04-23
# Description: Configuration file for setup and file path specification
#########################################

##################################
# Load libraries
##################################
library(here)
library(tidyverse)
library(ggplot2)
library(scales)
library(plotly)
library(tidyr)
library(purrr)
##################################
# Set file directories
##################################
raw_dir = here("raw/")
figs_dir = here("figs/")
processed_dir = here("processed/")

##################################
# Set file paths 
##################################
processed_merge_data_path = paste0(processed_dir, "gridwatch_merge.csv")
processed_data_path = paste0(processed_dir, "gridwatch_processed.csv")
processed_unique_years_path = paste0(processed_dir, "gridwatch_unique_years.csv")

##################################
# Load utility functions 
##################################
source(here("script", "utils.R"))