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
#' @param previous_format: format of date to be converted 
#' @param new_format: format of date to be converted to
#' @return: formatted date 
#' @export
#' 
#' @examples:
#' convert_date("2021-04-23 00:00:00", previous_format="%Y-%m-%d %H:%M:%S", new_format= "%Y-%m-%d")
convert_date = function(value,
                        previous_format = "%Y-%m-%d %H:%M:%S",
                        new_format = "%Y-%m-%d %H:%M:%S") {
  # Convert date to POSIXct
  timestamp = strptime(value, format = previous_format)
  
  # Format date 
  new_value = as.POSIXct(format(timestamp, format = new_format))
  
  # Return formatted date
  return(new_value)
}