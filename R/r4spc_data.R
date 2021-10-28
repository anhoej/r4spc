set.seed(5)

# blood pressure
measure <- round(rnorm(24, 125, 4), 1)

# bacteremia deaths
patients <- round(rnorm(24, 70, 10))
cases    <- rbinom(24, patients, 0.1)

# patient harm
days   <- round(rnorm(24, 150, 20), 1)
events <- rpois(24, 0.06 * days)

d <- data.frame(x = 1:24,
                measure,
                month = seq(as.Date('2019-01-01'),
                            by         = 'month',
                            length.out = 24),
                cases,
                patients,
                events,
                days)

saveRDS(d, 'data/r4spc.rds')
