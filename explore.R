                        #explore scrap del pdf
#La página que en teoría se actualiza todos los días es:
#https://wsse.krakow.pl/page/informacja-mpwis-o-sytuacji-epidemiologicznej-w-malopolsce-wg-stanu-na-23-10-2020-r-godzina-800/

library(tidyverse)
library(tabulizer)

sitio <- "https://wsse.krakow.pl/page/wp-content/uploads/2020/10/COVID-19-ogniska-stan-na-23.10.2020-MPWIS.pdf"

df <- extract_tables(sitio, encoding = "UTF-8")
df <- as.data.frame(df)[4:25, ] 
df
#Ponemos los nombres en español
names(df) <- c("id", "distrito", "ogolem", "activos_10mil", "fallecidos", "curados",
               "activos", "cuarentena_ext", "cuarentena_contacto", "enfermo_tras_hospital",
               "enfermo_dps", "enfermo_zol", "trabajo", "escuelas", "colegios",
               "dormitorios", "bodas", "hosteleria", "transporte", "otros")
#Le ponemos la fecha de hoy
df <- df %>% mutate(fecha = Sys.Date()) %>% select(fecha, everything())

#Lo guardamos y mañana agregamos las filas nuevas
# write.csv(df, "poland/data/output.csv", row.names = F)
