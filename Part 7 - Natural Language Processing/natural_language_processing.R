# Natural Language Processing

# Importing the dataset
dataset_original = read.delim('Restaurant_Reviews.tsv', quote = '', stringsAsFactors = FALSE) 
    # sep='\t' by default, quote='' to remove double-quote, stringAsFactors=F to avoid `reviews` identified as facotrs

# Cleaning the texts
library(tm)
library(SnowballC)  # this package includes the list of stopwords (Japanese not supported)
corpus = VCorpus(VectorSource(dataset_original$Review))
# as.character(corpus[[1]])
corpus = tm_map(x=corpus, FUN=content_transformer(tolower))  # convert to lower case 
corpus = tm_map(corpus, removeNumbers)  
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords('en'))
corpus = tm_map(corpus, stemDocument)   # stemming words (loved->love)
corpus = tm_map(corpus, stripWhitespace) # remove extra spaces; two spaces to a space

# Creating the Bag of Words model
dtm = DocumentTermMatrix(corpus)   # dim(dtm); 1000 1577
dtm   # confirm that we have 1.5m cells with the sparsity of 100% 
dtm = removeSparseTerms(dtm, 0.999)  # allow 99.9% sparcity at max. 
dtm # This reduces the nr of cells to 686k w/ 99% sparcity. The nr of columns(words) is now 691
dataset = as.data.frame(as.matrix(dtm)) # Since `dtm` is a matrix in the sparce matrix form, first we need to coerse it into standard matrix using `as.matrix`
dataset$Liked = dataset_original$Liked
dataset$Liked = factor(dataset$Liked, levels = c(0, 1))  # Liked was integer in the original file. Need to encode as factor 

# Splitting the dataset into the Training set and Test set

library(caTools)
set.seed(123)
split = sample.split(dataset$Liked, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fitting Random Forest Classification to the Training set

library(randomForest)
classifier = randomForest(x = training_set[-692],    # remoce Liked Column
                          y = training_set$Liked,
                          ntree = 10)

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-692])

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred); cm

