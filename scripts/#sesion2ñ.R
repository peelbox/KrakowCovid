#============ ggplot2 =========== 
#tanto ggplot2 como dplyr y varias librerías más, ya están dentro de tidyverse pero en esta 
#ocación la cargamos explícitamente. 
library(ggplot2)
library(dplyr)
datos <- palmerpenguins::penguins
###breve paréntesis -cómo escribir y leer csv ======== 
?write.csv()
write.csv(datos, file = "pinguinos.csv")
?read.csv()
datos <- read.csv("pinguinos.csv", header = T)
#Como podemos imagirnarnos se puede leer cualquier tipo de archivo. 
#Esta página de Cheatsheets es interesante: https://rstudio.com/resources/cheatsheets/
#===  fin del paréntesis ============== 

#ggplot2 es la herramienta gráfica más potente de R. Funciona bajo el principio de 
#grammar of graphics en el que se van dibujando las capa por capa. Si bien los plots del R 
#base son muy útiles y rápidos, para presentar reportes se suele utilizar ggplot. 

#cambio el nombre a las variables para poder escribirlas más rápido
names(datos) <- c("especie", "isla", "lon_pico", "anch_pico", "aleta", "masa", "sexo")
head(datos)
datos <- na.omit(datos)

ggplot(datos) #dibuja un lienzo en blanco

#en la estética -aestethics- le indicamos las variables a dibujar 
ggplot(datos, aes(x = lon_pico, y = aleta)) #vemos que dibuja sobre el lienzo las escalas 

#falta indicarle la geometría que queremos. Para ello utilizamos un más para concatenar
ggplot(datos, aes(x = lon_pico, y = aleta)) +
        geom_point() #le indicamos la geometría en este caso puntos

#Lo que acabamos de hacer también podríamos haberlo hecho de manera secuencial guardándo en objetos 
#aveces esto es útil para no tener demasiado código en el script y guardar parte de nuestros "diseños"
#en otras carpetas y cargarlos como si fueran una función. Por ejemplo haciendo lo mismo de arriba

base <- ggplot() + theme_dark()
base + geom_point(data = datos, 
                  aes(x = lon_pico, y = aleta), 
                  colour = "white") -> p1 #Observa que también puedo asignar así 
p1 

#Además dentro de la estética puedo especificar que el color, la forma o el tamaño esté determinado 
#por una tercera variable:

#color 
datos %>% 
        ggplot(aes(lon_pico, aleta, colour = isla)) +
        geom_point()

#tamaño y color 
datos %>% 
        ggplot(aes(lon_pico, aleta, 
                   colour = isla,
                   shape = sexo)) +
        geom_point()
#tamaño
datos %>% 
        ggplot(aes(lon_pico, aleta, 
                   colour = isla,
                   shape = sexo,
                   size = lon_pico)) +
        geom_point()

#todo lo anterior dentro de la estética pero también puedo ponerla fuera para controlar los parámetros 
#generales de los puntos
p <- ggplot(datos, aes(lon_pico, aleta, colour = sexo, size = aleta)) +
        geom_point(alpha = 0.2) +
        labs(x = "Longitud del pico", y = "Longitud de la aleta", title = "Pinguinos") #Etiquetas 
p

#En general puedo cambiar todos y cada uno de los elementos gráficos del lienzo, la forma raw de hacerlo 
#y de crear temas propios es con la función theme 
?theme
p + theme(legend.title = element_blank()) #quito el título del legend

##### geometrías 
#Hay todas las geometrías imaginables desde mapas hasta los gráficos más habituales por ejemplo 
ggplot(datos, aes(especie, masa, fill = isla)) +
        geom_bar(stat = "identity", #toma las ordenadas -masa- como referencia
                 alpha = 0.6 #opacidad
                 ) -> p2 
p2 + 
        scale_fill_viridis_d() #otra escala de colores (hay muchisímas y se pueden poner a mano en rgb)
#se pueden encontrar muchas geometrías en la cheatsheet de ggplot2

#### Facets
#Es mejor mostrar el ejemplo:
p2 + facet_grid(~sexo) #el símbolo "~" se lee: "en función de" 


#Lo bueno de todo esto es que podemos combinarlo con los verbos de la sesión 1. Por ejemplo,
#queremos saber la relación entre la longitud de las aletas en función de la masa pero sólo 
#para las hembras de la isla "Dream" por especies:
datos %>% filter(isla == "Dream", sexo == "female") %>% #Aquí filtro
        ggplot(aes(masa, aleta)) + 
        geom_point() +
        facet_grid(~especie) -> p3
p3

#a lo anterior puedo calcularle la recta de regresión por mínimos cuadrados o por otro método:
p3 + geom_smooth(method = "lm")


#TAREA: Calcula la medía de la masa en función de la especie y el sexo y haz una gráfica con el resultado. 


#TAREA: Haz un boxplot de la longitud del pico en función de la especie para conocer su distribución y 
#cambia las etiquetas tales como título, eje x, eje y, caption etc


#TAREA: Dibuja la densidad de la anchura del pico (geom_density) en función de la especie (fill = especie) 
#cambiando la opacidad y otros elementos gráficos
