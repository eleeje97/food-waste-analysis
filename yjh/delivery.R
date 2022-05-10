# setwd
setwd("~/Dropbox/class_materials/R_mini_project/food-waste-analysis/yjh")

# loading data
order_2019 <- read.csv("./data/order_dest_data/KGU_2019.csv", header = F)
order_2020 <- read.csv("./data/order_dest_data/KGU_2020.csv", header = F)
order_2021 <- read.csv("./data/order_dest_data/KGU_2021.csv", header = F)
names(order_2019) <- c("date", "hour", "food_type", "sido", "sgg", "order_cnt")
names(order_2020) <- c("date", "hour", "food_type", "sido", "sgg", "order_cnt")
names(order_2021) <- c("date", "hour", "food_type", "sido", "sgg", "order_cnt")


# data preprocessing
library(dplyr)
order_2019_gg <- order_2019 |> filter(sido == "경기도")
order_2020_gg <- order_2020 |> filter(sido == "경기도")
order_2021_gg <- order_2021 |> filter(sido == "경기도")

# save data
write.csv(order_2019_gg, "./data/order_dest_data/order_2019_gg.csv", row.names = F)
write.csv(order_2020_gg, "./data/order_dest_data/order_2020_gg.csv", row.names = F)
write.csv(order_2021_gg, "./data/order_dest_data/order_2021_gg.csv", row.names = F)

# binding data 2019 + 2020
order_1920_gg <- rbind(order_2019_gg, order_2020_gg)
order_total_gg <- rbind(order_1920_gg, order_2021_gg)

# save data
write.csv(order_1920_gg, "./data/order_dest_data/order_1920_gg.csv", row.names = F)
write.csv(order_total_gg, "./data/order_dest_data/order_total_gg.csv", row.names = F)

filter(order_total_gg, order_total_gg$sgg == "수원시 영통구")
order_total_gg$YYmm <- substr(order_total_gg$date, 1, 7)













