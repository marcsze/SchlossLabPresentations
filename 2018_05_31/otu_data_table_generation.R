

# Load in tidyverse library
library(tidyverse)

# Make it reproducible
set.seed(12345)

# Create the toy data table
test <- bind_cols(otu_1 = sample(10, replace = T), otu_2 = sample(10, replace = T), otu_3 = sample(10, replace = T), 
                   otu_4 = sample(10, replace = T), otu_5 = sample(10, replace = T), otu_6 = sample(10, replace = T), 
                   otu_7 = sample(10, replace = T), otu_8 = sample(10, replace = T), otu_9 = sample(10, replace = T), 
                   otu_10 = sample(10, replace = T)) %>% 
  mutate(individual = paste("patient_", 1:10, sep = ""), 
         disease = c(rep("case", 5), rep("control", 5)), 
         total_reads = rowSums(as.data.frame(select(., contains("otu"))))) %>% 
  mutate_at(vars(otu_1:otu_10), function(x) x/.$total_reads) %>% 
  gather("otu", "rel_abund", otu_1:otu_10) %>% 
  mutate(taxa = case_when(
    otu == "otu_1" ~ "Lachnospiraceae", 
    otu == "otu_2" ~ "Blautia", 
    otu =="otu_3" ~ "Escherichia", 
    otu == "otu_4" ~ "Clostridium", 
    otu == "otu_5" ~ "Ruminococcus", 
    otu == "otu_6" ~ "Lactobacillus", 
    otu == "otu_7" ~ "Eubacterium", 
    otu =="otu_8" ~ "Enterobacteriaceae", 
    otu == "otu_9" ~ "Faecalibacterium", 
    otu == "otu_10" ~ "Bacteroides"))

# Write out the csv to the directory  
write_csv(test, "SchlossLabPresentations/2018_05_31/otu_table.csv")

# This was used to check if the graph output was the same
test %>%
  filter(otu == "otu_1") %>% 
  ggplot(aes(disease, rel_abund, fill = disease)) +
  geom_boxplot(position = position_dodge(width = 1))

# An example of map for plotting
# trial <- test %>% group_by(otu) %>% 
#   nest() %>% 
#   mutate(test = map(data, ~ ggplot(., aes(disease, rel_abund, fill = disease)) +
#       geom_boxplot(position = position_dodge(width = 1))))
# 
# trial$test

  
  

    

