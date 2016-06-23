# Team Unicorn
# Practice code for lab meeting
# Date: 2016-06-23

library(ggplot2)
library(colorbrewer)

# Load in the data
input <- read.delim("./test3R.csv", header=TRUE, sep=",")
#input <- input[factor(input$Study, levels()]
input$Study <- factor(input$Study, levels=input$Study)

# Plot the data
ggplot(input, aes(x=factor(Study), y=LogFC, colour=Region)) +
	theme_bw() +
	geom_point() +
	geom_errorbar(aes(ymin=CILB, ymax=CIUB), width=0.25) +
	coord_flip() +
	scale_color_brewer(palette="Set1", na.value="Black") +
	geom_hline(aes(yintercept=0), linetype="dashed") +
	xlab("Study") +
	ylab("Log Scale") +
	theme(axis.title.x = element_text(face="bold") , axis.title.y= element_text(face="bold"))+
	ggtitle("Marc's data, unicorn style")
