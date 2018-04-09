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
gather_example <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p1_p5_Steps.csv")
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
spread_example <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p1_p5_ActivityIntensity.csv", 
                           col_types = cols(
                             date = col_date("%m/%d/%y")
                           )
                           )
```

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

Aggregating & Summarizing
-------------------------

Deriving
--------
