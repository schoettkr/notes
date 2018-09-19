library(stringr, lib.loc = "~/arch/R/")

raw.data <- "555-1239Moe Szyslask(636) 555-0113Burns, C. Montgomery555-6542Rev. Timothy Lovejoy555 8904Ned Flanders"

name <- unlist(str_extract_all(raw.data , "[[:alpha:]., ]{2,}"))
name

test <- unlist(str_extract_all(raw.data , "\\..."))
test
test2 <- unlist(str_extract_all(raw.data , "\\w+"))
test2

## Str Methods
## str_replace, str_locate, str_split, str_detect, str_count, str_length, str_c

## phone <- unlist(str_extract_all(raw.data , "\\(?)"))
?unlist

## Aufgaben Sitzung 4
# 1.)
simpsons <- c('Moe Szyslask', 'Rev. Timothy Lovejoy', 'Ned Flanders', 'Homer Simpson', 'Dr. Julius Hibbert')
simpsons
# 1.a)
hasTitle <-  str_detect(simpsons, "(Dr|Rev)\\.")
hasTitle <-  str_detect(simpsons, "\\w+\\.")
str_count(simpsons, "[[:alpha:]]+") > 2

# 2.)
# 2.a)
string <- "My telephonenumber is 0943280342$ Great!"
string <- "5$"
str_extract_all(string, "[0-9]+\\$")
# 2.b)
string <- "maaaaatch ye ma a"
string <- "ente"
str_extract_all(string, "\\b[a-z]{1,4}\\b")
# 2.c)
string <- "test.txt"
str_extract_all(string, ".*?\\.txt$")
# 2.d)
string <- "13/22/1996"
str_extract_all(string, "\\d{2}/\\d{2}/\\d{4}")

# 3.)
# 3.a)
string <- "chunkylover53[at]aol[dot]com"
news <- str_replace(string, "\\[at\\]", "@")
news <- str_replace(news, "\\[dot\\]", ".")
news
## ?str_replace
news2 <- str_replace(string, "\\[at\\]aol\\[dot\\]", "@aol.")
news2 <- str_replace(string, "\\[at\\]\\w+\\[dot\\]", "@aol.")
news2 <- str_replace(string, "\\[at\\](\\w+)\\[dot\\]", "@$1.")
news2
?str_replace

# 4.)
# 4.a)
string <- "<title>+++BREAKING NEWS+++</title>"
str_extract(string, "<.+?>")

