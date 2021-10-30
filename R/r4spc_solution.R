# BASIC STANDARDISED CONTROL CHART
#   Plot 24 random normal data points connected with lines.
#   Add three horizontal lines at -3, 0, 3.
#   Make points outside control limits stand out.
#   Re-run the code many times.
#   How often do you get data points outside the limits?
#   What affects the chance of (false) signals?
#   How big a shift in data is necessary to make almost every chart signal?
#   How can you increase the chart's sensitivity to (minor) shifts in data?
#
# ADDING RUNS ANALYSIS
#   Add check for unusually long runs or unusually few crossings.
#   How often do you get false signals?
#   How big a shift is necessary to make almost every chart signal?
#
# EMPIRICAL CENTRE LINE AND LIMITS (I CHART, RUN CHART)
#   What parts of the script do you need to change to add empirical limits?
#   Make an I chart.
#   Make a median based run chart.
#
# ONE FUNCTION TO RULE THEM ALL
#   Wrap everything in a function, spc().
#   Add optional x argument.
#   Add C, U, and P charts.
#   Fix LCL < 0 for P, C, and U charts.
#   Fix UCL > 1 for P charts.
#
# WRAPPING UP
#   Allow data to be in a data frame.
#   Add a multiplication argument (P and U charts).
#   How do you add title and labels to the plot?
#   Add a target argument.
#   How do you decide when the target has been reached?
#
#   The final function interface should look something like this:
#   spc(
#     x,                                       # x axis values
#     y        = NULL,                         # measure or numerator
#     n        = NULL,                         # denominator for u and p charts
#     data     = NULL,                         # data frame with x, y, and n
#     chart    = c('run', 'i', 'c', 'u', 'p'), # type of SPC chart
#     target   = NA,                           # target value to be plotted
#     multiply = 1,                            # multiplicator value
#     ...
#   )
#
#  WHAT NEXT
#   What about error handling - what can go wrong?
#   What else do you want from an SPC function?

spc <- function(x,
                y        = NULL,
                n        = NULL,
                data     = NULL,
                chart    = c('run', 'i', 'c', 'u', 'p'),
                target   = NA,
                multiply = 1,
                ...) {
  x <- eval(substitute(x), data, parent.frame())
  y <- eval(substitute(y), data, parent.frame())
  n <- eval(substitute(n), data, parent.frame())

  if (is.null(y)) {
    y <- x
    x <- seq_along(y)
  }

  n.obs <- length(y)

  chart <- match.arg(chart)

  if (chart == 'run') {               # Run chart
    m <- median(y)
    s <- NA
  } else if (chart == 'i') {          # I chart
    m <- mean(y)
    s <- mean(abs(diff(y))) / 1.128
  } else if (chart == 'c') {          # C chart
    m <- mean(y)
    s <- sqrt(m)
  } else if (chart == 'u') {          # U chart
    m <- sum(y) / sum(n)
    s <- sqrt(m / n)
    y <- y / n
  } else if (chart == 'p') {          # P chart
    m <- sum(y) / sum(n)
    s <- sqrt(m * (1 - m) / n)
    y <- y / n
  }

  cl  <- rep(m, n.obs) * multiply
  lcl <- cl - 3 * s * multiply
  ucl <- cl + 3 * s * multiply
  y   <- y * multiply

  if (chart %in% c('c', 'u', 'p')) {
    lcl[lcl < 0] <- 0
  }

  if (chart == 'p') {
    ucl[ucl > 1 * multiply] <- 1 * multiply
  }

  # sigma signal
  signals                 <- y < lcl | y > ucl
  signals[is.na(signals)] <- F

  # runs analysis
  runs            <- sign(y - cl)
  runs            <- runs[runs != 0]
  run.lengths     <- rle(runs)$lengths
  n.useful        <- sum(run.lengths)
  longest.run     <- max(run.lengths)
  n.crossings     <- length(run.lengths) - 1
  longest.run.max <- round(log2(n.useful)) + 3
  n.crossings.min <- qbinom(0.05, n.useful - 1, 0.5)
  runs.signal     <- longest.run > longest.run.max |
                     n.crossings < n.crossings.min

  # plot
  plot(x, y,
       type = 'l',
       bty  = 'l',
       las  = 1,
       ylim = range(lcl, ucl, target, y, na.rm = T),
       ...)
  lines(x, lcl)
  lines(x, cl,
        col = runs.signal + 1,
        lty = runs.signal + 1)
  lines(x, ucl)
  lines(x,
        rep(target, length(y)),
        col = 'darkgreen',
        lty = 3)
  points(x, y,
         pch = 19,
         col = signals + 1)
}

# Examples
y <- rnorm(24)
spc(y)
spc(y, chart = 'i')
spc(y, target = 3)

x <- Sys.Date() - rev(seq_along(y))
spc(x, y)

# Data frame examples
d <- readRDS(url('https://github.com/anhoej/r4spc/raw/main/data/r4spc_data.rds'))

spc(x, measure,
    data  = d,
    chart = 'i')
spc(month, events,
    data  = d,
    chart = 'c')
spc(month, events, days,
    data     = d,
    chart    = 'u',
    multiply = 100)
spc(month, cases, patients,
    data     = d,
    chart    = 'p',
    multiply = 100,
    main     = 'P chart',
    xlab     = 'Month',
    ylab     = '%',
    las      = 1)
