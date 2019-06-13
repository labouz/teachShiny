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

    # Sidebar with a slider input for number of bins 
    navlistPanel(widths = c(2,10),
        "Analyses",
        tabPanel("Motor Trend",
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
                         DT::dataTableOutput("cars"), tags$hr()
                         
                         
                         
                     )#end  main panel
                 )#end sidebarlayout
        ),#end motortrend tabPanel
        tabPanel(
            "Mapping",
            sidebarLayout(
                sidebarPanel(
                    h5("This map provides the percentage of people with no means
                       of transportation by vehicle")
                    
                ), #end sidebar panel
                mainPanel(
                    #leaflet output
                    fluidRow(
                        h4("The Map"),
                        
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
        popup <- paste0("County: ", vehicle_merged$NAMELSAD, "<br>", 
                        "Percent with no vehicle: ", round(vehicle_merged$percent,2))
        
        pal <- colorNumeric(
            palette = "YlGnBu",
            domain = vehicle_merged$percent
        )
        
        map <-leaflet() %>%
            addProviderTiles("CartoDB.Positron") %>%
            addPolygons(data = vehicle_merged, 
                        fillColor = ~pal(percent), 
                        color = "#b2aeae", # outline color - you need to use hex colors
                        fillOpacity = 0.7, 
                        weight = 1, 
                        smoothFactor = 0.2,
                        popup = popup) %>%
            addLegend(pal = pal, 
                      values = vehicle_merged$percent, 
                      position = "bottomright", 
                      title = "Percent with no vehicle",
                      labFormat = labelFormat(suffix = "%")) 
        map
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
