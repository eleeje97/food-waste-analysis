library(readr)
###sosang <- read_excel("C:/project/food-waste-analysis/jtw/경기도상권.csv.xlsx")
###head(sosang)

###food_dom <- df_sosang %>% filter(상권업종대분류명 == '음식' | 상권업종대분류명 == '숙박')
###head(food_dom)
###table(sosang$시군구명)

###sang <- read_excel("C:/project/food-waste-analysis/jtw/data/1인당음쓰상권.xlsx")
###head(sang)


###re_foodpeople <- lm( 인당배출량~세대당인구, food_population)
###re_foodpeople
###ggplot(food_population, aes(x = food_person, y = 세대당인구)) +
###  geom_point() +
###  geom_smooth(se=F)
###geom_abline(intercept = 0.6922, slope = -0.1697)
###head(food_seoul)
###seoul <- read.csv("C:/project/food-waste-analysis/jtw/서울상가.csv")
###food_seoul <- seoul %>% filter(상권업종대분류명 == '음식')
###seoul_rest <- table(food_seoul$시군구명) %>% data.frame()
###seoul_rest <- rename(seoul_rest, c(자치구 = Var1,
###                                          음식점수 = Freq))
###seoul_rest

###food_dom <- df_sosang %>% filter(상권업종대분류명 == '음식')
###table(food_dom$시군구명) %>% data.frame()
###19-20년경기도 음식물쓰레기데이터 가져오기 출처:https://www.recycling-info.or.kr/rrs/stat/envStatDetail.do?menuNo=M13020201&pageIndex=1&bbsId=BBSMSTR_000000000002&s_nttSj=KEC005&nttId=1200&searchBgnDe=&searchEndDe=
gyeonggi_food <- read.csv("C:/project/food-waste-analysis/jtw/data/1920경기도음쓰.csv")
head(gyeonggi_food)
###경기도 인구수 데이터 출처:https://stat.gg.go.kr/statHtml/statHtml.do?orgId=210&tblId=DT_210J0001
pop1 <- read.csv("C:/project/food-waste-analysis/jtw/data/2019경기인구.csv")
pop1
pop2 <- read.csv("C:/project/food-waste-analysis/jtw/data/2020경기인구.csv")
gyeonggi_food <- merge(gyeonggi_food, pop1,  by = '시군구')
gyeonggi_food <- merge(gyeonggi_food, pop2, by = '시군구')
head(gyeonggi_food)
###head(sang)
food_people1 <- (gyeonggi_food$X2019/gyeonggi_food$X2019년인구*1000)
food_people2 <- (gyeonggi_food$X2020/gyeonggi_food$X2020년인구*1000)
gyeonggi_food <- cbind(gyeonggi_food, food_people1)
gyeonggi_food <-cbind(gyeonggi_food, food_people2)
head(gyeonggi_food)
###경기도 상권 데이터https://sg.sbiz.or.kr/godo/index.sg
sangkwon <- read.csv("C:/project/food-waste-analysis/jtw/data/상권현황.csv")
sangkwon
gyeonggi_food <- merge(gyeonggi_food, sangkwon, by = '시군구')
head(gyeonggi_food)


###sang <- read_excel("C:/project/food-waste-analysis/jtw/data/1인당음쓰상권.xlsx")
###sang
###sang <- merge(sang, sangkwon, by = "시군구")
###head(sang)
###head(sang1)
###total_food19 <- (sang$`2019 발생량`*sang$총인구수)
###total_food20 <- (sang$`2020 발생량`*sang$총인구수)
###sang <- cbind(sang, total_food19)
###sang <- cbind(sang, total_food20)
###경기도 세대당 인구수 출처:https://jumin.mois.go.kr/
peo <- read.csv("C:/project/food-waste-analysis/jtw/data/경기세대당인구수.csv")
head(peo)
###head(sang)
gyeonggi_food <- merge(gyeonggi_food,peo, by = '시군구')
head(gyeonggi_food)
gyeonggi_food <- rename(gyeonggi_food, 발생량19 = X2019,
                       발생량20 = X2020,
                        인구19 = X2019년인구,
                        인구20 = X2020년인구,
                        인당발생량19 = food_people1,
                        인당발생량20 = food_people2,
                       세대당인구 = X2022년04월_세대당.인구)
