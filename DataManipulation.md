r4bs: Data Manipulation
================

First things first - let's make sure you have all the necessary files.

1.  Navigate to the [r4bs github repo](https://github.com/erramirez/r4bs)
2.  Dowload or Clone the repo
3.  Open the r4bs.Rproj file

Tidy Data
---------

When working with the tidyverse family of packages and analytical processes it's best to follow tidy data princples. In the book, [*R for Data Science*](http://r4ds.had.co.nz/tidy-data.html), tidy data is described as:

> There are three interrelated rules which make a dataset tidy: \* Each variable must have its own column. \* Each observation must have its own row. \* Each value must have its own cell.

However, not all data is created in such a clean and consistent manner. Good thing there are some functions and methods included in the `tidyr` package (loaded with `tidyverse`) that can help turn messy data into tidy data. \#\# Transforming The two most commonly used functions are `spread()` and `gather()`. These two functions help clean and "tidy" data that is either: \* *spread* across multiple *columns* \* *scattered* across multiple *rows*

Before we go into the actual functions themselves it's important to understand few terms that we're going to use: *key value pair*. For these functions you will need to identify each *key* and each *value* pair to properly spread or gather the data.

-   key
-   value

### gather()

When you have data that includes variables that are set as column names and you need to gather those columns into neat and tidy rows (remember, each observation has its own row) you can use the `gather()` function.

Let's examine a data set that has step data spread across many columns:

``` r
# load tidyverse to start!

library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.8.0     ✔ stringr 1.3.0
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ───────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
gather_example <- read_csv("~/GitHub/r4bs/ExampleData/Transform/p1_p5_Steps.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   ID = col_integer(),
    ##   `1/9/12` = col_integer(),
    ##   `1/10/12` = col_integer(),
    ##   `1/11/12` = col_integer(),
    ##   `1/12/12` = col_integer(),
    ##   `1/13/12` = col_integer(),
    ##   `1/14/12` = col_integer(),
    ##   `1/15/12` = col_integer()
    ## )

``` r
gather_example
```

    ## # A tibble: 5 x 8
    ##      ID `1/9/12` `1/10/12` `1/11/12` `1/12/12` `1/13/12` `1/14/12`
    ##   <int>    <int>     <int>     <int>     <int>     <int>     <int>
    ## 1     1     6425      9261     12084      6250      9182      8139
    ## 2     2     1105      1197      4288      8141      4738      3866
    ## 3     3     7168      6851      7364     10041      3214      1707
    ## 4     4     1564      1162       948      1320      2193      1865
    ## 5     5     1279      1862      1811      1521      2795      6590
    ## # ... with 1 more variable: `1/15/12` <int>

You can see that for this data file, we have daily step data for five participants, but each column is the date - sometimes called a "wide" format. We want to turn that into a narrow file, with three variables: id, date, and totalsteps.

``` r
p1_p5_DailySteps<- gather_example %>% 
  gather(`1/9/12`, `1/10/12`, `1/11/12`, `1/12/12`, `1/13/12`, `1/14/12`, `1/15/12`, 
         key = "date", value = "totalsteps")

p1_p5_DailySteps
```

    ## # A tibble: 35 x 3
    ##       ID date    totalsteps
    ##    <int> <chr>        <int>
    ##  1     1 1/9/12        6425
    ##  2     2 1/9/12        1105
    ##  3     3 1/9/12        7168
    ##  4     4 1/9/12        1564
    ##  5     5 1/9/12        1279
    ##  6     1 1/10/12       9261
    ##  7     2 1/10/12       1197
    ##  8     3 1/10/12       6851
    ##  9     4 1/10/12       1162
    ## 10     5 1/10/12       1862
    ## # ... with 25 more rows

Now we have nice and neat data set with one observation (one day) per row.

### spread()

As you may have guessed, spreading is the opposite of gathering. When you have data that has multiple rows when it should have multiple columns, we can use `spread()` to tidy it.

Let's start with some example data.

``` r
# date should be in date format so we use col_date here to format it
spread_example <- read_csv("~/GitHub/r4bs/ExampleData/Transform/p1_p5_ActivityIntensity.csv", 
                           col_types = cols(
                             date = col_date("%m/%d/%y")
                           )
                           )

spread_example
```

    ## # A tibble: 100 x 4
    ##       id date       activityintensity    minutes
    ##    <int> <date>     <chr>                  <int>
    ##  1     1 2015-01-09 VeryActiveMinutes         40
    ##  2     1 2015-01-09 FairlyActiveMinutes        8
    ##  3     1 2015-01-09 LightlyActiveMinutes      81
    ##  4     1 2015-01-09 SedentaryMinutes        1286
    ##  5     2 2015-01-09 VeryActiveMinutes         40
    ##  6     2 2015-01-09 FairlyActiveMinutes       43
    ##  7     2 2015-01-09 LightlyActiveMinutes     210
    ##  8     2 2015-01-09 SedentaryMinutes         728
    ##  9     3 2015-01-09 VeryActiveMinutes         35
    ## 10     3 2015-01-09 FairlyActiveMinutes       92
    ## # ... with 90 more rows

You can see here that four different activity intensity variables are scattered across multiple rows. We need to get these variables into columns.

-   The column that contains variable names we use as the `key`: `activityintensity`

-   The column that contains values for the variables we use as the `value` : `minutes`

``` r
p1_p5_DailyIntensityMinutes <- spread_example %>% 
  spread(key = activityintensity, value = minutes)

p1_p5_DailyIntensityMinutes
```

    ## # A tibble: 25 x 6
    ##       id date       FairlyActiveMinut… LightlyActiveMinu… SedentaryMinutes
    ##    <int> <date>                  <int>              <int>            <int>
    ##  1     1 2015-01-09                  8                 81             1286
    ##  2     1 2015-01-10                 62                188              553
    ##  3     1 2015-01-11                 53                182              738
    ##  4     1 2015-01-12                 67                248              677
    ##  5     1 2015-01-13                 20                227              736
    ##  6     2 2015-01-09                 43                210              728
    ##  7     2 2015-01-10                 69                218              686
    ##  8     2 2015-01-11                 42                156              815
    ##  9     2 2015-01-12                 73                184              672
    ## 10     2 2015-01-13                 29                216              662
    ## # ... with 15 more rows, and 1 more variable: VeryActiveMinutes <int>

Now we have a data set with one day's worth of activity intensity values across each of the four activity intensity variables for each day (observation).

Merging
-------

Rarely are you ever working with solitary data files all by themselves. Given the complexities of data collected and analyses you'll need to perform, it's quite common to combine data sets to produce the desired data you need for the next step in your data exploration and analysis.

We're going to go over two types of merging here: *binds* and *joins*.

### Binding

In some cases you'll only want to add a few rows to a data frame, add a few columns to a data frame, or combine data frames that have the same variables.

The most common method of combining data sets that have \* the same exact structure\* is to use the `rbind()` function. Keep in mind that this method is restrive as it requires the column names to be *identical* across each each of the data set. Let's try it with a few of our dailyActivity data sets.

``` r
# read in p01
p01_dailyActivity <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p01_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y") 
                            )
)

