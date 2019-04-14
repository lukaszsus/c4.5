library(dismo)

load_dataset <- function(filepath) {
  return(read.csv(filepath,
                  header=TRUE));
}

k_fold_indices <- function(dataset, k_folds, stratified) {
  if(stratified) {
    return(kfold(dataset, k = k_folds, by = dataset$class));
  }
  else {
    return(kfold(dataset, k = k_folds));
  }
}

count_returned_metrics <- function(accuracies, precisions, recalls, f1s) {
  if(count_var){
    metrics = list(
      "Accuracy"=var(unlist(accuracies)),    #unlins - to vector
      "Precision"=var(unlist(precisions)),
      "Recall"=var(unlist(recalls)),
      "F1"=var(unlist(f1s))
    )
  }
  else{
    metrics = list(
      "Accuracy"=mean(unlist(accuracies)),    #unlins - to vector
      "Precision"=mean(unlist(precisions)),
      "Recall"=mean(unlist(recalls)),
      "F1"=mean(unlist(f1s))
    )
  }
  
  return(metrics)
}

make_cross_val <- function(dataset, tree_params, k_folds, stratified, binary) {
  accuracies = list()
  precisions = list()
  recalls = list()
  f1s = list()
  
  for (j in 1:num_repeats){
    fold_indices <- k_fold_indices(dataset, k_folds, stratified)
    
    for(i in 1:k_folds) {
      # which - slice of indices which are TRUE (first param is bool list of indices)
      # arr.ind - should array indices should be returned
      curr_indices <- which(fold_indices==i, arr.ind=TRUE)
      test_data <- dataset[curr_indices, ]
      train_data <- dataset[-curr_indices, ]    # -curr_indices = take others
      
      tree <- J48(class~.,
                  data=train_data,
                  control=tree_params)
      
      y_pred <- predict(tree, newdata = test_data)
      cm <- confusionMatrix(y_pred, test_data$class)
      
      if(binary) {
        p <- cm$byClass["Precision"]
        r <- cm$byClass["Recall"]
        f1 <- cm$byClass["F1"]
      }
      else {
        p <- cm$byClass[, "Precision"]
        r <- cm$byClass[, "Recall"]
        f1 <- cm$byClass[, "F1"]
      }
      
      # na.rm	- wheather NA values should be stripped before the computation proceeds
      accuracies <- append(accuracies, cm$overall["Accuracy"])
      precisions <- append(precisions, mean(p, na.rm=TRUE))
      recalls <- append(recalls, mean(r, na.rm=TRUE))
      f1s <- append(f1s, mean(f1, na.rm=TRUE))
    }  
  }
  metrics = count_returned_metrics(accuracies, precisions, recalls, f1s)
  return(metrics)
}

explore_crossval_params <- function(params) {
  for(n in names(params)) {
    test_example <- params[[n]]
    print(test_example$tree_params)
    
    for(i in min_n_folds:max_n_folds) {
      if(stratified){
        print(sprintf("Stratified crossvalidation K=%d", i))
      }
      else{
        print(sprintf("Unstratified crossvalidation K=%d", i))
      }
      cv_data <- make_cross_val(data, test_example$tree_options, i, stratified, binary)
      
      test_example$Accuracy <- append(test_example$Accuracy, cv_data$Accuracy)
      test_example$Precision <- append(test_example$Precision, cv_data$Precision)
      test_example$Recall <- append(test_example$Recall, cv_data$Recall)
      test_example$F1 <- append(test_example$F1, cv_data$F1)
    }
    
    params[[n]] <- test_example
  }
  return(params)
}

save_to_file <- function(outcomes, savepath) {
  for(name in names(outcomes)) {
    prefix=""
    if(stratified){
      prefix = 'stratified'
    }
    else{
      prefix = 'unstrat'
    }
    for(attr in names(outcomes[[name]])) {
      # Concatenate vectors after converting to character.
      row <- paste(prefix, ",", name, ",", collapse="")
      if(attr == 'tree_params') {
        next
      }
      row <- paste(row, attr, ",",collapse="")
      for(val in outcomes[[name]][[attr]]) {
        row <- paste(row, format(round(val, 3), nsmall=3), ",",collapse="") # nsmall - number of digits to the right
      }
      write(row, file=savepath, append = TRUE)
      row <- ""
    }
  }
}

plot_tree <- function(trainData, tree_options, savepath) {
  if(savepath == FALSE) {
    x11()
  }
  else {
    png(savepath, width = 1280, height = 768)
  }
  
  tree <- J48(Class~.,
              data=trainData,
              control=tree_options)
  plot(tree)
  
  if (savepath != FALSE) {
    dev.off()
  }
  
  print(summary(tree))
}
