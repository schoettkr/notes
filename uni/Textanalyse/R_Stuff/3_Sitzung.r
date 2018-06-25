library(stringr, lib.loc = "~/arch/R/")
library(foreign)

## Aufgabe 1
dat <- read.csv("./participants.csv", sep = ";")
?read.csv
dat

## 1.a)
dat <- read.csv("./participants.csv", sep = ";", stringsAsFactors = FALSE)
dat

## 1.b)
class(dat$abschluss)

## 1.c)
colnames(dat)[4] <- "teilnahme"
colnames(dat)

## 1.d)
dat$geschlecht[dat$geschlecht == "m"]
dat$geschlecht[dat$geschlecht == "m"] <- "maennlich" 
dat$geschlecht[dat$geschlecht == "w"] <- "weiblich"
dat

## 1.e)
table(dat$geschlecht)

## 1.f)
proportion <- prop.table(table(dat$geschlecht))
round(proportion, 2) * 100

## 1.g)
round(proportion, 3) * 100

## 1.h)
table(dat$geschlecht, dat$teilnahme)

## 1.i)
prop.table(table(dat$geschlecht, dat$teilnahme), 1)

## 1.j)
dat$powi <- 0
dat$powi[dat$studiengang == "politikwissenschaft"] <- 1
dat

## 1.k)
dat$powi_wiwi <- 0
dat$powi_wiwi[dat$studiengang == "politikwissenschaft" | dat$studiengang == "wirtschaftswissenschaft"] <- 1
dat

## 1.l)
table(dat$studiengang, dat$powi)

## 1.m)
dat$powi_m <- 0
dat$powi_m[dat$studiengang == "politikwissenschaft" & dat$geschlecht == "maennlich"] <- 1
dat

## 1.n)
dat$studiengang[dat$studiengang == "unbekannt"] <- NA
dat

## 1.o)
log_vec <- rep(c(T,F), length.out = 24)
new_dat <- dat[log_vec, ]
new_dat
