# Artificial Neural Network

# Importing the dataset
dataset = read.csv('Churn_Modelling.csv')
dataset = dataset[4:14]

# Encoding the categorical variables as factors (deep learning package requires inputs to be numeric or integer)
dataset$Geography = as.numeric(factor(dataset$Geography,
                                      levels = c('France', 'Spain', 'Germany'),
                                      labels = c(1, 2, 3)))
dataset$Gender = as.numeric(factor(dataset$Gender,
                                   levels = c('Female', 'Male'),
                                   labels = c(1, 2)))

# Splitting the dataset into the Training set and Test set
library(caTools)
set.seed(123)
split = sample.split(dataset$Exited, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature Scaling
training_set[-11] = scale(training_set[-11])
test_set[-11] = scale(test_set[-11])

# Fitting ANN to the Training set
## packages for deep learning in R
library(h2o)
## `NuralNet` for regressor(continuous dep.var), `nnet` for one hidden layer, `Deepnet` for multiple hidden layers, etc
## `h2o` 1) is OSS 2) has many options 3) has parametero tuning argu
## Therefore, h2o performs deep learning very fast
h2o.init(nthreads = -1)  # since h2o is OSS, you need to establish a connection. Note that java9 is not supported. Need to use java version "1.8.0_151"
model = h2o.deeplearning(y = 'Exited',
                         training_frame = as.h2o(training_set), 
                         activation = 'Rectifier',
                         hidden = c(6,6), # five neurons in the first hidden layer and five in the second
                         epochs = 100,
                         export_weights_and_biases = T # to see coef mat and const
                         train_samples_per_iteration = -2) # batch size, -2: automatic

# Predicting the Test set results
y_pred = h2o.predict(model, newdata = as.h2o(test_set[-11])) # returns in H2OFrame class
y_pred = (y_pred > 0.5)  # returns T/F(1/0) based on the logical expression in the parenthesis
y_pred = as.vector(y_pred)

# Making the Confusion Matrix
cm = table

# The coef mat and const
h2o.weights(model, matrix_id=1)
h2o.biases(model,  vector_id=1)
h2o.weights(model, matrix_id=2)
h2o.biases(model,  vector_id=2)
h2o.weights(model, matrix_id=3)
h2o.biases(model,  vector_id=3)

h2o.shutdown()
