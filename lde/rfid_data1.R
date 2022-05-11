### RFID기반 음식물쓰레기 API ###

library(httr)
library(dplyr)
library(jsonlite)

# Working Directory 변경
setwd("c:/danalee/food-waste-analysis/lde/")

# api에 보낼 파라미터 값
auth <- read.table("data/auth_data.txt")
url <- auth[4,2]
api_key <- auth[5,2]

# 경기도 시군구 10곳 행정구역 리스트
gyeonggi_sigungu_10 <- readLines("data/gyeonggi_sigungu_10.txt", encoding = 'UTF-8')


# API 3번 지자체 정보 목록 조회 함수
getResponse3 <- function(sigungu_name) {
  res <- GET(url = paste(url, "getCityList", sep = ""),
             query = list(ServiceKey=api_key,
                          type="json",
                          citySidoName="경기",
                          citySggName=sigungu_name))
  
  res_df <- res %>% content(as = "text", encoding = "UTF-8") %>% fromJSON()
  return(res_df$data$list)
}


# API 10번 지자체별 배출내역(일별) 목록 조회 함수
getResponse10 <- function(disYear, disMonth, cityCode) {
  res <- GET(url = paste(url, "getCityDateList", sep = ""),
             query = list(ServiceKey=api_key,
                          type="json",
                          disYear=disYear,
                          disMonth=disMonth,
                          cityCode=cityCode,
                          rowNum=31))
  res_df <- res %>% content(as = "text", encoding = "UTF-8") %>% fromJSON()
  return(res_df$data$list)
}


# API 15번 아파트 세대수 및 좌표 목록 조회 함수
getResponse15 <- function(cityCode) {
  res <- GET(url = paste(url, "getAptLocInfoList", sep = ""),
             query = list(ServiceKey=api_key,
                          type="json",
                          cityCode=cityCode))
  res_df <- res %>% content(as = "text", encoding = "UTF-8") %>% fromJSON()
  count <- res_df$data$count
  
  res <- GET(url = paste(url, "getAptLocInfoList", sep = ""),
             query = list(ServiceKey=api_key,
                          type="json",
                          cityCode=cityCode,
                          rowNum=count))
  res_df <- res %>% content(as = "text", encoding = "UTF-8") %>% fromJSON()
  return(res_df$data$list)
}


## 지자체 영역코드 뽑기 ##
cityCodes <- data.frame()
for (i in 1:length(gyeonggi_sigungu_10)) {
  sigungu_name <- gyeonggi_sigungu_10[i]
  response <- getResponse3(sigungu_name)
  for (j in 1:length(response[,1])) {
    cityCodes <- rbind(cityCodes, c(response$citySggName[j], response$cityCode[j]))
  }
}
colnames(cityCodes) <- c("sigungu", "citycode")



## 수원, 포천 배출내역 뽑기 ##
library(stringr)
cityCodes_sw_pc <- cityCodes %>% filter(str_detect(sigungu, "수원") | sigungu == "포천시")
year <- c("2017", "2018", "2019", "2020", "2021")
rfid_swpc <- data.frame()
for (i in 1:length(year)) {
  for (j in 1:length(cityCodes_sw_pc$citycode)) {
    for (k in 1:12) {
      month <- formatC(k, width = 2, format = "d", flag = "0")
      temp <- getResponse10(year[i], month, cityCodes_sw_pc$citycode[j])
      rfid_swpc <- rbind(rfid_swpc, temp)
    }
  }
}


rfid_swpc <- rfid_swpc %>% select(disYear, disMonth, cityCode, citySggName, disQuantity)
temp <- rfid_swpc %>% group_by(disYear, disMonth, cityCode, citySggName) %>% 
  summarise(disQuantity=sum(disQuantity))
temp <- temp %>% arrange(disYear)
rfid_swpc_2017 <- temp %>% filter(disYear==2017)
rfid_swpc_2018 <- temp %>% filter(disYear==2018)
rfid_swpc_2019 <- temp %>% filter(disYear==2019)
rfid_swpc_2020 <- temp %>% filter(disYear==2020)
rfid_swpc_2021 <- temp %>% filter(disYear==2021)


# csv 파일로 저장
# write.csv(temp, "data/rfid_swpc.csv", row.names = F)
# write.csv(rfid_swpc_2017, "data/rfid_swpc_2017.csv", row.names = F)
# write.csv(rfid_swpc_2018, "data/rfid_swpc_2018.csv", row.names = F)
# write.csv(rfid_swpc_2019, "data/rfid_swpc_2019.csv", row.names = F)
# write.csv(rfid_swpc_2020, "data/rfid_swpc_2020.csv", row.names = F)
# write.csv(rfid_swpc_2021, "data/rfid_swpc_2021.csv", row.names = F)




## 아파트 세대수 및 좌표 뽑기 ##
a <- getResponse15(cityCodes$citycode[1])

