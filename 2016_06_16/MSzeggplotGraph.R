# MSze Lab Meeting Code Review / Hack-a-thon
# June 23, 2016

#Load libraries used
library(ggplot2)
library(wesanderson)

test3R <- read.csv("C:/Users/marc/Desktop/test3R.csv")

RRTest <- ggplot(test3R, aes(LogFC, Study, xmax=CIUB, xmin=CILB))
HRRG1 <- RRTest + coord_cartesian(xlim=c(-2.2, 2.2)) + 
  geom_vline(xintercept = 0.0, linetype=2, alpha=0.75) + 
  geom_errorbarh(aes(colour=Region), alpha=0.5, height=0) + 
  geom_errorbarh(data = subset(test3R, Study=="Pooled Outcome"), 
                 colour="black", alpha=0.5, height=0) + 
  geom_point(aes(colour=Region), size = 3) + ylab("") + 
  xlab("Log Relative Risk") + 
  geom_point(data = subset(test3R, Study=="Pooled Outcome"), 
             colour="black", size=5) + 
  scale_color_manual(values = wes_palette("FantasticFox")) + 
  scale_size(range=c(2, 5), guide=FALSE) + 
  theme(axis.line=element_line(colour="black"), 
        axis.line.y=element_blank(), axis.ticks.y=element_blank(), 
        axis.title=element_text(size=12, face="bold"), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(), 
        text = element_text(size=15), 
        axis.text.y = element_text(face=c(
          "bold", "plain", "plain", "plain", "plain", "plain", "plain", "plain", "plain"), 
          size=c(12, 10, 10, 10, 10, 10, 10, 10, 10)), 
        legend.position="none")