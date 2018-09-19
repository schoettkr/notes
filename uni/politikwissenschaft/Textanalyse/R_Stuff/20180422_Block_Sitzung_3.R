



















#---------------
# Data frame
#---------------

setwd("~/Dropbox/Lehre/2018_SoSe/Textanalyse/Sitzungen/Sitzung_Block/misc/") ## Working directory

library(foreign) ## Fremd"sprachliche" Datensätze
library(stringr) ## Textoperationen

# install.packages("stringr")

FOLDER <- "~/Dropbox/Lehre/2018_SoSe/Textanalyse/Sitzungen/Sitzung_Block/misc/"

## Austrian national election study -- Pre- and post-electoral survey
dat <- read.dta(str_c(FOLDER, "ZA5859_de_v1-0-0.dta"))
dat <- read.dta("ZA5859_de_v1-0-0.dta")
dat <- read.dta("~/Dropbox/Lehre/2018_SoSe/Textanalyse/Sitzungen/Sitzung_Block/misc/ZA5859_de_v1-0-0.dta")    

## Equivalent
dat <- read.dta(file = "ZA5859_de_v1-0-0.dta")

View(dat)

## Arguments/Defaults                
dat <- read.dta(file = "ZA5859_de_v1-0-0.dta", convert.factors = F)

colnames(participants) <- tolower(colnames(participants)) ## column names lower case

## Subsetting

# $: Elements of a data.frame or list

dim(dat[dat$zpsex == "weiblich",]) ## Female participants

head(dat$zpsex[dat$zpsex == "weiblich"])
head(dat[dat$zpsex == "weiblich",])

## In the background: Creation of logical vector: dat$zpsex == "weiblich"

tmp_vec <- dat$zpsex == "weiblich" & dat$zpage >= 40

dat$zpsex[tmp_vec]

dim(dat[dat$zpsex == "weiblich" & dat$zpage > 40,]) ## Female AND over 40
View(dat[dat$zpsex == "weiblich" & dat$zpage > 40,]) ## Female AND over 40

dim(dat[dat$zpsex == "weiblich" | dat$zpage > 40,]) ## Female OR over 40

tmp_dat <- dat[dat$zpsex == "weiblich" & dat$zpage > 40,]

table(tmp_dat$zpsex) ## Tabulate content of vector
table(tmp_dat$zpage)

table(tmp_dat$zpsex, tmp_dat$zpage) ## Cross-tabulate two vectors

dat$old <- 0
dat$old[dat$zpage > 65] <- 1

tmp_dat <- dat

log_vec <- rep(c(T,F), length.out = 3266)

tmp_dat <- tmp_dat[log_vec, 1:10]
tmp_dat <- tmp_dat[log_vec, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]

tmp_dat <- tmp_dat[log_vec, c(1:10, 20)]
tmp_dat <- tmp_dat[log_vec, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20)]

tmp_dat <- tmp_dat[, 1:10]



## Anticipated vote choice
table(dat$w1_q50)

## Create new variable, assign to data.frame
dat$choice <- dat$w1_q50

## Recoding variable
dat$choice[dat$choice == "FP Kaernten"] <- "FPOE"

dat$choice[dat$choice == "KPOE"] <- NA ## Missing values
dat$choice[dat$choice == "Piraten"] <- NA
dat$choice[dat$choice == "andere Partei"] <- NA
dat$choice[dat$choice == "keine Partei/niemand"] <- NA
dat$choice[dat$choice == "weiss nicht"] <- NA
dat$choice[dat$choice == "verweigert"] <- NA

table(dat$choice)

class(dat$choice)
## --> Factors most useful for statistical modeling

levels(dat$choice) ## Levels of factor

dat$choice <- as.character(dat$choice) ## Convert to character

table(dat$choice)

proportion <- prop.table(table(dat$choice)) ## Percentages
round(proportion, 2) * 100

round(prop.table(table(dat$choice, dat$zpsex), 2), 3) * 100

## Equivalent

table_proportion <- table(dat$choice)

proportion_2 <- table_proportion / sum(table_proportion) ## Manual calculation
proportion_2

## Rename NEOS/LIF/JULIS
names(proportion)

names(proportion)[4] <- "NEOS" ## Rename fourth element

electoral_result <- c(
	3.5, # BZÖ
	20.5, # FPÖ
	12.4, # GRÜNE
	5.0, # NEOS
	24.0, # ÖVP
	26.8, # SPÖ
	5.7 # STRONACH
)

## Operation on the entire vector
electoral_result <- electoral_result / 100 ## Divide electoral result by 100

electoral_result_new <- electoral_result / 100
electoral_result_new

#---------------
# Plotting
#---------------

barplot(table(dat$zpage))

colors <- c(
	"orange",
	"blue",
	"green",
	"violet",
	"black",
	"red",
	"yellow"
)

pdf("~/Desktop/electoral_result.pdf") ## Generate PDF

plot(
	as.numeric(proportion),
	electoral_result,
	xlab = "Survey result",
	ylab = "Election outcome",
	xlim = c(0, .4),
	ylim = c(0, .4),
	col = colors,
	pch = 16,
	cex = 2,
	bty = "n"
)

abline(a = 0, b = 1, lty = 2)
abline(a = 0, b = 1/2, lty = 3)

legend(
	"topleft",
	bty = "n",
	fill = colors,
	border = NA,
	legend = c(
		"BZÖ",
		"FPÖ",
		"GRÜNE",
		"NEOS",
		"ÖVP",
		"SPÖ",
		"STRONACH"
	)
)

dev.off() ## Function with no arguments

pdf("~/Desktop/electoral_result_labels.pdf")

plot(
	as.numeric(proportion),
	electoral_result,
	xlab = "Survey result",
	ylab = "Election outcome",
	xlim = c(0, .4),
	ylim = c(0, .4),
	col = colors,
	pch = 16,
	cex = 2,
	bty = "n",
	type = "n"
)

abline(a = 0, b = 1, lty = 2)

text(
	as.numeric(proportion),
	electoral_result,
	labels = c(
		"BZÖ",
		"FPÖ",
		"GRÜNE",
		"NEOS",
		"ÖVP",
		"SPÖ",
		"STRONACH"
	)
)

dev.off()

## Lists

tmp_list <- list(1:10, matrix(0, 2, 3), "LUH")

tmp_list[[1]] ## Access the first element

names(tmp_list) <- c("numeric", "matrix", "character")

tmp_list$character ## Access by name

tmp_list[["character"]] ## Access by name

tmp_list[[2]][2]

tmp_list[["matrix"]][2,]
tmp_list$matrix[2,]

dat[2, "zpsex"]
dat[, "zpsex"][2]
dat$zpsex[2]
dat[2:3, ]

#---------------
# Inferenzstatistik
#---------------

## Wie sympathisch sind Ihnen die politischen Parteien in Österreich (FPÖ)
## 0 - Gar nicht sympathisch
## 10 - Sehr sympathischo
table(dat$w1_q45x3) 
fpoe <- dat$w1_q45x3
fpoe[fpoe > 10] <- NA
#table(dat$w1_q58x1)

## Einige Menschen sind für die Gesellshcaft einfach mehr wert als andere
## 1 - trifft sehr zu
## 5 -- trifft gar nicht zu
value <- table(dat$w1_q64x3) 
value <- as.numeric(dat$w1_q64x3)
value[value > 5] <- NA

out <- lm(value ~ fpoe)

summary(out)

plot(fpoe, value)
abline(a = 3.18, b = -.10)
abline(a = coef(out)[1], b = coef(out)[2])













