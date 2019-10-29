#! /usr/lib64/R/bin/exec

DELIMITER='\t'
stdin <- file(description="stdin",open="r")

inputDF <- data.frame();

# Need to know the type of input columns. Cite them in following vector to feed
# the colClasses argument of the read.table() function.
#cv <- c("numeric","numeric","numeric","numeric")
cv <- c("numeric", "numeric","numeric","numeric","numeric"
        ,"numeric","numeric","numeric","numeric", "numeric"
        ,"numeric","numeric","numeric","numeric", "numeric"
        ,"numeric","numeric","numeric","numeric", "numeric"
        ,"numeric","numeric","numeric","numeric" ,  "numeric"
        ,"numeric","numeric","numeric","numeric", "numeric"
        ,"numeric","numeric","numeric","numeric", "numeric"
        ,"numeric","numeric","numeric","numeric", "numeric"
        ,"numeric","numeric","numeric","numeric", "numeric")

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
names(inputDF)[2]="Asegurado_id" 
names(inputDF)[3]="Ind_Ramo_Canal_Vigente" 
names(inputDF)[4]="Meses_Antiguedad_Ramo_Canal" 
names(inputDF)[5]="Canal_Agrup_Id" 

names(inputDF)[6]="Ind_Exequial" 
names(inputDF)[7]="Ind_Accidentes_Personales" 
names(inputDF)[8]="Ind_Automoviles" 
names(inputDF)[9]="Ind_Hogar" 
names(inputDF)[10]="Ind_SuRenta" 

names(inputDF)[11]="Ind_MasVida" 
names(inputDF)[12]="Ind_Soat" 
names(inputDF)[13]="Ind_Renta_Educativa" 
names(inputDF)[14]="Ind_Otros_Personales" 
names(inputDF)[15]="Ind_Salud" 

names(inputDF)[16]="Ind_Otros_Empresariales" 
names(inputDF)[17]="Ind_Arrendamiento" 
names(inputDF)[18]="Ind_Renta_Pensional" 
names(inputDF)[19]="Ind_Desempleo" 
names(inputDF)[20]="Ind_Vida" 

 names(inputDF)[21]="Produccion_Emitida_Grupo_Cliente" 
 names(inputDF)[22]="Porc_RT_Grupo_Cliente" 
 names(inputDF)[23]="Frecuencia_Anual_Siniestros_Grupo_Cliente" 
 names(inputDF)[24]="Monto_Pagado_Siniestros_Grupo_Cliente" 
names(inputDF)[25]="Recencia_Meses_Ultimo_Siniestros_Grupo_Cliente" 

names(inputDF)[26]="Cont_Compania_Cliente" 
names(inputDF)[27]="Regional_Contacto_id" 
names(inputDF)[28]="Sexo_id" 
names(inputDF)[29]="Edad" 
names(inputDF)[30]="Numero_Hijos" 

names(inputDF)[32]="Ind_Dependientes_Mayores18" 
names(inputDF)[33]="Nivel_Ingreso_id" 
names(inputDF)[34]="Nivel_Estudios_id" 
names(inputDF)[35]="Estado_Civil_id" 

names(inputDF)[36]="Ind_Independiente" 
names(inputDF)[37]="Cont_Quejas" 
names(inputDF)[38]="Cont_Peticion" 
names(inputDF)[39]="Cont_Inquietud" 
names(inputDF)[40]="Ind_Tipo_Negocio_Colectivo" 

names(inputDF)[41]="Ind_Forma_Pago_Mensual" 
names(inputDF)[42]="Ind_Forma_Pago_Anual" 
names(inputDF)[43]="Ind_Tipo_Pago_Caja_Sura" 
names(inputDF)[44]="Ind_Tipo_Pago_Financiacion_Sura" 
names(inputDF)[45]="Extra" 


#
#newdata0<-inputDF[c(1,500, 600, 700, 750,800),]
library(survival)


inputDF$Canal_Agrup_Id <- factor(inputDF$Canal_Agrup_Id)
inputDF$Regional_Contacto_id <- factor(inputDF$Regional_Contacto_id)
inputDF$Sexo_id <- factor(inputDF$Sexo_id)
inputDF$Nivel_Ingreso_id <- factor(inputDF$Nivel_Ingreso_id)
inputDF$Nivel_Estudios_id <- factor(inputDF$Nivel_Estudios_id)
inputDF$Estado_Civil_id <- factor(inputDF$Estado_Civil_id)




#inputDF1=rbind(inputDF, unregistro)

#modelocoxph <- coxph(Surv(time, delta) ~ race + gender , data = inputDF)
modelocoxph <- coxph(Surv(Meses_Antiguedad_Ramo_Canal, Ind_Ramo_Canal_Vigente) ~ . , data = inputDF)

#
#modelo<-survfit(modelocoxph, conf.type = "log-log",type = "kaplan-meier",newdata =newdata0 )


save(modelocoxph, file="/tmp/modelocoxph.RData")


#modelo<-survfit(modelocoxph, conf.type = "log-log",type = "kaplan-meier",newdata =inputDF )




#output = as.data.frame(modelo$surv[2,1:3])
#output=data.frame(inputDF$id, modelo$surv[2,1:length(modelo$surv[2,])])
output=data.frame(modelocoxph$coefficients)
#output=data.frame(inputDF1$id)



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
