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

# 경기도 시군구 행정구역 리스트
gyeonggi_sigungu_10 <- readLines("data/gyeonggi_sigungu_10.txt", encoding = 'UTF-8')


# API 3번 지자체 정보 목록 조회 함수
getResponse3 <- function(api_oper, sigungu_name) {
  res <- GET(url = paste(url, api_oper, sep = ""),
             query = list(ServiceKey=api_key,
                          type="json",
                          citySidoName="경기",
                          citySggName=sigungu_name))
  
  res_df <- res %>% content(as = "text", encoding = "UTF-8") %>% fromJSON()
  return(res_df$data$list$cityCode)
}


## 지자체 영역코드 뽑기 ##
cityCodes <- c()
for (i in 1:length(gyeonggi_sigungu_10)) {
  sigungu_name <- gyeonggi_sigungu_10[i]
  
  cityCodes <- c(cityCodes, c(sigungu_name, getResponse3("getCityList", sigungu_name)))
}




