# Working Directory 변경
setwd("c:/danalee/food-waste-analysis/lde/")

# 파일 불러오기
library(readxl)
waste17 <- read_excel("data/waste2017.xlsx", sheet = 2)
waste18 <- read_excel("data/waste2018.xlsx", sheet = 2)
waste19 <- read_excel("data/waste2019.xlsx", sheet = 6)
waste20 <- read_excel("data/waste2020.xlsx", sheet = 5)

# 데이터 정제
library(dplyr)
waste17 <- waste17 %>% select(시도, 시군구, 음식물류폐기물분리배출) %>% filter(시도 == "경기")
colnames(waste17) <- c("시도", "시군구", "배출량") # 배출량 단위: 톤/일
waste17$년도 <- "2017"

waste18 <- waste18 %>% select(시도, 시군구, 음식물류폐기물분리배출) %>% filter(시도 == "경기")
colnames(waste18) <- c("시도", "시군구", "배출량")
waste18$년도 <- "2018"

waste19 <- waste19 %>% select(시도, 시군구, "폐기물 종류", "2019년 발생량")
colnames(waste19) <- c("시도", "시군구", "폐기물종류", "배출량")
current_sido <- ""
current_sigungu <- ""
for (i in 1:nrow(waste19)) {
  if(is.na(waste19[i,1])) {
    waste19[i,1] <- current_sido
    waste19[i,2] <- current_sigungu
  } else {
    current_sido <- waste19[i,1]
    current_sigungu <- waste19[i,2]
  }
}
waste19 <- waste19 %>% filter(시도 == "경기" & 폐기물종류 == "음식물류 폐기물 분리배출") %>% select(-폐기물종류)
waste19$년도 <- "2019"

waste20 <- waste20 %>% select(시도, 시군구, "폐기물 종류", "2020년 발생량")
colnames(waste20) <- c("시도", "시군구", "폐기물종류", "배출량") # 배출량 단위: 톤/년
current_sido <- ""
current_sigungu <- ""
for (i in 1:nrow(waste20)) {
  if(is.na(waste20[i,1])) {
    waste20[i,1] <- current_sido
    waste20[i,2] <- current_sigungu
  } else {
    current_sido <- waste20[i,1]
    current_sigungu <- waste20[i,2]
  }
}
waste20 <- waste20 %>% filter(시도 == "경기" & 폐기물종류 == "음식물류 폐기물 분리배출") %>% select(-폐기물종류)
waste20$년도 <- "2020"
waste20$배출량 <- waste20$배출량 / 365 # 배출량 단위 변경 (톤/년 -> 톤/일)

###############################################################################

### 데이터 분석 & 시각화 ###
library(ggplot2)

# 경기도 전체 배출량 추이
waste_data <- rbind(waste17, waste18, waste19, waste20)
waste_data_gyeonggi <- waste_data %>% filter(시군구 == "소계")
ggplot(data = waste_data_gyeonggi, 
       aes(x = 년도 , y = 배출량)) +
  geom_col(width = 0.5)

# 경기도 시군구별 배출량 추이
waste_data_sigungu <- waste_data %>% filter(!시군구=="소계") # %>% group_by(시군구)
ggplot(data = waste_data_sigungu,
       aes(x = 시군구, y = 배출량, fill = 년도)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 2019-2020년 데이터 추출
waste_data_1920 <- waste_data_sigungu %>% filter(년도=="2019" | 년도=="2020")
ggplot(data = waste_data_1920,
       aes(x = 시군구, y = 배출량, fill = 년도)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 시군구별 증감률



