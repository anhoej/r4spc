################################################################################

# This R script demonstrates the basic functionality of the qic() function from
# the qicharts2 package for constructing run and control charts.
#
# You need a recent versions of R (> 4.1) and RStudio installed on your computer
# and the latest version of the qicharts2 package installed in R.
#
# Jacob Anhøj, 2021-10-28

################################################################################

library(qicharts2)

# Load data ---
load(
  url(
    'https://github.com/anhoej/r4spc/raw/main/data/qicharts2_examples.RData'
    )
  )

# Using the new pipe operator, |>
# 'https://github.com/anhoej/r4spc/raw/main/data/qicharts2_examples.RData' |>
#   url() |>
#   load()

# HELP! ----
help('qic')
vignette('qicharts2')

# Basic qic() syntax ----

## Run chart from 24 random normal numbers
y <- rnorm(24)
qic(y)

## ... add chart title and axis labels
qic(y,
    title = 'My first run chart',
    ylab  = 'Measure',
    xlab  = 'Sample')

# Using qic() with data frames ----

## Run chart of daily systolic blood pressure from blood_pressure dataset
qic(x     = date,
    y     = systolic,
    data  = blood_pressure,
    title = 'Systolic blood pressure',
    ylab  = 'mm Hg',
    xlab  = 'Date')

## Run chart of monthly proportion of harmed patients from patient_harm dataset
qic(x     = month,
    y     = harmed,
    n     = n,
    data  = patient_harm,
    title = 'Patients harmed during hospital stay',
    ylab  = 'Proportion',
    xlab  = 'Month')

## ... use unnamed arguments for x, y, and n
qic(month, harmed, n,
    data  = patient_harm,
    title = 'Patients harmed during hospital stay',
    xlab  = 'Month')

## ... add decimal to centre line label
qic(month, harmed, n,
    data     = patient_harm,
    decimals = 2,
    title    = 'Patients harmed during hospital stay',
    ylab     = 'Proportion',
    xlab     = 'Month')

## ... multiply proportion by 100
qic(month, harmed, n,
    data     = patient_harm,
    multiply = 100,
    title    = 'Patients harmed during hospital stay',
    ylab     = '%',
    xlab     = 'Month')

## ... show percentage
qic(month, harmed, n,
    data      = patient_harm,
    y.percent = T,
    title     = 'Patients harmed during hospital stay',
    xlab      = 'Month')

# Faceted charts ----

## Run chart of monthly number of hospital infections per 10000 patient days
## from hospital_infections dataset
qic(month, n, days,
    data     = hospital_infections,
    multiply = 10000,
    title    = 'Hospital infections',
    ylab     = 'Count per 1000 patient days',
    xlab     = 'Month')

## ... facet by hospital
qic(month, n, days,
    data     = hospital_infections,
    facets   = ~ hospital,
    multiply = 10000,
    title    = 'Hospital infections',
    ylab     = 'Count per 1000 patient days',
    xlab     = 'Month')

## ... facet by infection and hospital
qic(month, n, days,
    data     = hospital_infections,
    facets   = infection ~ hospital,
    multiply = 10000,
    title    = 'Hospital infections',
    ylab     = 'Count per 1000 patient days',
    xlab     = 'Month')

## ... release axis scales
qic(month, n, days,
    data     = hospital_infections,
    facets   = infection ~ hospital,
    multiply = 10000,
    scales   = 'free',
    title    = 'Hospital infections',
    ylab     = 'Count per 1000 patient days',
    xlab     = 'Month')

# Detecting non-random variation with run charts ----

## Critical values for longest run and number of crossings
View(signal_limits)

## Run chart of monthly number of cardiac arrests from arrests dataset
qic(month, arrests,
    data  = arrests,
    title = 'Cardiac arrests',
    ylab  = 'Count',
    xlab  = 'Month')

## ... print summary
qic(month, arrests,
    data          = arrests,
    title         = 'Cardiac arrests',
    ylab          = 'Count',
    xlab          = 'Month',
    print.summary = T)

## Run chart of weekly average hours from admission to antibiotics from
## abx_delay dataset
qic(week, abx_delay,
    data  = abx_delay,
    title = 'Mean time from order to administration of antibiotics',
    ylab  = 'Hours',
    xlab  = 'Week')

## ... aggregate by median
qic(week, abx_delay,
    data    = abx_delay,
    agg.fun = 'median',
    title   = 'Median time from order to administration of antibiotics',
    ylab    = 'Hours',
    xlab    = 'Week')

# Shewhart control charts for counts ----

## P chart of monthly percentage of harmed patients from patient_harm dataset
qic(month, harmed, n,
    data     = patient_harm,
    chart    = 'p',
    title    = 'Patients harmed during hospital stay',
    subtitle = 'P chart',
    xlab     = 'Month')

## C chart of monthly number of patient harms from patient_harm dataset
qic(month, harms,
    data     = patient_harm,
    chart    = 'c',
    title    = 'Patient harms',
    subtitle = 'C chart',
    ylab     = 'Count',
    xlab     = 'Month')

## U chart of monthly number of harms per 1000 patient days from patient_harm
## dataset
qic(month, harms, days,
    data     = patient_harm,
    chart    = 'u',
    multiply = 1000,
    title    = 'Patient harms',
    subtitle = 'U chart',
    ylab     = 'Count per 1000 patient days',
    xlab     = 'Month')

