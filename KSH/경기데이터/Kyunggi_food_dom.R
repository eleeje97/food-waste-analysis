sosang <- read_csv("/Users/teddykim/R/miniproject_0509/sosang.csv")
head(sosang)

df_sosang <- sosang[,-c(1,2,3,4,6,8,9,10,11,12,13,14,16,18,19,20,21:25,27)]
df_sosang <- df_sosang[,-c(2,4:9)]
df_sosang <- df_sosang[,-c(3)]
df_sosang$상권업종대분류명
df_sosang[df_sosang$상권업종대분류명 == '음식' | df_sosang$상권업종대분류명 == '숙박']

food_dom <- df_sosang %>% filter(상권업종대분류명 == '음식' | 상권업종대분류명 == '숙박')

df_si <- data.frame(table(food_dom$시군구명))

df_si <- dplyr::rename(df_si,"행정구역별" = "Var1")
df_si <- dplyr::rename(df_si,"음식 및 숙박업체" = "Freq")

df_si_final <- df_si[-c(3,4,5),]
df_si_final[2,2] <- 10282

df_si_final <- df_si_final[-c(13,14),]
df_si_final[12,2] <- 11056
df_si_final$행정구역별<- as.character(df_si_final$행정구역별)

df_si_final[12,1] <- "성남시"

df_si_final <- df_si_final[-c(14:16,19,20,23,30:32),]
df_si_final[13,2] <- 13112
df_si_final[15,2] <- 7883
df_si_final[17,2] <- 6134
df_si_final[23,2] <- 10780

rownames(df_si_final)=NULL


write_csv(df_si_final, "/Users/teddykim/R/miniproject_0509/kyunggi.csv")
