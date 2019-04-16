# CSP571 Project
# Joined Data Covariance Analysis

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

eComBr$seller_zip_code_prefix <- as.character(eComBr$seller_zip_code_prefix)
eComBr$customer_zip_code_prefix <- as.character(eComBr$customer_zip_code_prefix)
eComBr$salesTaxRate <- as.character(eComBr$salesTaxRate)

str(eComBr)


# Implement sampling for EFA train, CFA/SEM train, test (last month)

test <- subset(eComBr, order_purchase_timestamp > "2018-7-31 23:59:00")
head(test)
str(test)
summary(test)

train <- subset(eComBr, order_purchase_timestamp < "2018-7-31 23:59:00")
head(train)
str(train)
summary(train)
stopifnot(nrow(test) + nrow(train) == nrow(eComBr))
nrow(test)
nrow(train)
nrow(eComBr)

EFATrain <- subset(train, order_purchase_timestamp < "2017-11-30 23:59:00")
CFATrain <- subset(train, order_purchase_timestamp > "2017-11-30 23:59:00")
stopifnot(nrow(EFATrain) + nrow(CFATrain) == nrow(train))
nrow(EFATrain)
nrow(CFATrain)
nrow(train)

# Create EFATrainNums (only numeric attributes of EFATrain)

numVars <- names(which(sapply(EFATrain, is.numeric)))
catVars <- names(which(sapply(EFATrain, is.factor)))
logVars <- names(which(sapply(EFATrain, is.logical)))
numVars 
catVars
logVars

library(dplyr)
EFATrainNums <- select(EFATrain,numVars)
summary(EFATrainNums)
str(EFATrainNums)

# Exploratory Factor Analysis on EFATrainNums
library(stats)
EFATrainCov <- cov(EFATrainNums)
EFATrainCov

#install.packages("psych")
library(psych)
fa.parallel(EFATrainCov,n.obs=27214,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=20)

fa.parallel(EFATrainNums,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=20)
#Won't run, so segment into SocioEconomic variables and OList variables

EFATrainOList <- select(EFATrain, c("order_item_id","price"
                                    ,"freight_value"
                                    ,"product_name_lenght"
                                    ,"product_description_lenght"
                                    ,"product_photos_qty"
                                    ,"product_weight_g"
                                    ,"product_length_cm"
                                    ,"product_height_cm"
                                    ,"product_width_cm"
                                    ,"review_score"
                                    #,"Bi.weekly"
                                    ))

