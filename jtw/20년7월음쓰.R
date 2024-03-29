library(dplyr)
library(readr)
library(reshape2)
library(ggplot2)
library(readxl)

###RFID기반 음식물쓰레기 배출 데이터 불러오기
foodtrash_RFID <- read.csv("C:/Rstudy/week4/RFID설치지자체월별음쓰배출(2017.7~2020.7).csv")
head(foodtrash_RFID)
###2020년 7월 데이터만 필터링
foodtrash_RFID <- filter(foodtrash_RFID, 배출연도==2020 , 배출월 == 6 )
foodtrash_RFID <- foodtrash_RFID[,c(1:5)]
foodtrash_RFID
### 월이랑 시컬럼명 정리
city <- paste(foodtrash_RFID$광역시도,foodtrash_RFID$기초지자체)
date <- paste(foodtrash_RFID$배출연도,foodtrash_RFID$배출월, sep = "-")
foodtrash_info <- cbind(city, foodtrash_RFID)
foodtrash_info <- cbind(date, foodtrash_info)
head(foodtrash_info)
### 쓸모없는 것들 삭제
foodtrash_info <-subset(foodtrash_info, select=c(-광역시도, - 기초지자체,-배출연도,-배출월))
foodtrash_info
### 인구수데이터 불러오기
RFID_people <- read.csv("C:/Rstudy/week4/RFID 설치 추정인구수.csv")
RFID_people
RFID_people <-subset(RFID_people, select=c(-RFID종량기.수,-X.추정..세대수))
head(RFID_people)
city <- paste(RFID_people$광역시도,RFID_people$기초지자체)

RFID_people <- cbind(city,RFID_people)
head(RFID_people)
RFID_people <-subset(RFID_people, select=c(-광역시도,-기초지자체))
head(RFID_people)
RFID_foodtrash <- merge(RFID_people, foodtrash_info, by = 'city')
food_perperson <- (RFID_foodtrash$배출량.톤./RFID_foodtrash$RFID설치.인구수/30)
food_perperson
RFID_foodtrash <-cbind(RFID_foodtrash,food_perperson)
RFID_foodtrash

cor.test(RFID_foodtrash$구별.세대당.인구, RFID_foodtrash$food_perperson)

re_foodpeople <- lm( 구별.세대당.인구~food_perperson, RFID_foodtrash)
re_foodpeople
ggplot(RFID_foodtrash, aes(x = 구별.세대당.인구, y = food_perperson)) +
  geom_point() +
  geom_smooth(se=F) +
geom_abline(intercept = 2.1699, slope = 0.1954)

###데이터를 살펴보니 강남구같은 경우는 2018년 8월부터 RFID를 설치하기 시작했는데, 굉장히 기하급수적으로 늘더라구요.
###현재 확인 가능한 RFID 설치 정보가 20년7월 데이터여서 서울시 전체 RFID 증가량으로 보정값을 세우면 될 거 같았는데, 세부 데이터를 살펴보니
###지역마다 설치 증가율이 상당히 달라서 이 부분에 대한 데이터를 구해야 2020년 7월것 아닌 데이터들도 사용이 가능할 것 같습니다.
