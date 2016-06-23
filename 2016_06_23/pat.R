data <- read.csv(file="test3R.csv", header=TRUE, stringsAsFactors=F)

#Sort by log relative risk, but keep pooled last
o <- c(1, order(data$LogFC[-1], decreasing=T)+1)
data <- data[o,]


#Get rid of dates and put sample size in parentheses
study_name <- gsub(", .*, n(=\\d*)", " (N\\1)", data$Study)


#Color points by the region that they came from
colors <- c("V4"="red", "V1-V3"="blue", "V3-V5"="green", "V2"="orange")

par(mar=c(4,9,0.5,0.5))
plot(NA, ylim=c(1,9), xlim=c(min(data$CILB),2), axes=F, xlab="", ylab="")

#Need to call abline first so that this goes behind the points
abline(v=0, lty=3, col="gray", lwd=2)

#Plot the logRR points for the individual studies with their error
#bars
points(x=data$LogFC[-1], y=2:9, pch=19, col=colors[data$Region[-1]])
segments(x0=data$CILB[-1], x1=data$CIUB[-1], y0=2:9, col=colors[data$Region[-1]], lty=1, lwd=2)

#Plot the logRR points for the pooled analysis with its error bar
points(x=data$LogFC[1], y=1, col="black", pch=19, cex=2)
segments(x0=data$CILB[1], x1=data$CIUB[1], y0=1, col="black", lty=1, lwd=2)

box()
axis(1)

#Wasn't able to vectorize font parameter
axis(2, at=2:9, label=study_name[-1], las=2, tick=FALSE)
axis(2, at=1, label=study_name[1], las=2, tick=FALSE, font=2)

#Did't like where plot put the x-axis label
mtext(side=1, at=0, line=2.2, text="Log Relative Risk")


legend(x=1.25, y=2.5, legend=c("V4", "V1-V3", "V3-V5", "V2"), pch=19, col=colors)
