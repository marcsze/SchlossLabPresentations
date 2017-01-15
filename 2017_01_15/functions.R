### List of Stored Functions
### CRC Follow up project
### Marc Sze


#This function loads and installs libraries if they are not already loaded by the user 
loadLibs <- function(deps){
  for (dep in deps){
    if (dep %in% installed.packages()[,"Package"] == FALSE){
      install.packages(as.character(dep), quiet=TRUE);
    }
    library(dep, verbose=FALSE, character.only=TRUE)
  }
}


# Run alpha diversity tests
# Order of paired samples has to already be set
get_alpha_pvalues <- function(data_table, numComp = 3, rows_names = c("sobs", "shannon", "evenness"), 
                              multi = "BH"){
  
  alpha_pvalue_table <- as.data.frame(matrix(ncol = 2, nrow = numComp, dimnames = list(rows = rows_names, 
                                                                                 cols = c("pvalue", "BH_adj_pvalue"))))
  
  for(i in 1:length(rownames(alpha_pvalue_table))){
    # The 1 is to ignore the sample names (group) column
    alpha_pvalue_table[i, 'pvalue'] <- wilcox.test(x = filter(data_table, sampleType == "initial")[, 1+i], 
                                                   y = filter(data_table, sampleType == "followups")[, 1+i], 
                                                   paired = TRUE)$p.value
  }
  
  alpha_pvalue_table$BH_adj_pvalue <- p.adjust(alpha_pvalue_table$pvalue, method = paste(multi))
  
  return(alpha_pvalue_table)
}


# Function to obtain paired wilcoxson tests on probabilities at initial and follow up
# from a given model
# dataTable must have columns named as Dx_Bin and sampleType for it to work
# probability table should have a "No" and "Yes" column for the probability call of the model
getProb_PairedWilcox <- function(dataTable, 
                                 rown = c("lesion", "all_adenoma", "carcinoma_only", "SRN_only"), 
                                 # next two variables are used to set up filtering criteria
                                 lesion_group = c("all", "cancer", "adenoma", "cancer"), 
                                 extra_specifics = c("none", "none", "adv_adenoma", "adenoma")){
  
  # create table to hold wilcoxson paired tests pvalues
  
  wilcox_pvalue_summary <- as.data.frame(matrix(
    nrow = 4, ncol = 1, dimnames = list(
      rows = rown, 
      cols = "Pvalue")))
  
  # Set up variable vector
  lesion_type <- lesion_group
  filter_diagnosis <- extra_specifics
  
  for(i in 1:length(lesion_type)){
    
    wilcox_pvalue_summary[i, "Pvalue"] <- wilcox.test(
      filter(dataTable, sampleType == "initial" & 
               Dx_Bin != paste(lesion_type[i]) & 
               Dx_Bin != paste(filter_diagnosis[i]))[, "Yes"], 
      filter(dataTable, sampleType == "followup" & 
               Dx_Bin != paste(lesion_type[i]) & 
               Dx_Bin != paste(filter_diagnosis[i]))[, "Yes"], 
      paired = TRUE)$p.value
    
  }
  
  # Add Benjamini-Hochberg correction
  wilcox_pvalue_summary <- cbind(
    wilcox_pvalue_summary, 
    BH_correction = p.adjust(wilcox_pvalue_summary$Pvalue, 
                             method = "BH")) 
  
  return(wilcox_pvalue_summary)
}


# Create function to obtain confusion summary data
# Of importance is the Mcnemar P-value for comparison of actual versus predicted similarity
# needs caret to work properly and needs a meta data table with a column called Disease_Free
# Disease_Free needs to be in a "y"/"n" format
get_confusion_data <- function(dataTable, metaData){
  
  loadLibs(c("caret", "dplyr"))
  #add needed columns for the testing
  dataTable <- mutate(
    dataTable, 
    predict_call = factor(ifelse(Yes > 0.5, "Yes", "No"))) %>% 
    mutate(
      initial_call = factor(c(rep("Yes", length(rownames(metaData))), 
                              ifelse(metaData$Disease_Free == "n", "Yes", "No"))))
  
  #run testing on all the data
  confusion_all <- confusionMatrix(dataTable$predict_call, dataTable$initial_call, 
                                   positive = "Yes")
  
  #run testing based on initial only
  confusion_initial <- confusionMatrix(
    dataTable$predict_call[1:length(rownames(metaData))], 
    dataTable$initial_call[1:length(rownames(metaData))], 
    positive = "Yes")
  
  #run testing based on follow up only
  confusion_follow <- confusionMatrix(
    dataTable$predict_call[(length(rownames(metaData))+1):
                                         length(rownames(dataTable))], 
    dataTable$initial_call[(length(rownames(metaData))+1):
                                         length(rownames(dataTable))], positive = "Yes")
  
  #aggregate all the tests together into a single summary file to be read out
  confusion_summary <- cbind(
    all = c(confusion_all$overall, confusion_all$byClass), 
    initial = c(confusion_initial$overall, confusion_initial$byClass), 
    followup = c(confusion_follow$overall, confusion_follow$byClass))
}


# This function creates a confusion table
# Needs to have a metadata data with the column "Disease_Free"
# This column needs to be in the format of "n"/"y"
make_confusionTable <- function(dataTable, metaData, n = 1, m = 66){
  
  #add needed columns for the testing
  dataTable <- mutate(
    dataTable, 
    predict_call = factor(ifelse(Yes > 0.5, "Yes", "No"))) %>% 
    mutate(
      initial_call = factor(c(rep("Yes", length(rownames(good_metaf))), 
                              ifelse(metaData$Disease_Free == "n", "Yes", "No"))))
  
  temp_list <- confusionMatrix(
    dataTable$predict_call[n:m], 
    dataTable$initial_call[n:m], 
    positive = "Yes")
  
  c_table <- matrix(temp_list$table, nrow = 2, ncol = 2, 
                            dimnames = list(nrow = c("pred_no", "pred_yes"), 
                                            ncol = c("ref_no", "ref_yes")))
}

















