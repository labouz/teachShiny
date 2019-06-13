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
            
            #add selection for number of cylinders
            
            checkboxGroupInput("cyl",
                               "Select the number of cylinders:",
                               choices = c("4" = 4,
                                           "6" = 6,
                                           "8" = 8),
                               selected = c(4,6,8)
                               ),
            
            #add button to show table of cars
            actionButton("showCars", "Display Cars!")
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
           plotlyOutput("mpgVshp"),
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

    output$mpgVshp <- renderPlotly({
       
        # generate plot based on number of gears selected
        x <- analysisSub() %>% 
            filter(cyl %in% input$cyl) %>% 
            mutate(cyl = as.character(cyl))
        
        # draw the scatterplot with the relationship between mpg and hp
        ggplot(data = x) +
            geom_line(aes(x = mpg, y = hp, color = cyl), size = 1.5) +
            labs(x = "Miles/Gallon (MPG)", y = "Horsepower (HP)")+
            theme(legend.position = "bottom") +
            theme_minimal() 
        
        
    })
    
    theCars <- eventReactive(input$showCars,{
        analysisSub() %>% select(Name, cyl, mpg, hp)
    })
    
    output$cars <- DT::renderDataTable({
        theCars()
    }, selection = 'single')
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
