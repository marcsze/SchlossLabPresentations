

test_table <- read.delim('~/Desktop/test3R_edited.csv', header=TRUE, sep='\t')

par(mar=c(4,11,1,1))
dotchart(rev(test_table$LogFC), yaxt="n", xlab="Log Relative Risk", pch=19, xlim=c(-2,2), lcolor='white',
         color=rev(c('firebrick', 'firebrick', 'darkgoldenrod1','darkgoldenrod1','darkgoldenrod1','dodgerblue','dodgerblue','darkorange2','black')))
abline(v=0, lty=2)
axis(2, at=c(1:9), labels = rev(test_table$Study), las=1, tick = F)
segments(x0=c(rev(test_table$CILB)), y0=c(1:9), x1=c(rev(test_table$CIUB)), y1=c(1:9), col = rev(c('firebrick', 'firebrick', 'darkgoldenrod1','darkgoldenrod1','darkgoldenrod1','dodgerblue','dodgerblue','darkorange2','black')))
points(x=0.2616398, y=1,pch=19,col='black', cex=2)