# read in p02
p02_dailyActivity <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p02_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y") 
                            )
)

# read in p03
p03_dailyActivity <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p03_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y") 
                            )
)

# bind all three above to one data frame using rbind()
p1p2p3_dailyActivity <- rbind(p01_dailyActivity, p02_dailyActivity, p03_dailyActivity)

p1p2p3_dailyActivity
```

    ## # A tibble: 3,228 x 15
    ##    ActivityDate TotalSteps TotalDistance TrackerDistance LoggedActivities…
    ##    <date>            <int>         <dbl>           <dbl>             <dbl>
    ##  1 2012-01-09         6425          6.23            6.23              0.  
    ##  2 2012-01-10         9261          7.29            7.29              1.16
    ##  3 2012-01-11        12084          8.22            8.22              0.  
    ##  4 2012-01-12         6250          4.24            4.24              0.  
    ##  5 2012-01-13         9182          6.24            6.24              0.  
    ##  6 2012-01-14         8139          6.81            6.81              0.  
    ##  7 2012-01-15         4827          3.28            3.28              0.  
    ##  8 2012-01-16         5720          3.89            3.89              0.  
    ##  9 2012-01-17         5235          3.56            3.56              0.  
    ## 10 2012-01-18         4850          3.30            3.30              0.  
    ## # ... with 3,218 more rows, and 10 more variables:
    ## #   VeryActiveDistance <dbl>, ModeratelyActiveDistance <dbl>,
    ## #   LightActiveDistance <dbl>, SedentaryActiveDistance <dbl>,
    ## #   VeryActiveMinutes <int>, FairlyActiveMinutes <int>,
    ## #   LightlyActiveMinutes <int>, SedentaryMinutes <int>, Calories <int>,
    ## #   id <int>

``` r
# let's see an example where it doesn't work

