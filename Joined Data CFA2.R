# CSP571 Project
# Joined Data CFA
# Create: PCAEFATrain, CFASEMTrain, CFASEMTest

# Read in .csv file of joined primary and secondary data
library(lubridate)

eComBr <- read.csv('C:/Users/ginam/Documents/Gina/IIT/CSP571 2019S/Project/seller_prd_customer.csv',
                           stringsAsFactors = F,header=T)
str(eComBr)

eComBr$order_purchase_timestamp <- mdy_hm(eComBr$order_purchase_timestamp)
eComBr$order_purchase_month <- month(eComBr$order_purchase_timestamp)
eComBr$order_purchase_dayofweek <- wday(eComBr$order_purchase_timestamp,label=TRUE)

eComBr$order_approved_at <- mdy_hm(eComBr$order_approved_at)
eComBr$order_approved_at_month <- month(eComBr$order_approved_at)
eComBr$order_approved_at_dayofweek <- wday(eComBr$order_approved_at,label=TRUE)

eComBr$order_delivered_carrier_date <- mdy_hm(eComBr$order_delivered_carrier_date)
eComBr$order_delivered_carrier_month <- month(eComBr$order_delivered_carrier_date)
eComBr$order_delivered_carrier_dayofweek <- wday(eComBr$order_delivered_carrier_date,label=TRUE)

eComBr$order_delivered_customer_date <- mdy_hm(eComBr$order_delivered_customer_date)
eComBr$order_delivered_customer_month <- month(eComBr$order_delivered_customer_date)
eComBr$order_delivered_customer_dayofweek <- wday(eComBr$order_delivered_customer_date,label=TRUE)

eComBr$order_estimated_delivery_date <- mdy_hm(eComBr$order_estimated_delivery_date)
eComBr$order_estimated_delivery_month <- month(eComBr$order_estimated_delivery_date)
eComBr$order_estimated_delivery_dayofweek <- wday(eComBr$order_estimated_delivery_date,label=TRUE)

eComBr$shipping_limit_date <- mdy_hm(eComBr$shipping_limit_date)
eComBr$shipping_limit_month <- month(eComBr$shipping_limit_date)
eComBr$shipping_limit_dayofweek <- wday(eComBr$shipping_limit_date,label=TRUE)

#eComBr$order_item_id <- as.factor(eComBr$order_item_id)
eComBr$order_status <- as.factor(eComBr$order_status)
eComBr$seller_city <- as.factor(eComBr$seller_city)
eComBr$seller_state <- as.factor(eComBr$seller_state)
eComBr$product_category_name_english <- as.factor(eComBr$product_category_name_english)
eComBr$customer_city <- as.factor(eComBr$customer_city)
eComBr$customer_state <- as.factor(eComBr$customer_state)
eComBr$transaction_date <- as.factor(eComBr$transaction_date)
eComBr$transaction_year <- as.factor(eComBr$transaction_year)
eComBr$transaction_month <- as.factor(eComBr$transaction_month)
eComBr$order_purchase_month <- as.factor(eComBr$order_purchase_month)
eComBr$order_approved_at_month <- as.factor(eComBr$order_approved_at_month)
eComBr$order_delivered_carrier_month <- as.factor(eComBr$order_delivered_carrier_month)
eComBr$order_delivered_customer_month <- as.factor(eComBr$order_delivered_customer_month)
eComBr$order_estimated_delivery_month <- as.factor(eComBr$order_estimated_delivery_month)
eComBr$shipping_limit_month <- as.factor(eComBr$shipping_limit_month)
eComBr$product_photos_qty <- as.factor(eComBr$product_photos_qty)
eComBr$Bi.Weekly <- as.factor(eComBr$Bi.Weekly)

eComBr$seller_zip_code_prefix <- as.character(eComBr$seller_zip_code_prefix)
eComBr$customer_zip_code_prefix <- as.character(eComBr$customer_zip_code_prefix)
eComBr$salesTaxRate <- as.character(eComBr$salesTaxRate)

# Due to large variance problems with some variables,
# all numeric variables are divided by their standard deviation

eComBr$product_weight_kg <- eComBr$product_weight_g / 1000 


str(eComBr)


