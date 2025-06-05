
clean_sqf <- function(data = all_sqf_data) {
  if (isFALSE(tibble::is_tibble(data))) {
    stop("data should be a tibble")
  }
  
  data_filtered <- dplyr::filter(data, suspected.crime == "cpw")
  
  data_filtered <- dplyr::filter(data_filtered, precinct != 121)
  
  selected_columns <- c(
    'found.weapon',        
    'precinct',           
    'location.housing',    
    'subject.age',        
    'subject.build',      
    'subject.sex',        
    'subject.height',     
    'subject.weight',     
    'inside',             
    'observation.period',  
    'day',               
    'month',              
    'year',              
    'time.period',        
    
    'additional.associating', 'additional.direction', 'additional.highcrime',
    'additional.time', 'additional.sights', 'additional.other', 'additional.evasive',
    'additional.proximity', 'additional.report', 'additional.investigation',
    
    'stopped.bc.bulge', 'stopped.bc.object', 'stopped.bc.casing',
    'stopped.bc.lookout', 'stopped.bc.drugs', 'stopped.bc.furtive',
    'stopped.bc.clothing', 'stopped.bc.violent', 'stopped.bc.desc',
    'stopped.bc.other'
  )
  
  data_cleaned <- dplyr::select(data_filtered, all_of(selected_columns))
  
  data_cleaned <- data_cleaned[stats::complete.cases(data_cleaned), ]
  
  data_cleaned <- dplyr::mutate(data_cleaned,
                                precinct = as.factor(precinct),
                                time.period = as.factor(time.period))
  
  return(tibble::as_tibble(data_cleaned))
}



split_sqf_data <- function(data = sqf_data) {
  sqf_pre_2015 <- data %>%
    filter(year >= 2013 & year <= 2014)
  print("Filtered sqf_pre_2015:")
  print(head(sqf_pre_2015))  
  
  sqf_2015 <- data %>%
    filter(year == 2015)
  print("Filtered sqf_2015:")
  print(head(sqf_2015))  
  
  set.seed(123) 
  sqf_pre_2015_shuffled <- sqf_pre_2015 %>%
    sample_frac(1)
  
  n <- nrow(sqf_pre_2015_shuffled)
  print(paste("Number of rows in sqf_pre_2015_shuffled:", n))
  
  sqf_pre_train <- sqf_pre_2015_shuffled[1:(n/2), ]
  sqf_pre_test <- sqf_pre_2015_shuffled[(n/2 + 1):n, ]
  
  return(list(
    sqf_pre_train = sqf_pre_train,
    sqf_pre_test = sqf_pre_test,
    sqf_2015 = sqf_2015
  ))
}
logistic_model_1 <- function(data = sqf_split) {
  if (!is.list(data) || !all(c("sqf_pre_train", "sqf_pre_test", "sqf_2015") %in% names(data))) {
    stop("The input data must be a list with 'sqf_pre_train', 'sqf_pre_test', and 'sqf_2015'.")
  }
  library(dplyr)
  library(ROCR)
  set.seed(2)
  
  sqf_pre_train <- data$sqf_pre_train
  sqf_pre_test <- data$sqf_pre_test
  sqf_2015 <- data$sqf_2015
  
  model <- glm(found.weapon ~ ., data = sqf_pre_train, family = binomial)
  
  compute_auc <- function(model, test_data) {
    predicted_probs <- predict(model, test_data, type = "response")
    
    pred <- prediction(predicted_probs, test_data$found.weapon)
    perf <- performance(pred, "auc")
    
    auc_value <- as.numeric(perf@y.values)
    return(auc_value)
  }
  
  auc_pre_test <- compute_auc(model, sqf_pre_test)
  
  auc_2015 <- compute_auc(model, sqf_2015)
  
  auc_list <- list(
    auc_pre_test = auc_pre_test,
    auc_2015 = auc_2015
  )
  
  return(auc_list)
}



