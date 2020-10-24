# He realizado un cambio en el documento, ¿Puedes verlo? 
# si!!
# CHIDO 
# Para comentar tienes que poner el # antes de la frase

#Instalamos una librería de prueba en el workspace: install.packages("tidyverse")
#y utilizsamos el data set que viene por defecto: iris

#Cargar datos 
data(iris)

#Ver cabecera
head(iris)

#para asignar un objeto se puede utilizar = o bien <- En R preferimos el segundo
#y el igual = lo dejamos para argumentos de funciones: 
a <- 3
b <- 2
c <- a + b 
a
b
c

#Lo más potente es la creación de vectores dado que estos dan lugar a la 
#estructura matricial
c(a, b, c)

#c() crea vectores atómicos
mivector <- c(a, b, c)
class(mivector)

#str() vemos la clase de cada columna de un dataframe
class(iris)
str(iris)

#accedemos a las variables -columnas- de un dataframe de varias maneras
datos <- iris

datos[ ,1] #accede a la columna 1 todas las filas 
datos[1, ] #accede a la fila 1 todas las columnas 
datos[1,1] #fila 1 columna 1 
datos[0,0]

#También podemos acceder por el nombre de las variables
names(datos)
datos[,"Sepal.Length"]
datos[2 ,"Sepal.Length"] #fila 2 variable 1 

#Las variables son vectores

#Podemos cambiar la clase de un objeto con as. 
a <- c(1, 2, 3)
class(a)

achar <- as.character(a)
class(achar)




#====== Tareas ========
#Vamos a utilizar la librería de los pinguinos
library(palmerpenguins)
datos <- penguins

#Tarea 1 explorar el data set utiliando la función summary() que nos da los 
#principales estadísticos. Además utiliza str(), head(), tail(), view() --> view no se
#debe utilizar si los datos son muchos pero esta vez es para que veas como funciona.

# Tu turno: 
summary(datos) #info de estadisticas por cada columna

str(datos)
head(datos) #Muestra los primeros 6 filas
tail(datos) #Muestra las ultimas 6 filas
View(datos) #Abre una ventana de dataset . muy bueno!!


#Tarea 1: 
plot(datos$species)
plot(datos$flipper_length_mm)

#Observa que la función plot() se adapta al tipo de objeto dependiendo si la 
#variable es continua o discreta
#¿Qué pasa si haces plot(datos)? Tu turno:

plot(datos) #parece basura

#Tarea 3: 
#Con la función summary viste que había valores perdidos NA. Utiliza la función na.omit
#y guárdala en un objeto nuevo que se llame datos2 
datos2 <- na.omit(datos)
datos <- datos2
#La anterior acción no ocupa memoria

#============= Power subset =========== 
#Ahora sí lo siguiente es el motivo por el cual utilizo el universo tidyverse.
#install.packages(tidyverse)
library(tidyverse)
#Hay muchas funciones, pero vamos a empezar con 5 verbos clave: filter, select, group_by, mutate y summarise
#y un personaje: Al siguiente comando se le llama pipe %>% porque concatena una orden con otra.

### Select
?dplyr::select()
names(datos) #no me acuerdo el nombre de las variables
select(datos, bill_length_mm)
#En la manera base sería 
datos$bill_length_mm
#O bien 
datos[,"bill_length_mm"]

#Ahora observa que con el pipe podemos hacer lo siguiente
datos %>% select(bill_length_mm)

### Filter
?dplyr::filter()
#Supongamos que solo queremos trabajar con los pinguinos de una isla
levels(datos$island) #No me acuerdo de los niveles
datos %>% filter(island == "Dream")
datos %>% filter(bill_length_mm > 39) 



### Group_by 
?dplyr::group_by()

#group_by funciona mejor acompañada de summarise o mutate
datos %>% group_by(island) #observa que no pasa nada aparentemente aunque los datos ya están agrupados

#summarise
?dplyr::summarise()
#Sirve para hacer resumenes
datos %>% select(bill_length_mm) %>% summarise(media = mean(bill_length_mm))
#Pero es más poderoso cuando lo juntamos con groupby
datos %>% group_by(island) %>% summarise(media = mean(bill_length_mm))

##arrange
#la misma linea pero poniéndolos de menor a mayor
datos %>% 
        group_by(island) %>% 
        summarise(media = mean(bill_length_mm)) %>% 
        arrange(media)

### mutate
?dplyr::mutate()
#Sirve para crear variables nuevas
datos %>% mutate(varnueva = "ññññ")
datos %>% mutate(varn = bill_length_mm + flipper_length_mm)

#TAREA:  
#¿Cuál es la mediana -median()- de la longitud de las aletas de los pinguinos 
#en función de la especie?  y ¿en función del sexo? 
#Tu turno:

datos <- penguins
datos <- na.omit(datos)
View(datos)
names(datos)
levels(datos$species)
#la media de aletas
datos %>% select(flipper_length_mm) %>% summarise(media = mean(flipper_length_mm))
mean(datos$flipper_length_mm,na.rm = TRUE)

#la media en funcion del especie
datos %>% group_by(species) %>% summarise(media = mean(bill_length_mm))

#la media en funcion del sexo
datos %>% group_by(sex) %>% summarise(media = mean(bill_length_mm))

#TAREA: 
#Crea una nueva variable que sea la diferencia entre bill_length_mm  y bill_depth_mm
datos %>% mutate(dif = bill_length_mm  - bill_depth_mm)
#TAREA
datos %>% filter(island != "Dream") #Qué islas estoy seleccionando?
#todas las islas que no sean Dream , es decir Biscoe y Torgersen
levels(datos$island)

#TAREA
# Selecciona a los pinguinos de las especie Adelie que tengan una masa corporal menor que 3600
datos %>% filter(body_mass_g < 3600 ) 
