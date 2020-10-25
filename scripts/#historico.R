                 #histórico
#Parece que sólo hay registro hasta el 6 de octubre 

library(tidyverse)
library(tabulizer)

lista <- list()
ii <- paste0(rep(6:9), ".10.2020")
#falta el 10
jj <- paste0(rep(11:22), ".10.2020")
ii <- c(ii, jj)

lapply(ii, function(x) {
        
a <- paste0("https://wsse.krakow.pl/page/wp-content/uploads/2020/10/COVID-19-ogniska-stan-na-", x, "-MPWIS.pdf")

df <- extract_tables(a, encoding = "UTF-8")
df <- as.data.frame(df)[4:25, ]
#Ponemos los nombres en español
names(df) <- c("id", "distrito", "ogolem", "activos_10mil", "fallecidos", "curados",
               "activos", "cuarentena_ext", "cuarentena_contacto", "enfermo_tras_hospital",
               "enfermo_dps", "enfermo_zol", "trabajo", "escuelas", "colegios",
               "dormitorios", "bodas", "hosteleria", "transporte", "otros")
#Le ponemos la fecha de hoy
df <- df %>% mutate(fecha = x) %>% select(fecha, everything())
return(df)

}) -> lista 
        
historico <- bind_rows(lista)

#Los strings tienen espacios y para convertirlos a numeric hay que quitarlos
historico <- sapply(historico, function(x) {
        trimws(gsub(" ", "", x))
}) %>% data.frame()
historico[,c(4, 6:length(historico))] <- sapply(historico[,c(4, 6:length(historico))], function(x) {
        as.numeric(x)
}) 

#Convertimos en date la fecha
historico$fecha <- gsub("[.]", "/", historico$fecha) 
historico$fecha <- as.Date(historico$fecha, format="%d/%m/%Y")

#Ponemos en mayúsculas la primera letra del distrito
historico$distrito <- str_to_title(historico$distrito)


# write.csv(historico, "poland/data/historico.csv", row.names = F)

#Juntamos el hitórico con el de hoy (le aplicamos los cambios a output que le hicimos a histórico, salvo la fecha)
output <- read.csv("poland/data/output.csv")
datos <- read.csv("poland/data/historico.csv") 
datos$fecha <- lubridate::as_date(datos$fecha)

historico <- output
historico$fecha <- as.Date(historico$fecha)
historico$id <- as.integer(historico$id)

defin <-  full_join(datos, historico)

# write.csv(defin, "poland/data/definitivo.csv", row.names = F)

