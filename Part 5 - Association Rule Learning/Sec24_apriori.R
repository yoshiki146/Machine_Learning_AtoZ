# Apriori

#Apriori- Algorithm
# Step1: Set a minumum support and confidence 
# Step2: Take all the subsets in transactions having higher support than minumum support 
# Step3: Take all the rules aof these subsets having higher confidence than minumun confidence 
# Step4: Sort the rules bby decreasing lift

# Data Preprocessing
library(arules)
dataset = read.csv('Market_Basket_Optimisation.csv', header = FALSE)
dataset = read.transactions('Market_Basket_Optimisation.csv', sep = ',', rm.duplicates = TRUE)  # having duplicated value is very common error (there should be zero duplicate when dealing w/ transaction data)
summary(dataset)
itemFrequencyPlot(dataset, topN = 10) # 10 most purchased items ## item frequency corresponds to the support

# Training Apriori on the dataset
rules = apriori(data = dataset, parameter = list(support = 0.003, confidence = 0.4))
# suppose we pick the items that are purchased at least three times a day
# This is 21 times a week, and since we have 7501 transactions a week, min support = 3*7/7501
# High confidence leads to obvious conclusion, while small conf leads to totally irrelevant combination


# Visualising the results
inspect(sort(rules, by = 'lift')[1:10])
##     lhs                                            rhs                 support     confidence lift     count
##[6]  {chocolate,herb & pepper}                   => {ground beef}       0.003999467 0.4411765  4.490183 30
# This makes no sence. This is because of the inappropriate sup and conf and chocolate ranks 5th most purchased item
# better change values for sup ad conf(for example, 0.004 and 0.2). Lowering support allows other combanations to be considered.
# For more discussion, refer QA of Lecture155(Step3) and read ENNAJIH's ans to NAGESH's question 
# "Why decreasing the min.confidence helps us get more relevant association"
