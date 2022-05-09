# loading data
keco_foodwaste <- read.csv("./data/keco_RFID_foodwaste.csv")

apply(is.na(keco_foodwaste), 2, sum)
## no NAs in dataframe

# extracting only "경기도"
library(dplyr)
keco_gg_foodwaste <- keco_foodwaste %>% filter(sido == "경기도") %>% 
  arrange(year, month)

# save keco_gg_foodwaste
write.csv(keco_gg_foodwaste, "./data/keco_gg_foodwaste.csv", row.names = F,
          fileEncoding = "UTF-8")











