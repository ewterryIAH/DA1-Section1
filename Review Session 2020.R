library(lubridate)
library(tidyverse)
library(stringr)

setwd("C:/Users/ellen/Documents/UH/Spring 2020/DA1/Section 1")




LondonSales <- read_csv("C:/Users/ellen/Documents/UH/Fall 2019/DA1/Section1/Practice Exam/LondonSales.csv")

LondonSales <- rename(LondonSales, Product Name = ProductName) 

# whats wrong here?

LondonSales <- rename(LondonSales, "Product Name" = ProductName) 


LondonSales$`Product Name`

# now what does the column look like?

LondonSales$`Product Name` # what are those back tics? Why?

# put it back

LondonSales <- rename(LondonSales, ProductName = "Product Name") # now what does the column look like?
# back tics have more "power" than quotes - they can deal with special characters 


# why do we do this?

LondonSales = LondonSales %>% inner_join(LondonSales, by = "ProductID")

# what did R do?

# OR

Product  <- dbGetQuery(con1,"
SELECT
[SalesLT].[Product].[ProductID]
,[SalesLT].[Product].[ProductCategoryID]
,[SalesLT].[Product].[Name]
FROM 
[SalesLT].[Product]                               
                               ")

ProductCategory  <- dbGetQuery(con1,"
SELECT
[SalesLT].[ProductCategory].[ProductCategoryID]
,[SalesLT].[ProductCategory].[Name]
FROM 
[SalesLT].[ProductCategory]                               
                               ")


Product = Product %>% inner_join(ProductCategory, by = "ProductCategoryID")


# this will create weeeeiiiiird problems in SQL:

ProductCategory  <- dbGetQuery(con1,"
SELECT 
[SalesLT].[Product].[ProductID]
,[SalesLT].[Product].[Name]
,[SalesLT].[ProductCategory].[Name]
FROM
[SalesLT].[Product]
INNER JOIN
[SalesLT].[ProductCategory]
ON
[SalesLT].[Product].[ProductCategoryID] = [SalesLT].[ProductCategory].[ProductCategoryID]
")

str(ProductCategory)
colnames(ProductCategory)

# this is buggy, but its your problem now - this is fubar
# best way to get out of this


ProductCategory = tibble(ProductID = ProductCategory[,1], ProductName = ProductCategory[,2], CategoryName = ProductCategory[,3])
warnings()


ProductCategory = ProductCategory %>% inner_join(ProductCategory, by = "ProductID")

# keep all this in mind and PLAN AHEAD.


# strings

# str_sub 14.4.2
# stringr cheatsheet
#negative numbers count backwards from end
#str_sub(x, -3, -1)

# str_sub(UnitPrice, End of the string (so it's a negative number), back 5 from the end(so it's a negative number))

LondonSales <- read_csv("C:/Users/ellen/Documents/UH/Fall 2019/DA1/Section1/Practice Exam/LondonSales.csv")


tstStr <- LondonSales$UnitPrice[1]

str_sub(tstStr, 1, 6)

tstStr2 <- LondonSales$UnitPrice[8]
str_sub(tstStr2, 1, 6)

tstStr <- LondonSales$UnitPrice[1]
str_sub(tstStr, -10, -5)

tstStr2 <- LondonSales$UnitPrice[8]
str_sub(tstStr2, -10, -5)

# so you really want:


str_sub(tstStr2, -str_length(tstStr2), -5)


str_sub(tstStr, -str_length(tstStr), -5)
str_sub(tstStr2, -str_length(tstStr2), -5)


?str_replace

str_replace(tstStr, "USD", "")
str_replace(tstStr2, "USD", "")

as.numeric(str_replace(tstStr, "USD", ""))



LondonSales$UnitPrice <- as.numeric(str_sub(LondonSales$UnitPrice, -str_length(LondonSales$UnitPrice), -5))


LondonSales$ProductID <- as.integer(LondonSales$ProductID)


# strings to dates

mdy("10/5/2019")

datestring <- "Oct 19"

mdy(datestring) # ??? not enough info

datestring2 <- "Oct 2019"

mdy(datestring2) # the hueristic is guessing here - probably not what you want

mdy(str_c(str_sub(datestring2, 1, 3), "01",  str_sub(datestring2, 5, 8)))



tst <- data.frame(Sdate = c("Oct-19", "Oct-20"))

mdy(tst$Sdate)

tst$Sdate2 <- mdy(str_c(str_sub(tst$Sdate, 1, 3), "-01-20", str_sub(tst$Sdate, 5, 6)))

tst2 <- data.frame(Sdate = "2019-10-19")

tst2$Sdate <- ymd(tst2$Sdate)






make_date(2019, 10, 1)

# dokyr transformations

TopSales <- LondonSales %>% group_by(ProductID)%>% 
  summarise(TotalSales = sum(OrderQty * UnitPrice )) %>%
  top_n(TotalSales, n = 10) %>%
  arrange(desc(TotalSales)) 


TopSales$NewSales <- TopSales$TotalSales * 2
TopSales2 <- data.frame(ProductID = 1, TotalSales = NA, NewSales = 5)
TopSales2 <- bind_rows(TopSales2, data.frame(ProductID = 1, TotalSales = 5, NewSales = NA))
TopSales2 <- bind_rows(TopSales2, data.frame(ProductID = 1, TotalSales = NA, NewSales = NA))
TopSales <- bind_rows(TopSales, TopSales2)

data.frame(filter(TopSales, TotalSales > 0 ) )

# this will exclude NAs but what happens if you need neg numbers.... 

data.frame(filter(TopSales, !TotalSales > 0 ))

data.frame(filter(TopSales, is.na(TotalSales))) 

data.frame(filter(TopSales, !is.na(TotalSales) | !is.na(NewSales))) 
data.frame(filter(TopSales, !is.na(TotalSales) & !is.na(NewSales))) 

t1 <- filter(TopSales, !is.na(TotalSales) & !is.na(NewSales))

data.frame(filter(TopSales, NewSales > 0 ))
data.frame(filter(TopSales, TotalSales > 0  & NewSales > 0 ))
data.frame(filter(TopSales, TotalSales > 0  | NewSales > 0 ))

data.frame(filter(TopSales, is.na(TotalSales) | is.na(NewSales)))
data.frame(filter(TopSales, is.na(TotalSales) & is.na(NewSales)))
data.frame(sum(TopSales$TotalSales))
data.frame(sum(TopSales$TotalSales, na.rm = T))

ProductDescriptions <- dbGetQuery(con1,"
SELECT  [SalesLT].[Product].[ProductID]
    ,[SalesLT].[Product].[ProductNumber]
		,[SalesLT].[ProductModelProductDescription].[Culture]
		,[SalesLT].[ProductDescription].[Description]
  FROM [SalesLT].[Product]
  INNER JOIN [SalesLT].[ProductModelProductDescription]
  ON [SalesLT].[Product].[ProductModelID] = 
  [SalesLT].[ProductModelProductDescription].[ProductModelID]
  INNER JOIN [SalesLT].[ProductDescription]
  ON [SalesLT].[ProductModelProductDescription].[ProductDescriptionID] = 
  [SalesLT].[ProductDescription].[ProductDescriptionID]
  WHERE TRIM([SalesLT].[ProductModelProductDescription].[Culture]) = 'fr'
                         ")  

str_length(ProductDescriptions$Culture)

nrow(filter(ProductDescriptions, Culture == "fr    "))

nrow(filter(ProductDescriptions, Culture == "fr"))


ProductDescriptions$Culture <-  str_trim(ProductDescriptions$Culture, side = c("both"))
ProductDescriptions <- filter(ProductDescriptions, Culture == "fr")


# LEFT JOINS and GROUP BYs

CitySales <- dbGetQuery(con1," 

SELECT

   [SalesLT].[Address].[City]
  ,sum([SalesLT].[SalesOrderHeader].[SubTotal]) AS Total

FROM [SalesLT].[Address]

  INNER JOIN [SalesLT].[CustomerAddress]
  ON [SalesLT].[Address].[AddressID] = 
  [SalesLT].[CustomerAddress].[AddressID]

  INNER JOIN [SalesLT].[SalesOrderHeader]
  ON [SalesLT].[CustomerAddress].[CustomerID] = 
  [SalesLT].[SalesOrderHeader].[CustomerID]

GROUP BY 

  [SalesLT].[Address].[City]

")


sum(CitySales$Total)

CitySales2 <- dbGetQuery(con1," 

SELECT

   [SalesLT].[Address].[City]
  ,sum([SalesLT].[SalesOrderHeader].[SubTotal]) AS Total

FROM [SalesLT].[Address]

  INNER JOIN [SalesLT].[CustomerAddress]
  ON [SalesLT].[Address].[AddressID] = 
  [SalesLT].[CustomerAddress].[AddressID]

  LEFT JOIN [SalesLT].[SalesOrderHeader]
  ON [SalesLT].[CustomerAddress].[CustomerID] = 
  [SalesLT].[SalesOrderHeader].[CustomerID]

GROUP BY 

  [SalesLT].[Address].[City]

")
                        
sum(CitySales2$Total, na.rm = T)


CitySales3 <- dbGetQuery(con1," 

SELECT

   [SalesLT].[Address].[City]
  ,sum([SalesLT].[SalesOrderHeader].[SubTotal]) AS Total

FROM [SalesLT].[Address]

  LEFT JOIN [SalesLT].[CustomerAddress]
  ON [SalesLT].[Address].[AddressID] = 
  [SalesLT].[CustomerAddress].[AddressID]

  LEFT JOIN [SalesLT].[SalesOrderHeader]
  ON [SalesLT].[CustomerAddress].[CustomerID] = 
  [SalesLT].[SalesOrderHeader].[CustomerID]

GROUP BY 

  [SalesLT].[Address].[City]

")

sum(CitySales3$Total, na.rm = T)


# ================== pivots ====================#




CustomerSales <- dbGetQuery(con1," 
SELECT
[SalesLT].[SalesOrderHeader].[OrderDate]
,[SalesLT].[SalesOrderHeader].[SubTotal]
,[SalesLT].[Customer].[CompanyName]
FROM 
[SalesLT].[SalesOrderHeader]
INNER JOIN
[SalesLT].[Customer]
ON
[SalesLT].[SalesOrderHeader].[CustomerID] =  [SalesLT].[Customer].[CustomerID]
")


write_csv(CustomerSales, "CustomerSales.csv")

CustomerSales  = CustomerSales %>% arrange(CompanyName)
SalesByDate = CustomerSales %>% pivot_wider(names_from = CompanyName, values_from = SubTotal)

write_csv(SalesByDate, "SalesByDate.csv")

?pivot_longer

CustomerSales2 = SalesByDate %>% pivot_longer(
  2:ncol(SalesByDate), 
  names_to = "CompanyName", 
  values_to = "SubTotal", 
  values_drop_na = T )


