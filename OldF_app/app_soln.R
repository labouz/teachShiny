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
library(leaflet)
library(plotly)

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
         h5("Learn more about Old Faithful", 
           a("here", href = "https://en.wikipedia.org/wiki/Old_Faithful"), "!"),
         
         br(),
         #add a normal checkbox
         checkboxInput("normal",
                       "Normalize?"),
         
         h5("What is the linear model?"),
         actionButton("lm","Compute lm"),
         br(),
         verbatimTextOutput("model")
         
      ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         br(),
         br(),
         plotlyOutput("scatter"),
         br(),
         leafletOutput("of_map", width = "1000px")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   of_dat <- reactive({
      normalize <- function(x) {
         (x - min(x)) / (max(x) - min(x))
      }
      normal_geyser <- map_df(faithful, normalize)
      
      if(input$normal){
         normal_geyser
      }else{
         faithful
      }
   })
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- of_dat()$waiting
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
   
   #scatter plot of erutions vs waiting
   
   output$scatter <- renderPlotly({
     g <- ggplot(data = of_dat(), aes(x = eruptions, y = waiting))
     
     g + geom_point() +
        geom_smooth(method = "loess", size = input$smoothSize)
   })
   
   theModel <- eventReactive(input$lm,{
      lm(waiting~., data = of_dat())
   })
   
   output$model <- renderPrint({
      theModel()
   })
   
   
   ###### ADD MAP of OF#######
   output$of_map <- renderLeaflet({
      
      leaflet() %>% 
         addProviderTiles("CartoDB.Positron")%>% 
         addMarkers(lng = -110.828052, lat = 44.460617)
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