## ... exclude freak data point from calculations of centre and control limits
qic(month, harms, days,
    data     = patient_harm,
    exclude  = 35,
    chart    = 'u',
    multiply = 1000,
    title    = 'Patient harms',
    subtitle = 'U chart',
    ylab     = 'Count per 1000 patient days',
    xlab     = 'Month')

# Case 1: Post operative mortality ----

## Monthly percentage of post operative mortality from postop_mortality dataset
qic(month, deaths, surgeries,
    data      = postop_mortality,
    y.percent = T,
    title     = 'Post op mortality',
    xlab      = 'Month')

## ... freeze baseline median
qic(month, deaths, surgeries,
    data        = postop_mortality,
    freeze      = 24,
    part.labels = c('Basline', 'Safe Surgery Checklist'),
    y.percent   = T,
    title       = 'Post op mortality',
    xlab        = 'Month')

## ... split chart after baseline
qic(month, deaths, surgeries,
    data        = postop_mortality,
    part        = 24,
    part.labels = c('Basline', 'Safe Surgery Checklist'),
    y.percent   = T,
    title       = 'Post op mortality',
    xlab        = 'Month')

## ... add control limits
qic(month, deaths, surgeries,
    data        = postop_mortality,
    chart       = 'p',
    part        = 24,
    part.labels = c('Basline', 'Safe Surgery Checklist'),
    title       = 'Post op mortality',
    subtitle    = 'P chart',
    xlab        = 'Month')

# Case 2: Clostridium difficile infections ----

## Monthly number of clostridium difficile infections from cdiff dataset
qic(month, n,
    data  = cdiff,
    title = 'Hospital acquired C. diff. infections',
    ylab  = 'Count',
    xlab  = 'Month')

## ... freeze baseline median
qic(month, n,
    data        = cdiff,
    freeze      = 24,
    part.labels = c('Baseline', 'Intervention'),
    title       = 'Hospital acquired C. diff. infections',
    ylab        = 'Count',
    xlab        = 'Month')

## ... split chart after baseline
qic(month, n,
    data        = cdiff,
    part        = 24,
    part.labels = c('Baseline', 'Intervention'),
    title       = 'Hospital acquired C. diff. infections',
    ylab        = 'Count',
    xlab        = 'Month')

## ... add control limits
qic(month, n,
    data        = cdiff,
    chart       = 'c',
    part        = 24,
    part.labels = c('Baseline', 'Intervention'),
    title       = 'Hospital acquired C. diff. infections',
    subtitle    = 'C chart',
    ylab        = 'Count',
    xlab        = 'Month')

# Shewhart control charts for measures ----

## I chart of daily systolic blood pressure from blood_pressure dataset
qic(date, systolic,
    data  = blood_pressure,
    chart = 'i',
    title = 'Systolic blood pressure (I chart)',
    ylab  = 'mm Hg',
    xlab  = 'Date')

## ... MR chart
qic(date, systolic,
    data     = blood_pressure,
    chart    = 'mr',
    title    = 'Systolic blood pressure',
    subtitle = 'MR chart',
    ylab     = 'mm Hg',
    xlab     = 'Date')

## Xbar chart of weekly radiation dose from radiation dataset
qic(month, dose,
    data     = radiation,
    chart    = 'xbar',
    title    = 'Mean radiation dose for renography',
    subtitle = 'Xbar chart',
    ylab     = 'MBq',
    xlab     = 'Month')

## ... S chart
qic(month, dose,
    data     = radiation,
    chart    = 's',
    title    = 'Standard deviation radiation dose for renography',
    subtitle = 'S chart',
    ylab     = 'MBq',
    xlab     = 'Month')

# Control charts for rare events ----

## T chart of days between newborns with asphyxia from asphyxia dataset
qic(no, d.days,
    data     = asphyxia,
    chart    = 't',
    title    = 'Days between newborns with asphyxia',
    subtitle = 'T chart',
    ylab     = 'Count',
    xlab     = 'Case no.')

## G chart of deliveries between newborns with asphyxia from asphyxia dataset
qic(no, d.deliveries,
    data     = asphyxia,
    chart    = 'g',
    title    = 'Deliveries between newborns with asphyxia',
    subtitle = 'G chart',
    ylab     = 'Count',
    xlab     = 'Case no.')

# Prime charts for overdispersed data ----

## P chart of percentage attendances seen within 4 hours from nhs_accidents
## dataset
qic(i, r, n,
    data     = nhs_accidents,
    chart    = 'p',
    title    = 'Attendances seen within 4 hours',
    subtitle = 'P chart',
    xlab     = 'Week')

## ... use I chart
qic(i, r, n,
    data      = nhs_accidents,
    chart     = 'i',
    y.percent = T,
    title     = 'Attendances seen within 4 hours',
    subtitle  = 'I chart',
    xlab      = 'Week')

## ... use P prime chart
qic(i, r, n,
    data     = nhs_accidents,
    chart    = 'pp',
    title    = 'Attendances seen within 4 hours',
    subtitle = 'P prime chart',
    xlab     = 'Week')