# read in p01
p01_dailyActivity <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p01_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y") 
                            )
)

# read in p02
p02_dailyActivity <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p02_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y") 
                            )
)

# read in p03
# remove Calories for rbind error example
p03_dailyActivityNoCal <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p03_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y"),
                              Calories = col_skip()
                            )
)

# this now throws an error since p03_DailyActivity doesn't have the same variables as p01 and p02.
p1p2p3_dailyActivity <- rbind(p01_dailyActivity, p02_dailyActivity, p03_dailyActivityNoCal)
```

    ## Error in rbind(deparse.level, ...): numbers of columns of arguments do not match

`dplyr`, part of the tidyverse family contains a few updated functions that better handle these type of binding problems: \* `bind_rows`: Appends new rows, columns do not need to match. \* `bind_cols`: Appends new columns, rows do not need to match.

### Joining

There are four types of joins that are supported via `dplyr` functions: \* `left_join`: left\_join(a, b, by = "x"): join matching rows from b to a. \* `right_join`: right\_join(a, b, by = "x"): join matching rows from a to b. \* `inner_join`: inner\_join(a, b, by = "x"); join data and retain only rows in both sets. \* `full_join`: full\_join(a, b, by = "x"); join data and retain all values, all rows

Let's try a quick example where we join demographic data to the daily activity data.

``` r
# combining all activity files 
# from ExerciseOne.md tips
dailyactivity_all <- list.files(path = "~/GitHub/r4bs/ExampleData/FitbitDailyData/",
                    pattern = "*.csv", # only look for .csv files
                    full.names = TRUE) %>% # use the full path name
  map_df(~read_csv(., 
                   col_types = cols( 
                     ActivityDate = col_date("%m/%d/%y")
                     )
  )
  )

