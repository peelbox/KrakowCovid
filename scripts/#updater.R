                    #updater
#La página que en teoría se actualiza todos los días es:
#https://wsse.krakow.pl/page/informacja-mpwis-o-sytuacji-epidemiologicznej-w-malopolsce-wg-stanu-na-23-10-2020-r-godzina-800/

if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
}
if (!("tabulizer" %in% installed.packages())) {
  install.packages("tabulizer")
}
if (!("lubridate" %in% installed.packages())) {
  install.packages("lubridate")
}
`%>%` <- dplyr::`%>%` #definición del pipe 

fecha <- Sys.Date() %>% format("%d.%m.%Y") #Fecha de hoy en el formato de la url
sitio <- paste0("https://wsse.krakow.pl/page/wp-content/uploads/2020/10/COVID-19-ogniska-stan-na-", fecha,"-MPWIS.pdf")
df <- tabulizer::extract_tables(sitio, encoding = "UTF-8")
df <- as.data.frame(df)[4:25, ] 
df
#Ponemos los nombres en español
names(df) <- c("id", "distrito", "ogolem", "activos_10mil", "fallecidos", "curados",
               "activos", "cuarentena_ext", "cuarentena_contacto", "enfermo_tras_hospital",
               "enfermo_dps", "enfermo_zol", "trabajo", "escuelas", "colegios",
               "dormitorios", "bodas", "hosteleria", "transporte", "otros")

#=========== Correr sólo los lunes ========= 
#Agrega valores perdidos a los datos de sábado y domingo -agrega filas-.
# m2 <- c(Sys.Date() - 2); names(m2) <- "fecha"
# m1 <- c(Sys.Date() - 1); names(m1) <- "fecha"
# a <- bind_rows(m2, m1); a$fecha <- lubridate::as_date(a$fecha)
# df <- dplyr::full_join(df, a)
#===========================================

#Le ponemos la fecha de hoy
df <- df %>% dplyr::mutate(fecha = Sys.Date()) %>% dplyr::select(fecha, dplyr::everything())

#=========== limpiador ========== 
#Dejamos el df de la misma manera que datos para poder unirlos
df <- sapply(df, function(x) {
  trimws(gsub(" ", "", x))
}) %>% data.frame()

df[,c(4, 6:length(df))] <- sapply(df[,c(4, 6:length(df))], function(x) {
  as.numeric(x)
}) 
df$fecha <- lubridate::as_date(df$fecha)
df$id <- as.integer(df$id)
#Ponemos en mayúsculas la primera letra del distrito
df$distrito <- str_to_title(df$distrito)
#================================

#============= Unión ============ 
#Agrega los nuevos datos al csv definitivo que se llama krakow.csv
datos <- read.csv("data/krakow.csv", header = T)
datos$fecha <- lubridate::as_date(datos$fecha)

datos <- dplyr::full_join(datos, df)
#======================================
# Escribe csv 
# write.csv(datos, "data/krakow.csv", row.names = F)
