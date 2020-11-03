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
if (!("ggthemes" %in% installed.packages())) {
        install.packages("ggthemes")
}

datos <- read.csv("data/krakow.csv", header = T) 
datos$Date <- lubridate::as_date(datos$Date)
`%>%` <- dplyr::`%>%` #definición del pipe 
fecha <- Sys.Date()

#============= Active cases today ================
datos %>% dplyr::filter(County == "M.kraków") %>% #filtro
        
        #============= Gráfico ========= 
ggplot2::ggplot(ggplot2::aes(Date, Active, label = Active)) +
        ggplot2::geom_line() +
        ggplot2::geom_point() +
        ggrepel::geom_label_repel() + 
        
        #escalas
        ggplot2::scale_x_date(date_breaks = "2 day", date_labels = "%b %d") + 
        
        # Etiquetas
        ggplot2::labs(title = "Active cases in M. Kraków",
             subtitle = paste("Update:", fecha, "| Data source: https://wsse.krakow.pl"),
             caption = "Author: @JKniffki | KStats®",
             x = "", y = "Active Cases") +
        ggthemes::theme_economist() -> p1
#Guardar en /plots
ggplot2::ggsave("plots/active.png", p1)

#==============================================
#=========== Plot con indicadores ============= 
#==============================================
datos <- read.csv("data/MKrakow.csv", header = T) 
datos$Date <- as.Date(datos$Date)

#=========== 7 Días ============= 
datos %>% ggplot2::ggplot(ggplot2::aes(Date, Siete, label = round(Siete, 2))) +
        ggplot2::geom_point() +
        ggplot2::geom_line() +
        ggrepel::geom_label_repel() +
        ggplot2::labs(title = "Number of new Covid-19 cases per 100,000 persons within the last 7 days in M. Krakow",
             subtitle = paste("Update:", fecha, "| Data source: https://wsse.krakow.pl"),
             caption = "Author: @JKniffki | KStats®",
             x = "", y = "Active Cases") +
        ggthemes::theme_economist() -> p2
p2
#Guardar en /plots
ggplot2::ggsave("plots/daysSeven.png", p2)


#=========== tasa 100 mil ============= 
datos %>% ggplot2::ggplot(ggplot2::aes(Date, Cienmil, label = round(Cienmil, 2))) +
        ggplot2::geom_point() +
        ggplot2::geom_line() +
        ggrepel::geom_label_repel() +
        ggplot2::labs(title = "Rate of new Covid-19 cases per 100,000 persons in M. Krakow",
             subtitle = paste("Update:", fecha, "| Data source: https://wsse.krakow.pl"),
             caption = "Author: @JKniffki | KStats®",
             x = "", y = "Active Cases") +
        ggthemes::theme_economist() -> p3
p3
#Guardar en /plots
ggplot2::ggsave("plots/rate.png", p3)

#=============== MA3 de tasa de nuevos casos cada 100mil ======== 
datos %>% dplyr::mutate(MA3new = zoo::rollmean(Cienmil, k = 3, fill = NA, align = "right")) %>% 
        ggplot2::ggplot(ggplot2::aes(Date, MA3new, label = round(MA3new, 2))) +
        ggplot2::geom_point() +
        ggplot2::geom_line() +
        ggrepel::geom_label_repel() +
        ggplot2::labs(title = "Rate of new Covid-19 cases per 100,000 persons Moving Average 3 days in M. Krakow",
                      subtitle = paste("Update:", fecha, "| Data source: https://wsse.krakow.pl"),
                      caption = "Author: @JKniffki | KStats®",
                      x = "", y = "Active Cases") +
        ggthemes::theme_economist() -> p4
p4
#Guardar en /plots
ggplot2::ggsave(paste0("plots/rateMa3.png"), p4)
