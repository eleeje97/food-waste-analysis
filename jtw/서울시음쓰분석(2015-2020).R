install.packages("reshape")
library(dplyr)
library(readr)
library(reshape2)
library(ggplot2)
library(readxl)
library(reshape)

foodtrash_seoul <- read_excel("C:/project/food-waste-analysis/jtw/서울시연도별음쓰발생량(2015-2020).xls")
foodtrash_seoul

population_seoul <- read_excel("C:/project/food-waste-analysis/jtw/서울시연도별인구수(2015-2020).xls")
population_seoul

food_population <- merge(foodtrash_seoul, population_seoul, by = "자치구" )
food_population <-filter(food_population, 기간.x == 기간.y)
food_population
food_person <- (food_population$발생량/food_population$인구수*1000)
food_population <- cbind(food_population,food_person)
food_population
food_population <- subset(food_population, select = c(-기간.y))
food_population

food_population <- rename(food_population, c(기간 = "기간.x",
                                               인당배출량 = "food_person"))

food_population                                               

cor.test(food_population$food_person, food_population$세대당인구)

re_foodpeople <- lm( food_person~세대당인구, food_population)
re_foodpeople
ggplot(food_population, aes(x = food_person, y = 세대당인구)) +
  geom_point() +
  geom_smooth(se=F)
  geom_abline(intercept = 0.6922, slope = -0.1697)
  
ggplot(food_population, aes(x = 자치구, y = food_person)) +
 geom_bar(stat = "identity")
