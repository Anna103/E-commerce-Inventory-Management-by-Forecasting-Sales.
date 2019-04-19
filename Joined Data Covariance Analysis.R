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

eComBr$order_item_id <- as.factor(eComBr$order_item_id)
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

# standardize all the numeric variables
numVarseCombBr <- names(which(sapply(eComBr, is.numeric)))
numVarseCombBr
eComBr <- transform(eComBr, price = scale(price))
eComBr <- transform(eComBr, freight_value = scale(freight_value))
eComBr <- transform(eComBr, product_name_lenght = scale(product_name_lenght))
eComBr <- transform(eComBr, product_description_lenght = scale(product_description_lenght))
eComBr <- transform(eComBr, product_weight_g = scale(product_weight_g))
eComBr <- transform(eComBr, product_length_cm = scale(product_length_cm))
eComBr <- transform(eComBr, product_height_cm = scale(product_height_cm))
eComBr <- transform(eComBr, product_width_cm = scale(product_width_cm))
eComBr <- transform(eComBr, review_score = scale(review_score))
eComBr <- transform(eComBr, bankLendingRate = scale(bankLendingRate))
eComBr <- transform(eComBr, businessConfidence = scale(businessConfidence))
eComBr <- transform(eComBr, carRegistrations = scale(carRegistrations))
eComBr <- transform(eComBr, consumerConfidence = scale(consumerConfidence))
eComBr <- transform(eComBr, gasPrices = scale(gasPrices))
eComBr <- transform(eComBr, housingIndex = scale(housingIndex))
eComBr <- transform(eComBr, inflationRate = scale(inflationRate))
eComBr <- transform(eComBr, inflationRateMoM = scale(inflationRateMoM))
eComBr <- transform(eComBr, labourCosts = scale(labourCosts))
eComBr <- transform(eComBr, minimumWages = scale(minimumWages))
eComBr <- transform(eComBr, producerPricesChange = scale(producerPricesChange))
eComBr <- transform(eComBr, retailSalesMoM = scale(retailSalesMoM))
eComBr <- transform(eComBr, retailSalesYoY = scale(retailSalesYoY))
eComBr <- transform(eComBr, smallBusinessSentiment = scale(smallBusinessSentiment))
eComBr <- transform(eComBr, unemploymentRate = scale(unemploymentRate))
eComBr <- transform(eComBr, changeInInventory = scale(changeInInventory))
eComBr <- transform(eComBr, GDPGrowthRate = scale(GDPGrowthRate))
eComBr <- transform(eComBr, householdDebt = scale(householdDebt))
eComBr <- transform(eComBr, easeOfDoingBusiness = scale(easeOfDoingBusiness))
eComBr <- transform(eComBr, livingWageFamily = scale(livingWageFamily))
eComBr <- transform(eComBr, livingWageIndividual = scale(livingWageIndividual))

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
#plot(EFATrainCov)
#install.packages("psych")
library(psych)
fa.parallel(EFATrainCov,n.obs=27214,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=100)

fa.parallel(EFATrainNums,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=100)
#Won't run, so segment into SocioEconomic variables and OList variables

EFATrainOList <- select(EFATrain, c("price"
                                    ,"freight_value"
                                    ,"product_name_lenght"
                                    ,"product_description_lenght"
                                    ,"product_weight_g"
                                    ,"product_length_cm"
                                    ,"product_height_cm"
                                    ,"product_width_cm"
                                    ,"review_score"
                                    ))