# Implement data splitting  - order data first by order_purchase_timestamp
eComBrSorted <- eComBr[order(eComBr$order_purchase_timestamp),]
eComBrSorted$order_purchase_timestamp

# PCA/EFA train = first 25%, CFA/SEM train = middle 50%, test = final 25% 
# PCA/EFA train is approximately first 25% (to about row 16136=9/7/17), 
# and CFA/SEM train ends at approximately 75% (about row 48406=4/18/18)
# Therefore:
# PCA/EFA train covers 10/3/16-8/31/17, with Aug 2017 as holdout for DV
# CFA/SEM train covers 9/1/17-3/31/18, with March 2018 as holdout for DV
# CFA/SET test covers 4/1/18-8/29/18, with Aug 2018 as holdout for DV

CFASEMtest <- subset(eComBrSorted, order_purchase_timestamp > "2018-3-31 23:59:00")
train <- subset(eComBrSorted, order_purchase_timestamp < "2018-3-31 23:59:00")
stopifnot(nrow(CFASEMtest) + nrow(train) == nrow(eComBr))

PCAEFATrain <- subset(train, order_purchase_timestamp < "2017-8-31 23:59:00")
CFASEMTrain <- subset(train, order_purchase_timestamp > "2017-8-31 23:59:00")
stopifnot(nrow(PCAEFATrain) + nrow(CFASEMTrain) == nrow(train))


# Separate all 3 dataframes into last month (name=dfname_dv)
# and other months (name=dfname_ivs)
# Dependent variable (dv) = count by product_category_name_english
# Independent variables (ivs) will be PCA components or FA factors of numeric variables

CFASEMtest_dv <- subset(CFASEMtest, order_purchase_timestamp > "2018-7-31 23:59:00")
CFASEMtest_ivs <- subset(CFASEMtest, order_purchase_timestamp < "2018-7-31 23:59:00")
stopifnot(nrow(CFASEMtest_dv) + nrow(CFASEMtest_ivs) == nrow(CFASEMtest))

PCAEFATrain_dv <- subset(PCAEFATrain, order_purchase_timestamp > "2017-7-31 23:59:00")
PCAEFATrain_ivs <- subset(PCAEFATrain, order_purchase_timestamp < "2017-7-31 23:59:00")
stopifnot(nrow(PCAEFATrain_dv) + nrow(PCAEFATrain_ivs) == nrow(PCAEFATrain))

CFASEMTrain_dv <- subset(CFASEMTrain, order_purchase_timestamp > "2018-2-28 23:59:00")
CFASEMTrain_ivs <- subset(CFASEMTrain, order_purchase_timestamp < "2018-2-28 23:59:00")
stopifnot(nrow(CFASEMTrain_dv) + nrow(CFASEMTrain_ivs) == nrow(CFASEMTrain))


# Create dependent variables (dv) = orders sold, units sold
# In _dv dataframes (which is for one month), count by product_category_name_english
# in _dv dataframes
ordersCFASEMTrain <- table(CFASEMTrain_dv$product_category_name_english)
ordersCFASEMTrain <- as.data.frame(ordersCFASEMTrain)
colnames(ordersCFASEMTrain)<-c('product_category_name_english','orders_2018_March')
head(ordersCFASEMTrain)

unitsCFASEMTrain <- aggregate(CFASEMTrain_dv$order_item_id,list(CFASEMTrain_dv$product_category_name_english),FUN=sum)
colnames(unitsCFASEMTrain)<-c('product_category_name_english','units_2018_March')
head(unitsCFASEMTrain)

ordersCFASEMtest <- table(CFASEMtest_dv$product_category_name_english)
ordersCFASEMtest <- as.data.frame(ordersCFASEMtest)
colnames(ordersCFASEMtest)<-c('product_category_name_english','orders_2018_August')
head(ordersCFASEMtest)

unitsCFASEMtest <- aggregate(CFASEMtest_dv$order_item_id,list(CFASEMtest_dv$product_category_name_english),FUN=sum)
colnames(unitsCFASEMtest)<-c('product_category_name_english','units_2018_August')
head(unitsCFASEMtest)

