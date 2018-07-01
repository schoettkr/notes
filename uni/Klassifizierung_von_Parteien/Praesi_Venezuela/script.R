?install.packages
install.packages("stringr", lib = "~/arch/pkgs/R/")
library(stringr, lib.loc = "~/arch/pkgs/R/")
## install.packages("~/downloads/backports_1.1.2.tar.gz", repos = NULL, type="source")
install.packages("bdynsys", lib = "~/arch/pkgs/R/")
library(bdynsys, lib.loc = "~/arch/pkgs/R/")

bayfacfig(2, 5, c(-5.4534, -5.3955, -5.235, -4.99948, -5.321), 4)
bdynsys(datap, 2, 1, datap$logGDP, datap$EmanzV)
## datap


# Graph cars using blue points overlayed by a line 
cars <- c(1, 3, 6, 4, 9)
plot(cars, type="o", col="blue")


datap$DemocrH[2] == 0
datap$DemocrH
tail(datap, 60)
datap["73-2012",]

install.packages("withr", lib = "~/arch/pkgs/R/")
library(withr, lib.loc="~/arch/pkgs/R/")
install.packages("httr", lib = "~/arch/pkgs/R/")
library(httr, lib.loc="~/arch/pkgs/R/")
install.packages("curl", lib = "~/arch/pkgs/R/")
library(curl, lib.loc="~/arch/pkgs/R/")


install.packages("devtools", lib = "~/arch/pkgs/R/")
library(devtools, lib.loc = "~/arch/pkgs/R/")
devtools::install_github("xmarquez/democracyData", lib = "~/arch/pkgs/R/")

## library(democracyData, lib.loc = "~/arch/pkgs/R/")
library(democracyData) 

venezuelaVanhanen <- vanhanen[vanhanen$vanhanen_country == "Venezuela",]
tail(venezuelaVanhanen, 20)

tail(vanhanen[vanhanen$vanhanen_country == "Brazil",], 20)