logistic_model_2 <- function(data = all_sqf_data, seed = 2) {
  
  
  if(isFALSE(tibble::is_tibble(data))){
    stop("data should be a tibble")
  }
  library(dplyr)
  library(ROCR)
  library(tibble)
  
  set.seed(seed)
  
  data_2008 <- data %>%
    filter(year == 2008)
  
  predictors <- colnames(data_2008)[colnames(data_2008) != "year"]
  
  model <- glm(found.weapon ~ ., data = data_2008[, predictors], family = binomial)
  
  auc_results <- tibble(year = integer(), auc = numeric())
  
  for (year_val in 2009:2016) {
    data_year <- data %>%
      filter(year == year_val)
    
    predicted_probs <- predict(model, newdata = data_year[, predictors], type = "response")
    
    pred <- prediction(predicted_probs, data_year$found.weapon)
    perf <- performance(pred, "auc")
    
    auc_value <- as.numeric(perf@y.values)
    
    auc_results <- auc_results %>%
      add_row(year = year_val, auc = auc_value)
  }
  
  return(auc_results)
}

################## Test functions: do not edit the code below ##################
test_clean_sqf <- function(){
  testthat::test_that('Checking that `clean_sqf()` exists', {
    testthat::expect_true(exists('clean_sqf'))
  })
  
  testthat::test_that('Checking that clean_sqf() returns a tibble', {
    testthat::expect_true(tibble::is_tibble(sqf_data))
  })
  
  testthat::test_that('Checking that column names are correct', {
    testthat::expect_named(sqf_data, 
                           expected = c("found.weapon", "precinct", "location.housing", "additional.report", 
                                        "additional.investigation", "additional.sights", "additional.proximity", 
                                        "additional.evasive", "additional.associating", "additional.direction", 
                                        "additional.highcrime", "additional.time", "additional.other", 
                                        "stopped.bc.object", "stopped.bc.bulge", "stopped.bc.desc", "stopped.bc.violent", 
                                        "stopped.bc.casing", "stopped.bc.lookout", "stopped.bc.drugs", 
                                        "stopped.bc.clothing", "stopped.bc.furtive", "stopped.bc.other", 
                                        "subject.age", "subject.build", "subject.sex", "subject.height", 
                                        "subject.weight", "inside", "observation.period", "day", "month", 
                                        "year", "time.period"), 
                           ignore.order = TRUE)
  })
  
}

test_split_sqf_data <- function(){
  testthat::test_that('Checking that `split_sqf_data()` exists', {
    testthat::expect_true(exists('split_sqf_data'))
  })
  
  testthat::test_that('Checking that split_sqf_data() returns a list', {
    testthat::expect_true(class(sqf_split) == 'list')
  })
  
  testthat::test_that('Checking that split_sqf_data() returns a named list with the proper named elements', {
    testthat::expect_named(sqf_split, 
                           expected = c('sqf_pre_train', 
                                        'sqf_pre_test', 
                                        'sqf_2015'), 
                           ignore.order = TRUE)
  })
  
  testthat::test_that('Checking that all elements in the list are tibbles', {
    testthat::expect_true(all(sapply(sqf_split, tibble::is_tibble)))
  })
}

test_logistic_model_1 <- function(){
  testthat::test_that('Checking that `logistic_model_1()` exists', {
    testthat::expect_true(exists('logistic_model_1'))
  })
  
  testthat::test_that('Checking that logistic_model_1() returns a list', {
    testthat::expect_true(class(auc_list) == 'list')
  })
  
  testthat::test_that('Checking that logistic_model_1() returns a named list with the proper named elements', {
    testthat::expect_named(auc_list, 
                           expected = c('auc_pre_test', 
                                        'auc_2015'), 
                           ignore.order = TRUE)
  })
  
  testthat::test_that('Checking that all elements in the list are vectors', {
    testthat::expect_true(all(sapply(auc_list, is.atomic)))
  })
}

test_logistic_model_2 <- function(){
  testthat::test_that('Checking that `logistic_model_2()` exists', {
    testthat::expect_true(exists('logistic_model_2'))
  })
  
  testthat::test_that('Checking that logistic_model_2() returns a tibble', {
    testthat::expect_true(tibble::is_tibble(predictions))
  })
  
  testthat::test_that('Checking that logistic_model_1() returns a named list with the proper named elements', {
    testthat::expect_named(predictions, 
                           expected = c('year', 
                                        'auc'), 
                           ignore.order = TRUE)
  })
  
}


