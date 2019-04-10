# Secondary Data: Trading Economics for Brazil

#install.packages('tidyverse')
library(tidyverse)
library(lubridate)

# Read in .csv files for 15 attributes collected each month
# For each, transform DateTime to Date, split into 'year' and 'month' attributes, 
# select only the rows for years 2016-2018, rename 3rd column as attribute name

bankLendingRate <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_bank_lending_rate.csv',
                            stringsAsFactors = F, sep = ';', header=T)
bankLendingRate$DateTime <- as.Date(bankLendingRate$DateTime)
bankLendingRate$year <- year(bankLendingRate$DateTime)
bankLendingRate$month <- month(bankLendingRate$DateTime)
bankLendingRate571 <- subset(bankLendingRate, year > 2015, select=c(year,month,Value))
colnames(bankLendingRate571)<-c('year','month','bankLendingRate')
bankLendingRate571


businessConfidence <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_business_confidence.csv',  
                               stringsAsFactors = F, header=T)
businessConfidence$DateTime <- as.Date(businessConfidence$DateTime)
businessConfidence$year <- year(businessConfidence$DateTime)
businessConfidence$month <- month(businessConfidence$DateTime)
businessConfidence571 <- subset(businessConfidence, year > 2015, select=c(year,month,Value))
colnames(businessConfidence571)<-c('year','month','businessConfidence')
businessConfidence571


carRegistrations <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_car_registrations.csv',  
                             stringsAsFactors = F, sep = ';',header=T)
carRegistrations$DateTime <- as.Date(carRegistrations$DateTime)
carRegistrations$year <- year(carRegistrations$DateTime)
carRegistrations$month <- month(carRegistrations$DateTime)
carRegistrations571 <- subset(carRegistrations, year > 2015, select=c(year,month,Value))
colnames(carRegistrations571)<-c('year','month','carRegistrations')
carRegistrations571


consumerConfidence <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_consumer_confidence.csv',  
                               stringsAsFactors = F,  header=T)
consumerConfidence$DateTime <- as.Date(consumerConfidence$DateTime)
consumerConfidence$year <- year(consumerConfidence$DateTime)
consumerConfidence$month <- month(consumerConfidence$DateTime)
consumerConfidence571 <- subset(consumerConfidence, year > 2015, select=c(year,month,Value))
colnames(consumerConfidence571)<-c('year','month','consumerConfidence')
consumerConfidence571


gasPrices <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_gasoline_prices.csv',  
                      stringsAsFactors = F, sep = ';', header=T)

gasPrices$DateTime <- as.Date(gasPrices$DateTime)
gasPrices$year <- year(gasPrices$DateTime)
gasPrices$month <- month(gasPrices$DateTime)
gasPrices571 <- subset(gasPrices, year > 2015, select=c(year,month,Value))
colnames(gasPrices571)<-c('year','month','gasPrices')
gasPrices571


housingIndex <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_housing_index.csv',  
                         stringsAsFactors = F, sep = ';', header=T)
housingIndex$DateTime <- as.Date(housingIndex$DateTime)
housingIndex$year <- year(housingIndex$DateTime)
housingIndex$month <- month(housingIndex$DateTime)
housingIndex571 <- subset(housingIndex, year > 2015, select=c(year,month,Value))
colnames(housingIndex571)<-c('year','month','housingIndex')
housingIndex571


inflationRate <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_inflation_rate.csv',  
                          stringsAsFactors = F, sep = ';', header=T)
inflationRate$DateTime <- as.Date(inflationRate$DateTime)
inflationRate$year <- year(inflationRate$DateTime)
inflationRate$month <- month(inflationRate$DateTime)
inflationRate571 <- subset(inflationRate, year > 2015, select=c(year,month,Value))
colnames(inflationRate571)<-c('year','month','inflationRate')
inflationRate571


inflationRateMoM <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_inflation_rate_mom.csv',  
                             stringsAsFactors = F, sep = ';', header=T)
