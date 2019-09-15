#packages needed

install.packages("MASS")
install.packages("unbalanced")
install.packages("multcomp")
install.packages("brglm")
install.packages("car")
install.packages("haven")
install.packages("anchors")
install.packages("rJava")
install.packages("glmulti")
install.packages("givitiR")


#library needed
library(MASS)
library(unbalanced)
library(multcomp)
library(brglm)
library(car)
library("haven")
library("anchors")
library("rJava")
library("glmulti")
library("givitiR")



setwd("C:\\Users\\Iqra Munawar\\Documents\\Python Scripts\\LogisticPhase2")

insurance_t <- read_sas("C:/Users/Iqra Munawar/Documents/Python Scripts/LogisticPhase2/insurance_t_bin.sas7bdat")
summary(insurance_t)

#finding the missing values
colSums(is.na(insurance_t))

#assigning missing values a category


insurance_t <- replace.value(insurance_t,"CC", from= NA, to = as.integer(2) )
insurance_t <- replace.value(insurance_t,"CCPURC", from= NA, to = as.integer(5) )
insurance_t <- replace.value(insurance_t,"INV", from= NA, to = as.integer(2) )
insurance_t <- replace.value(insurance_t,"HMOWN", from= NA, to = as.integer(2) )


# Categorical Variables #
finsurance_t <- as.data.frame(lapply(insurance_t, as.factor))

logit.model.w1 <- glm(INS~.,
                      data = finsurance_t, family = binomial(link = "logit")
)
summary(logit.model.w1)

#adjusting separation variable 
insurance_t <- replace.value(insurance_t,"CASHBK", from= 2, to = as.integer(1) )
insurance_t <- replace.value(insurance_t,"MMCRED", from= 5, to = as.integer(3) )

# Logistic Regression Model - Backward Selection #
back.model <- step(logit.model.w1, direction = "backward", k=9.549536)
summary(back.model)


qchisq(0.002,1,lower.tail=FALSE)