head(gyeonggi_food)
###cor.test(sang$'2020 발생량', sang$인구당.업소수)
###cor.test(sang$'2020 발생량', sang$인당음식점)
###cor.test(sang$'2019 발생량', sang$아파트.단위면적당.기준시가_원단위)
###cor.test(sang$total_food19, sang$상권일일유동인구)
###cor.test(sang$total_food20, sang$상권일일유동인구)
###cor.test(sang$총인구수, sang$total_food19)
###cor.test(sang$총인구수, sang$total_food20)

###인구수가 많으면 음식물쓰레기 배출량이 높아질까?2019년 - 상관계수: 0.92
cor.test(gyeonggi_food$발생량19,gyeonggi_food$인구19)
re_foodpeople <- lm( 인구19~발생량19, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 인구19, y = 발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 56043, slope = 3216)

###인구수가 많으면 음식물쓰레기 배출량이 높아질까?2020년 - 상관계수: 0.91
cor.test(gyeonggi_food$발생량20,gyeonggi_food$인구20)
re_foodpeople <- lm( 인구20~발생량20, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 인구20, y = 발생량20)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 129409, slope = 2393)
###인구당 음식점 수가 많으면 인당 음식물쓰레기 배출량이 높아질까? - 상관계수:0.59
cor.test(gyeonggi_food$인당발생량19, gyeonggi_food$인구당.업소수)
re_foodpeople <- lm( 인구당.업소수~인당발생량19, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 인구당.업소수, y = 인당발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 0.01054, slope = 0.02483)
###상권일일유동인구가 많으면 음식물쓰레기 배출량이 높아질까? 2019년 - 상관계수:0.83
cor.test(gyeonggi_food$발생량19, gyeonggi_food$상권일일유동인구)
re_foodpeople <- lm( 상권일일유동인구~발생량19, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 상권일일유동인구, y = 발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 16126.8, slope = 478.4)
###상권일일유동인구가 많으면 음식물쓰레기 배출량이 높아질까? 2020년 - 상관계수:0.79
cor.test(gyeonggi_food$발생량20, gyeonggi_food$상권일일유동인구)
re_foodpeople <- lm( 상권일일유동인구~발생량20, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 상권일일유동인구, y = 발생량20)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 28393, slope = 340)
###세대당인구수가 적으면(1인가구비율이 높으면) 1인당 음식물쓰레기 배출량이 높아질까? - 상관계수 : -0.44
cor.test(gyeonggi_food$세대당인구, gyeonggi_food$인당발생량19)
re_foodpeople <- lm( 세대당인구~인당발생량19, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 세대당인구, y = 인당발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 2.4309, slope = -0.5543)
###아파트 면적당 가격이 높으면 1인당 음식물쓰레기 배출량이 높아질까? - 상관계수: -0.16
cor.test(gyeonggi_food$인당발생량20, gyeonggi_food$아파트.단위면적당.기준시가_원단위) 
re_foodpeople <- lm( 아파트.단위면적당.기준시가_원단위~인당발생량19, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 아파트.단위면적당.기준시가_원단위, y = 인당발생량20)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 0.01054, slope = 0.02483)
###경기도아파트가격이 경기도 유동인구수에 영향을 많이 미칠까?
cor.test(gyeonggi_food$상권일일유동인구, gyeonggi_food$아파트.단위면적당.기준시가_원단위) 
re_foodpeople <- lm( 아파트.단위면적당.기준시가_원단위~인당발생량19, gyeonggi_food)
re_foodpeople
ggplot(gyeonggi_food, aes(x = 아파트.단위면적당.기준시가_원단위, y = 상권일일유동인구)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 0.01054, slope = 0.02483)