inflationRateMoM$DateTime <- as.Date(inflationRateMoM$DateTime)
inflationRateMoM$year <- year(inflationRateMoM$DateTime)
inflationRateMoM$month <- month(inflationRateMoM$DateTime)
inflationRateMoM571 <- subset(inflationRateMoM, year > 2015, select=c(year,month,Value))
colnames(inflationRateMoM571)<-c('year','month','inflationRateMoM')
inflationRateMoM571


labourCosts <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_labour_costs.csv',  
                        stringsAsFactors = F, sep = ';', header=T)
labourCosts$DateTime <- as.Date(labourCosts$DateTime)
labourCosts$year <- year(labourCosts$DateTime)
labourCosts$month <- month(labourCosts$DateTime)
labourCosts571 <- subset(labourCosts, year > 2015, select=c(year,month,Value))
colnames(labourCosts571)<-c('year','month','labourCosts')
labourCosts571

minimumWages <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_minimum_wages.csv',  
                         stringsAsFactors = F, sep = ';', header=T)
minimumWages$DateTime <- as.Date(minimumWages$DateTime)
minimumWages$year <- year(minimumWages$DateTime)
minimumWages$month <- month(minimumWages$DateTime)
minimumWages571 <- subset(minimumWages, year > 2015, select=c(year,month,Value))
colnames(minimumWages571)<-c('year','month','minimumWages')
minimumWages571

producerPricesChange <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_producer_prices_change.csv',  
                                 stringsAsFactors = F, sep = ';', header=T)
producerPricesChange$DateTime <- as.Date(producerPricesChange$DateTime)
producerPricesChange$year <- year(producerPricesChange$DateTime)
producerPricesChange$month <- month(producerPricesChange$DateTime)
producerPricesChange571 <- subset(producerPricesChange, year > 2015, select=c(year,month,Value))
colnames(producerPricesChange571)<-c('year','month','producerPricesChange')
producerPricesChange571

retailSalesMoM <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_retail_sales_mom.csv',  
                           stringsAsFactors = F, sep = ';', header=T)
retailSalesMoM$DateTime <- as.Date(retailSalesMoM$DateTime)
retailSalesMoM$year <- year(retailSalesMoM$DateTime)
retailSalesMoM$month <- month(retailSalesMoM$DateTime)
retailSalesMoM571 <- subset(retailSalesMoM, year > 2015, select=c(year,month,Value))
colnames(retailSalesMoM571)<-c('year','month','retailSalesMoM')
retailSalesMoM571

retailSalesYoY <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_retail_sales_yoy.csv',  
                           stringsAsFactors = F, sep = ';', header=T)
retailSalesYoY$DateTime <- as.Date(retailSalesYoY$DateTime)
retailSalesYoY$year <- year(retailSalesYoY$DateTime)
retailSalesYoY$month <- month(retailSalesYoY$DateTime)
retailSalesYoY571 <- subset(retailSalesYoY, year > 2015, select=c(year,month,Value))
colnames(retailSalesYoY571)<-c('year','month','retailSalesYoY')
retailSalesYoY571

smallBusinessSentiment <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_small_business_sentiment.csv',  
                                   stringsAsFactors = F, sep = ';', header=T)
smallBusinessSentiment$DateTime <- as.Date(smallBusinessSentiment$DateTime)
smallBusinessSentiment$year <- year(smallBusinessSentiment$DateTime)
smallBusinessSentiment$month <- month(smallBusinessSentiment$DateTime)
smallBusinessSentiment571 <- subset(smallBusinessSentiment, year > 2015, select=c(year,month,Value))
colnames(smallBusinessSentiment571)<-c('year','month','smallBusinessSentiment')
smallBusinessSentiment571

unemploymentRate <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/monthly metrics/historical_country_brazil_indicator_unemployment_rate.csv',  
                             stringsAsFactors = F, sep = ';', header=T)
unemploymentRate$DateTime <- as.Date(unemploymentRate$DateTime)
unemploymentRate$year <- year(unemploymentRate$DateTime)
unemploymentRate$month <- month(unemploymentRate$DateTime)
unemploymentRate571 <- subset(unemploymentRate, year > 2015, select=c(year,month,Value))
colnames(unemploymentRate571)<-c('year','month','unemploymentRate')
unemploymentRate571

