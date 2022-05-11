library(readr)
sosang <- read_excel("C:/project/food-waste-analysis/jtw/경기도상권.csv.xlsx")
head(sosang)

df_sosang <- sosang[,-c(1,2,3,4,6,8,9,10,11,12,13,14,16,18,19,20,21:25,27)]
df_sosang <- df_sosang[,-c(2,4:9)]
df_sosang <- df_sosang[,-c(3)]
df_sosang$상권업종대분류명
df_sosang[df_sosang$상권업종대분류명 == '음식' | df_sosang$상권업종대분류명 == '숙박']

food_dom <- df_sosang %>% filter(상권업종대분류명 == '음식' | 상권업종대분류명 == '숙박')
head(food_dom)
table(sosang$시군구명)

sang <- read_excel("C:/project/food-waste-analysis/jtw/1인당음쓰상권.xlsx")
head(sang)

cor.test(sang$'2019 발생량', sang$인당음식점)

re_foodpeople <- lm( 인당배출량~세대당인구, food_population)
re_foodpeople
ggplot(food_population, aes(x = food_person, y = 세대당인구)) +
  geom_point() +
  geom_smooth(se=F)
geom_abline(intercept = 0.6922, slope = -0.1697)
head(food_seoul)
seoul <- read.csv("C:/project/food-waste-analysis/jtw/서울상가.csv")
food_seoul <- seoul %>% filter(상권업종대분류명 == '음식')
seoul_rest <- table(food_seoul$시군구명) %>% data.frame()
seoul_rest <- rename(seoul_rest, c(자치구 = Var1,
                                          음식점수 = Freq))
seoul_rest

food_dom <- df_sosang %>% filter(상권업종대분류명 == '음식')
table(food_dom$시군구명) %>% data.frame()
