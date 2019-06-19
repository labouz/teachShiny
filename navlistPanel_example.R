library(shiny)
library(tidyverse)

#taken from: https://shiny.rstudio.com/gallery/navlistpanel-example.html

ui <- fluidPage(
  
  titlePanel("Navlist panel example"),
  
  navlistPanel(
    "Header",
    tabPanel("First",
             h3("This is the first panel"),
             p("Hi my name is Layla!")
    ),
    tabPanel("Second",
             h3("This is the second panel")
    ),
    tabPanel("Third",
             h3("This is the third panel")
    )
  )
)

server <- function(input, output) {
    

}

shinyApp(ui, server)
