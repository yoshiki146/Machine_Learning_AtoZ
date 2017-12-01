# Eclat

# Step1: Set a min support
# Step2: Take all the subsets in transactions having higher support than min sup
# Step 3: Sort these subsets by decreasing sup

# Data Preprocessing
library(arules)
dataset = read.transactions('Market_Basket_Optimisation.csv', sep = ',', rm.duplicates = TRUE)
summary(dataset)
itemFrequencyPlot(dataset, topN = 10)

# Training Eclat on the dataset
rules = eclat(data = dataset, parameter = list(support = 0.003, minlen = 2))

# Visualising the results
inspect(sort(rules, by = 'support')[1:10])