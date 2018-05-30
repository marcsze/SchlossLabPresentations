# Random number generator function
# Marc Sze

# Load in tidyverse library
library(tidyverse)


random_draw <- function(groups){
  
  number_of_groups <- paste("g_", 1:groups, sep = "")
  
  a <- "blank"
  
  for(sampling_round in 1:length(number_of_groups)){
    
    if(sampling_round == 1){
      
      temp_groups <- number_of_groups
    } else{
      
      temp_groups <- temp_groups[!temp_groups %in% choice]
    }
    
    
    choice <- sample(temp_groups, size = 1)
    
    
    
    print(choice)
    
    Sys.sleep(3)
  }
  
}



random_draw(4)








