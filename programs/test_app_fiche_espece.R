#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
sp_name = "Amaryllis"
source("fonctions/var.R")
source("fonctions/library.R")
readRenviron(".env")
source("fonctions/carte.R")
source("fonctions/function_graphics.R")
source("fonctions/function_import_from_mosaic.R")
# Création des data frame
source("fonctions/create_df_all_sp.R")
source("fonctions/create_df_one_sp.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Test pour une carte"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Choix de l'année",
                  min = 2019,
                  max = 2024,
                  value = 2019)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("map")
    )
  )
  
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
  

  
  output$map <- renderPlot({
    a = sort(c(sp_name, "Jardins"))
    b = c("#d50404", "#d50404")
    b[which(a == "Jardins")] = "#0baaff"
    
    ggplot(france) +
      geom_sf(fill = "#f0f0f0", color = "#a0a0a0") +
      geom_point(data = (rbind(df_bary_one_sp, df_bary_base)) %>% filter(annee == input$year),
                 aes(x = longitude, y=latitude, color = nom_espece)) +
      scale_color_manual(values = b) +
      theme_minimal()
    })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
