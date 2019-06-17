#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30),
         
         ###>>>>ADD SLIDER FOR ADJUSTING THE SIZE OF THE LOWESS HERE <<<<<<< 
         
         
         br(),
         br(),
         
         ####>>>>ADD A LINK TO WIKI ABOUT OF HERE! <<<<<<<
         h4(learn about old faithful)
         
      ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         br(),
         br()
         ###>>ADD PLOTOUPUT HERE!<<<
         
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
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
   
   #####>>>>ADD SCATTER PLOT OF ERUOPTION VS WAITING HERE <<<<<<

}

# Run the application 
shinyApp(ui = ui, server = server)