# join the monthly-reported attributes into a single dataframe
byMonth <- merge(bankLendingRate571,businessConfidence571)
byMonth <- merge(byMonth,carRegistrations571)
byMonth <- merge(byMonth,consumerConfidence571)
byMonth <- merge(byMonth,gasPrices571)
byMonth <- merge(byMonth,housingIndex571)
byMonth <- merge(byMonth,inflationRate571)
byMonth <- merge(byMonth,inflationRateMoM571)
byMonth <- merge(byMonth,labourCosts571)
byMonth <- merge(byMonth,minimumWages571)
byMonth <- merge(byMonth,producerPricesChange571)
byMonth <- merge(byMonth,retailSalesMoM571)
byMonth <- merge(byMonth,retailSalesYoY571)
byMonth <- merge(byMonth,smallBusinessSentiment571)
byMonth <- merge(byMonth,unemploymentRate571)

summary(byMonth)
byMonth



#quarterly
# Read in .csv files for 3 attributes collected each quarter
# For each, transform DateTime to Date, split into 'year' and 'month' attributes, 
# select only the rows for years 2016-2018, rename 3rd column as attribute name
changeInInventory <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/quarterly metrics/historical_country_brazil_indicator_changes_in_inventories.csv',  
                              stringsAsFactors = F, sep = ';', header=T)
changeInInventory$DateTime <- as.Date(changeInInventory$DateTime)
changeInInventory$year <- year(changeInInventory$DateTime)
changeInInventory$month <- month(changeInInventory$DateTime)
changeInInventory571 <- subset(changeInInventory, year > 2015, select=c(year,month,Value))
colnames(changeInInventory571)<-c('year','month','changeInInventory')
changeInInventory571


#quarterly
GDPGrowthRate <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/quarterly metrics/historical_country_brazil_indicator_gdp_growth_rate.csv',  
                          stringsAsFactors = F, sep = ';', header=T)
GDPGrowthRate$DateTime <- as.Date(GDPGrowthRate$DateTime)
GDPGrowthRate$year <- year(GDPGrowthRate$DateTime)
GDPGrowthRate$month <- month(GDPGrowthRate$DateTime)
GDPGrowthRate571 <- subset(GDPGrowthRate, year > 2015, select=c(year,month,Value))
colnames(GDPGrowthRate571)<-c('year','month','GDPGrowthRate')
GDPGrowthRate571


#quarterly
# householdDebt does not report 4Q2018, so 3Q2018 repeated for 4Q2018
householdDebt <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/quarterly metrics/historical_country_brazil_indicator_households_debt_to_gdp.csv',  
                          stringsAsFactors = F, sep = ';', header=T)
householdDebt$DateTime <- as.Date(householdDebt$DateTime)
householdDebt$year <- year(householdDebt$DateTime)
householdDebt$month <- month(householdDebt$DateTime)
householdDebt571 <- subset(householdDebt, year > 2015, select=c(year,month,Value))
colnames(householdDebt571)<-c('year','month','householdDebt')
householdDebt571



# join the quarterly-reported attributes into a single dataframe
byQuarter <- merge(changeInInventory571,GDPGrowthRate571)
byQuarter <- merge(byQuarter,householdDebt571)
byQuarter <- byQuarter[do.call(order,byQuarter),]
byQuarter

# repeat each row 3 times and replace the month with 1 through 12 for each year
byQuarter <- byQuarter[rep(1:nrow(byQuarter),each=3),] 
byQuarter$month <- c(rep(1:12,len=36)) 
byQuarter




#annual
# Read in .csv files for 5 attributes collected each year
# For each, transform DateTime to Date, split into 'year' and 'month' attributes, 
# select only the rows for years 2016-2018, rename 3rd column as attribute name
easeOfDoingBusiness <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/annual metrics/historical_country_brazil_indicator_ease_of_doing_business.csv',  
                                stringsAsFactors = F, sep = ';', header=T)
