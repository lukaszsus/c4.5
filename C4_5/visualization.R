source('c45lib.R')

set.seed(5)
k_folds = 10
stratified = TRUE

ds_path <- '../data/diabetes/iris.data'
data <- load_dataset(ds_path)

# tree_params = Weka_control(M=10)
# tree <- J48(class~.,
#             data=data,
#             control=tree_params)
# plot(tree)

#################
ds_path <- '../data/diabetes/diabetes.data'
data <- load_dataset(ds_path)

fold_indices <- k_fold_indices(data, k_folds, stratified)
# which - slice of indices which are TRUE (first param is bool list of indices)
# arr.ind - should array indices should be returned
curr_indices <- which(fold_indices==1, arr.ind=TRUE)
small_data <- data[curr_indices, ]

tree_params = Weka_control(C=0.01)
tree <- J48(class~.,
            data=small_data,
            control=tree_params)
plot(tree)

tree_params = Weka_control(C=0.5)
tree <- J48(class~.,
            data=small_data,
            control=tree_params)
plot(tree)

#################
ds_path <- '../data/glass/glass.data'
data <- load_dataset(ds_path)

fold_indices <- k_fold_indices(data, k_folds, stratified)
# which - slice of indices which are TRUE (first param is bool list of indices)
# arr.ind - should array indices should be returned
curr_indices <- which(fold_indices==1, arr.ind=TRUE)
small_data <- data[curr_indices, ]

tree_params = Weka_control(R=TRUE, N=2)
tree <- J48(class~.,
            data=small_data,
            control=tree_params)
plot(tree)

tree_params = Weka_control(R=TRUE, N=9)
tree <- J48(class~.,
            data=small_data,
            control=tree_params)
plot(tree)

#################
ds_path <- '../data/wine/wine.data'
data <- load_dataset(ds_path)

tree_params = Weka_control(M=2)
tree <- J48(class~.,
            data=data,
            control=tree_params)
plot(tree)

tree_params = Weka_control(M=10)
tree <- J48(class~.,
            data=data,
            control=tree_params)
plot(tree)
