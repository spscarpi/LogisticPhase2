


library(haven)#For read_sas()
library(forcats)# For fct_explicit_na
library(tidyverse)# For 

trainData <- read_sas("insurance_t_bin.sas7bdat")
summary(trainData)
#missing variables: INV, CC, HMOWN, CCPURC
###################################################################################
#Add missing value category to categories that are missing
factor_trainData <- as.data.frame(lapply(trainData, factor))
factor_trainData$INV <- fct_explicit_na(factor_trainData$INV, na_level="MISSING")
factor_trainData$CC <- fct_explicit_na(factor_trainData$CC, na_level="MISSING")
factor_trainData$HMOWN <- fct_explicit_na(factor_trainData$HMOWN, na_level="MISSING")
factor_trainData$CCPURC <- fct_explicit_na(factor_trainData$CCPURC, na_level="MISSING")
summary(factor_trainData)
###################################################################################
#Target  factor_trainData$INS

#   o Check each variable for separation concerns. Document in the report and adjust any 
#     variables with complete or quasi-separation concerns.
for(var in factor_trainData){
  model <- glm(INS ~ var, data = factor_trainData, family = binomial(link = "logit"))
  print(summary(model))
}

#  Build a main effects only binary logistic regression model to predict the purchase 
#   of the insurance product.



#     o Use backward selection to do the variable selection – the Bank currently uses 
#       𝛼 = 0.002 and p-values to perform backward, but is open to another technique
#       and/or significance level if documented in your report.


#     o Report the final variables from this model ranked by p-value.

#        (HINT: Even if you choose to not use p-values to select your variables, you
#          should still rank all final variables by their p-value in this report.) 

#  Interpret one variable’s odds ratio from your final model as an example.

#    o Report on any interesting findings from your odds ratios from your model.
#        (HINT: This is open-ended and has no correct answer. However, you should get
#         use to keeping an eye out for what you might deem important or interesting
#         when exploring data to report in an executive summary.)
#  Investigate possible interactions using forward selection including only the main effects from
# your previous final model.

#    o Report the final interaction variables from this model ranked by p-value.

#  Report your final logistic regression model’s variables by significance.

#     o (HINT: These steps are here to help you build your model, but not to tell you which
#       order to write your report. Consider the most important information when done with these 
#       questions and write your report accordingly.)










