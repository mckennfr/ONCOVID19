COVID-19 Cases in Ontario
================

## ONCOVID19 GitHub archive

The code in this archive uses the latest [public data on COVID-19 cases
in
Ontario](https://www.ontario.ca/page/2019-novel-coronavirus#section-0)

This is an R Markdown format used for publishing markdown documents to
GitHub. When you click the **Knit** button all R code chunks are run and
a markdown file (.md) suitable for publishing to GitHub is generated.

## Status of cases in Ontario

Ontario is now providing a more detailed daily epidemiologic summary of
COVID-19 cases in the province ([January 15 -
April 12, 2020](https://files.ontario.ca/moh-covid-19-report-en-2020-04-12.pdf))
that will be updated each day at 10:30 a.m. The new summary provides
more provincial and regional data on confirmed cases, demographics and
trends of cases since the outbreak began including geography, exposure
and severity.

## Confirmed positive cases of COVID19 in Ontario

``` r
url <- paste0("https://data.ontario.ca/dataset/",
              "f4112442-bdc8-45d2-be3c-12efae72fb27/resource/",
              "455fd63b-603d-4608-8216-7d8647f43350/download/",
              "conposcovidloc.csv")

dat_conf <- read.csv(url)

head(dat_conf)
```

    ##   ROW_ID ACCURATE_EPISODE_DATE Age_Group CLIENT_GENDER CASE_ACQUISITIONINFO
    ## 1      1            2020-03-21       60s          MALE       Travel-Related
    ## 2      2            2020-03-30       20s        FEMALE  Information pending
    ## 3      3            2020-03-30       60s          MALE  Information pending
    ## 4      4            2020-03-28       40s        FEMALE  Information pending
    ## 5      5            2020-03-27       40s        FEMALE              Neither
    ## 6      6            2020-03-28       50s          MALE  Information pending
    ##       OUTCOME1                Reporting_PHU          Reporting_PHU_Address
    ## 1     Resolved        Toronto Public Health 277 Victoria Street, 5th Floor
    ## 2 Not Resolved        Toronto Public Health 277 Victoria Street, 5th Floor
    ## 3 Not Resolved           Peel Public Health         7120 Hurontario Street
    ## 4     Resolved Middlesex-London Health Unit                 50 King Street
    ## 5     Resolved         Ottawa Public Health        100 Constellation Drive
    ## 6 Not Resolved        Toronto Public Health 277 Victoria Street, 5th Floor
    ##   Reporting_PHU_City Reporting_PHU_Postal_Code
    ## 1            Toronto                   M5B 1W2
    ## 2            Toronto                   M5B 1W2
    ## 3        Mississauga                   L5W 1N4
    ## 4             London                   N6A 5L7
    ## 5             Ottawa                   K2G 6J8
    ## 6            Toronto                   M5B 1W2
    ##                                   Reporting_PHU_Website Reporting_PHU_Latitude
    ## 1 www.toronto.ca/community-people/health-wellness-care/               43.65659
    ## 2 www.toronto.ca/community-people/health-wellness-care/               43.65659
    ## 3                             www.peelregion.ca/health/               43.64747
    ## 4                                    www.healthunit.com               42.98147
    ## 5                             www.ottawapublichealth.ca               45.34567
    ## 6 www.toronto.ca/community-people/health-wellness-care/               43.65659
    ##   Reporting_PHU_Longitude
    ## 1               -79.37936
    ## 2               -79.37936
    ## 3               -79.70889
    ## 4               -81.25402
    ## 5               -75.76391
    ## 6               -79.37936
