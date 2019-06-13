library(shiny)

ui <- fluidPage(
  
  mainPanel(
    h4("Summary"),
    verbatimTextOutput("summary"),
    
    h4("Observations"),
    tableOutput("view")
  )
)

server <- function(input, output){
  
  output$summary <- renderPrint({
    summary(faithful)
  })
  
  output$view <- renderTable({
    head(faithful)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)