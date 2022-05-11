### RFID기반 음식물쓰레기 API - 포천, 수원, 의왕, 이천, 안양 ###

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

library(stringr)
cityCodes <- cityCodes %>% filter(str_detect(sigungu, "수원") | 
                                    sigungu == "포천시" | sigungu == "의왕시" | 
                                    sigungu == "이천시" | sigungu == "안양시")


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





## 포천, 수원, 의왕, 이천, 안양 배출내역 뽑기 ##
year <- c("2018", "2019", "2020", "2021")
rfid_data <- data.frame()
for (i in 1:length(year)) {
  for (j in 1:length(cityCodes$citycode)) {
    for (k in 1:12) {
      month <- formatC(k, width = 2, format = "d", flag = "0")
      temp <- getResponse10(year[i], month, cityCodes$citycode[j])
      rfid_data <- rbind(rfid_data, temp)
    }
  }
}


# 일별 데이터 -> 월별 데이터로 가공
rfid_data <- rfid_data %>% select(disYear, disMonth, cityCode, citySggName, disQuantity)
temp <- rfid_data %>% group_by(disYear, disMonth, cityCode, citySggName) %>% 
  summarise(disQuantity=sum(disQuantity))
temp <- temp %>% arrange(disYear)

# 단위를 g/월 -> ton/월 로 변경
temp$disQuantity <- temp$disQuantity/1000000
rfid_data_2018 <- temp %>% filter(disYear==2018)
rfid_data_2019 <- temp %>% filter(disYear==2019)
rfid_data_2020 <- temp %>% filter(disYear==2020)
rfid_data_2021 <- temp %>% filter(disYear==2021)


# csv 파일로 저장
# write.csv(temp, "data/rfid_data.csv", row.names = F)
# write.csv(rfid_data_2018, "data/rfid_data_2018.csv", row.names = F)
# write.csv(rfid_data_2019, "data/rfid_data_2019.csv", row.names = F)
# write.csv(rfid_data_2020, "data/rfid_data_2020.csv", row.names = F)
# write.csv(rfid_data_2021, "data/rfid_data_2021.csv", row.names = F)

