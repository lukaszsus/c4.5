# Loading packages
library(RWeka)
library(caret)

# load dataset
iris_path = '../../L1/Iris_dataset/iris.data'
data = read.csv(iris_path)

# f1 score function
f1 <- function (data, lev = NULL, model = NULL) {
  precision <- posPredValue(data$pred, data$obs, positive = "pass")
  recall  <- sensitivity(data$pred, data$obs, postive = "pass")
  f1_val <- (2 * precision * recall) / (precision + recall)
  names(f1_val) <- c("F1")
  f1_val
}

# create model
#set.seed(1958)  # set a seed to get replicable results
train <- createFolds(iris$Species, k=10) # stratified
grid <- expand.grid(C = c(0.01, 0.1, 0.25, 0.375, 0.5),
                    M = c(1, 2, 3, 5, 10))
model <- J48(Species~., data=iris, control=Weka_control(B=FALSE))
C45Fit <- train(Species ~., method="J48",
                data=iris,
                # tuneLength = 5, # how many values of main parameter should try
                tuneGrid = grid,
                trControl =
                  trainControl(method="cv", # resampling method = cv (cross validation)
                              indexOut=train  # dictates which sample are held-out for each resample
                              ))

