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
         
         #slider for adjusting the size of the loess 
         sliderInput("smoothSize",
                     "Thickeness of Loess Curve:",
                     min = 1,
                     max = 4,
                     step = .5,
                     value = 1.5),
         
         br(),
         br(),
         p("Learn more about Old Faithful", 
           a("here", href = "https://en.wikipedia.org/wiki/Old_Faithful"), "!")
         
      ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         br(),
         br(),
         plotOutput("scatter")
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
   
   #scatter plot of erutions vs waiting
   
   output$scatter <- renderPlot({
     g <- ggplot(data = faithful, aes(x = eruptions, y = waiting))
     
     g + geom_point() +
        geom_smooth(method = "loess", size = input$smoothSize)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

