library(shiny)
library(tidyverse)
library(plotly)
library(leaflet)

data("mtcars")
vehicle_merged <- readRDS("./data/vehicle_merged.rds")

#subset data

analysis <- mtcars %>% 
    rownames_to_column(var = "Name") %>% 
    filter(hp >= 70)
    

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("BST 692 - Learning Shiny!"),

    #MAKE THE WIDTHS OF THE NAVLIST PANEL 2 AND THE REST OF THE PAGE 10 - widths = .... 
    navlistPanel(widths = c(2,10),
        "WHAT'S MY NAME?",
        tabPanel("NAME OF FIRST TAB",
                 sidebarLayout(
                     sidebarPanel(
                         #>>>>>INSERT YOUR INPUT WIDGET FOR FGEARS HERE!<<<<
                         
                         
                         ,
                         
                         br(),
                         
                         #>>>>>INSERT YOUR CHECKBOXINPUT WIDGET FOR NUM CYLINDERS HEERE!<<<<<
                         
                         ,
                         
                         #>>>>>>ADD THE ACTION BUTTON HERE!!!<<<<<
                         
                         
                         
                     ),
                     
                     # Show a plot of the generated distribution
                     mainPanel(
                         
                         #>>>>>ADD YOUR PLOTLYOUPUT HERE!<<<<<
                         ,
                         
                         br(),
                         
                         #>>>>>>ADD YOUR DATATABLEOUPUT HERE!!<<<<<
                         
                         
                         
                         
                     )#end  main panel
                 )#end sidebarlayout
        ),#end motortrend tabPanel
        tabPanel(
            "NAME OF SECOND TAB",
            sidebarLayout(
                sidebarPanel(
                    h5("DESCRIBE THE MAP")
                    
                ), #end sidebar panel
                mainPanel(
                    #leaflet output
                    fluidRow(
                        h3("GIVE YOUR MAP A TITLE!"),
                        
                        ####>>>>ADD YOUR LEAFLETOUTPUT() HERE!<<<<<
                        
                    )
                    
                )#end mainpanel
            )#end sidebarlayout
        )#end tabpanel mapping
    )#end navlistPanel
) #end ui

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
    
    
    #leaflet map
    output$vehicleMap <- renderLeaflet({
        
        #>>>>>>>PLOP YOUR LEAFLET MAP CODE HERE!!!!<<<<<<<<
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
