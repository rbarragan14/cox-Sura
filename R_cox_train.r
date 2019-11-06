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
        ,"numeric","numeric","numeric","numeric", "numeric"
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
library(dplyr)

# Create dataframe with model-dependent vars. Select them from the inputDF.


names(inputDF)[1]="c1"
names(inputDF)[2]="Cross_Validation"
names(inputDF)[3]="Asegurado_id"
names(inputDF)[4]="Ind_Ramo_Canal_Vigente"
names(inputDF)[5]="Meses_Antiguedad_Ramo_Canal"
names(inputDF)[6]="Canal_Agrup_Id"
names(inputDF)[7]="Ind_Exequial"
names(inputDF)[8]="Ind_Accidentes_Personales"
names(inputDF)[9]="Ind_Automoviles"
names(inputDF)[10]="Ind_Hogar"
names(inputDF)[11]="Ind_SuRenta"
names(inputDF)[12]="Ind_MasVida"
names(inputDF)[13]="Ind_Soat"
names(inputDF)[14]="Ind_Renta_Educativa"
names(inputDF)[15]="Ind_Otros_Personales"
names(inputDF)[16]="Ind_Salud"
names(inputDF)[17]="Ind_Otros_Empresariales"
names(inputDF)[18]="Ind_Arrendamiento"
names(inputDF)[19]="Ind_Renta_Pensional"
names(inputDF)[20]="Ind_Desempleo"
names(inputDF)[21]="Ind_Vida"
names(inputDF)[22]="Produccion_Emitida_Grupo_Cliente"
names(inputDF)[23]="Porc_RT_Grupo_Cliente"
names(inputDF)[24]="Frecuencia_Anual_Siniestros_Grupo_Cliente"
names(inputDF)[25]="Monto_Pagado_Siniestros_Grupo_Cliente"
names(inputDF)[26]="Recencia_Meses_Ultimo_Siniestros_Grupo_Cliente"
names(inputDF)[27]="Cont_Compania_Cliente"
names(inputDF)[28]="Regional_Contacto_id"
names(inputDF)[29]="Sexo_id"
names(inputDF)[30]="Edad"
names(inputDF)[31]="Numero_Hijos"
names(inputDF)[32]="Ind_Dependientes_Menores18"
names(inputDF)[33]="Ind_Dependientes_Mayores18"
names(inputDF)[34]="Nivel_Ingreso_id"
names(inputDF)[35]="Nivel_Estudios_id"
names(inputDF)[36]="Estado_Civil_id"
names(inputDF)[37]="Ind_Independiente"
names(inputDF)[38]="Cont_Quejas"
names(inputDF)[39]="Cont_Peticion"
names(inputDF)[40]="Cont_Inquietud"
names(inputDF)[41]="Ind_Tipo_Negocio_Colectivo"
names(inputDF)[42]="Ind_Forma_Pago_Mensual"
names(inputDF)[43]="Ind_Forma_Pago_Anual"
names(inputDF)[44]="Ind_Tipo_Pago_Caja_Sura"
names(inputDF)[45]="Ind_Tipo_Pago_Financiacion_Sura"


inputDF$Canal_Agrup_Id <- factor(inputDF$Canal_Agrup_Id)
inputDF$Regional_Contacto_id <- factor(inputDF$Regional_Contacto_id)
inputDF$Sexo_id <- factor(inputDF$Sexo_id)
inputDF$Nivel_Ingreso_id <- factor(inputDF$Nivel_Ingreso_id)
inputDF$Nivel_Estudios_id <- factor(inputDF$Nivel_Estudios_id)
inputDF$Estado_Civil_id <- factor(inputDF$Estado_Civil_id)

newdata0<-inputDF %>% filter(Cross_Validation==1)

newdata1<-newdata0[,3:ncol(newdata0)]


inputDF<-inputDF %>% filter(Cross_Validation==0)#para entrenar modelo
inputDF1<-inputDF[,3:ncol(inputDF)]#excluye campos que no aplican

modelocoxph <- coxph(Surv(Meses_Antiguedad_Ramo_Canal, Ind_Ramo_Canal_Vigente) ~ . , data = inputDF1)


save(modelocoxph, file="/tmp/modelocoxph.RData")

modelo<-survfit(modelocoxph, conf.type = "log-log",type = "kaplan-meier",newdata =newdata1 )

#output=data.frame(modelo$surv[2,1:length(modelo$surv[2,])])

output=data.frame(Asegurado_id=newdata0[,3],Tiempo1=modelo$surv[4,1:length(modelo$surv[4,])],Tiempo2=modelo$surv[61,1:length(modelo$surv[61,])])

# Export results to Teradata through standard output

write.table(output, file=stdout(), col.names=FALSE, row.names=FALSE,quote=FALSE, sep="\t", na="")

# write.table(1, file=stdout(), col.names=FALSE, row.names=FALSE,quote=FALSE, sep="\t", na="")
