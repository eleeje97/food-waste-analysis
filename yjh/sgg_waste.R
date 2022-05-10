# setwd
setwd("~/Dropbox/class_materials/R_mini_project/food-waste-analysis/yjh")

# loading data
library(readxl)
sgg_waste1 <- read_excel("data/sgg_waste.xlsx", sheet = "2020_생활(가정)")
sgg_waste2 <- read_excel("data/sgg_waste.xlsx", sheet = "2020_사업장비배출시설계")
sgg_waste3 <- read_excel("data/sgg_waste.xlsx", sheet = "2019_생활(가정)")
sgg_waste4 <- read_excel("data/sgg_waste.xlsx", sheet = "2019_사업장비배출시설계")

# data preprocessing
library(dplyr)
sgg_waste1_grouped <- sgg_waste1 %>% group_by(signgu) %>% summarise(waste_2020_sum = sum(waste_2020))
sgg_waste2_grouped <- sgg_waste2 %>% group_by(signgu) %>% summarise(waste_2020_sum = sum(waste_2020))

sgg_waste1_grouped$total <- (sgg_waste1_grouped$waste_2020_sum + sgg_waste2_grouped$waste_2020_sum) / 365

sgg_2020_total <- subset(sgg_waste1_grouped, select = c(signgu, total))

# save dataset
write.csv(sgg_2020_total, "./data/sgg_waste_2020.csv", row.names = F)

# 음식물전용봉투를 사용하지 않고 생활(가정) 배출량이 증가했는지
waste_nobag <- sgg_waste1 %>% filter(type == "음식물류 폐기물") |> 
  
waste_wbag <- sgg_waste3 |> filter(type == "음식물류 폐기물")


