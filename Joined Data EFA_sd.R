# CSP571 Project
# Joined Data CFA
# Create: PCAEFATrain, CFASEMTrain, CFASEMTest

# Run EFA on numeric variables standardized by dividing by SD

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

#eComBr$product_weight_kg <- eComBr$product_weight_g / 1000 

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


# Create EFATrainNums (only numeric attributes of PCAEFATrain)

numVars <- names(which(sapply(PCAEFATrain, is.numeric)))
catVars <- names(which(sapply(PCAEFATrain, is.factor)))
logVars <- names(which(sapply(PCAEFATrain, is.logical)))
numVars 
catVars
logVars

library(dplyr)
EFATrainNums <- select(PCAEFATrain,numVars)

# Due to large variance problems with some variables,
# all numeric variables are divided by their standard deviation

EFATrainNums_sd <- select(PCAEFATrain,logVars)
EFATrainNums_sd
EFATrainNums_sd$price_sd <- EFATrainNums$price / sd(EFATrainNums$price)
EFATrainNums_sd$freight_value_sd <- EFATrainNums$freight_value / sd(EFATrainNums$freight_value)
EFATrainNums_sd$product_name_lenght_sd <- EFATrainNums$product_name_lenght / sd(EFATrainNums$product_name_lenght)
EFATrainNums_sd$product_description_lenght_sd <- EFATrainNums$product_description_lenght / sd(EFATrainNums$product_description_lenght)
EFATrainNums_sd$product_weight_g_sd <- EFATrainNums$product_weight_g / sd(EFATrainNums$product_weight_g)
EFATrainNums_sd$product_length_cm_sd <- EFATrainNums$product_length_cm / sd(EFATrainNums$product_length_cm)
EFATrainNums_sd$product_height_cm_sd <- EFATrainNums$product_height_cm / sd(EFATrainNums$product_height_cm)
EFATrainNums_sd$product_width_cm_sd <- EFATrainNums$product_width_cm / sd(EFATrainNums$product_width_cm)
EFATrainNums_sd$review_score_sd <- EFATrainNums$review_score / sd(EFATrainNums$review_score)
EFATrainNums_sd$bankLendingRate_sd <- EFATrainNums$bankLendingRate / sd(EFATrainNums$bankLendingRate)
EFATrainNums_sd$businessConfidence_sd <- EFATrainNums$businessConfidence / sd(EFATrainNums$businessConfidence)
EFATrainNums_sd$carRegistrations_sd <- EFATrainNums$carRegistrations / sd(EFATrainNums$carRegistrations)
EFATrainNums_sd$consumerConfidence_sd <- EFATrainNums$consumerConfidence / sd(EFATrainNums$consumerConfidence)
EFATrainNums_sd$gasPrices_sd <- EFATrainNums$gasPrices / sd(EFATrainNums$gasPrices)
EFATrainNums_sd$housingIndex_sd <- EFATrainNums$housingIndex / sd(EFATrainNums$housingIndex)
EFATrainNums_sd$inflationRate_sd <- EFATrainNums$inflationRate / sd(EFATrainNums$inflationRate)
EFATrainNums_sd$inflationRateMoM_sd <- EFATrainNums$inflationRateMoM / sd(EFATrainNums$inflationRateMoM)
EFATrainNums_sd$labourCosts_sd <- EFATrainNums$labourCosts / sd(EFATrainNums$labourCosts)
EFATrainNums_sd$minimumWages_sd <- EFATrainNums$minimumWages / sd(EFATrainNums$minimumWages)
EFATrainNums_sd$producerPricesChange_sd <- EFATrainNums$producerPricesChange / sd(EFATrainNums$producerPricesChange)
EFATrainNums_sd$retailSalesMoM_sd <- EFATrainNums$retailSalesMoM / sd(EFATrainNums$retailSalesMoM)
EFATrainNums_sd$retailSalesYoY_sd <- EFATrainNums$retailSalesYoY / sd(EFATrainNums$retailSalesYoY)
EFATrainNums_sd$smallBusinessSentiment_sd <- EFATrainNums$smallBusinessSentiment / sd(EFATrainNums$smallBusinessSentiment)
EFATrainNums_sd$unemploymentRate_sd <- EFATrainNums$unemploymentRate / sd(EFATrainNums$unemploymentRate)
EFATrainNums_sd$changeInInventory_sd <- EFATrainNums$changeInInventory / sd(EFATrainNums$changeInInventory)
EFATrainNums_sd$GDPGrowthRate_sd <- EFATrainNums$GDPGrowthRate / sd(EFATrainNums$GDPGrowthRate)
EFATrainNums_sd$householdDebt_sd <- EFATrainNums$householdDebt / sd(EFATrainNums$householdDebt)
EFATrainNums_sd$easeOfDoingBusiness_sd <- EFATrainNums$easeOfDoingBusiness / sd(EFATrainNums$easeOfDoingBusiness)
EFATrainNums_sd$livingWageFamily_sd <- EFATrainNums$livingWageFamily / sd(EFATrainNums$livingWageFamily)
EFATrainNums_sd$livingWageIndividual_sd <- EFATrainNums$livingWageIndividual / sd(EFATrainNums$livingWageIndividual)

