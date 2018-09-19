## print("Test")
## plot(faithful)
## print("End")
## x <- 34
## print(x)
## mat <- matrix(0, 4, 4)
## diag(mat) <- (1:4)
## mat[c(1,2),]
## mat[1:2,]
## mean(mat[1,])

## 1. Aufgabe
mat <- matrix(,6,4)
mat
### a
mat[2:3,] <- 1
### b
mat[,c(1,2,4)] <- c(1:6)
### c
colnames(mat) <- c("apfel", "banane", "birne", "pflaume")
### d
tmp_vec <- mat[3,]
### e
tmp_vec <- as.logical(tmp_vec)
### f
is.numeric(tmp_vec)

## 2. Aufgabe
tmp_vec_2 <- 5:15
### a
tmp_vec_2[c(6,7)]

## 3. Aufgabe
vec_a <- c(3,5,9)
vec_b <- c(1,4,10)
vec_c <- vec_a + vec_b
### a
vec_d <- c(rep(NA, 3))
### b
vec_d[vec_c >= 9] <- vec_c[vec_c >= 9]
### c
vec_e <- c(rep(NA, 3))
vec_e[vec_a == 3 | vec_a == 9] <- 100
