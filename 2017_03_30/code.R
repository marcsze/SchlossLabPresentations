### Code fo Code Review
### March 26, 2017
### Marc Sze

# Load in needed libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

# Create the data set to be used in the example
shared <- read.delim("final.shared", header = T) %>% slice(1:30) %>% 
  select(Group, numOtus, label, num_range("Otu00000", 1:9), num_range("Otu0000", 10:60))

taxonomy <- read.delim("final.taxonomy", header = T) %>% slice(1:60)

# Write out the data set
write.table(shared, "example.shared", sep = "\t", row.names = FALSE)
write.table(taxonomy, "example.taxonomy", sep = "\t", row.names = FALSE)

# Use this table to re-read data into R
shared <- read.delim("example.shared", stringsAsFactors = F, header = T) %>% select(-label, -numOtus)
taxonomy <- read.delim("example.taxonomy", stringsAsFactors = F, header = T)

# Get total counts
counts <- rowSums(select(shared, -Group))

################# For OTU level

# Divide by total counts and multiply by 100 to get percent relative abundance
otu.rel.abund <- shared
otu.rel.abund[, colnames(select(otu.rel.abund, -Group))] <- apply(
  select(otu.rel.abund, 
         contains("Otu")), 2, function(x) (x/counts)*100) 
otu.rel.abund <- gather(otu.rel.abund, otu, value = per.rel.abund, -Group)

################ For taxa level (phyla)

# Remove all the (100) from the taxa file
new_taxonomy <- taxonomy %>% mutate(Taxonomy = gsub("\\(\\d*\\)", "", Taxonomy))

# Seperate calls based on ;
# Some warnings are outputted but that should be okay
new_taxonomy <- separate(new_taxonomy, Taxonomy, c("kingdom", "phyla", "class", "order", "family", "genus"), sep = ";") %>% select(-Size)

# Store the phyla information in a separate vector for later use
phyla_call <- new_taxonomy$phyla

# Create a melted data frame with otu count data and not per.rel.abund
temp_shared <- gather(shared, otu, value = count_number, -Group)

# Create a vector with the appropriate sized phyla calls
taxa_call <- c()
for(i in 1:length(phyla_call)){
  
  taxa_call <- c(taxa_call, rep(phyla_call[i], length(rownames(shared))))
}

# Add this vector to the temp shared file
temp_shared <- mutate(temp_shared, taxa_call = taxa_call)

# group by sample and phyla and then summarize the counts
# Need to convert to a data frame because dplyr converts to a special type of table which cannot be mutated to
phyla_data <-as.data.frame(group_by(temp_shared, Group, taxa_call) %>% 
                        summarise_each(funs(total = sum(.)), starts_with("count_number")))

# Create a vector with the total count per sample information to be added to the phyla_data table
expanded_counts <- c()
for(j in 1:length(counts)){
  
  expanded_counts <- c(expanded_counts, rep(counts[j], length(unique(temp_shared$taxa_call))))
}

# Add a total count and per.rel.abund column for the phyla data table
phyla_data <- phyla_data %>% mutate(total_counts = expanded_counts, per.rel.abund = (total/expanded_counts)*100)


# Generate a bar plot so we can see if data look similar

example_fig <- ggplot(phyla_data, aes(factor(Group), per.rel.abund, fill = taxa_call)) + 
  geom_bar(position = "fill", stat = "identity") + 
  scale_y_continuous(labels = percent_format(), expand = c(0,0)) + 
  scale_fill_discrete(name = "Phyla") + 
  coord_flip() + theme_bw() + 
  xlab("Sample") + ylab("% Relative Abundance") + 
  theme(plot.title = element_text(face = "bold"), 
        legend.title = element_text(face = "bold"), 
        axis.title = element_text(face = "bold"))

ggsave(file = "example_fig.png", example_fig, 
       width=6, height = 6, dpi = 300)