###과천시가 세대당 인구수와 1인당 음식물쓰레기 상관관계 추세에 벗어나는데, 과천시의 인구수가 5만 8천명으로
###많은 인구수가 아니라서 세대당인구수가 낮을수록(1인가구비중이 높을수록) 인당음식물쓰레기발생량이 높아진다는 추세
###에 영향을 준다고 보기는 힘들 것이다. 또한 집값에서 볼 수 있듯이 과천시는 경기도 지역보다는 서울지역의 특성을 
###보이는 경향이 있는 지역이기에 이상치로 제외시켜도 무방하다.




###서울과 비슷한 특성을 지닌다고 추정되는 집값 상위 3곳 제외
g_food_no <- gyeonggi_food[-c(3, 12,30), ]
g_food_no
###인구수가 많으면 음식물쓰레기 배출량이 높아질까?2019년 - 상관계수: 0.92
cor.test(g_food_no$발생량19,g_food_no$인구19)
re_foodpeople <- lm( 인구19~발생량19, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 인구19, y = 발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 56043, slope = 3216)

###인구수가 많으면 음식물쓰레기 배출량이 높아질까?2020년 - 상관계수: 0.91
cor.test(g_food_no$발생량20,g_food_no$인구20)
re_foodpeople <- lm( 인구20~발생량20, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 인구20, y = 발생량20)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 129409, slope = 2393)
###인구당 음식점 수가 많으면 인당 음식물쓰레기 배출량이 높아질까? - 상관계수:0.59
cor.test(g_food_no$인당발생량19, g_food_no$인구당.업소수)
re_foodpeople <- lm( 인구당.업소수~인당발생량19, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 인구당.업소수, y = 인당발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 0.01054, slope = 0.02483)
###상권일일유동인구가 많으면 음식물쓰레기 배출량이 높아질까? 2019년 - 상관계수:0.83
cor.test(g_food_no$발생량19, g_food_no$상권일일유동인구)
re_foodpeople <- lm( 상권일일유동인구~발생량19, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 상권일일유동인구, y = 발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 16126.8, slope = 478.4)
###상권일일유동인구가 많으면 음식물쓰레기 배출량이 높아질까? 2020년 - 상관계수:0.79
cor.test(g_food_no$발생량20, g_food_no$상권일일유동인구)
re_foodpeople <- lm( 상권일일유동인구~발생량20, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 상권일일유동인구, y = 발생량20)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 28393, slope = 340)
###세대당인구수가 적으면(1인가구비율이 높으면) 1인당 음식물쓰레기 배출량이 높아질까? - 상관계수 : -0.44
cor.test(g_food_no$세대당인구, g_food_no$인당발생량19)
re_foodpeople <- lm( 세대당인구~인당발생량19, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 세대당인구, y = 인당발생량19)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 2.4309, slope = -0.5543)
###아파트 면적당 가격이 높으면 1인당 음식물쓰레기 배출량이 높아질까? - 상관계수: -0.16
cor.test(g_food_no$인당발생량20, g_food_no$아파트.단위면적당.기준시가_원단위) 
re_foodpeople <- lm( 아파트.단위면적당.기준시가_원단위~인당발생량19, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 아파트.단위면적당.기준시가_원단위, y = 인당발생량20)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 0.01054, slope = 0.02483)
###경기도아파트가격이 경기도 유동인구수에 영향을 많이 미칠까? - 집값 상위 3곳 제외
cor.test(g_food_no$상권일일유동인구, g_food_no$아파트.단위면적당.기준시가_원단위) 
re_foodpeople <- lm( 아파트.단위면적당.기준시가_원단위~인당발생량19, g_food_no)
re_foodpeople
ggplot(g_food_no, aes(x = 아파트.단위면적당.기준시가_원단위, y = 상권일일유동인구)) +
  geom_point() +
  geom_smooth(se=F) +
  geom_abline(intercept = 0.01054, slope = 0.02483)