dailyactivity_all
```

    ## # A tibble: 20,640 x 15
    ##    ActivityDate TotalSteps TotalDistance TrackerDistance LoggedActivities…
    ##    <date>            <int>         <dbl>           <dbl>             <dbl>
    ##  1 2012-01-09         6425          6.23            6.23              0.  
    ##  2 2012-01-10         9261          7.29            7.29              1.16
    ##  3 2012-01-11        12084          8.22            8.22              0.  
    ##  4 2012-01-12         6250          4.24            4.24              0.  
    ##  5 2012-01-13         9182          6.24            6.24              0.  
    ##  6 2012-01-14         8139          6.81            6.81              0.  
    ##  7 2012-01-15         4827          3.28            3.28              0.  
    ##  8 2012-01-16         5720          3.89            3.89              0.  
    ##  9 2012-01-17         5235          3.56            3.56              0.  
    ## 10 2012-01-18         4850          3.30            3.30              0.  
    ## # ... with 20,630 more rows, and 10 more variables:
    ## #   VeryActiveDistance <dbl>, ModeratelyActiveDistance <dbl>,
    ## #   LightActiveDistance <dbl>, SedentaryActiveDistance <dbl>,
    ## #   VeryActiveMinutes <int>, FairlyActiveMinutes <int>,
    ## #   LightlyActiveMinutes <int>, SedentaryMinutes <int>, Calories <int>,
    ## #   id <int>

``` r
demographics_factor <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDemographics/demographics.csv", 
                                col_types = cols(
                                  Gender = col_factor(levels = c("Female", "Male")),
                                  Ethnicity = col_factor(NULL),
                                  Education = col_factor(levels = 
                                                           c("Some High School",
                                                             "Some College or Vocational Training",
                                                             "Completed College or University",
                                                             "Completed Graduate or Professional Degree")),
                                  `Martial Status` = col_factor(levels = NULL), 
                                  `Work Status` = col_factor(levels = NULL),
                                  Income = col_factor(levels = c("$10,000-$19,000",
                                                                 "$20,000-$29,000",
                                                                 "$30,000-$39,000",
                                                                 "$40,000-$49,000",
                                                                 "$50,000-$59,000",
                                                                 "$60,000-$69,000",
                                                                 "$70,000-$79,000",
                                                                 "$80,000-$89,000",
                                                                 "$90,000-$99,000",
                                                                 "> $100,000"), 
                                                      ordered = TRUE
                                                      )
                                )
)

# using inner_join for only matching ids in both data sets
# id is saved as ID in demographics, tell inner_join about that id == ID
dailyactivity_demographics <- inner_join(dailyactivity_all, demographics_factor, by = c("id" = "ID"))

dailyactivity_demographics
```

    ## # A tibble: 20,640 x 23
    ##    ActivityDate TotalSteps TotalDistance TrackerDistance LoggedActivities…
    ##    <date>            <int>         <dbl>           <dbl>             <dbl>
    ##  1 2012-01-09         6425          6.23            6.23              0.  
    ##  2 2012-01-10         9261          7.29            7.29              1.16
    ##  3 2012-01-11        12084          8.22            8.22              0.  
    ##  4 2012-01-12         6250          4.24            4.24              0.  
    ##  5 2012-01-13         9182          6.24            6.24              0.  
    ##  6 2012-01-14         8139          6.81            6.81              0.  
    ##  7 2012-01-15         4827          3.28            3.28              0.  
    ##  8 2012-01-16         5720          3.89            3.89              0.  
    ##  9 2012-01-17         5235          3.56            3.56              0.  
    ## 10 2012-01-18         4850          3.30            3.30              0.  
    ## # ... with 20,630 more rows, and 18 more variables:
    ## #   VeryActiveDistance <dbl>, ModeratelyActiveDistance <dbl>,
    ## #   LightActiveDistance <dbl>, SedentaryActiveDistance <dbl>,
    ## #   VeryActiveMinutes <int>, FairlyActiveMinutes <int>,
    ## #   LightlyActiveMinutes <int>, SedentaryMinutes <int>, Calories <int>,
    ## #   id <int>, Gender <fct>, Age <int>, BMI <dbl>, Ethnicity <fct>,
    ## #   Education <fct>, `Martial Status` <fct>, `Work Status` <fct>,
    ## #   Income <ord>

Deriving
--------

So you've read in, formatted, and merged data sets. What comes next? Well, what if you need to also create new variables before you move on to the next step? There is a great tool for just that - `mutate()`! the `mutate()` function powers the ability to derive a variable and create new variables.

Let's go over a few examples of when you may want to derive some activity variables that aren't part of the original data set.

``` r
# use mutate to create a new variable from the sum of two variables
dailyMVPA <- dailyactivity_all %>% 
  mutate(MVPAmins = (FairlyActiveMinutes + VeryActiveMinutes)) %>% 
  select(id, ActivityDate, MVPAmins) # use select() to select named columns