fa.parallel(EFATrainOList,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrainOList", n.iter=100)
## Suggested number of factors = 5

#Run EFA on OList numeric variables
faOList <- fa(EFATrainOList, nfactors=5,rotate = "none",fm="ml")
faOList

# Try rotating for better factors - orthogonal
faOListVarimax <- fa(EFATrainOList, nfactors=5,rotate = "varimax",fm="ml")
faOListVarimax

# Try rotating for better factors - oblique
#install.packages("GPArotation")
library(GPArotation)
faOListPromax <- fa(EFATrainOList, nfactors=4,rotate = "promax",fm="ml")
faOListPromax

## CONCLUSION FOR EFA OF OLIST VARIABLES:
## The solution is somewhat useful.

# First table (below) shows the loadings for each variable on each of the 4 factors.
# We want a variable to have a loading >.7 on 1 factor only.
# Factor MLe has freight_value and product_weight_g
# The other 3 factors have only one variable loading sufficiently.
## Standardized loadings (pattern matrix) based upon correlation matrix
##                             ML2   ML3   ML1   ML4     h2    u2 com
## price                       0.17  0.12 -0.10  0.84 0.6735 0.327 1.2
## freight_value               0.03  0.58  0.01  0.28 0.4455 0.555 1.4
## product_name_lenght         0.14  0.00 -0.06  0.01 0.0219 0.978 1.3
## product_description_lenght -0.14  0.08  0.02  0.29 0.1212 0.879 1.6
## product_weight_g            0.05  0.85  0.14  0.04 0.8645 0.136 1.1
## product_length_cm           0.42  0.27  0.06 -0.06 0.3560 0.644 1.8
## product_height_cm           0.02  0.13  0.95 -0.04 0.9950 0.005 1.0
## product_width_cm            1.00 -0.05  0.29 -0.01 0.9950 0.005 1.2
## review_score                0.01 -0.04  0.01  0.04 0.0033 0.997 2.1

# Second table (below) shows how much variance each factor explains.
# Factor ML2 explains a small amount of variance (0.28)
##                        ML2  ML3  ML1  ML4
## SS loadings           1.26 1.33 1.05 0.83
## Proportion Var        0.14 0.15 0.12 0.09
## Cumulative Var        0.14 0.29 0.40 0.50
## Proportion Explained  0.28 0.30 0.24 0.19
## Cumulative Proportion 0.28 0.58 0.81 1.00

# CONCLUSION: Group freight_value, product_weight_g into a single 'shipping costs' factor? 


EFATrainNumsSEvars1 <- select(EFATrain, c("bankLendingRate","businessConfidence"
                                         ,"carRegistrations"
                                         ,"consumerConfidence"
                                         ,"gasPrices"
                                         ,"housingIndex"
                                         ,"inflationRate"
                                         ,"inflationRateMoM"
                                         ,"labourCosts"
                                         ,"minimumWages"
                                         ,"producerPricesChange"
                                         ,"retailSalesMoM"))
                                         #,"retailSalesYoY"
                                         #,"smallBusinessSentiment"
                                         #,"unemploymentRate"
                                         #,"changeInInventory"
                                         #,"GDPGrowthRate"
                                         #,"householdDebt"
                                         ##))
# Won't run with all the SocioEconomic, so split into two groups

fa.parallel(EFATrainNumsSEvars1,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=100)
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
# Heywood case occurred, so don't use oblique rotation

## CONCLUSION FOR EFA with orthogonal OF SEvars1 VARIABLES:
## The solution is quite useful

# As the loadings table (below) shows, the first factor has 7 variables loading on it:
# bankLendingRate, carRegistrations (negatively), consumerConfidence, housingIndex,
# inflationRate,producerPricesChange. This factor reflects consumers' wealth self-perceptions.
# The second factor is comprised of gasPrices and inflationRateMoM - short-term wealth self-perceptions.
# BusinessConfidence is alone on the third factor of ML5, retailSalesMOM is alone on 
# 4th factor of ML4, and minimumWages is alone on the last factor of ML3.

## Standardized loadings (pattern matrix) based upon correlation matrix
##                        ML1   ML2   ML5   ML4   ML3   h2     u2 com
## bankLendingRate       0.88 -0.15 -0.44 -0.10 -0.02 1.00 0.0048 1.6
## businessConfidence   -0.17  0.39  0.86 -0.05  0.02 0.93 0.0710 1.5
## carRegistrations     -0.72 -0.02  0.31 -0.43  0.01 0.81 0.1941 2.0
## consumerConfidence    0.70  0.01  0.06 -0.11 -0.06 0.52 0.4839 1.1
## gasPrices            -0.24  0.96  0.11 -0.07  0.01 1.00 0.0049 1.2
## housingIndex          0.89 -0.36 -0.17  0.08  0.09 0.95 0.0459 1.4
## inflationRate         0.95 -0.07 -0.03  0.12 -0.26 1.00 0.0045 1.2
## inflationRateMoM      0.16  0.61  0.30 -0.21  0.00 0.52 0.4754 1.9
## labourCosts           0.46 -0.05 -0.29 -0.16 -0.03 0.33 0.6713 2.0
## minimumWages         -0.14  0.00  0.02 -0.01  0.99 1.00 0.0050 1.0
## producerPricesChange  0.98  0.16  0.06  0.09 -0.09 1.00 0.0035 1.1
## retailSalesMoM        0.01 -0.22  0.00  0.97 -0.01 1.00 0.0050 1.1

# Second table (below) shows how much variance each factor explains.
# Factor 1 explains a lot of variance (0.48), and the first three factors
# cumulatively explain 77%.

##                        ML1  ML2  ML5  ML4  ML3
## SS loadings           4.78 1.67 1.26 1.26 1.06
## Proportion Var        0.40 0.14 0.10 0.10 0.09
## Cumulative Var        0.40 0.54 0.64 0.75 0.84
## Proportion Explained  0.48 0.17 0.13 0.13 0.11
## Cumulative Proportion 0.48 0.64 0.77 0.89 1.00

# CONCLUSION: Recommend examining this factor structure in CFA.


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
                                          ##,"retailSalesMoM"
                                          "retailSalesYoY"
                                          ,"smallBusinessSentiment"
                                          ,"unemploymentRate"
                                          ,"changeInInventory"
                                          ,"GDPGrowthRate"
                                          ,"householdDebt"
                                          ))