fa.parallel(EFATrainOList,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrainOList", n.iter=20)
## Suggested number of factors = 5

#Run EFA on OList numeric variables
faOList <- fa(EFATrainOList, nfactors=5,rotate = "none",fm="ml")
faOList

# Try rotating for better factors - orthogonal
faOListVarimax <- fa(EFATrainOList, nfactors=5,rotate = "varimax",fm="ml")
faOListVarimax

#install.packages("GPArotation")
library(GPArotation)
# Try rotating for better factors - oblique
faOListPromax <- fa(EFATrainOList, nfactors=5,rotate = "promax",fm="ml")
faOListPromax

## CONCLUSION FOR EFA OF OLIST VARIABLES:
## The solution is not a big help.

# First table (below) shows the loadings for each variable on each of the 5 factors.
# We want a variable to have a loading >.7 on 1 factor only.
# Factor 1 has freight_value,product_weight_g,product_height_cm
# The other 4 factors have only one variable loading sufficiently.
## Standardized loadings (pattern matrix) based upon correlation matrix
## ML2   ML1   ML3   ML4   ML5    h2    u2 com
## order_item_id               0.01  0.01  0.00 -0.06 -0.21 0.046 0.954 1.2
## price                       0.21 -0.02  0.13  0.62  0.10 0.451 0.549 1.4
## freight_value               0.56  0.11  0.10  0.32 -0.03 0.434 0.566 1.8
## product_name_lenght         0.00  0.09  0.10 -0.04  0.23 0.074 0.926 1.7
## product_description_lenght  0.07 -0.01 -0.12  0.38  0.07 0.167 0.833 1.4
## product_photos_qty         -0.03 -0.02 -0.07 -0.01  0.43 0.194 0.806 1.1
## product_weight_g            0.97  0.18  0.12  0.02  0.00 0.995 0.005 1.1
## product_length_cm           0.23  0.94  0.23 -0.01 -0.04 0.995 0.005 1.3
## product_height_cm           0.58  0.02  0.11  0.19 -0.22 0.427 0.573 1.6
## product_width_cm            0.32  0.27  0.90 -0.05  0.01 0.995 0.005 1.5
## review_score               -0.02 -0.02  0.00  0.04  0.10 0.012 0.988 1.6

# Second table (below) shows how much variance each factor explains.
# Factor 1 explains a small amount of variance (0.37)
## ML2  ML1  ML3  ML4  ML5
## SS loadings           1.80 1.01 0.95 0.67 0.36
## Proportion Var        0.16 0.09 0.09 0.06 0.03
## Cumulative Var        0.16 0.26 0.34 0.40 0.44
## Proportion Explained  0.37 0.21 0.20 0.14 0.08
## Cumulative Proportion 0.37 0.59 0.79 0.92 1.00

# CONCLUSION: Could group freight_value,product_weight_g,product_height_cm into a single factor
# related to shipping costs
# Could ignore product_length_cm and product_width_cm  

EFATrainNumsSEvars1 <- select(EFATrain, c("bankLendingRate","businessConfidence",
                                         "carRegistrations"
                                         ,"consumerConfidence"
                                         ,"gasPrices"
                                         ,"housingIndex"
                                         ,"inflationRate"
                                         ,"inflationRateMoM"
                                         ,"labourCosts"
                                         ,"minimumWages"
                                         ,"producerPricesChange"
                                         #,"retailSalesMoM"
                                         ,"retailSalesYoY"
                                         #,"smallBusinessSentiment"
                                         #,"unemploymentRate"
                                         #,"changeInInventory"
                                         #,"GDPGrowthRate"
                                         #,"householdDebt"
                                         ))
# Won't run with all the SocioEconomic, so split into two groups

fa.parallel(EFATrainNumsSEvars1,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=20)
## Suggested number of factors = 5

#Run EFA on SEvars1 numeric variables
faSEvars1 <- fa(EFATrainNumsSEvars1, nfactors=5, rotate = "none", fm="ml")
faSEvars1

# Try rotating for better factors - orthogonal
faSEvars1Varimax <- fa(EFATrainNumsSEvars1, nfactors=5,rotate = "varimax",fm="ml")
faSEvars1Varimax

#install.packages("GPArotation")
library(GPArotation)
# Try rotating for better factors - oblique
faSEvars1Promax <- fa(EFATrainNumsSEvars1, nfactors=5,rotate = "promax",fm="ml")
faSEvars1Promax

## CONCLUSION FOR EFA OF SEvars1 VARIABLES:
## The solution is quite useful

# As the loadings table (below) shows, the first factor has 7 variables loading on it:
# bankLendingRate, carRegistrations (negatively), consumerConfidence, housingIndex,
# inflationRate,producerPricesChange,and retailSalesYoY (negatively). This factor looks
# to reflect consumers' wealth self-perceptions. The second factor is comprised of gasPrices, 
# inflationRateMoM - short term wealth self-perceptions. BusinessConfidence is alone on the 
# third factor, and the last 2 factors have no variables loading substantially.

## Standardized loadings (pattern matrix) based upon correlation matrix
##                        ML1   ML2   ML3   ML4   ML5   h2     u2 com
## bankLendingRate       0.81 -0.13 -0.41  0.39 -0.03 1.00 0.0048 2.1
## businessConfidence   -0.15  0.39  0.83 -0.20  0.04 0.90 0.0982 1.6
## carRegistrations     -0.77  0.05  0.23 -0.04  0.03 0.65 0.3524 1.2
## consumerConfidence    0.64  0.03  0.11  0.33 -0.08 0.53 0.4668 1.6
## gasPrices            -0.18  0.95  0.09 -0.20  0.02 1.00 0.0049 1.2
## housingIndex          0.87 -0.38 -0.16  0.19  0.09 0.97 0.0310 1.6
## inflationRate         0.94 -0.09 -0.01  0.18 -0.27 1.00 0.0041 1.3
## inflationRateMoM      0.10  0.65  0.37  0.22 -0.04 0.62 0.3794 1.9
## labourCosts           0.39 -0.01 -0.21  0.41  0.04 0.37 0.6313 2.5
## minimumWages         -0.13 -0.01  0.02 -0.02  0.94 0.91 0.0950 1.0
## producerPricesChange  0.97  0.13  0.07  0.15 -0.10 1.00 0.0037 1.1
## retailSalesYoY       -0.70  0.11  0.19 -0.66  0.15 1.00 0.0049 2.3

# Second table (below) shows how much variance each factor explains.
# Factor 1 explains a lot of variance (0.50), and the first three factors
# cumulatively expslain 79%.

##                        ML1  ML2  ML3  ML4  ML5
## SS loadings           4.95 1.69 1.18 1.09 1.02
## Proportion Var        0.41 0.14 0.10 0.09 0.08
## Cumulative Var        0.41 0.55 0.65 0.74 0.83
## Proportion Explained  0.50 0.17 0.12 0.11 0.10
## Cumulative Proportion 0.50 0.67 0.79 0.90 1.00

# CONCLUSION: Recommend grouping the 7 variables of Factor 1 together, along
# with the 2 variables of factor 2, and including BusinessConfidence by itself


EFATrainNumsSEvars2 <- select(EFATrain, c(##"bankLendingRate","businessConfidence",
                                          ##"carRegistrations"
                                          ## ,"consumerConfidence"
                                          ## ,"gasPrices"
                                          ## ,"housingIndex"
                                          ## ,"inflationRate"
                                          ## ,"inflationRateMoM"
                                          ## ,"labourCosts"
                                          ## ,"minimumWages"
                                          ##,"producerPricesChange"
                                          #,"retailSalesMoM"
                                          ##,"retailSalesYoY"
                                          "smallBusinessSentiment"
                                          ,"unemploymentRate"
                                          ,"changeInInventory"
                                          ,"GDPGrowthRate"
                                          ,"householdDebt"
                                          ))

fa.parallel(EFATrainNumsSEvars2,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=20)
# Suggested number of factors = 3

#Run EFA on SEvars2 numeric variables
faSEvars2 <- fa(EFATrainNumsSEvars2, nfactors=3, rotate = "none", fm="ml")
faSEvars2

# Try rotating for better factors - orthogonal
faSEvars2Varimax <- fa(EFATrainNumsSEvars2, nfactors=3,rotate = "varimax",fm="ml")
faSEvars2Varimax

#install.packages("GPArotation")
library(GPArotation)
# Try rotating for better factors - oblique
faSEvars2Promax <- fa(EFATrainNumsSEvars2, nfactors=3,rotate = "promax",fm="ml")
faSEvars2Promax

## CONCLUSION FOR EFA OF SEvas2 VARIABLES:
## The solution is not a big help.

# As the loadings table (below) shows, the first factor has 3 variables loading on it:
# smallBusinessSentiment (negatively), unemploymentRate, and changeInInventory. This factor 
# appears to reflect business confidence. The second factor is householdDebt, while the third 
# third factor GDPGrowthRate.

## Standardized loadings (pattern matrix) based upon correlation matrix
##                          ML1   ML2   ML3   h2    u2 com
## smallBusinessSentiment -0.69 -0.15 -0.06 0.51 0.494 1.1
## unemploymentRate        0.87 -0.04  0.49 0.99 0.005 1.6
## changeInInventory       0.67  0.58  0.35 0.90 0.096 2.5
## GDPGrowthRate           0.18  0.22  0.63 0.47 0.526 1.4
## householdDebt           0.09  0.97  0.21 0.99 0.005 1.1

# Second table (below) shows how much variance each factor explains.
# Factor 1 explains a lot of variance (0.45), and the first two factors
# cumulatively expslain 79%.
##                        ML1  ML2  ML3
## SS loadings           1.73 1.34 0.80
## Proportion Var        0.35 0.27 0.16
## Cumulative Var        0.35 0.61 0.77
## Proportion Explained  0.45 0.35 0.21
## Cumulative Proportion 0.45 0.79 1.00

# CONCLUSION: Recommend grouping the 3 variables of Factor 1 together, and including
# the other 2 variables by themselves
