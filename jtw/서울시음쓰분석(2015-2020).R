install.packages("reshape")

library(dplyr)
library(readr)
library(reshape2)
library(ggplot2)
library(readxl)
library(reshape)
###서울시연도별 음식물쓰레기 발생량 데이터 가져오기. 출처: https://data.seoul.go.kr/dataList/371/S/2/datasetView.do
foodtrash_seoul <- read_excel("C:/project/food-waste-analysis/jtw/data/서울시연도별음쓰발생량(2015-2020).xls")
foodtrash_seoul
###서울시연도별 인구수 데이터 가져오기. 출처: https://data.seoul.go.kr/
population_seoul <- read_excel("C:/project/food-waste-analysis/jtw/data/서울시연도별인구수(2015-2020).xls")
population_seoul

###자치구별로 통합 데이터 전처리 진행
food_population <- merge(foodtrash_seoul, population_seoul, by = "자치구" )
food_population <-filter(food_population, 기간.x == 기간.y)
food_population
food_person <- (food_population$발생량/food_population$인구수*1000)
food_population <- cbind(food_population,food_person)
food_population
food_population <- subset(food_population, select = c(-기간.y))
food_population

food_population <- rename(food_population, 
                          인당배출량 = food_person,
                          기간 = 기간.x)

food_population                                               

###seoul <- read.csv("C:/project/food-waste-analysis/jtw/data/서울상가.csv")
###food_seoul <- seoul %>% filter(상권업종대분류명 == '음식')
###seoul_rest <- table(food_seoul$시군구명) %>% data.frame()
###seoul_rest <- rename(seoul_rest, c(자치구 = Var1,
###                                      음식점수 = Freq))
###seoul_rest

###food_population <- merge(food_population, seoul_rest, by = "자치구" )
###food_population
###rest_person <- (food_population$음식점수/food_population$인구수)

###2020년 데이터만 추출
food_population2020 <-filter(food_population, 기간 == 2020)
food_population2020

###rest_person2020 <- (food_population2020$음식점수/food_population2020$인구수)
###food_population2020 <- cbind(food_population2020, rest_person2020)
###rename(food_population2020, 인당음식점수 = rest_person2020)

###상권정보,아파트가격 데이터 출처:https://sg.sbiz.or.kr/godo/index.sg
seoul_sang <- read.csv("C:/project/food-waste-analysis/jtw/data/서울상권현황.csv")
### 2020년 서울시 음식물쓰레기 데이터와 병합
food_population2020 <-merge(food_population2020, seoul_sang, by = "자치구")
head(food_population2020)

###아파트 면적당 가격이 높으면 1인당 음식물쓰레기 배출량이 많아질까? - 상관계수:0.42
cor.test(food_population2020$인당배출량,food_population2020$아파트면적당가격)
re_foodpeople <- lm( 아파트면적당가격~인당배출량, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 아파트면적당가격, y = 인당배출량, color = 유동인구)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 6604438, slope = 11002987)
###인구당 음식점 수가 많으면 1인당 음식물쓰레기 배출량이 높아질까? - 상관계수:0.89
cor.test(food_population2020$인당배출량,food_population2020$인구당업소수)
re_foodpeople <- lm( 인구당업소수~인당배출량, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 인구당업소수, y = 인당배출량)) +
  geom_point() +
  geom_smooth(se=F) +
geom_abline(intercept = -0.005187, slope = 0.070596)
###음식점 수가 많으면 1인당 음식물쓰레기 배출량이 높아질까? - 상관계수:0.54
cor.test(food_population2020$인당배출량,food_population2020$업소수)
re_foodpeople <- lm( 업소수~인당배출량, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 업소수, y = 인당배출량)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 2387, slope = 8963)
###인구수가 많으면 음식물쓰레기 배출량이 높아질까? - 상관계수:0.68
cor.test(food_population2020$인구수,food_population2020$발생량)
re_foodpeople <- lm(인구수~발생량, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 인구수, y = 발생량)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 201430, slope = 1920)
###세대당인구수가 적으면(1인가구비율이 높으면) 1인당 음식물쓰레기 배출량이 높아질까?
cor.test(food_population2020$세대당인구,food_population2020$인당배출량)
re_foodpeople <- lm( 세대당인구~인당배출량, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 세대당인구, y = 인당배출량)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 2.2389, slope = -0.2455)
###세대당인구수가 적으면(1인가구비율이 높으면) 1인당 음식물쓰레기 배출량이 높아질까?-2015-2020년 6개년 데이터분석 -상관계수:-0.21, p-value=0.009
cor.test(food_population$세대당인구, food_population$인당배출량)
re_foodpeople <- lm( 세대당인구~인당배출량, food_population)
re_foodpeople
ggplot(food_population, aes(x = 세대당인구, y = 인당배출량)) +
  geom_point() +
  geom_smooth(se=F) +
geom_abline(intercept =2.365, slope = -0.259)
###상권유동인구가 많으면 음식물쓰레기 배출량이 높아질까?- 상관계수:0.95.. 제일 높음!!
cor.test(food_population2020$발생량,food_population2020$유동인구)
re_foodpeople <- lm( 유동인구~발생량, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 유동인구, y = 발생량)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = -607.8, slope = 591)
###서울시집값이 높은 곳은 유동인구도 많을까?
cor.test(food_population2020$유동인구,food_population2020$아파트면적당가격)
re_foodpeople <- lm( 아파트면적당가격~유동인구, food_population2020)
re_foodpeople
ggplot(food_population2020, aes(x = 아파트면적당가격, y = 유동인구)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 5051868.1, slope = 75.7)
ggplot(food_population2020, aes(x = 자치구, y = food_person)) +
  geom_bar(stat = "identity")
