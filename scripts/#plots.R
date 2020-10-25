                        #plots
library(tidyverse)
library(ggrepel) #Previene que se encimen las etiquetas
library(gganimate) #animados

datos <- read.csv("poland/data/definitivo.csv") 
datos$fecha <- lubridate::as_date(datos$fecha)

#============= Plot ======
unique(datos$distrito)
datos %>% filter(distrito == "M.kraków") %>% 
        
        #plot
ggplot(aes(fecha, activos)) +
        geom_line() +
        geom_point() +
        geom_text_repel(aes(label = as.character(activos))) + 
        
        #escalas
        scale_x_date(date_breaks = "2 day", date_labels = "%b %d") + 
        
        # Etiquetas
        labs(title = "Evolución de casos activos en M. Kraków",
             subtitle = "Actualización: 23-10-2020",
             caption = "Elaboración: @JKniffki | KStats®",
             x = "", y = "") -> p1
p1
ggsave("poland/plots/casosact.png")


#========== plot animado 
# p1 + transition_reveal(fecha)
# anim_save("poland/plots/animact.gif")
