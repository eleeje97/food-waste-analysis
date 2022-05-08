# setwd
setwd("~/Dropbox/class_materials/R_mini_project/food-waste-analysis/yjh")

# loading data
local_foodwaste_1 <- read.csv("./data/local_foodwaste_1.csv")
local_foodwaste_2 <- read.csv("./data/local_foodwaste_2.csv")

# check data
## counting NAs by columns
apply(is.na(local_foodwaste_1), 2, sum)
apply(is.na(local_foodwaste_2), 2, sum)

## "apt_cd", "apt_nm" are all NAs
local_foodwaste_1 <- subset(local_foodwaste_1, select = -c(apt_cd, apt_nm))
local_foodwaste_2 <- subset(local_foodwaste_2, select = -c(apt_cd, apt_nm))

summary(local_foodwaste_1)
summary(local_foodwaste_2)

library(dplyr)
local_foodwaste_1 <- local_foodwaste_1 %>% arrange(exhst_yy, exhst_mt, exhst_de)
## local_foodwaste_1 data duration: 2018.11.01 ~ 2020.08.31
local_foodwaste_2 <- local_foodwaste_2 %>% arrange(exhst_yy, exhst_mt, exhst_de)
## local_foodwaste_2 data duration: 2019.11.01 ~ 2021.07.31

## extracting "경기도"
gg_foodwaste_1 <- local_foodwaste_1 %>% filter(locgov_sido_nm == "경기도")
gg_foodwaste_2 <- local_foodwaste_2 %>% filter(ctpr_nm == "경기도")

# binding two dataframes
## matching colnames
names(gg_foodwaste_1) <- c("year", "month", "day", "dotw",
                           "locgov_code", "sido", "signgu",
                           "quantity", "quantity_rt", "cnt", "cnt_rt")
names(gg_foodwaste_2) <- c("year", "month", "day", "dotw",
                           "locgov_code", "sido", "signgu",
                           "quantity", "quantity_rt", "cnt", "cnt_rt")

gg_foodwaste_tt <- rbind(gg_foodwaste_1, gg_foodwaste_2)

# unique records
gg_foodwaste_tt <- unique(gg_foodwaste_tt)

# Now, we only use "gg_foodwaste_tt"
## 5: "목요일", 6: "금요일", 7: "토요일", 1: "일요일", 2: "월요일", 3: "화요일", 4: "수요일"
gg_foodwaste_tt$dotw <- cut(gg_foodwaste_tt$dotw, breaks = c(0, 1, 2, 3, 4, 5, 6, 7), right = TRUE,
    labels = c("sun", "mon", "tue", "wed", "thu", "fri", "sat"))

## locgov_code는 제거
gg_foodwaste_tt <- subset(gg_foodwaste_tt, select = -c(locgov_code))

## "year", "month", "day"는 날짜 타입으로 변경

# save dataframe
write.csv(gg_foodwaste_tt, "./data/gg_foodwaste_tt.csv", row.names = F,
          fileEncoding = "UTF-8")









