#! /usr/lib64/R/bin/exec

DELIMITER='\t'
stdin <- file(description="stdin",open="r")

inputDF <- data.frame();

# Need to know the type of input columns. Cite them in following vector to feed
# the colClasses argument of the read.table() function.
#cv <- c("numeric","numeric","numeric","numeric")
cv <- c("numeric","numeric","numeric","numeric","numeric", "numeric")

inputDF <- try(read.table(stdin, sep=DELIMITER, flush=TRUE, header=FALSE, quote="", na.strings="", colClasses=cv), silent=TRUE)

close(stdin)

# For AMPs that receive no data, choose to simply quit the script immediately.
if (class(inputDF) == "try-error") {
    inputDF <- NULL
    quit()
}
#installed.packages("survival")
library(survival)
# Create dataframe with model-dependent vars. Select them from the inputDF.

names(inputDF)[1]="c1" 
names(inputDF)[2]="id" 
names(inputDF)[3]="time" #
names(inputDF)[4]="delta" 
names(inputDF)[5]="gender" 
names(inputDF)[6]="race" #

#newdata0<-inputDF[c(1,500, 600, 700, 750,800),]
#
library(survival)
#modelocoxph <- coxph(Surv(time, delta) ~ race + gender , data = inputDF)

#modelo<-survfit(modelocoxph, conf.type = "log-log",type = "kaplan-meier",newdata =newdata0 )

load(file="/tmp/modelocoxph.RData")

#load(file="./DWH_STAGE/modelocoxph.RData");

modelo<-survfit(modelocoxph, conf.type = "log-log",type = "kaplan-meier",newdata =inputDF )
#modelo<-survfit(modelocoxph,newdata =inputDF )



#output = as.data.frame(modelo$surv[2,1:3])
output=data.frame(inputDF$id, modelo$surv[2,1:length(modelo$surv[2,])])
#output=data.frame(modelocoxph$coefficients)
	


#output=data.frame(modelo$surv)

#res<-summary(modelo,times=c(1,100))
#res<-summary(modelo)

#salida=data.frame(t(cbind(Tiempo=res$time,res$surv)))
#out=salida$X2

#out=inputDF

#dataDF <- data.frame(out);

# Build export data frame:
# output <- data.frame(out);
#output <- data.frame(salida);

# Export results to Teradata through standard output
#write.table(output, file=stdout(), col.names=FALSE, row.names=FALSE,quote=FALSE, sep="\t", na="")
 write.table(output, file=stdout(), col.names=FALSE, row.names=FALSE,quote=FALSE, sep="\t", na="")
