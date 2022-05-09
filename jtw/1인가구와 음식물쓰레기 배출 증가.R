library(dplyr)
library(readr)
library(reshape2)
library(ggplot2)
library(readxl)
food <- read.csv("C:/Rstudy/week4/경기도 인당 음식물쓰레기.csv")
people <- read.csv("C:/Rstudy/week4/경기도 세대당 인구수1.csv")

foodpeople <- merge(food, people, by = "시군명")

foodpeople <-rename(foodpeople, c(인당발생량 = X1일1인발생량.kg., 
                          세대당인구 = X2022년04월_세대당.인구))
cor.test(foodpeople$인당발생량, foodpeople$세대당인구)

re_foodpeople <- lm( 인당발생량~세대당인구, foodpeople)
re_foodpeople
ggplot(foodpeople, aes(x = 인당발생량, y = 세대당인구)) +
  geom_point() +
  geom_abline(intercept = 0.7153, slope = -0.2096) ### 세대당 인구수

fp <- read_excel("c:/Rstudy/week4/시도별1인가구음식물쓰레기.xlsx")
fp

cor.test(fp$`1인당 음식물쓰레기 배출량`,fp$`1인가구 비율`)

re_fp <- lm(`1인당 음식물쓰레기 배출량`~`1인가구 비율`, data = fp)
re_fp
ggplot(fp, aes( x= `1인당 음식물쓰레기 배출량`, y= `1인가구 비율`)) +
  geom_point() +
  geom_abline(intercept = 0.1060, slope = 0.4674)
