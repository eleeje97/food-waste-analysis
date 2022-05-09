sosang <- read_csv("/Users/teddykim/R/miniproject_0509/sosang.csv")
head(sosang)

df_sosang <- sosang[,-c(1,2,3,4,6,8,9,10,11,12,13,14,16,18,19,20,21:25,27)]
df_sosang <- df_sosang[,-c(2,4:9)]
df_sosang <- df_sosang[,-c(3)]
df_sosang$상권업종대분류명
df_sosang[df_sosang$상권업종대분류명 == '음식' | df_sosang$상권업종대분류명 == '숙박']

food_dom <- df_sosang %>% filter(상권업종대분류명 == '음식' | 상권업종대분류명 == '숙박')
