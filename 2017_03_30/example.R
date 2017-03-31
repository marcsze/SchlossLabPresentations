library(dplyr)
library(tidyr)
library(ggplot2)
  
shared<- read.delim("./example.shared", header = T, sep = '\t')
tax<- read.delim("./example.taxonomy", header = T, sep = '\t')
meta <- read.delim("./example.metadata", header = T, sep = '\t')

taxonomy <- tax %>% 
  mutate(Taxonomy = gsub("\\(\\d*\\)", "", Taxonomy)) %>% 
  separate(Taxonomy, c("kingdom", "phyla", "class", "order", "family", "genus"), sep = ";")

example_plot <- shared %>% 
  select( Group, contains('Otu0')) %>% 
  gather( OTU, count, -Group)%>% 
  left_join(select(taxonomy, OTU, phyla)) %>% 
  left_join(summarise(group_by(., Group), total = sum(count))) %>% 
  mutate(rel_abund = 100 * count / total ) %>% 
  group_by(Group, phyla) %>% 
  summarise(rel_abund = sum(rel_abund)) %>% 
  left_join(select(meta, Group, disease)) %>% 
  filter(phyla != 'Acidobacteria') %>% 
  ggplot(aes(x = disease, y = rel_abund, color = disease)) +
  geom_jitter(width = 0.3, alpha = 0.2) + 
  facet_grid(. ~ phyla, scales = 'free_y') +
  stat_summary(fun.data = 'median_hilow', fun.args = (conf.int=0.5)) + 
  labs(x='', y = 'Relative Abundance') + 
  theme_bw() + 
  scale_colour_discrete(name = 'Disease') +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        legend.position = 'top')

ggsave('./example_plot.jpg', example_plot, width = 7, height = 5, units = 'in')
