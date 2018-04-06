r4bs: Part One
================

Reading in Data
---------------

We're going to start with reading in data. This short tutorial will focus on .csv files as that tends to be a very common and standard format.

### Base R and read.csv

We want to first explore how to use base R to read in a csv. We'll start with reading in the first file from `ExampleData\FitbitDailyData`.

``` r
# use read.csv to read in the p01_dailyActivity.csv file and name it p01_base
p01_base <- read.csv("https://raw.githubusercontent.com/erramirez/r4bs/master/ExampleData/FitbitDailyData/p01_dailyActivity.csv")
```

Great! We created a data frame. What if we want to understand the structure of the data? We can use the `str()` function from the included `utils` package.

``` r
str(p01_base)
```

    ## 'data.frame':    1263 obs. of  15 variables:
    ##  $ ActivityDate            : Factor w/ 1263 levels "1/1/13","1/1/14",..: 113 4 8 12 16 20 24 28 32 36 ...
    ##  $ TotalSteps              : int  6425 9261 12084 6250 9182 8139 4827 5720 5235 4850 ...
    ##  $ TotalDistance           : num  6.23 7.29 8.22 4.24 6.24 ...
    ##  $ TrackerDistance         : num  6.23 7.29 8.22 4.24 6.24 ...
    ##  $ LoggedActivitiesDistance: num  0 1.16 0 0 0 ...
    ##  $ VeryActiveDistance      : num  4.37 3.07 0.2 0 0.67 ...
    ##  $ ModeratelyActiveDistance: num  0 0.19 1.15 0 1.24 ...
    ##  $ LightActiveDistance     : num  0.73 3.49 6.84 4.21 4.31 ...
    ##  $ SedentaryActiveDistance : num  0 0.01 0.03 0.03 0.03 ...
    ##  $ VeryActiveMinutes       : int  40 40 35 8 13 31 7 11 8 3 ...
    ##  $ FairlyActiveMinutes     : int  8 43 92 52 86 62 69 49 39 52 ...
    ##  $ LightlyActiveMinutes    : int  81 210 253 179 238 188 218 158 184 164 ...
    ##  $ SedentaryMinutes        : int  1286 728 621 789 681 553 686 778 785 787 ...
    ##  $ Calories                : int  1687 1969 2084 1699 1904 1911 1780 1678 1670 1650 ...
    ##  $ id                      : int  1 1 1 1 1 1 1 1 1 1 ...

As you can see `str()` prints the structure of our dataframe, giving us information on: \* the number of observations (rows) \* the number of variables (columns) \* the format or column type

While that *looks good* I don't think that we actually want to store our `ActivityDate` variable as a factor. This is a quirk of the `read.csv` function - it sometimes converts strings to factors! So, let's dive into the Tidyverse and see how that works.

### Tidyverse, readr, and read\_csv

The tidyverse loads the `readr` package, which is a powerful package for reading in data. The nice thing about readr is that it creates a `tibble` which is a bit different than a `data.frame`. One of the nice things that read\_csv will do is *NOT* change strings to factors! Let's see it in action

``` r
# load tidyverse because it's great
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.8.0     ✔ stringr 1.2.0
    ## ✔ readr   1.1.1     ✔ forcats 0.2.0

    ## ── Conflicts ───────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
# use read_csv to read in the p01_dailyActivity.csv file and name it p01_readr
p01_readr <- read_csv("https://raw.githubusercontent.com/erramirez/r4bs/master/ExampleData/FitbitDailyData/p01_dailyActivity.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   ActivityDate = col_character(),
    ##   TotalSteps = col_integer(),
    ##   TotalDistance = col_double(),
    ##   TrackerDistance = col_double(),
    ##   LoggedActivitiesDistance = col_double(),
    ##   VeryActiveDistance = col_double(),
    ##   ModeratelyActiveDistance = col_double(),
    ##   LightActiveDistance = col_double(),
    ##   SedentaryActiveDistance = col_double(),
    ##   VeryActiveMinutes = col_integer(),
    ##   FairlyActiveMinutes = col_integer(),
    ##   LightlyActiveMinutes = col_integer(),
    ##   SedentaryMinutes = col_integer(),
    ##   Calories = col_integer(),
    ##   id = col_integer()
    ## )
