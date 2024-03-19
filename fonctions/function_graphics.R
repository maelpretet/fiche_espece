# Fonctions graphiques

# Graphique en echarts4r
aes_echarts <- function(plot_e, xlab, ylab, title, line_color){
  plot_e <- plot_e %>%
    # e_bar(sum_ab) %>%
    e_legend(top = "3%") %>%
    e_tooltip(e_tooltip_pointer_formatter("currency"),
              axisPointer = list(type = "cross")) %>%
    e_datazoom(x_index = 0, type = "slider", bottom = "3%") %>%
    e_toolbox_feature(feature = "saveAsImage") %>%
    e_toolbox_feature(feature = "dataView", readOnly = TRUE) %>%
    e_x_axis(name=xlab,
             nameLocation = "middle", nameGap= 27) %>%
    e_grid(bottom = "20%") %>%
    e_color(color = line_color) %>%
    e_y_axis(name=ylab, nameLocation = 'middle',
             nameGap= 50) %>%
    e_title(text = paste(title),
            textStyle = list(fontSize = list(14)))
  
  return(plot_e)
}

# Carte d'abondance
carte_ab <- function(shape_map, fill_map, fill_title, fill_color, fill_cat){
  carte <- ggplot(shape_map) + 
    geom_sf(aes(fill = fill_map), show.legend = "fill") +
    scale_fill_manual(values = fill_color, breaks = fill_cat, drop = FALSE)+
    labs(fill = fill_title) +
    theme_light()
  
  return(carte)
}
