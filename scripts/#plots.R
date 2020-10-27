                        #plots
if (!("dplyr" %in% installed.packages())) {
        install.packages("dplyr")
}
if (!("lubridate" %in% installed.packages())) {
        install.packages("lubridate")
}
if (!("ggplot2" %in% installed.packages())) {
        install.packages("ggplot2")
}
if (!("ggrepel" %in% installed.packages())) {
        install.packages("ggrepl")
}

datos <- read.csv("data/krakow.csv") 
datos$fecha <- lubridate::as_date(datos$fecha)
`%>%` <- dplyr::`%>%` #definición del pipe 
fecha <- Sys.Date()

#============= Active cases today ================
datos %>% dplyr::filter(distrito == "M.kraków") %>% #Filtro
        
        #============= Gráfico ========= 
ggplot2::ggplot(ggplot2::aes(fecha, activos)) +
        ggplot2::geom_line() +
        ggplot2::geom_point() +
        ggrepel::geom_text_repel(ggplot2::aes(label = as.character(activos))) + 
        
        #escalas
        ggplot2::scale_x_date(date_breaks = "2 day", date_labels = "%b %d") + 
        
        # Etiquetas
        ggplot2::labs(title = "Active Cases in M. Kraków",
             subtitle = paste("Update:", fecha, "| Data source: https://wsse.krakow.pl"),
             caption = "Author: @JKniffki | KStats®",
             x = "", y = "Active Cases") -> p1

#Guardar en /plots
ggplot2::ggsave(paste0("plots/active", fecha, ".png"), p1)

