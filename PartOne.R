# First things first - setup your script by loading necessary packages

# tidyverse because it's great
library(tidyverse)
# lubridate because we're going to be working with dates and times
library(lubridate)


# let's start with using readr to read in one participant's daily activity data. 

p01 <- read_csv("ExampleData/FitbitDailyData/p01_dailyActivity.csv")

# we want to actually read in the date field so that R recognizes it as a date and not a character

p01 <- read_csv("ExampleData/FitbitDailyData/p01_dailyActivity.csv",
                col_types = cols(
                  ActivityDate= col_date(format = "%m/%d/%y")
                )
)
