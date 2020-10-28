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
if (!("stringr" %in% installed.packages())) {
  install.packages("stringr")
}
`%>%` <- dplyr::`%>%` #definición del pipe 

fecha <- Sys.Date() %>% format("%d.%m.%Y") #Fecha de hoy en el formato de la url
sitio <- paste0("https://wsse.krakow.pl/page/wp-content/uploads/2020/10/COVID-19-ogniska-stan-na-", fecha,"-MPWIS.pdf")
df <- tabulizer::extract_tables(sitio, encoding = "UTF-8")
df <- as.data.frame(df)[4:25, ] 
#Ponemos los nombres en español
names(df) <- c("id", "County", "Overall", "Incidence_vs_Active", "Deaths", "Recovered",
               "Active", "Quarantine_inbound", "Quarantine_contact", "Contracted-health-services",
               "Acvtive_DPS", "Acvtive_ZOL", "Work", "Academy", "School",
               "Dormitories", "Weddings", "Hotels", "Public_Transport", "Others")

#=========== Correr sólo los lunes ========= 
#Agrega valores perdidos a los datos de sábado y domingo -agrega filas-.
# m2 <- c(Sys.Date() - 2); names(m2) <- "fecha"
# m1 <- c(Sys.Date() - 1); names(m1) <- "fecha"
# a <- bind_rows(m2, m1); a$fecha <- lubridate::as_date(a$fecha)
# df <- dplyr::full_join(df, a)
#===========================================

#Le ponemos la fecha de hoy
df <- df %>% dplyr::mutate(Date = Sys.Date()) %>% dplyr::select(Date, dplyr::everything())

#=========== limpiador ========== 
#Dejamos el df de la misma manera que datos para poder unirlos
df <- sapply(df, function(x) {
  trimws(gsub(" ", "", x))
}) %>% data.frame()

df[,c(4, 6:length(df))] <- sapply(df[,c(4, 6:length(df))], function(x) {
  as.numeric(x)
}) 
df$Date <- lubridate::as_date(df$Date)
df$id <- as.integer(df$id)
#Ponemos en mayúsculas la primera letra del distrito
df$County <-  stringr::str_to_title(df$County)
#================================

#============= Unión ============ 
#Agrega los nuevos datos al csv definitivo que se llama krakow.csv
datos <- read.csv("data/krakow.csv", header = T)
datos$Date <- lubridate::as_date(datos$Date)

datos <- dplyr::full_join(datos, df)
#======================================
# Escribe csv 
# write.csv(datos, "data/krakow.csv", row.names = F)
