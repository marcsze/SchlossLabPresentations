## Journal Club
## July 14th, 2016
## Marc Sze

# Load needed libraries
library(ggplot2)


# Read data into R
supplData <- read.csv("mmc2.csv", header=T, stringsAsFactors = FALSE)

# In order to use FDR p-values need to be normally distributed/uniformaly distributed
phist <- ggplot(supplData, aes(x=CE_to_ACE_p))
phist + geom_histogram(fill = "white", colour = "black", bins = 20) + 
  theme_bw() + xlab("P-values")
      # P-values are Not normally distributed
  #Do not look at this distribution and say, 
  #“Oh, I guess I don’t have any significant hypotheses.” 
  #If you had no significant hypotheses, your p-values would look 
 #something like (B) above. P-values are specifically designed so that they are uniform 
# under the null hypothesis. A graph like this indicates something is wrong with your test. 
# Perhaps your test assumes that the data fits some distribution that it doesn’t fit. 
# Perhaps it’s designed for continuous data while your data is discrete, 
# or perhaps it is designed for normally-distributed data and your data is severely non-normal. 
# In any case, this is a great time to find a friendly statistician to help you.
#(Update 12/17/14: Rogier in the comments helpfully notes another possible explanation: 
# your p-values may have already been corrected for multiple testing, 
# for example using the Bonferroni correction. If so, you might want to get your hands on 
# the original, uncorrected p-values so you can view the histogram yourself and confirm it’s 
# well behaved!)

# Check to see if second FDR p-values groups are normally distributed
notOTUsupplData <- supplData[which(supplData$Level != "OTU"), ] 
phist2 <- ggplot(notOTUsupplData, aes(x=CE_to_ACE_p))
phist2 + geom_histogram(fill = "white", colour = "black", bins = 20) + 
  theme_bw() + xlab("P-values") + ylim(0, 35)

# Need to see if having more significant duplicated values effects results
noOnePvalues <- supplData[which(supplData$CE_to_ACE_p < 1), ]
noOnePvalues <- noOnePvalues[order(noOnePvalues$CE_to_ACE_p, decreasing = TRUE), ]
noOnePvalues <- noOnePvalues[!duplicated(noOnePvalues$CE_to_ACE_p),]
UniquenotOTUsupplData <- noOnePvalues[which(noOnePvalues$Level != "OTU"), ] 
phist3 <- ggplot(UniquenotOTUsupplData, aes(x=CE_to_ACE_p))
phist3 + geom_histogram(fill = "white", colour = "black", bins = 20) + 
  theme_bw() + xlab("P-values") + ylim(0, 35)


#collect data on number of P < 0.05 lost after duplicate removal

beforeSub <- nrow(notOTUsupplData[which(notOTUsupplData$CE_to_ACE_p < 0.05), ])
afterSub <- nrow(UniquenotOTUsupplData[which(UniquenotOTUsupplData$CE_to_ACE_p < 0.05), ])


