mat <- matrix(1:9, 3, 3)
# length
## old <- ifelse(age>65, 1, 0)
# apply
for (x in 1:nrow(mat)) {
    for (y in 1:ncol(mat)) {
        mat[x,y] <- mat[x,y]^2
    }
}
mat
help(apply)

# Aufgabe 1
## mat <- matrix(1:16, 4, 4, byrow=TRUE)
mat <- matrix(1:16, 4, 4, byrow=FALSE)
mat
### a
root <- numeric()
for (i in 1:nrow(mat)) {
      root[i] <- sqrt(mat[i, 1])
}
root
### b
root_mat <- matrix(, 4, 2)
for (x in 1:nrow(mat)) {
    for (y in 1:2) {
        ## cat("x: ", x, "y: ", y, "\n")
        root_mat[x,y] <- sqrt(mat[x,y])
    }
}
root_mat
nrow(mat)

# 2 Aufgabe
c_to_f <- function(celsius) {
    (celsius * 1.8) + 32
}
x <- c_to_f(20)
zz <- numeric(8)
zz
## a
temp_convert = function(degree, from_celsius) {
    if (from_celsius) {
        c_to_f(degree)
        ## (celsius * 1.8) + 32
    } else {
        (degree - 32)/1.8
    }
}
temp_convert(20, TRUE)
temp_convert(68, FALSE)

# Aufgabe 3
mat2 <- matrix(rpois(1000,10), 100, 10)
head(mat2)
maxrow <- apply(mat2,1,max)
head(maxrow)
mincol <- apply(mat2,2,min)
head(mincol)
