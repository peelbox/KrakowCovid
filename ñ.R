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
#Con la función summary viste que había valores perdidos NA. Utiliza la función 


