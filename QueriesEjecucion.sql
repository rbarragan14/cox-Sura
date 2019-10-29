SET SESSION SEARCHUIFDBPATH = Rtdsura;
DATABASE Rtdsura;

CALL SYSUIF.REMOVE_FILE('R_cox_train', 1);

CALL SYSUIF.INSTALL_FILE('R_cox_train', 'R_cox_train.r', 'cz!C:\\Users\\rb255002\\Documents\\3. Clientes\\2019\\Colombia\\Suramericana\\ModeloCox\\R_cox_train.r ');

SELECT  *
FROM SCRIPT (
ON (select  
 1,Asegurado_id, Ind_Ramo_Canal_Vigente, Meses_Antiguedad_Ramo_Canal, Canal_Agrup_Id 
,Ind_Exequial, Ind_Accidentes_Personales, Ind_Automoviles, Ind_Hogar, Ind_SuRenta 
 ,Ind_MasVida, Ind_Soat, Ind_Renta_Educativa, Ind_Otros_Personales, Ind_Salud 
  ,Ind_Otros_Empresariales,  Ind_Arrendamiento, Ind_Renta_Pensional, Ind_Desempleo, Ind_Vida 
 ,Produccion_Emitida_Grupo_Cliente ,  Porc_RT_Grupo_Cliente  , Frecuencia_Anual_Siniestros_Grupo_Cliente ,  Monto_Pagado_Siniestros_Grupo_Cliente ,  Recencia_Meses_Ultimo_Siniestros_Grupo_Cliente 
,Cont_Compania_Cliente ,   Regional_Contacto_id, Sexo_id, Edad, Numero_Hijos
  ,Ind_Dependientes_Menores18, Ind_Dependientes_Mayores18, Nivel_Ingreso_id, Nivel_Estudios_id, Estado_Civil_id  
 ,Ind_Independiente,  Cont_Quejas, Cont_Peticion,  Cont_Inquietud, Ind_Tipo_Negocio_Colectivo
,Ind_Forma_Pago_Mensual, Ind_Forma_Pago_Anual, Ind_Tipo_Pago_Caja_Sura, Ind_Tipo_Pago_Financiacion_Sura ,1
FROM Rtdsura.Training_VPC_Cancelacion_Autos2
)
--partition by c1
SCRIPT_COMMAND('R --vanilla --slave -f ./Rtdsura/R_cox_train.r')
--RETURNS ('time1 integer,delta integer,gender integer,race integer') )
--RETURNS ('x1 decimal (18,1) , x2 decimal (18,10)')) ;
RETURNS ('x1 decimal (18,14)'));

SELECT DISTINCT *
    FROM SCRIPT (
    SCRIPT_COMMAND('tail -n 3 /var/opt/teradata/tdtemp/uiflib/scriptlog')
        RETURNS ('x1 Varchar (400)') );
        

