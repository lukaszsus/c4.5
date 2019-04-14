# Loading packages
library(RWeka)
library(caret)
source('c45lib.R')

set.seed(5)

#ds_path <- '../data/iris/iris.data'
ds_path <- '../data/diabetes/diabetes.data'
#ds_path <- '../data/glass/glass.data'
#ds_path <- '../data/wine/wine.data'
data <- load_dataset(ds_path)

num_repeats <- 10
min_n_folds <- 2
max_n_folds <- 9    # ograniczam do 9, bo sa klasy po 9 przykladow
stratified <- TRUE
binary <- TRUE
count_var <- FALSE

# Parameters
# R = FALSE - Use reduced error pruning
# N = 3 - Set number of folds for reduced error pruning
# M = 2 - Set minimum number of instances per leaf
# C = 0.25 - Set confidence threshold for pruning

params <- list(
  "KFold_Default"=list(
    "tree_params"=Weka_control(),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_C001"=list(
    "tree_params"=Weka_control(C = 0.01),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_C01"=list(
    "tree_params"=Weka_control(C = 0.1),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_C025"=list(
    "tree_params"=Weka_control(C = 0.25),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_C05"=list(
    "tree_params"=Weka_control(C = 0.5),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_M1"=list(
    "tree_params"=Weka_control(M = 1),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_M2"=list(
    "tree_params"=Weka_control(M = 2),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_M4"=list(
    "tree_params"=Weka_control(M = 4),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_M10"=list(
    "tree_params"=Weka_control(M = 10),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_N2"=list(
    "tree_params"=Weka_control(R=TRUE, N=2),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_N3"=list(
    "tree_params"=Weka_control(R=TRUE, N=3),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_N6"=list(
    "tree_params"=Weka_control(R=TRUE, N=6),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  ),
  "KFold_N9"=list(
    "tree_params"=Weka_control(R=TRUE, N=9),
    "Accuracy"=list(),
    "Precision"=list(),
    "Recall"=list(),
    "F1"=list()
  )
)

outcomes <- explore_crossval_params(params)
save_to_file(outcomes, '../outcomes/skfold_diabetes.csv')

