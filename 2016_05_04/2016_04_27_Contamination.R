## Negative Contamination Project Part 1
## Start Date: April 27th, 2016
## Marc Sze

# First part I want to test whether the proposed correction method by Lazarevic, 
# et al. break down at lower 16S concentrations.  I plan to do this by modelling
# different values for total 16S of a MOCK community.  This data will be based on
# a total 16S count of ~1x10^2 (a rough average from Sze, et al. 2012 and
# Lazarevic, et al. 2016).

#Load in custom functions to be used
source("ProjectFunctionsUsed.R")

#Read in the shared file with all samples and remove unnecessary columns
data <- read.table("contaminant.shared", header=TRUE)
rownames(data) <- data[, 2]
data <- data[, -c(1:3)]

#Create MOCK Community and Negative data frames
mockData <- data[c(9:26), ]
negData <- data[c(27:42), ]

#Store total OTU, Total Mock OTU, and Total Negative OTU Counts
TotalOTU <- sum(apply(data[c(9:42), ], 2, function(c)sum(c!=0)) > 0)
TotalMockOTU <- sum(apply(mockData, 2, function(c)sum(c!=0)) > 0)
TotalNegOTU <- sum(apply(negData, 2, function(c)sum(c!=0)) > 0)

#Get total OTUs if using a "hard" subtraction
keep <- which(apply(data[c(9:42), ], 2, function(c)sum(c!=0)) > 0)
CombinedData <- data[(9:42), keep]
keep <- which(apply(CombinedData[c(19:34), ], 2, function(c)sum(c!=0)) > 0)
TotalMockOTUHardCut <- length(colnames(CombinedData[,-keep]))

#Get total OTUs if using a "soft" subtraction
MOCKOnlySoft <- CombinedData[-c(19:34),]
MOCKOnlySoft <- rbind(MOCKOnlySoft, colMeans(CombinedData[c(19:34),]))
MOCKOnlySoftdata <- sapply(MOCKOnlySoft, function(x) x-x[19])
rownames(MOCKOnlySoftdata) <- rownames(MOCKOnlySoft)
MOCKOnlySoftdata <- MOCKOnlySoftdata[-19,]
MOCKOnlySoftdata[MOCKOnlySoftdata<0] <- 0
MOCKOnlySoftdata <- as.data.frame(MOCKOnlySoftdata)
keep <- which(apply(MOCKOnlySoftdata, 2, function(c)sum(c!=0)) > 0)
TotalMockOTUSoftCut <- length(colnames(MOCKOnlySoftdata[,keep]))

#Get a table with before and after "Soft" Subtraction for an OTU
SoftComparison <- as.data.frame(cbind(MOCKOnlySoftdata[, 21], 
                                      CombinedData[c(1:18), 21]))
SoftComparison <- cbind(SoftComparison, rownames(SoftComparison))
colnames(SoftComparison) <- c("SoftOTU21", "OrigOTU21", "Group")

#Get total sequence counts for each sample
MockSeqTotal <- rowSums(mockData)
NegSeqTotal <- rowSums(negData)

#Generate relative abundance values for each mock and negative sample
RelAbundMockData <- mockData/MockSeqTotal
RelAbundNegData <- negData/NegSeqTotal

#Generate average relative abundance for mock and negative groups
MeanRelAbundMock <- colMeans(RelAbundMockData)
MeanRelAbundNeg <- colMeans(RelAbundNegData)

#Create a for loop to iterate through and apply the correction factor to each
#specific OTU and generate the ratio
Amount16S <- c(1E10, 1E9, 1E8, 1E7, 1E6, 1E5, 1E4, 1E3, 1E2, 1E1)
dataStorage <- matrix(0, nrow=10, ncol=499)

for(i in 1:10){
 MockAbund <- MeanRelAbundMock * Amount16S[i]
 NegAbund <- MeanRelAbundNeg * 100
 dataStorage[i, c(1:499)] <-  NegAbund/MockAbund
}

#Rename table and make it a data frame
dataStorage <- as.data.frame(dataStorage)
colnames(dataStorage) <- colnames(mockData)
rownames(dataStorage) <- Amount16S

#Remove NAs (Result from 0/0) and Infs (Result from value/0)
RatioData <- do.call(data.frame, lapply(dataStorage, function(x) replace(
  x, is.infinite(x), NA)))
RatioData <- RatioData[, colSums(is.na(RatioData)) == 0]
rownames(RatioData) <- rownames(dataStorage)

#Create Tables based on different cutoffs
#Use Lazarevic Defined Cutoffs of 1, 0.1, 0.01, 0.001
#If ratio is larger than defined cutoff call it contamination and remove
#Get the overall Percentage of OTUs that remain after subtraction
SimLazarevicALLRemoval <- SimRemoval(RatioData, TotalOTU, Amount16S)


#Investigate how it performs for the "Real" MOCK sequences
realSeqMockData <- RatioData[c(1:10), c(1:17, 19:20)]
SimLazarevicMOCKReal <- SimRemoval(realSeqMockData, 
                                   length(colnames(realSeqMockData)), Amount16S)

#Create data table for first graph visualization of the data
library(ggplot2)
library(reshape2)
SimLazarevicALLRemoval <- cbind(SimLazarevicALLRemoval, 
                                rownames(SimLazarevicALLRemoval))
colnames(SimLazarevicALLRemoval)[11] <- "Ratio"
test1 <- MakeTableForGraph(SimLazarevicALLRemoval, "Ratio", "Amount", "Percent")

#First Graph of the 16S amount versus the percent OTUs Removed based on a
#specified cutoff ratio.  Dotted line represents the percent of OTUs removed
#with a "hard" cutoff.
GraphMockSimALL <- GraphSimData(test1, (TotalMockOTUHardCut/TotalOTU)*100, 
                                (TotalMockOTUSoftCut/TotalOTU)*100, 
                                50, 100, gtitle='A')

#Create data table for second graph visualization of the data
#For known bacteria in the MOCK does the subtraction remove real signal?
SimLazarevicMOCKReal <- cbind(SimLazarevicMOCKReal, 
                                rownames(SimLazarevicMOCKReal))
colnames(SimLazarevicMOCKReal)[11] <- "Ratio"
test2 <- MakeTableForGraph(SimLazarevicMOCKReal, "Ratio", "Amount", "Percent") 

#Second Graph of the 16S amount versus the percent OTUs Removed based on a
#specified cutoff ratio.  Dotted line represents the percent of OTUs removed
#with a "hard" cutoff. This graph shows the loss of actual 16S that should be
#in the sample.

GraphMOCKSimReal <- GraphSimData(test2, (14/19)*100, (19/19)*100, 
                                 50, 100, gtitle='B')

#Adding the two graphs together
library(gridExtra)
grid.arrange(GraphMockSimALL, GraphMOCKSimReal)

#Create plot to show what happens to data after "soft" subtraction
GraphOrigOTU21 <- GraphBarPlot(SoftComparison, 3, 2, "A")
GraphSoftOTU21 <- GraphBarPlot(SoftComparison, 3, 1, "B")
grid.arrange(GraphOrigOTU21, GraphSoftOTU21, ncol=2)