ordersPCAEFATrain <- table(PCAEFATrain_dv$product_category_name_english)
ordersPCAEFATrain <- as.data.frame(ordersPCAEFATrain)
colnames(ordersPCAEFATrain)<-c('product_category_name_english','orders_2017_August')
head(ordersPCAEFATrain)

unitsPCAEFATrain <- aggregate(PCAEFATrain_dv$order_item_id,list(PCAEFATrain_dv$product_category_name_english),FUN=sum)
colnames(unitsPCAEFATrain)<-c('product_category_name_english','units_2017_August')
head(unitsPCAEFATrain)

# Write train and test data frames to .csv files
#write.csv(PCAEFATrain, file = "PCAEFATrain.csv", row.names = FALSE)
#write.csv(PCAEFATrain_dv, file = "PCAEFATrain_dv.csv", row.names = FALSE)
#write.csv(PCAEFATrain_ivs, file = "PCAEFATrain_ivs.csv", row.names = FALSE)
#read.csv("PCAEFATrain.csv")
#read.csv("PCAEFATrain_dv.csv")
#read.csv("PCAEFATrain_ivs.csv")

#write.csv(CFASEMTrain, file = "CFASEMTrain.csv", row.names = FALSE)
#write.csv(CFASEMTrain_dv, file = "CFASEMTrain_dv.csv", row.names = FALSE)
#write.csv(CFASEMTrain_ivs, file = "CFASEMTrain_ivs.csv", row.names = FALSE)
#read.csv("CFASEMTrain.csv")
#read.csv("CFASEMTrain_dv.csv")
#read.csv("CFASEMTrain_ivs.csv")

#write.csv(CFASEMtest, file = "CFASEMtest.csv", row.names = FALSE)
#write.csv(CFASEMtest_dv, file = "CFASEMtest_dv.csv", row.names = FALSE)
#write.csv(CFASEMtest_ivs, file = "CFASEMtest_ivs.csv", row.names = FALSE)
#read.csv("CFASEMtest.csv")
#read.csv("CFASEMtest_dv.csv")
#read.csv("CFASEMtest_ivs.csv")


# Create CFATrainNums (only numeric attributes of CFASEMTrain)

numVars <- names(which(sapply(CFASEMTrain, is.numeric)))
catVars <- names(which(sapply(CFASEMTrain, is.factor)))
logVars <- names(which(sapply(CFASEMTrain, is.logical)))
numVars 
catVars
logVars

