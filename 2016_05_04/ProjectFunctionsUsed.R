## Negative Contamination Project
## Functions Used for the analysis
## Start Date: April 28th, 2016
## Marc Sze


#Create Tables based on different cutoffs
#Use Lazarevic Defined Cutoffs of 1, 0.1, 0.01, 0.001
#If ratio is larger than defined cutoff call it contamination and remove
#Get the overall Percentage of OTUs that remain after subtraction
SimRemoval <- function(RatioData, TotalOTU, colNames, colsN=10){
  SimQPCRTotal <- matrix(0, nrow=6, ncol=colsN)
  cutoffs <- c(1, 0.1, 0.01, 0.001, 0.0001, 0.00001)
  for (j in 1:10){
    test <- as.vector(as.matrix(RatioData[j, ]))
    total <- rep(0, 6)
    #Get the number eliminated at each cutoff
    for(i in 1:6){
      total[i] <- length(test[which(test < cutoffs[i])])
    }
    
    #Needs to be added to a data matrix
    SimQPCRTotal[, j] <- (total/TotalOTU)*100
  }
  #Convert the stored data to a data frame and name rows and columns
  SimQPCRTotal <- as.data.frame(SimQPCRTotal)
  rownames(SimQPCRTotal) <- cutoffs
  colnames(SimQPCRTotal) <- Amount16S
  return(SimQPCRTotal)
}

#Create Table with the right format for graphing
#Needs either reshape or reshape2 to run
MakeTableForGraph <- function(data, ID, variable, value){
  test <- melt(data, id=c(ID))
  colnames(test)[2:3] <- c(variable, value)
  test[, 2] <- as.numeric(as.character(test$Amount))
  test[, 1] <- factor(test$Ratio, levels=c("1", "0.1", "0.01", "0.001", 
                                           "1e-04", "1e-05"), 
                      labels=c("1", "0.1", "0.01", "0.001", "1e-04", "1e-05"))
  return(test)
}

#Creates a graph with Percent OTUs Removed on the Y-axis and 16S Amount on 
#the X-axis.  With each group coloured by the ratio used
#Must have ggplot2 to run the function properly

GraphSimData <- function(data, yintercept1, yintercept2, minY, maxY, gtitle){
  a1 <- ggplot(data, aes(data[,2], data[,3]))
  a2 <- a1 + geom_line(aes(colour = Ratio), size=1.5, alpha=7/10) + 
    geom_point(aes(colour = data[,1]), size=4) + 
    scale_colour_brewer(palette="Set1", name = "Ratio") + 
    scale_x_log10(breaks=c(0, 1e1, 1e2, 1e3, 1e4, 1e5, 
                           1e6, 1e7, 1e8, 1e9, 1e10)) +  ylim(minY, maxY) + 
    xlab("16S Amount") + ylab("Percent OTUs Remaining") + 
    theme(axis.text=element_text(size=8), 
          axis.title=element_text(size=10, face="bold"), 
          axis.line=element_line(colour="black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(), 
          legend.key = element_rect(fill = "white")) +  
    geom_hline(aes(yintercept=yintercept1), linetype="twodash") + 
    geom_hline(aes(yintercept=yintercept2), linetype="dashed") + ggtitle(gtitle) + 
    theme(plot.title=element_text(hjust=0, face="bold", size=20))
  return(a2)
}


#Create plot to show what happens to data after "soft" subtraction
#Make a barplot with given data and select which values from table
#To plot within it.  Displays in black and white.
#Need to have ggplot2 to have function work properly 
GraphBarPlot <- function(dataTable, i, j, gtitle){
  a1 <- ggplot(dataTable, aes(x=dataTable[,i], y=dataTable[, j])) + 
    geom_bar(stat="identity") + xlab(colnames(dataTable)[i]) + 
    ylab(colnames(dataTable)[j]) + 
    theme(axis.text=element_text(size=8), 
          axis.title=element_text(size=10, face="bold"), 
          axis.line=element_line(colour="black"), 
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          panel.border = element_blank(), 
          panel.background = element_blank(), 
          legend.key = element_rect(fill = "white")) + 
    scale_y_continuous(expand=c(0,0)) + coord_flip() + ggtitle(gtitle) + 
    theme(plot.title=element_text(hjust=0, face="bold", size=20))
  return(a1)
}

