library(shiny)
library(tidyverse)
library(plotly)

data("mtcars")

#subset data

analysis <- mtcars %>% 
    rownames_to_column(var = "Name") %>% 
    filter(hp >= 70)
    

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Analysis of Motor Trend Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            radioButtons("fgears",
                        "Select the number of forward gears: ",
                        choices = c("3" = 3,
                                    "4" = 4,
                                    "5" = 5)),
            
            br(),
            
            #####ADD THE CHECKBOXGROUPINPUT TO SELECT NUMBER OF CYLINDERS!<<<
            
            
            
            #add button to show table of cars
            actionButton("showCars", "Display Cars!")
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            ####>>>ADD PLOTLYOUTPUT() HERE! <<<<
            
            br(),
            DT::dataTableOutput("cars", width = 500), tags$hr()
           
          
           
        )#end  main panel
    )#end sidebarlayout
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    analysisSub <- reactive({
        analysis %>% 
            filter(gear == input$fgears) %>% 
            mutate(am = as.character(am))
    })

    ###>>>>>ADD RENDERPLOTLY HERE!<<<<<
    ####HINT: COPY AND PASTE THE SCATTERPLOT OF JUST MPG VS HP FROM PREVIOUS EXERCISE
    ####HINT: DONT FORGET TO FILTER FOR NUMBER OF CYLINDERS IN THE DATA THAT FEEDS THE GGPLOT!
    
    
    
    
    
    
    theCars <- eventReactive(input$showCars,{
        analysisSub() %>% select(Name, cyl, mpg, hp)
    })
    
    output$cars <- DT::renderDataTable({
        theCars()
    }, selection = 'single')
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