library(dplyr)
CFASEMTrainNums <- select(CFASEMTrain,numVars)
CFASEMTrainNums_sd <- select(CFASEMTrain,logVars)
CFASEMTrainNums_sd
CFASEMTrainNums_sd$price_sd <- CFASEMTrainNums$price / sd(CFASEMTrainNums$price)
CFASEMTrainNums_sd$freight_value_sd <- CFASEMTrainNums$freight_value / sd(CFASEMTrainNums$freight_value)
CFASEMTrainNums_sd$product_name_lenght_sd <- CFASEMTrainNums$product_name_lenght / sd(CFASEMTrainNums$product_name_lenght)
CFASEMTrainNums_sd$product_description_lenght_sd <- CFASEMTrainNums$product_description_lenght / sd(CFASEMTrainNums$product_description_lenght)
CFASEMTrainNums_sd$product_weight_g_sd <- CFASEMTrainNums$product_weight_g / sd(CFASEMTrainNums$product_weight_g)
CFASEMTrainNums_sd$product_length_cm_sd <- CFASEMTrainNums$product_length_cm / sd(CFASEMTrainNums$product_length_cm)
CFASEMTrainNums_sd$product_height_cm_sd <- CFASEMTrainNums$product_height_cm / sd(CFASEMTrainNums$product_height_cm)
CFASEMTrainNums_sd$product_width_cm_sd <- CFASEMTrainNums$product_width_cm / sd(CFASEMTrainNums$product_width_cm)
CFASEMTrainNums_sd$review_score_sd <- CFASEMTrainNums$review_score / sd(CFASEMTrainNums$review_score)
CFASEMTrainNums_sd$bankLendingRate_sd <- CFASEMTrainNums$bankLendingRate / sd(CFASEMTrainNums$bankLendingRate)
CFASEMTrainNums_sd$businessConfidence_sd <- CFASEMTrainNums$businessConfidence / sd(CFASEMTrainNums$businessConfidence)
CFASEMTrainNums_sd$carRegistrations_sd <- CFASEMTrainNums$carRegistrations / sd(CFASEMTrainNums$carRegistrations)
CFASEMTrainNums_sd$consumerConfidence_sd <- CFASEMTrainNums$consumerConfidence / sd(CFASEMTrainNums$consumerConfidence)
CFASEMTrainNums_sd$gasPrices_sd <- CFASEMTrainNums$gasPrices / sd(CFASEMTrainNums$gasPrices)
CFASEMTrainNums_sd$housingIndex_sd <- CFASEMTrainNums$housingIndex / sd(CFASEMTrainNums$housingIndex)
CFASEMTrainNums_sd$inflationRate_sd <- CFASEMTrainNums$inflationRate / sd(CFASEMTrainNums$inflationRate)
CFASEMTrainNums_sd$inflationRateMoM_sd <- CFASEMTrainNums$inflationRateMoM / sd(CFASEMTrainNums$inflationRateMoM)
CFASEMTrainNums_sd$labourCosts_sd <- CFASEMTrainNums$labourCosts / sd(CFASEMTrainNums$labourCosts)
CFASEMTrainNums_sd$minimumWages_sd <- CFASEMTrainNums$minimumWages / sd(CFASEMTrainNums$minimumWages)
CFASEMTrainNums_sd$producerPricesChange_sd <- CFASEMTrainNums$producerPricesChange / sd(CFASEMTrainNums$producerPricesChange)
CFASEMTrainNums_sd$retailSalesMoM_sd <- CFASEMTrainNums$retailSalesMoM / sd(CFASEMTrainNums$retailSalesMoM)
CFASEMTrainNums_sd$retailSalesYoY_sd <- CFASEMTrainNums$retailSalesYoY / sd(CFASEMTrainNums$retailSalesYoY)
CFASEMTrainNums_sd$smallBusinessSentiment_sd <- CFASEMTrainNums$smallBusinessSentiment / sd(CFASEMTrainNums$smallBusinessSentiment)
CFASEMTrainNums_sd$unemploymentRate_sd <- CFASEMTrainNums$unemploymentRate / sd(CFASEMTrainNums$unemploymentRate)
CFASEMTrainNums_sd$changeInInventory_sd <- CFASEMTrainNums$changeInInventory / sd(CFASEMTrainNums$changeInInventory)
CFASEMTrainNums_sd$GDPGrowthRate_sd <- CFASEMTrainNums$GDPGrowthRate / sd(CFASEMTrainNums$GDPGrowthRate)
CFASEMTrainNums_sd$householdDebt_sd <- CFASEMTrainNums$householdDebt / sd(CFASEMTrainNums$householdDebt)
CFASEMTrainNums_sd$easeOfDoingBusiness_sd <- CFASEMTrainNums$easeOfDoingBusiness / sd(CFASEMTrainNums$easeOfDoingBusiness)
CFASEMTrainNums_sd$livingWageFamily_sd <- CFASEMTrainNums$livingWageFamily / sd(CFASEMTrainNums$livingWageFamily)
CFASEMTrainNums_sd$livingWageIndividual_sd <- CFASEMTrainNums$livingWageIndividual / sd(CFASEMTrainNums$livingWageIndividual)

summary(CFASEMTrainNums_sd)
str(CFASEMTrainNums_sd)

# Confirmatory Factor Analysis on CFASEMTrainNums
library(stats)
CFASEMTrainCov <- cov(CFASEMTrainNums)
CFASEMTrainCov

#install.packages("lavaan")
library(lavaan)


CFATrainOList_sd <- select(CFASEMTrainNums_sd, c("price_sd"
                                    ,"freight_value_sd"
                                    ,"product_name_lenght_sd"
                                    ,"product_description_lenght_sd"
                                    ,"product_weight_g_sd"
                                    ,"product_length_cm_sd"
                                    ,"product_height_cm_sd"
                                    ,"product_width_cm_sd"
                                    ,"review_score_sd"
                                    ))

