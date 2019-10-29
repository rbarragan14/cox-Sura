
install.packages("survival")
install.packages("KMsurv")
install.packages("survMisc")
install.packages("survminer")
install.packages("flexsurv")
install.packages("ggfortify")
install.packages("actuar")
install.packages("dplyr")
install.packages("broom")



library(survival)
library(KMsurv)
library(survMisc)
library(survminer)
library(ggfortify)
library(flexsurv)
library(actuar)
library(dplyr)
library(broom)
library(readr)

# Data cargada 

VPC_Training<-read_tsv(file.choose(),skip = 0,col_names = TRUE)

str(VPC_Training)

with(VPC_Training, table(Ind_Ramo_Canal_Vigente))  # es la Censura del evento si ocurre o no

summary(VPC_Training)
colnames(VPC_Training)


#convertir a factor las varieble nominales o categoricas
VPC_Training$Canal_Agrup_Id <- factor(VPC_Training$Canal_Agrup_Id)
VPC_Training$Regional_Contacto_id <- factor(VPC_Training$Regional_Contacto_id)
VPC_Training$Sexo_id <- factor(VPC_Training$Sexo_id)
VPC_Training$Nivel_Ingreso_id <- factor(VPC_Training$Nivel_Ingreso_id)
VPC_Training$Nivel_Estudios_id <- factor(VPC_Training$Nivel_Estudios_id)
VPC_Training$Estado_Civil_id <- factor(VPC_Training$Estado_Civil_id)

# Modelo de riesgos proporcionales de cox

# la data con la cual se testea el modelo entrenado para los clientes  con covariables 

newdata0<-VPC_Training %>% filter(Cross_Validation==1)#para testear modelo
newdata0<-newdata0[,3:ncol(newdata0)]#excluye campos que no aplican
VPC_Training<-VPC_Training %>% filter(Cross_Validation==0)#para entrenar modelo
VPC_Training<-VPC_Training[,3:ncol(VPC_Training)]#excluye campos que no aplican
# Entrenamiento del modelo de cox con covariables que afectan la ocurrencia del evento en el tiempo "time"
modelocoxph <- coxph(Surv(time=Meses_Antiguedad_Ramo_Canal, event=Ind_Ramo_Canal_Vigente) ~. , data = VPC_Training)

# Significacia de las covariables con el valor-p
summary(modelocoxph)
#como se esta entrenando el ramo = Ind_Automoviles, la variable no aplica para modelar, pero no es necsario excluir porque es excluida por defecto, po no tener variacion
# Aplicacion del modelo de cox sobre una la nueva base de testing con los tres pacientes observados


modelo<-survfit(modelocoxph, conf.type = "log-log",type = "kaplan-meier",newdata =newdata0 )#aplica modelo a nueva muestra
#Resultados del modelo para las tiempos  times = 1,3,60. Cada cliente tiene probabilidad de superviviencia survival1,2,3 hasta la semana 1 y 100
res<-summary(modelo,times=c(1,3,60))
# Los mismos resultados como data frame trasnspuestos para poder acceder mas facil a los resultados mas adelante
res2<-data.frame(t(cbind(Tiempo=res$time,res$surv)))#prob supervivencia en los tiempo dados
