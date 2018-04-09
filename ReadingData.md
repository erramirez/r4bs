r4bs: Reading Data
================

First things first - let's make sure you have all the necessary files.

1.  Navigate to the [r4bs github repo](https://github.com/erramirez/r4bs)
2.  Dowload or Clone the repo
3.  Open the r4bs.Rproj file

Reading in Data
---------------

We're going to start with reading in data. This short tutorial will focus on .csv files as that tends to be a very common and standard format.

### Base R and read.csv

We want to first explore how to use base R to read in a csv. We'll start with reading in the first file from `ExampleData\FitbitDailyData`.

``` r
# use read.csv to read in the p01_dailyActivity.csv file and name it p01_base
# NOTE: using the full directory path here
p01_base <- read.csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p01_dailyActivity.csv")
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

    ## ── Attaching packages ────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.8.0     ✔ stringr 1.3.0
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ───────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
# use read_csv to read in the p01_dailyActivity.csv file and name it p01_readr
p01_readr <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData//p01_dailyActivity.csv")
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

Well look at that! The `read_csv` package not only loads the data but it automatically prints the column (variable) format. You'll also notice that `ActivityDate` is not a factor, but a character. Awesome.

Formatting Data
---------------

So now that we've used `read_csv` let's do some more work to better set up our data when we read it in. You may have noticed that the `ActivityDate` variable was in fact a date. While `readr` can detect some date and time formats it doesn't automatically parse this particular format (m/d/yy), and read it in as a character vector.

When you're reading in your data you may need to update, change, or remove columns. You can use a few simple arguments to format your data as it's read it. This is very useful if you already know the format and content of your data.

You can use the `col_types` argument to format your columns (cols) as they're read in via `readr`. There are a few different `col` arguments that allow you to specify the format of the column. Let's focus on `ActivityDate` here.

``` r
# we use col_types to specify column formats
# we can either specifiy each column or just "edit" a specific column
# when editing one column all other column format are guessed using the normal parser

# NOTE: we use %m/%d/%y to indicate what format to parse
# NOTE: lower case y is used for two digit year, Y for four digit year
p01_readrformat <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p01_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y") 
                            )
)

head(p01_readrformat)
```

    ## # A tibble: 6 x 15
    ##   ActivityDate TotalSteps TotalDistance TrackerDistance LoggedActivitiesD…
    ##   <date>            <int>         <dbl>           <dbl>              <dbl>
    ## 1 2012-01-09         6425          6.23            6.23               0.  
    ## 2 2012-01-10         9261          7.29            7.29               1.16
    ## 3 2012-01-11        12084          8.22            8.22               0.  
    ## 4 2012-01-12         6250          4.24            4.24               0.  
    ## 5 2012-01-13         9182          6.24            6.24               0.  
    ## 6 2012-01-14         8139          6.81            6.81               0.  
    ## # ... with 10 more variables: VeryActiveDistance <dbl>,
    ## #   ModeratelyActiveDistance <dbl>, LightActiveDistance <dbl>,
    ## #   SedentaryActiveDistance <dbl>, VeryActiveMinutes <int>,
    ## #   FairlyActiveMinutes <int>, LightlyActiveMinutes <int>,
    ## #   SedentaryMinutes <int>, Calories <int>, id <int>

You can also do other types of formatting and data editing within your `read_csv` call. For example, let's say that we don't care about any of the distance information in this file. We can specify that we want to skip reading those in.

``` r
# you can also use other arguments to help with reading in data in a way that works for you
# we use col_skip here to specificy that we don't want any distance related data read in

p01_readrformatskip <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDailyData/p01_dailyActivity.csv",
                            col_types = cols(
                              ActivityDate = col_date("%m/%d/%y"),
                              TotalDistance = col_skip(),
                              TrackerDistance = col_skip(),
                              LoggedActivitiesDistance = col_skip(),
                              VeryActiveDistance = col_skip(),
                              ModeratelyActiveDistance= col_skip(),
                              LightActiveDistance = col_skip(),
                              SedentaryActiveDistance = col_skip()
                              )
                            )