# following EFA
OLEFA_sd.model <- '
  OL1_sd =~ product_weight_g_sd
  OL2_sd =~ product_width_cm_sd 
  OL3_sd =~ product_height_cm_sd 
  OL4_sd =~ price_sd
' 
fit <- cfa(model = OLEFA_sd.model, data = CFATrainOList_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)

# As a single factor - This solution looks very good
OL1Factor_sd.model <- '
  OL1_sd =~ product_weight_g_sd + product_width_cm_sd +
    product_height_cm_sd + price_sd
' 
fit <- cfa(model = OL1Factor_sd.model, data = CFATrainOList_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)



CFATrainNumsSEvars1_sd <- select(CFASEMTrainNums_sd, c("bankLendingRate_sd"
                                         ,"businessConfidence_sd"
                                         ,"carRegistrations_sd"
                                         ,"consumerConfidence_sd"
                                         ,"gasPrices_sd"
                                         ,"housingIndex_sd"
                                         ,"inflationRate_sd"
                                         ,"inflationRateMoM_sd"
                                         ,"labourCosts_sd"
#                                         ,"minimumWages_sd"
#                                         ,"producerPricesChange_sd"
#                                         ,"retailSalesMoM"
#                                         ,"retailSalesYoY"
#                                         ,"smallBusinessSentiment"
#                                         ,"unemploymentRate"
#                                         ,"changeInInventory"
#                                         ,"GDPGrowthRate"
#                                         ,"householdDebt"
                                         ))

# from EFA
SEvars1_sd.model <- '
  SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd +
      housingIndex_sd + inflationRate_sd
  SEvars12_sd =~ gasPrices_sd + inflationRateMoM_sd
  SEvars13_sd =~ consumerConfidence_sd + labourCosts_sd
  SEvars14_sd =~ businessConfidence_sd
' 
fit <- cfa(model = SEvars1_sd.model, data = CFATrainNumsSEvars1_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)

# housingIndex_sd mean is very high
SEvars2_sd.model <- '
  SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd +
      housingIndex_sd/100 + inflationRate_sd
  SEvars12_sd =~ gasPrices_sd + inflationRateMoM_sd
  SEvars13_sd =~ consumerConfidence_sd + labourCosts_sd
  SEvars14_sd =~ businessConfidence_sd
' 
fit <- cfa(model = SEvars2_sd.model, data = CFATrainNumsSEvars1_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)

# delete housingIndex_sd
SEvars3_sd.model <- '
SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd +
 inflationRate_sd
SEvars12_sd =~ gasPrices_sd + inflationRateMoM_sd
SEvars13_sd =~ consumerConfidence_sd + labourCosts_sd
SEvars14_sd =~ businessConfidence_sd
' 
fit <- cfa(model = SEvars3_sd.model, data = CFATrainNumsSEvars1_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)

# delete businessConfidence_sd
SEvars4_sd.model <- '
SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd +
 inflationRate_sd
SEvars12_sd =~ gasPrices_sd + inflationRateMoM_sd
SEvars13_sd =~ consumerConfidence_sd + labourCosts_sd
' 
fit <- cfa(model = SEvars4_sd.model, data = CFATrainNumsSEvars1_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)
## Can't get model to run


CFATrainNumsSEvars2_sd <- select(CFASEMTrainNums_sd, c(##"bankLendingRate","businessConfidence",
                                          ##"carRegistrations"
                                          ## ,"consumerConfidence"
                                          ## ,"gasPrices"
                                          ## ,"housingIndex"
                                          #"inflationRate_sd"
                                          #,"inflationRateMoM_sd"
                                          ## ,"labourCosts"
                                          ## ,"minimumWages"
                                          "producerPricesChange_sd"
                                          ,"retailSalesMoM_sd"
                                          ,"retailSalesYoY_sd"
                                          ,"smallBusinessSentiment_sd"
                                          ,"unemploymentRate_sd"
                                          ,"changeInInventory_sd"
                                          ,"GDPGrowthRate_sd"
                                          ,"householdDebt_sd"
                                          ))

