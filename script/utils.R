#########################################
# MSc data visualisation project examining energy demand over time
# and the impact of covid-19
#
# Author: Shepherd_220225638
# Date: 2023-04-23
# Description: Utility functions
#########################################

#' Function to convert date to date format
#' 
#' @param value: date to be converted 
#' @param new_format: format of date to be converted to
#' @return: formatted date 
#' @export
#' 
#' @examples:
#' convert_date("2021-04-23 00:00:00", new_format= "%Y-%m-%d")
convert_date = function(value,
                        new_format = "%Y-%m-%d %H:%M:%S") {
  # Format date
  new_value = as.Date(strftime(value, new_format))
  
  # Return formatted date
  return(new_value)
}
