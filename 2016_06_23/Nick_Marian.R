# MSze Lab Meeting Code Review / Hack-a-thon
# Nick and Marian's Attempt at decent graphing skillz
# June 23, 2016

#Load libraries used
library(ggplot2)
library(wesanderson)
library(cowplot)

setwd("~/git_repos/SchlossLabPresentations/2016_06_23")

test3R <- read.csv("test3R.csv")

# THE PLAN
# Facet pooled outcome
# Order by year, point size represents the size of the study 

data <- test3R
stud <- as.character(test3R$Study)
172 + 63 + 507 + 30 + 200 + 256 + 63 + 146
stud[1] <- c("Pooled Outcome, All Studies, Total=1437")
stud2 <- stud
stud3 <- strsplit(stud2, ",")
stud4 <- rbind(unlist(stud3[[1]]),unlist(stud3[[2]]),unlist(stud3[[3]]),
              unlist(stud3[[4]]),unlist(stud3[[5]]),unlist(stud3[[6]]),
              unlist(stud3[[7]]),unlist(stud3[[8]]),unlist(stud3[[9]]))
stud5 <- cbind(test3R, stud4)

colnames(stud5) <- c("X","Study","LogFC","CILB","CIUB","p",
                     "interval","RelConf","Region","stud","Year","Size")

# There were secret spaces before "n="!
stud5$size2 <- factor(stud5$size, levels = c(" n=507", " n=256", " n=200", " n=172", 
                        " n=146"," n=63", " n=30"," Total=1437"))

# Set up the main plot
plot <- ggplot(stud5, aes(LogFC, stud, xmax=CIUB, xmin=CILB)) + 
  coord_cartesian(xlim=c(-2.2, 2.2)) + 
  geom_vline(xintercept = 0.0, linetype=2, alpha=0.75) + 
  geom_errorbarh(data = subset(stud5, stud=="Pooled Outcome"), 
                 colour="black", alpha=0.5, height=0) + 
  xlab("Log Relative Risk") + 
  geom_point(data = subset(stud5, stud=="Pooled Outcome"), 
             colour="black", size=5) +
  ylab("") +
  theme_classic() 

  
year <- plot + 
  facet_grid(Year~., scales="free", space = "free_y") + 
  geom_point(aes(colour=Year), size = 3) + 
  geom_errorbarh(aes(colour=Year), alpha=0.5, height=0) + 
  scale_color_brewer(palette = "Set1") +
  ggtitle("Study Year")

study_size <- plot + 
  facet_grid(Size~., scales="free", space = "free_y") + 
  geom_point(aes(colour=Size), size = 3) +  
  geom_errorbarh(aes(colour=Size), alpha=0.5, height=0) + 
  scale_color_brewer(palette = "Set3") + 
  ggtitle("Study Size")

region_16s <- plot + 
  facet_grid(Region~., scales="free", space = "free_y") +
  geom_point(aes(colour=Region), size = 3) + 
  geom_errorbarh(aes(colour=Region), alpha=0.5, height=0) + 
  scale_color_manual(values = wes_palette("FantasticFox")) +
  ggtitle("16S Region")

plot_grid(year, study_size, region_16s, labels = c("A", "B", "C"), 
          nrow = 1, ncol = 3)