head(CFATrainNumsSEvars2_sd)
# from EFA
SEvars2_sd.model <- '
      SEvars21_sd =~ producerPricesChange_sd + retailSalesYoY_sd + GDPGrowthRate_sd
      SEvars22_sd =~ retailSalesMom_sd + smallBusinessSentiment_sd
      SEvars23_sd =~ changeInInventory_sd 
      SEvars24_sd =~ unemploymentRate_sd + householdDebt_sd
' 
fit <- cfa(model = SEvars2_sd.model, data = CFATrainNumsSEvars2_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
# Above model won't run

SEvars2_sd.model <- 'SEvars21_sd =~ inflationRate_sd + retailSalesYoY_sd
SEvars23_sd =~ retailSalesMoM_sd + smallBusinessSentiment_sd 
SEvars24_sd =~ changeInInventory_sd + GDPGrowthRate_sd
' 
fit <- cfa(model = SEvars2_sd.model, data = CFATrainNumsSEvars2_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
# Above model won't converge - householdDebt has very high variance relatively

SEvars2_sd.model <- 'SEvars21_sd =~ inflationRate_sd + retailSalesYoY_sd + unemploymentRate_sd
  SEvars23_sd =~ retailSalesMoM_sd + smallBusinessSentiment_sd 
  SEvars24_sd =~ changeInInventory_sd + GDPGrowthRate_sd
' 
fit <- cfa(model = SEvars2_sd.model, data = CFATrainNumsSEvars2_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)

# Try a single model with all three of splits together
allVars_sd <- select(CFASEMTrainNums_sd, c("price_sd"
                                                      ,"freight_value_sd"
                                                      ,"product_name_lenght_sd"
                                                      ,"product_description_lenght_sd"
                                                      ,"product_weight_g_sd"
                                                      ,"product_length_cm_sd"
                                                      ,"product_height_cm_sd"
                                                      ,"product_width_cm_sd"
                                                      ,"review_score_sd"
                                                      ,"bankLendingRate_sd"
                                                      ,"businessConfidence_sd"
                                                      ,"carRegistrations_sd"
                                                      ,"consumerConfidence_sd"
                                                      ,"gasPrices_sd"
                                                      ,"housingIndex_sd"
                                                      ,"inflationRate_sd"
                                                      ,"inflationRateMoM_sd"
                                                      ,"labourCosts_sd"
                                                      ,"minimumWages_sd"
                                                      ,"producerPricesChange_sd"
                                                      ,"retailSalesMoM_sd"
                                                      ,"retailSalesYoY_sd"
                                                      ,"smallBusinessSentiment_sd"
                                                      ,"unemploymentRate_sd"
                                                      ,"changeInInventory_sd"
                                                      ,"GDPGrowthRate_sd"
                                                      ,"householdDebt_sd"
                                                      ))
allVars_sd.model <- 'OL1_sd =~ freight_value_sd + product_weight_g_sd
      OL2_sd =~ product_width_cm_sd + product_length_cm_sd 
      OL3_sd =~ product_height_cm_sd + price_sd
      SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd +
            housingIndex_sd + producerPricesChange_sd
      SEvars12_sd =~ businessConfidence_sd + gasPrices_sd +consumerConfidence_sd
      SEvars21_sd =~ inflationRate_sd + retailSalesYoY_sd + unemploymentRate_sd
      SEvars23_sd =~ retailSalesMoM_sd + smallBusinessSentiment_sd 
      SEvars24_sd =~ changeInInventory_sd + GDPGrowthRate_sd
  ' 
allVars_sd1.model <- ' 
      SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd + housingIndex_sd + producerPricesChange_sd
SEvars12_sd =~ businessConfidence_sd + gasPrices_sd +consumerConfidence_sd
SEvars21_sd =~ inflationRate_sd + retailSalesYoY_sd + changeInInventory_sd + GDPGrowthRate_sd
' 
allVars_sd2.model <- ' 
      SEvars11_sd =~ bankLendingRate_sd + carRegistrations_sd + housingIndex_sd + producerPricesChange_sd
SEvars21_sd =~ inflationRate_sd + retailSalesYoY_sd + changeInInventory_sd + GDPGrowthRate_sd
' 
fit <- cfa(model = allVars_sd.model, data = allVars_sd)
summary(fit, fit.measures = TRUE, standardized = TRUE)
varTable(fit)