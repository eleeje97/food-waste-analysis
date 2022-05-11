# setwd
setwd("~/Dropbox/class_materials/R_mini_project/food-waste-analysis/yjh")

# loading packages
library(readxl)
library(ggplot2)
library(dplyr)

# plot korean font
library(extrafont)
font_import()
theme_set(theme_grey(base_family = 'NanumGothic'))

# 전국 배달음식 시장 성장
delivery_market <- read.csv("./data/온라인쇼핑동향_음식서비스.csv")
str(delivery_market)
delivery_market$시점 <- gsub("\\.", "-", delivery_market$시점)

ggplot(delivery_market, aes(x = 시점, y = 총합, group = 1)) +
  geom_line() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("거래액")

# 코로나 확진자 현황
corona_202205 <- read_excel("data/corona_202205.xlsx", sheet = "Sheet1")
str(corona_202205)
corona_202205$Ym <- substr(corona_202205$일자, 1, 7)
corona_202205$Ym <- gsub("-", ".", corona_202205$Ym)
corona_month <- corona_202205 |> select(Ym, 확진자수) |> 
  group_by(Ym) |> summarise(p_sum = sum(확진자수))

# 코로나 확진자 수와 음식서비스 결제액 테이터 합치기
corona_delivery <- inner_join(corona_month, delivery_market, by = c("Ym" = "시점"))
# 2022년도 행은 자르기
corona_delivery <- corona_delivery[-c(23:25), ]

g <- ggplot(corona_delivery, aes(Ym)) +
  geom_line(aes(y = p_sum, group = 1), color = "red") +
  ylab("코로나19 확진자 수") +
  xlab("")
g + geom_line(aes(y = 총합 / 10, group = 1), color = "blue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.title.y.left = element_text(color = "red"),
        axis.title.y.right = element_text(color = "blue"),
        axis.text.y.left = element_text(color = "red"),
        axis.text.y.right = element_text(color = "blue")) +
  scale_y_continuous(sec.axis = sec_axis(~.*10, name = "음식서비스 결제금액"),
                     labels = scales::comma)








