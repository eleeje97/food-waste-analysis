### 자원순환정보시스템 전국폐기물 발생현황 데이터 2019-2020 ###

waste19_raw <- read_excel("data/waste2019.xlsx", sheet = 6)
waste19 <- waste19_raw %>% select(시도, 시군구, "폐기물 종류", "...5", "2019년 발생량")
colnames(waste19) <- c("시도", "시군구", "폐기물종류", "폐기물종류_세부", "배출량")
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
waste19 <- waste19 %>% filter(시도 == "경기") %>% 
  filter(폐기물종류 == "음식물류 폐기물 분리배출" | 폐기물종류_세부 == "음식물류 폐기물") %>% 
  select(-시도)
waste19 <- waste19 %>% group_by(시군구) %>% summarise(배출량=sum(배출량))
waste19$년도 <- "2019"


library(readr)
waste20 <- read_csv("../yjh/data/sgg_waste_2020.csv")
waste20 <- waste20 %>% filter(!(signgu=="합계"))
colnames(waste20) <- c("시군구", "배출량")
waste20$년도 <- "2020"


waste1920 <- rbind(waste19, waste20)
ggplot(data = waste1920,
       aes(x = 시군구, y = 배출량, fill = 년도)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 시군구별 증감률
waste1920 <- cbind(select(waste19, c(시군구, 배출량)), select(waste20, 배출량))
colnames(waste1920) <- c("시군구", "2019", "2020")
waste1920$rate <- (waste1920$`2020`-waste1920$`2019`)/waste1920$`2019` * 100

# csv 파일로 저장
#write.csv(waste1920, "data/waste1920.csv", row.names = F)
