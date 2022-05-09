<<<<<<< HEAD
install.packages("httr") # HTTP통신을 위한 패키지 설치

library(httr)
tmp <- GET('http://apis.data.go.kr/B552584/RfidFoodWasteServiceNew/getTotalTimeList?serviceKey=YnMclRSaf7BPlwfk3i27A9b57cvb%2B1XKeGjs4GWXcd%2FNN6SKSsD%2BNt9B48YpeLMggrUMiI0Ded0tqKAxbT7FTA%3D%3D&type=xml&disYear=2020&disMonth=06&page=1&rowNum=10')
tmp
library(jsonlite)

tmp <- fromJSON('http://apis.data.go.kr/B552584/RfidFoodWasteServiceNew/getTotalTimeList?serviceKey=YnMclRSaf7BPlwfk3i27A9b57cvb%2B1XKeGjs4GWXcd%2FNN6SKSsD%2BNt9B48YpeLMggrUMiI0Ded0tqKAxbT7FTA%3D%3D&type=json&disYear=2020&disMonth=06&page=1&rowNum=10')

fromJSON()

tmp$data
library(dplyr)
library(readr)
library(reshape2)
library(ggplot2)
library(readxl)

foodtrash_RFID <- read.csv("C:/Rstudy/week4/RFID설치지자체월별음쓰배출(2017.7~2020.7).csv")
head(foodtrash_RFID)
filter(foodtrash_RFID, 배출연도==2020 , 배출월 == 7 )
foodtrash_RFID <- foodtrash_RFID[,c(1:5)]
foodtrash_RFID

RFID_people <- read.csv("C:/Rstudy/week4/RFID 설치 추정인구수.csv")
head(RFID_people)
###기초지자체를 기준으로 두 차트를 병합
RFID_foodtrash_info <- merge(foodtrash_RFID, RFID_people, by = "기초지자체")
###쓸모없는 것 제외(RFID종량기.수,세대수)  
RFID_foodtrash_info <-subset(RFID_foodtrash_info, select=c(-광역시도.x, - RFID종량기.수, -X.추정..세대수))
###(배출연도 배출월), (광역시도랑 기초지자체 병합)
city <- paste(RFID_foodtrash_info$광역시도.y,RFID_foodtrash_info$기초지자체)
head(city)
RFID_foodtrash_info <- cbind(city,RFID_foodtrash_info)
RFID_foodtrash_info <-subset(RFID_foodtrash_info, select=c(-기초지자체, - 광역시도.y))
date <-paste(RFID_foodtrash_info$배출연도,RFID_foodtrash_info$배출월, sep="-")

RFID_foodtrash_info <- cbind(date,RFID_foodtrash_info)
head(RFID_foodtrash_info)
###배출연도, 배출월 제거
RFID_foodtrash_info <-subset(RFID_foodtrash_info, select=c(-배출연도, - 배출월))
head(RFID_foodtrash_info)
RFID_foodtrash_info
###여기까지 했는데, 데이터 중간에 부산광역시랑 강서구가 묶여있어서 뭔가 잘못한거는 같은데 뭔지는 모르겠음..
###그리고 데이터를 살펴보니 강남구같은 경우는 2018년 8월부터 RFID를 설치하기 시작했는데, 굉장히 기하급수적으로 늘더라구요.
###현재 확인 가능한 RFID 설치 정보가 20년7월 데이터여서 서울시 전체 RFID 증가량으로 보정값을 세우면 될 거 같았는데, 세부 데이터를 살펴보니
###지역마다 설치 증가율이 상당히 달라서 이 부분에 대한 데이터를 구할 수 있다면 좋을 것 같습니다.

RFID_foodtrash_info_207 <-filter(RFID_foodtrash_info, date==2020-7)
RFID_foodtrash_info_207
RFID_foodtrash_info_207 <-filter(foodtrash_RFID, 배출연도==2020, 배출월 == 7 )
=======
install.packages("httr") # HTTP통신을 위한 패키지 설치

