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
  filter(폐기물종류 == "음식물류 폐기물 분리배출" | 폐기물종류_세부 == "음식물류 폐기물")
waste19 <- waste19 %>% group_by(시도, 시군구) %>% summarise(배출량=sum(배출량)) %>% 
  filter(!시군구=="소계")
waste19$년도 <- "2019"
