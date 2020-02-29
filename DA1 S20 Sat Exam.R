library(tidyverse)
library(stringr)
library(lubridate)

locString = "C:/Users/ellen/Documents/UH/Spring 2020/DA1/Section 1/MIdterms/Sat/"

JuneShipments  <- dbGetQuery(con1,"
SELECT
  [SalesLT].[SalesOrderHeader].[SalesOrderID]
  ,[SalesLT].[SalesOrderHeader].[OrderDate]
  ,[SalesLT].[SalesOrderHeader].[DueDate]
  ,[SalesLT].[SalesOrderHeader].[ShipDate]
FROM [SalesLT].[SalesOrderHeader]
")

JuneShipments <- select(JuneShipments, SalesOrderID, DueDate, ShipDate) %>%
  mutate(DueDate = ymd(DueDate), ShipDate = ymd(ShipDate))

AprilShipments <- read_csv(str_c(locString,"Shipments-April.csv"))
MayShipments <- read_csv(str_c(locString,"Shipments-May.csv"))

AprilShipments <- select(AprilShipments, SalesOrderID, DueDate, ShipDate)
MayShipments <- select(MayShipments, SalesOrderID, DueDate, ShipDate)

TotalShipments <- AprilShipments %>% bind_rows(MayShipments) %>%
  mutate(DueDate = mdy(DueDate), ShipDate = mdy(ShipDate)) %>%
  bind_rows(JuneShipments) %>%
  mutate(LeadTime = DueDate - ShipDate)

ggplot(TotalShipments, aes(x = LeadTime)) + geom_bar() + 
  facet_wrap(month(TotalShipments$ShipDate, label = T), dir = "v")

CntLateShipments <- TotalShipments %>% 
  filter(LeadTime < 3) %>%
  group_by(Month = month(ShipDate, label = T)) %>% 
  summarise(Cnt_Late = n())

CntShipments <- TotalShipments %>%
  group_by(Month = month(ShipDate, label = T)) %>% 
  summarise(Cnt_Total = n()) %>%
  inner_join(CntLateShipments, by = "Month") %>%
  mutate(Prcntg_Late = round(100*Cnt_Late / Cnt_Total, 0))

print(CntShipments)