easeOfDoingBusiness$DateTime <- as.Date(easeOfDoingBusiness$DateTime)
easeOfDoingBusiness$year <- year(easeOfDoingBusiness$DateTime)
easeOfDoingBusiness$month <- month(easeOfDoingBusiness$DateTime)
easeOfDoingBusiness571 <- subset(easeOfDoingBusiness, year > 2015, select=c(year,month,Value))
colnames(easeOfDoingBusiness571)<-c('year','month','easeOfDoingBusiness')
easeOfDoingBusiness571


#annual
livingWageFamily <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/annual metrics/historical_country_brazil_indicator_living_wage_family.csv',  
                             stringsAsFactors = F, sep = ';', header=T)
livingWageFamily$DateTime <- as.Date(livingWageFamily$DateTime)
livingWageFamily$year <- year(livingWageFamily$DateTime)
livingWageFamily$month <- month(livingWageFamily$DateTime)
livingWageFamily571 <- subset(livingWageFamily, year > 2015, select=c(year,month,Value))
colnames(livingWageFamily571)<-c('year','month','livingWageFamily')
livingWageFamily571

#annual
livingWageIndividual <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/annual metrics/historical_country_brazil_indicator_living_wage_individual.csv',  
                                 stringsAsFactors = F, sep = ';', header=T)
livingWageIndividual$DateTime <- as.Date(livingWageIndividual$DateTime)
livingWageIndividual$year <- year(livingWageIndividual$DateTime)
livingWageIndividual$month <- month(livingWageIndividual$DateTime)
livingWageIndividual571 <- subset(livingWageIndividual, year > 2015, select=c(year,month,Value))
colnames(livingWageIndividual571)<-c('year','month','livingWageIndividual')
livingWageIndividual571

#annual
population <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/annual metrics/historical_country_brazil_indicator_population.csv',  
                       stringsAsFactors = F, sep = ';', header=T)
population$DateTime <- as.Date(population$DateTime)
population$year <- year(population$DateTime)
population$month <- month(population$DateTime)
population571 <- subset(population, year > 2015, select=c(year,month,Value))
colnames(population571)<-c('year','month','population')
population571 #no 2018 data

#annual
salesTaxRate <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/Brazil Trading Economics Data/annual metrics/historical_country_brazil_indicator_sales_tax_rate.csv',  
                         stringsAsFactors = F, sep = ';', header=T)
salesTaxRate$DateTime <- as.Date(salesTaxRate$DateTime)
salesTaxRate$year <- year(salesTaxRate$DateTime)
salesTaxRate$month <- month(salesTaxRate$DateTime)
salesTaxRate571 <- subset(salesTaxRate, year > 2015, select=c(year,month,Value))
colnames(salesTaxRate571)<-c('year','month','salesTaxRate')
salesTaxRate571

# join the annually-reported attributes into a single dataframe
byYear <- merge(easeOfDoingBusiness571,livingWageFamily571)
byYear <- merge(byYear,livingWageIndividual571)
#byYear <- merge(byYear,population571) #no 2018 data
byYear <- merge(byYear,salesTaxRate571)
byYear

# repeat each row 12 times and replace the month with 1 through 12 for each of 3 years
byYear <- byYear[rep(1:nrow(byYear),each=12),] 
byYear$month <- c(rep(1:12,3))
byYear


# merge all 3 "by..." dataframes
brazilEcon <- merge(byMonth,byQuarter,by=c('year','month'),sort=TRUE)
brazilEcon <- brazilEcon[do.call(order,brazilEcon),]

# used cbind because merge wouldn't work
brazilEcon <- cbind.data.frame(brazilEcon,byYear)

# deleted extra 'year' and 'month' columns from cbind
brazilEcon <- subset(brazilEcon, select = -c(21, 22))
dim(brazilEcon)
summary(brazilEcon)
str(brazilEcon)
brazilEcon

# Write brazilEcon data frame to .csv file
write.csv(brazilEcon, file = "FeatureEng/brazilEcon.csv", row.names = FALSE)

read.csv("brazilEcon.csv")