library(httr)
tmp <- GET('http://apis.data.go.kr/B552584/RfidFoodWasteServiceNew/getTotalTimeList?serviceKey=YnMclRSaf7BPlwfk3i27A9b57cvb%2B1XKeGjs4GWXcd%2FNN6SKSsD%2BNt9B48YpeLMggrUMiI0Ded0tqKAxbT7FTA%3D%3D&type=xml&disYear=2020&disMonth=06&page=1&rowNum=10')
tmp
library(jsonlite)

tmp <- fromJSON('http://apis.data.go.kr/B552584/RfidFoodWasteServiceNew/getTotalTimeList?serviceKey=YnMclRSaf7BPlwfk3i27A9b57cvb%2B1XKeGjs4GWXcd%2FNN6SKSsD%2BNt9B48YpeLMggrUMiI0Ded0tqKAxbT7FTA%3D%3D&type=json&disYear=2020&disMonth=06&page=1&rowNum=10')

fromJSON()

tmp$data
library(dplyr)
library(readr)
library(reshape2)
library(ggplot2)
library(readxl)

foodtrash_RFID <- read.csv("C:/Rstudy/week4/RFID설치지자체월별음쓰배출(2017.7~2020.7).csv")
head(foodtrash_RFID)
filter(foodtrash_RFID, 배출연도==2020 , 배출월 == 7 )
foodtrash_RFID <- foodtrash_RFID[,c(1:5)]
foodtrash_RFID

RFID_people <- read.csv("C:/Rstudy/week4/RFID 설치 추정인구수.csv")
head(RFID_people)
###기초지자체를 기준으로 두 차트를 병합
RFID_foodtrash_info <- merge(foodtrash_RFID, RFID_people, by = "기초지자체")
###쓸모없는 것 제외(RFID종량기.수,세대수)  
RFID_foodtrash_info <-subset(RFID_foodtrash_info, select=c(-광역시도.x, - RFID종량기.수, -X.추정..세대수))
###(배출연도 배출월), (광역시도랑 기초지자체 병합)
city <- paste(RFID_foodtrash_info$광역시도.y,RFID_foodtrash_info$기초지자체)
head(city)
RFID_foodtrash_info <- cbind(city,RFID_foodtrash_info)
RFID_foodtrash_info <-subset(RFID_foodtrash_info, select=c(-기초지자체, - 광역시도.y))
date <-paste(RFID_foodtrash_info$배출연도,RFID_foodtrash_info$배출월, sep="-")

RFID_foodtrash_info <- cbind(date,RFID_foodtrash_info)
head(RFID_foodtrash_info)
###배출연도, 배출월 제거
RFID_foodtrash_info <-subset(RFID_foodtrash_info, select=c(-배출연도, - 배출월))
head(RFID_foodtrash_info)
RFID_foodtrash_info
###여기까지 했는데, 데이터 중간에 부산광역시랑 강서구가 묶여있어서 뭔가 잘못한거는 같은데 뭔지는 모르겠음..
###그리고 데이터를 살펴보니 강남구같은 경우는 2018년 8월부터 RFID를 설치하기 시작했는데, 굉장히 기하급수적으로 늘더라구요.
###현재 확인 가능한 RFID 설치 정보가 20년7월 데이터여서 서울시 전체 RFID 증가량으로 보정값을 세우면 될 거 같았는데, 세부 데이터를 살펴보니
###지역마다 설치 증가율이 상당히 달라서 이 부분에 대한 데이터를 구할 수 있다면 좋을 것 같습니다.

RFID_foodtrash_info_207 <-filter(RFID_foodtrash_info, date==2020-7)
RFID_foodtrash_info_207
RFID_foodtrash_info_207 <-filter(foodtrash_RFID, 배출연도==2020, 배출월 == 7 )
>>>>>>> 42ff9e3da7035386496de0b56ca1d42d0b3c0801
