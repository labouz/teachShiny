
library(shiny)

shinyApp(
  ui = basicPage( actionButton("go", "Go")),
  server = function(input, output, session) {
    observeEvent(input$go, {
      print(paste("This will only be printed once; all",
                  "subsequent button clicks won't do anything"))
    }, once = TRUE)
  }
)


shinyApp(
  ui = fluidPage(
    column(4,
           numericInput("x", "Value", 5),
           br(),
           actionButton("button", "Show")
    ),
    column(8, tableOutput("table"))
  ),
  server = function(input, output) {
    # Take an action every time button is pressed;
    # here, we just print a message to the console
    observeEvent(input$button, {
      cat("Showing", input$x, "rows\n")
    })
    # Take a reactive dependency on input$button, but
    # not on any of the stuff inside the function
    df <- eventReactive(input$button, {
      head(cars, input$x)
    })
    output$table <- renderTable({
      df()
    })
  }
)


rsconnect::setAccountInfo(
  name='my-username', 
  token='my-token', 
  secret='my-secret'
)

rsconnect::deployApp("inputdemo")