fa.parallel(EFATrainNumsSEvars2,fm="ml",fa="both",nfactors = 1,
            main="Parallel Analysis Scree Plots for EFATrain", n.iter=100)
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
# A loading greater than abs(1) detected, so don't use oblique rotation

## CONCLUSION FOR EFA OF SEvas2 VARIABLES:
## The solution is quite useful.

# As the loadings table (below) shows, the first factor (ML3) has 2 variables loading on it:
# unemploymentRate and changeInInventory, reflecting business worry.
# The second factor (ML2) has retailSalesYoY (negative) and GDPGrowthRate loading.
# The third factor (ML1) has changeInInventory and householdDebt loading.

## Standardized loadings (pattern matrix) based upon correlation matrix
##                          ML1   ML2   ML3   h2    u2 com
## smallBusinessSentiment -0.69 -0.15 -0.06 0.51 0.494 1.1
## unemploymentRate        0.87 -0.04  0.49 0.99 0.005 1.6
## changeInInventory       0.67  0.58  0.35 0.90 0.096 2.5
## GDPGrowthRate           0.18  0.22  0.63 0.47 0.526 1.4
## householdDebt           0.09  0.97  0.21 0.99 0.005 1.1

# Second table (below) shows how much variance each factor explains.
# Factor 1 (ML3) explains 0.38, and the first two cumulatively explain 0.71.
##                        ML3  ML2  ML1
## SS loadings           1.89 1.64 1.41
## Proportion Var        0.31 0.27 0.23
## Cumulative Var        0.31 0.59 0.82
## Proportion Explained  0.38 0.33 0.29
## Cumulative Proportion 0.38 0.71 1.00

# CONCLUSION: Recommend examining this factor structure in CFA.







##Principal Components Analysis (PCA) on EFATrainNums
library(psych)
fa.parallel(EFATrainNums,fa="pc",n.iter=100, show.legend = FALSE,
            main="Scree plot with Parallel Analysis for PD of EFATrainNums")
#Won't run due to singular correlation matrix, so construct SocioEconomic variables and OList variables

EFATrainOList <- select(EFATrain, c("price"
                                    ,"freight_value"
                                    ,"product_name_lenght"
                                    ,"product_description_lenght"
                                    ,"product_weight_g"
                                    ,"product_length_cm"
                                    ,"product_height_cm"
                                    ,"product_width_cm"
                                    ,"review_score"))


fa.parallel(EFATrainOList,fa="pc",n.iter=100, show.legend = F,
            main="Parallel Analysis Scree Plots PD of EFATrainOList")
## Suggested number of components = 3

#Run PCA on OList numeric variables
pcOList <- principal(EFATrainOList, nfactors=3)
pcOList

## OUTPUT
## Standardized loadings (pattern matrix) based upon correlation matrix
##                              RC1   RC2   RC3    h2   u2 com
## price                       0.31  0.65  0.01 0.514 0.49 1.4
## freight_value               0.70  0.30 -0.04 0.579 0.42 1.4
## product_name_lenght        -0.14  0.23  0.87 0.835 0.16 1.2
## product_description_lenght  0.00  0.77 -0.06 0.604 0.40 1.0
## product_weight_g            0.86  0.09  0.06 0.749 0.25 1.0
## product_length_cm           0.59 -0.24  0.44 0.605 0.39 2.2
## product_height_cm           0.70  0.21 -0.18 0.561 0.44 1.3
## product_width_cm            0.66 -0.22  0.43 0.669 0.33 2.0
## review_score               -0.03  0.08 -0.13 0.024 0.98 1.8