head(p01_readrformatskip)
```

    ## # A tibble: 6 x 8
    ##   ActivityDate TotalSteps VeryActiveMinutes FairlyActiveMinutes
    ##   <date>            <int>             <int>               <int>
    ## 1 2012-01-09         6425                40                   8
    ## 2 2012-01-10         9261                40                  43
    ## 3 2012-01-11        12084                35                  92
    ## 4 2012-01-12         6250                 8                  52
    ## 5 2012-01-13         9182                13                  86
    ## 6 2012-01-14         8139                31                  62
    ## # ... with 4 more variables: LightlyActiveMinutes <int>,
    ## #   SedentaryMinutes <int>, Calories <int>, id <int>

You may not always be working with .csv files so you'll be happy to know that `readr` is a powerful package with functions for reading in all sorts of data, supporting six additional file formats:

-   `read_csv2()`: uses ; for the field separator and , for the decimal point (good for EU files).
-   `read_tsv()`: tab separated files
-   `read_delim()`: general delimited files
-   `read_fwf()`: fixed width files
-   `read_table()`: tabular files where colums are separated by white-space.
-   `read_log()`: web log files

### Working with Factors

Since not all data is numerical (or integer), we should probably touch on how to deal with factors. Factors are important, especially in survey data, as they represent categorial data. Let's work with some demographic data to better understand factors.

We provide a demographic data file here: `ExampleDate/FitbitDemographics/demographics.csv`. Let's load it and take a peak at what we have.

``` r
demographics <- read_csv("~/GitHub/r4bs/ExampleData/FitbitDemographics/demographics.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   ID = col_integer(),
    ##   Gender = col_character(),
    ##   Age = col_integer(),
    ##   BMI = col_double(),
    ##   Ethnicity = col_character(),
    ##   Education = col_character(),
    ##   `Martial Status` = col_character(),
    ##   `Work Status` = col_character(),
    ##   Income = col_character()
    ## )

``` r
head(demographics)
```

    ## # A tibble: 6 x 9
    ##      ID Gender   Age   BMI Ethnicity Education          `Martial Status`  
    ##   <int> <chr>  <int> <dbl> <chr>     <chr>              <chr>             
    ## 1     1 Female    24  21.6 Caucasian Completed College… Single and Never …
    ## 2     2 Male      28  21.8 Caucasian Completed College… Married           
    ## 3     3 Male      35  59.7 Caucasian Completed College… Single and Never …
    ## 4     4 Female    25  17.3 Caucasian Some College or V… Single and Never …
    ## 5     5 Male      34  23.1 Caucasian Completed Graduat… Married           
    ## 6     6 Female    29  22.4 Caucasian Completed Graduat… Single and Never …
    ## # ... with 2 more variables: `Work Status` <chr>, Income <chr>

So we have 30 observations in a 9-variable data set here. Of those variables six were parsed as character variables, but in reality these are categorical variables and we want them to be read in as factors.

Before we go down that path, let's take a brief pause here to explain the different ways factors can be set in R.

``` r
# factor, no level
colors <- factor(c("yellow", "indigo", "green", "blue", "orange", "red", "violet"))

levels(colors)
```

    ## [1] "blue"   "green"  "indigo" "orange" "red"    "violet" "yellow"

Here, R understands that there are four levels of the categorical vector we called colors. It also guessed at the levels, placing them in alphabetical order. When working with factors, you can also set the level to your specific needs.

``` r
# factor, with levels
colors <- factor(c("yellow", "indigo", "green", "blue", "orange", "red", "violet"))

# pass an list, in the correct order
colors <- factor(colors, levels= c("red", "orange", "yellow", "green", "blue", "indigo", "violet"))
levels(colors)
```

    ## [1] "red"    "orange" "yellow" "green"  "blue"   "indigo" "violet"

So now say that thesevcategories actually have a distinct order that is useful for passing to computation arguments such as `min()` or `max()`. We can easily add an argument to make that happen.

``` r
# factor, with levels and ordered
colors <- factor(colors, levels= c("red", "orange", "yellow", "green", "blue", "indigo", "violet"), ordered = TRUE)

min(colors)
```

    ## [1] red
    ## Levels: red < orange < yellow < green < blue < indigo < violet

``` r
max(colors)
```

    ## [1] violet
    ## Levels: red < orange < yellow < green < blue < indigo < violet

Great. Now that we have a feeling for how factors work in R. We can set those variables we wish to keep as categorical as we read in our data.

When reading in a factor using the `col_factor` argument we have a few different options. Let's check them using the built R help tools.

``` r
?col_factor
```

    ## Help on topic 'col_factor' was found in the following packages:
    ## 
    ##   Package               Library
    ##   readr                 /Library/Frameworks/R.framework/Versions/3.4/Resources/library
    ##   scales                /Library/Frameworks/R.framework/Versions/3.4/Resources/library
    ## 
    ## 
    ## Using the first match ...

``` r
# reading in categorical variables as factor
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

# check to see if factors are correctly applied
head(demographics_factor)
```

    ## # A tibble: 6 x 9
    ##      ID Gender   Age   BMI Ethnicity Education          `Martial Status`  
    ##   <int> <fct>  <int> <dbl> <fct>     <fct>              <fct>             
    ## 1     1 Female    24  21.6 Caucasian Completed College… Single and Never …
    ## 2     2 Male      28  21.8 Caucasian Completed College… Married           
    ## 3     3 Male      35  59.7 Caucasian Completed College… Single and Never …
    ## 4     4 Female    25  17.3 Caucasian Some College or V… Single and Never …
    ## 5     5 Male      34  23.1 Caucasian Completed Graduat… Married           
    ## 6     6 Female    29  22.4 Caucasian Completed Graduat… Single and Never …
    ## # ... with 2 more variables: `Work Status` <fct>, Income <ord>

``` r
# check to see if ordinal factor for Income is correctly applied
min(demographics_factor$Income)
```

    ## [1] <NA>
    ## 10 Levels: $10,000-$19,000 < $20,000-$29,000 < ... < > $100,000

``` r
# let's not take into account that NA (missing) data point
min(demographics_factor$Income, na.rm = TRUE)
```

    ## [1] $10,000-$19,000
    ## 10 Levels: $10,000-$19,000 < $20,000-$29,000 < ... < > $100,000

``` r
# use summary to check for number of participants per category for Education
summary(demographics_factor$Education)
```

    ##                          Some High School 
    ##                                         1 
    ##       Some College or Vocational Training 
    ##                                         5 
    ##           Completed College or University 
    ##                                        10 
    ## Completed Graduate or Professional Degree 
    ##                                        14

Working with Excel Files
------------------------

If you're working with Excel files (first, sorry - Excel can be the worst), then you can use another tidyverse package, `readxl` to work with excel files. Let's go through a quick example:

``` r
# readxl is not loaded by default, but it is installed as part of the tidyverse
# you will have to explicitly load it first
library(readxl)

# read in p01_dailyActivity
# use the read_xlsx function as our data is a .xlsx file
p01_excel <- read_xlsx("~/GitHub/r4bs/ExampleData/FitbitDailyData/p01_dailyActivity.xlsx")

head(p01_excel)
```

    ## # A tibble: 6 x 15
    ##   ActivityDate        TotalSteps TotalDistance TrackerDistance
    ##   <dttm>                   <dbl>         <dbl>           <dbl>
    ## 1 2012-01-09 00:00:00      6425.          6.23            6.23
    ## 2 2012-01-10 00:00:00      9261.          7.29            7.29
    ## 3 2012-01-11 00:00:00     12084.          8.22            8.22
    ## 4 2012-01-12 00:00:00      6250.          4.24            4.24
    ## 5 2012-01-13 00:00:00      9182.          6.24            6.24
    ## 6 2012-01-14 00:00:00      8139.          6.81            6.81
    ## # ... with 11 more variables: LoggedActivitiesDistance <dbl>,
    ## #   VeryActiveDistance <dbl>, ModeratelyActiveDistance <dbl>,
    ## #   LightActiveDistance <dbl>, SedentaryActiveDistance <dbl>,
    ## #   VeryActiveMinutes <dbl>, FairlyActiveMinutes <dbl>,
    ## #   LightlyActiveMinutes <dbl>, SedentaryMinutes <dbl>, Calories <dbl>,
    ## #   id <dbl>

Learning More
-------------

You can learn more about using `readr` here: <http://readr.tidyverse.org/>

You can learn more abour using `readxl` here: <http://readxl.tidyverse.org/>
