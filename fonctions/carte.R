library(cowplot)
library(here)
library(sf)

france <- read_sf(paste0("carte/contour-des-departements.geojson"))

carte <- function(data,
                  longitude = "longitude",
                  latitude = "latitude",
                  groupe,
                  couleurs,
                  labels,
                  legend.title = groupe){
  
  plot <- ggplot(france) + 
    geom_sf(fill = "#f4f4f4") +
    geom_point(data = data,
               aes(x = !!sym(longitude),
                   y = !!sym(latitude),
                   fill = !!sym(groupe)),
               show.legend = TRUE,
               shape = 21,
               color = "black",
               size = 1.5) +
    scale_fill_manual(values = couleurs, breaks = labels, drop = FALSE) +
    theme_void() +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.y = element_blank()) +
    labs(fill = legend.title)
 
  return(plot)
}