summary(EFATrainNums_sd)
str(EFATrainNums_sd)

# Exploratory Factor Analysis on EFATrainNums
library(stats)
EFATrainCov_sd <- cov(EFATrainNums_sd)
EFATrainCov_sd
#plot(EFATrainCov_sd)
#install.packages("psych")
library(psych)
#fa.parallel(EFATrainCov_sd,n.obs=27214,fm="ml",fa="both",nfactors = 1,
#            main="Parallel Analysis Scree Plots for EFATrain", n.iter=100)

fa.parallel(EFATrainNums_sd,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=100)
#Won't run, so segment into SocioEconomic variables and OList variables

# OList variables
EFATrainOList_sd <- select(EFATrainNums_sd, c("price_sd"
                                    ,"freight_value_sd"
                                    ,"product_name_lenght_sd"
                                    ,"product_description_lenght_sd"
                                    ,"product_weight_g_sd"
                                    ,"product_length_cm_sd"
                                    ,"product_height_cm_sd"
                                    ,"product_width_cm_sd"
                                    ,"review_score_sd"
                                    ))
# Identify number of factors
fa.parallel(EFATrainOList_sd,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrainOList", n.iter=100)
## 4 factors suggested

#Run EFA on OList_sd numeric variables
faOList_sd <- fa(EFATrainOList_sd, nfactors=4,rotate = "none",fm="ml")
faOList_sd

# Try rotating for better factors - orthogonal
faOListVarimax_sd <- fa(EFATrainOList_sd, nfactors=4,rotate = "varimax",fm="ml")
faOListVarimax_sd


# Try rotating for better factors - oblique
#install.packages("GPArotation")
library(GPArotation)
faOListPromax_sd <- fa(EFATrainOList_sd, nfactors=4,rotate = "promax",fm="ml")
faOListPromax_sd
## Bad result: loading > abs(1). Don't use

# CONCLUSION: Use orthogonal rotation.
# Each factor has one significantly-loading variable,
# which is not a factor structure 
## Standardized loadings (pattern matrix) based upon correlation matrix
##                                ML3   ML2   ML1   ML4     h2    u2 com
## price_sd                       0.24  0.11 -0.01  0.71 0.5722 0.428 1.3
## freight_value_sd               0.57  0.15  0.15  0.25 0.4276 0.572 1.7
## product_name_lenght_sd         0.02  0.15 -0.04 -0.03 0.0251 0.975 1.3
## product_description_lenght_sd  0.06 -0.13  0.10  0.24 0.0887 0.911 2.1
## product_weight_g_sd            0.88  0.26  0.28  0.00 0.9180 0.082 1.4
## product_length_cm_sd           0.29  0.49  0.07 -0.06 0.3299 0.670 1.7
## product_height_cm_sd           0.37  0.02  0.91  0.20 0.9950 0.005 1.4
## product_width_cm_sd            0.19  0.96  0.19  0.00 0.9950 0.005 1.2
## review_score_sd               -0.02 -0.01  0.01  0.03 0.0013 0.999 2.2

##                        ML3  ML2  ML1  ML4
## SS loadings           1.41 1.30 0.98 0.67
## Proportion Var        0.16 0.14 0.11 0.07
## Cumulative Var        0.16 0.30 0.41 0.48
## Proportion Explained  0.32 0.30 0.22 0.15
## Cumulative Proportion 0.32 0.62 0.85 1.00


# SocioEconomic Variables - tried as a group, but won't run, so split into 2 groups
EFATrainNumsSEvars1_sd <- select(EFATrainNums_sd, c("bankLendingRate_sd"
                                        ,"businessConfidence_sd"
                                        ,"carRegistrations_sd"
                                        ,"consumerConfidence_sd"
                                        ,"gasPrices_sd"
                                        ,"housingIndex_sd"
                                        ,"inflationRate_sd"
                                        ,"inflationRateMoM_sd"
                                        ,"labourCosts_sd"
                                        #,"minimumWages_sd"
                                        #,"producerPricesChange_sd"
                                        #,"retailSalesMoM_sd"
                                        #,"retailSalesYoY_sd"
                                        #,"smallBusinessSentiment_sd"
                                        #,"unemploymentRate_sd"
                                        #,"changeInInventory_sd"
                                        #,"GDPGrowthRate_sd"
                                        #,"householdDebt_sd"
                                         ))
# Identify number of factors in SEVars1_sd
fa.parallel(EFATrainNumsSEvars1_sd,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrainNumsSEvars1_SD", n.iter=100)
## 4 factors suggested

#Run EFA on SEVars1_sd numeric variables
faSEVars1_sd <- fa(EFATrainNumsSEvars1_sd, nfactors=4,rotate = "none",fm="ml")
faSEVars1_sd

# Try rotating for better factors - orthogonal
faSEVars1Varimax_sd <- fa(EFATrainNumsSEvars1_sd, nfactors=4,rotate = "varimax",fm="ml")
faSEVars1Varimax_sd


# Try rotating for better factors - oblique
#install.packages("GPArotation")
library(GPArotation)
faSEVars1Promax_sd <- fa(EFATrainNumsSEvars1_sd, nfactors=4,rotate = "promax",fm="ml")
faSEVars1Promax_sd
## Bad result: loading > abs(1). Don't use. Use orthogonal rotation

# CONCLUSION: 
# 1st (ML3): bankLendingRate_sd, -carRegistrations_sd, housingIndex_sd, inflationRate_sd
# 2nd (ML1): gasPrices_sd, inflationRateMoM_sd
# 3rd (ML4): consumerConfidence_sd, labourCosts_sd
# 4th (ML2): businessConfidence_sd

## Standardized loadings (pattern matrix) based upon correlation matrix
##                        ML3   ML1   ML4   ML2   h2     u2 com
## bankLendingRate_sd     0.73  0.17  0.63  0.12 0.97 0.0257 2.1
## businessConfidence_sd  0.10  0.00  0.21  0.97 1.00 0.0050 1.1
## carRegistrations_sd   -0.81 -0.07 -0.27  0.21 0.78 0.2205 1.4
## consumerConfidence_sd  0.40  0.10  0.61  0.27 0.62 0.3753 2.2
## gasPrices_sd          -0.20  0.87  0.36 -0.25 1.00 0.0048 1.6
## housingIndex_sd        0.84 -0.11  0.23  0.40 0.94 0.0616 1.6
## inflationRate_sd       0.86  0.08  0.34  0.25 0.92 0.0814 1.5
## inflationRateMoM_sd    0.24  0.95 -0.04  0.18 1.00 0.0049 1.2
## labourCosts_sd         0.39  0.12  0.67  0.12 0.63 0.3687 1.8

##                        ML3  ML1  ML4  ML2
## SS loadings           3.06 1.74 1.65 1.41
## Proportion Var        0.34 0.19 0.18 0.16
## Cumulative Var        0.34 0.53 0.72 0.87
## Proportion Explained  0.39 0.22 0.21 0.18
## Cumulative Proportion 0.39 0.61 0.82 1.00





EFATrainNumsSEvars2_sd <- select(EFATrainNums_sd, c(##"bankLendingRate","businessConfidence",
                                          ##"carRegistrations"
                                          ## ,"consumerConfidence"
                                          ## ,"gasPrices"
                                          ## ,"housingIndex"
                                          ##"inflationRate_sd"
                                          ##,"inflationRateMoM_sd"
                                          ## ,"labourCosts"
                                           #"minimumWages_sd"
                                          "producerPricesChange_sd"
                                          ,"retailSalesMoM_sd"
                                          ,"retailSalesYoY_sd"
                                          ,"smallBusinessSentiment_sd"
                                          ,"unemploymentRate_sd"
                                          ,"changeInInventory_sd"
                                          ,"GDPGrowthRate_sd"
                                          ,"householdDebt_sd"
                                          ))


fa.parallel(EFATrainNumsSEvars2_sd,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrainNumsSEvars2_sd", n.iter=100)
## 4 factors suggested

#Run EFA on OList_sd numeric variables
faSEvars2_sd <- fa(EFATrainNumsSEvars2_sd, nfactors=4,rotate = "none",fm="ml")
faSEvars2_sd

# Try rotating for better factors - orthogonal
faSEvars2Varimax_sd <- fa(EFATrainNumsSEvars2_sd, nfactors=4,rotate = "varimax",fm="ml")
faSEvars2Varimax_sd
## CONCLUSION FOR EFA OF OLIST VARIABLES:
## The solution is somewhat useful. See below

# Try rotating for better factors - oblique
#install.packages("GPArotation")
library(GPArotation)
faSEvars2Promax_sd <- fa(EFATrainNumsSEvars2_sd, nfactors=4,rotate = "promax",fm="ml")
faSEvars2Promax_sd
## Bad result: loading > abs(1). Don't use

# CONCLUSION: Based on orthogonal rotation:
# 1st (ML4): producerPricesChange_sd, -retailSalesYoY_sd, GDPGrowthRate_sd
# 2nd (ML2): -retailSalesMom_sd,smallBusinessSentiment_sd,
# 3rd (ML1): changeInInventory_sd
# 4th (ML3): unemploymentRate_sd, -householdDebt_sd


## Standardized loadings (pattern matrix) based upon correlation matrix
##                            ML4   ML2   ML1   ML3   h2     u2 com
## producerPricesChange_sd    0.91 -0.05  0.23  0.08 0.88 0.1168 1.1
## retailSalesMoM_sd          0.06 -0.90 -0.23  0.35 1.00 0.0049 1.4
## retailSalesYoY_sd         -0.94 -0.12 -0.27  0.13 1.00 0.0047 1.2
## smallBusinessSentiment_sd  0.11  0.80 -0.05  0.34 0.77 0.2349 1.4
## unemploymentRate_sd        0.49  0.30  0.17  0.68 0.83 0.1706 2.4
## changeInInventory_sd       0.41  0.12  0.87 -0.24 1.00 0.0047 1.7
## GDPGrowthRate_sd           0.73  0.04  0.67  0.10 0.99 0.0064 2.0
## householdDebt_sd           0.30  0.18  0.42 -0.84 1.00 0.0047 1.9

##                        ML4  ML2  ML1  ML3
## SS loadings           2.76 1.61 1.59 1.49
## Proportion Var        0.35 0.20 0.20 0.19
## Cumulative Var        0.35 0.55 0.74 0.93
## Proportion Explained  0.37 0.22 0.21 0.20
## Cumulative Proportion 0.37 0.59 0.80 1.00

