library(tidyverse)
library(stringr)
library(lubridate)

locString = "C:/Users/ellen/Documents/UH/Spring 2020/DA1/Section 1/MIdterms/Tues/"


SalesByGenderColor  <- dbGetQuery(con1,"
SELECT 
    [SalesLT].[Customer].[CustomerID]
    ,[SalesLT].[Customer].[Title]
    ,[SalesLT].[Product].[Color]
    ,[SalesLT].[SalesOrderDetail].[OrderQty]
    ,[SalesLT].[SalesOrderDetail].[LineTotal]
  FROM [SalesLT].[Customer]
  INNER JOIN 
  [SalesLT].[SalesOrderHeader]
  ON
  [SalesLT].[SalesOrderHeader].[CustomerID] =
  [SalesLT].[Customer].[CustomerID]
  INNER JOIN 
  [SalesLT].[SalesOrderDetail]
  ON
  [SalesLT].[SalesOrderDetail].[SalesOrderID]=
  [SalesLT].[SalesOrderHeader].[SalesOrderID]
  INNER JOIN 
  [SalesLT].[Product]
  ON
  [SalesLT].[SalesOrderDetail].[ProductID]=
  [SalesLT].[Product].[ProductID]
")


Store1Color <- SalesByGenderColor %>% 
  filter(Title %in% c("Mr.", "Ms.")) %>%
  filter(!is.na(Color)) %>%
  group_by(Title, Color) %>%
  summarise(Qty = sum(OrderQty, na.rm = T)) %>%
  select(Title, Color, Qty) %>%
  spread(Title, Qty) %>%
  rename(Men = Mr., Women = Ms.) %>%
  add_column(Store = "Store1")

Store2Color <- read_csv(str_c(locString, "Store2Color.csv")) 
Store2Color <- Store2Color[1:2,] # or you could use slice() in a pipe

AllStoreColor <- Store2Color %>% 
  gather(2:ncol(Store2Color), key = "Color", value = "Amt") %>%
  rename(Title = X1) %>%
  group_by(Title, Color) %>% 
  summarise(Qty = sum(Amt, na.rm = T)) %>%
  mutate(Prcntg = Qty / sum(Qty)) %>%
  select(Title, Color, Qty) %>% 
  spread(Title, Qty) %>%
  add_column(Store = "Store2") %>%
  bind_rows(Store1Color) 


AllStoreColor %>% pivot_longer(2:3, names_to = "Gender", values_to = "Qty") %>% 
  ggplot(aes(x = reorder(Color, Qty), y = Qty, fill = Store)) + 
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  facet_wrap(~Gender)





