# Random number generator function
# Marc Sze

# Load in tidyverse library
library(tidyverse)


random_draw <- function(groups){
 
  number_of_groups <- paste("g_", 1:groups, sep = "")
  
  a <- "blank"
  
  for(sampling_round in 1:length(number_of_groups)){
    
    Sys.sleep(5)
    
    if(sampling_round == 1){
      
      temp_groups <- number_of_groups
    } else{
      
      temp_groups <- temp_groups[!temp_groups %in% choice]
    }
    
    
    choice <- sample(temp_groups, size = 1)
    
    
    if(sampling_round == 1){
      
      print(paste("Congratulations ", choice, " you get to choose first!", sep = ""))
    } else if(sampling_round != length(number_of_groups)){
      
        print(paste(choice, " you get to choose next.", sep = ""))
    } else{
      
      print(paste("Unfortunately, ", choice, " you get to choose last.", sep = ""))
    }
    
    
    
  }
  
}



random_draw(3)