```

    ## Warning: package 'bindrcpp' was built under R version 3.4.4

``` r
dailyMVPA
```

    ## # A tibble: 20,640 x 3
    ##       id ActivityDate MVPAmins
    ##    <int> <date>          <int>
    ##  1     1 2012-01-09         48
    ##  2     1 2012-01-10         83
    ##  3     1 2012-01-11        127
    ##  4     1 2012-01-12         60
    ##  5     1 2012-01-13         99
    ##  6     1 2012-01-14         93
    ##  7     1 2012-01-15         76
    ##  8     1 2012-01-16         60
    ##  9     1 2012-01-17         47
    ## 10     1 2012-01-18         55
    ## # ... with 20,630 more rows

``` r
# use case_when within mutate to classify ranges
# case_when is great because it's a sequential operation
dailyMVPA2 <- dailyMVPA %>% 
  mutate(MVPAguideline = case_when(MVPAmins < 30 ~ "low",
                                   MVPAmins < 60 ~ "medium",
                                   MVPAmins >= 60 ~ "high"
                                   ) 
         )

dailyMVPA2
```

    ## # A tibble: 20,640 x 4
    ##       id ActivityDate MVPAmins MVPAguideline
    ##    <int> <date>          <int> <chr>        
    ##  1     1 2012-01-09         48 medium       
    ##  2     1 2012-01-10         83 high         
    ##  3     1 2012-01-11        127 high         
    ##  4     1 2012-01-12         60 high         
    ##  5     1 2012-01-13         99 high         
    ##  6     1 2012-01-14         93 high         
    ##  7     1 2012-01-15         76 high         
    ##  8     1 2012-01-16         60 high         
    ##  9     1 2012-01-17         47 medium       
    ## 10     1 2012-01-18         55 medium       
    ## # ... with 20,630 more rows

Aggregating & Summarizing
-------------------------

Now, we get into the fun part of manipulating and working with data - turning one data set into another that provide better insight and information.

We're going to focus on two core functions that are commonly used together, `group_by` and `summarise`. These two function do exactly what you think they might do: \* `group_by`: groups based on unique values of a column or columns \* `summarise`: supports a variety of functions to summarise groups specified by `group_by`

Let's say we want to create a new data set that gave us the following information \* number of days of observation for each particiapnt \* mean, sd, min, and max values for steps \* mean, sd, min, and max for MVPA minutes

``` r
activitysummary <- dailyactivity_all %>% 
  group_by(id) %>% 
  summarise(observation_days = n(),
            meansteps = mean(TotalSteps),
            sdsteps = sd(TotalSteps),
            minsteps = min(TotalSteps),
            maxsteps = max(TotalSteps),
            meanMVPA = mean(FairlyActiveMinutes+VeryActiveMinutes),
            sdMVPA = sd(FairlyActiveMinutes+VeryActiveMinutes),
            minMVPA = min(FairlyActiveMinutes+VeryActiveMinutes),
            maxMVPA = max(FairlyActiveMinutes+VeryActiveMinutes)
            )

activitysummary
```

    ## # A tibble: 30 x 10
    ##       id observation_days meansteps sdsteps minsteps maxsteps meanMVPA
    ##    <int>            <int>     <dbl>   <dbl>    <dbl>    <dbl>    <dbl>
    ##  1     1             1263     5126.   3888.       0.   26378.     46.2
    ##  2     2             1163     7989.   4018.       0.   31516.    115. 
    ##  3     3              802     8889.   4893.       0.   29741.    113. 
    ##  4     4              204    18694.   4438.       0.   36110.     94.3
    ##  5     5              497     8292.   3688.       0.   27093.     94.2
    ##  6     6              550    13438.   8704.       0.   68565.    120. 
    ##  7     7              187    11628.   3074.       0.   20122.    106. 
    ##  8     8              553     7066.   4194.       0.   31615.     75.3
    ##  9     9              525     8561.   3624.     535.   23600.     71.8
    ## 10    10              631     8826.   8878.       0.   50510.    102. 
    ## # ... with 20 more rows, and 3 more variables: sdMVPA <dbl>,
    ## #   minMVPA <int>, maxMVPA <int>