# Get the PC scores
pcOList <- principal(EFATrainOList, nfactors=3,scores = T)
pcOList$scores


# Try rotating for better components - orthogonal
pcOListVarimax <- principal(EFATrainOList, nfactors=3,rotate = "varimax")
pcOListVarimax
# Get the PC scores
pcOListVarimax <- principal(EFATrainOList, nfactors=3,rotate = "varimax",scores = T)
pcOListVarimax$scores
# scores are the same independent of rotation
pcOListScoresDiff <- pcOList$scores - pcOListVarimax$scores
pcOListScoresDiff


## CONCLUSION FOR PCA OF OLIST VARIABLES:
## The solution seems useful, and the scores can be used to compute PCs.


EFATrainNumsSEvars1 <- select(EFATrain, c("bankLendingRate","businessConfidence"
                                          ,"carRegistrations"
                                          ,"consumerConfidence"
                                          ,"gasPrices"
                                          ,"housingIndex"
                                          ,"inflationRate"
                                          ,"inflationRateMoM"
                                          ,"labourCosts"
                                          ,"minimumWages"
                                          ,"producerPricesChange"
                                          ,"retailSalesMoM"))

fa.parallel(EFATrainNumsSEvars1,fa="pc",n.iter=100, show.legend = F,
            main="Parallel Analysis Scree Plots PD of EFATrainNumsSEvars1")
## Suggested number of components = 3

#Run PCA on NumsSEvars1 numeric variables
pcNumsSEvars1 <- principal(EFATrainNumsSEvars1, nfactors=3)
pcNumsSEvars1

## OUTPUT
## Standardized loadings (pattern matrix) based upon correlation matrix
##                        RC1   RC2   RC3   h2    u2 com
## bankLendingRate       0.86 -0.40  0.23 0.95 0.046 1.6
## businessConfidence   -0.22  0.77 -0.13 0.66 0.338 1.2
## carRegistrations     -0.82  0.22  0.25 0.78 0.218 1.3
## consumerConfidence    0.76  0.09  0.10 0.59 0.410 1.1
## gasPrices            -0.18  0.83  0.10 0.73 0.273 1.1
## housingIndex          0.83 -0.45  0.01 0.89 0.106 1.5
## inflationRate         0.96 -0.09 -0.12 0.95 0.054 1.0
## inflationRateMoM      0.23  0.80  0.24 0.74 0.256 1.3
## labourCosts           0.53 -0.21  0.42 0.51 0.493 2.2
## minimumWages         -0.29 -0.12  0.23 0.15 0.848 2.2
## producerPricesChange  0.96  0.11 -0.05 0.94 0.058 1.0
## retailSalesMoM        0.07 -0.27 -0.90 0.88 0.119 1.2

# Get the PC scores
pcNumsSEvars1 <- principal(EFATrainNumsSEvars1, nfactors=3,scores = T)
pcNumsSEvars1$scores

## CONCLUSION FOR PCA OF SEvars1 VARIABLES:
## The solution seems useful, and the scores can be used to compute PCs.


EFATrainNumsSEvars2 <- select(EFATrain, c("retailSalesYoY"
  ,"smallBusinessSentiment"
  ,"unemploymentRate"
  ,"changeInInventory"
  ,"GDPGrowthRate"
  ,"householdDebt"
))

fa.parallel(EFATrainNumsSEvars2,fa="pc",n.iter=100, show.legend = F,
            main="Parallel Analysis Scree Plots PD of EFATrainNumsSEvars2")
## Suggested number of components = 1

#Run PCA on NumsSEvars2 numeric variables
pcNumsSEvars2 <- principal(EFATrainNumsSEvars2, nfactors=1)
pcNumsSEvars2

## OUTPUT
## Standardized loadings (pattern matrix) based upon correlation matrix
##                          PC1   h2   u2 com
## retailSalesYoY         -0.87 0.76 0.24   1
## smallBusinessSentiment -0.70 0.49 0.51   1
## unemploymentRate        0.82 0.67 0.33   1
## changeInInventory       0.88 0.77 0.23   1
## GDPGrowthRate           0.70 0.49 0.51   1
## householdDebt           0.59 0.35 0.65   1

# Get the PC scores
pcNumsSEvars2 <- principal(EFATrainNumsSEvars2, nfactors=1,scores = T)
pcNumsSEvars2$scores

## CONCLUSION FOR PCA OF SEvars2 VARIABLES:
## The solution seems useful, and the scores can be used to compute PCs.
