                              #Indicadores M.Krakow
#===================================================
#En este script se calculan los indicadores principales de 
#la Región de M Krakow y se guardan en el csv data/MKrakow.csv
#===================================================

if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
}
if (!("zoo" %in% installed.packages())) {
  install.packages("zoo")
}
`%>%` <- dplyr::`%>%` #definición del pipe 

datos <- read.csv("data/krakow.csv")
datos$Date <- as.Date(datos$Date)

habitantes <- 779115 #Los datos poblacionales se tomaron de esta página wsse censo del 31.12.2019 

kdf <- datos %>% dplyr::filter(County == "M.kraków") %>% dplyr::select(Date, Overall, Deaths, Recovered, Active)
kdf %>% dplyr::mutate(
               #Incremento diario bruto
               Increment = Overall - dplyr::lag(Overall), 
               
               #Media móvil activos 7 días
               MA7active = round(zoo::rollmean(Active, k = 7, fill = NA, align = "right"), 2), 
               
               #Media móvil activos 14 días
               MA14active = round(zoo::rollmean(Active, k = 14, fill = NA, align = "right"), 2), 
               
               #Media móvil activos 3 días
               MA3active = round(zoo::rollmean(Active, k = 3, fill = NA, align = "right"), 2), 
               
               #Incidencia por cada 100mil habitantes
               Cienmil = (Increment / habitantes) * 100000, 
               
               #Casos acumulados por cada 100mil hab. últimos 14 días
               Catorce = zoo::rollsum(Cienmil, k = 14, fill = NA, align = "right"), 
               
               #Casos acumulados por cada 100mil hab. últimos 7 días
               Siete = zoo::rollsum(Cienmil, k = 7, fill = NA, align = "right")  
               ) -> kdf 

#Escribir datos
write.csv(kdf, "data/MKrakow.csv", row.names = F)

