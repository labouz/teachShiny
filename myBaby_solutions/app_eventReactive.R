library(shiny)
library(tidyverse)

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
            #add a manual vs automatic button
            checkboxInput("trans", "Group by Transmission"),
            
            #add button to show table of cars
            actionButton("showCars", "Display Cars!")
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
           plotOutput("mpgVshp"),
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

    output$mpgVshp <- renderPlot({
       
        # generate plot based on number of gears selected
        x <- analysisSub()
        
        if(input$trans){
            # draw the scatterplot with the relationship between mpg and hp by 
            #transmission type
            ggplot(data = x, aes(x = mpg, y = hp)) +
                geom_line(aes(linetype = am, colour = am)) +
                labs(x = "Miles/Gallon (MPG)", y = "Horsepower (HP)")+
                # scale_linetype(name = "Transmission", 
                #                     labels = c("Automatic", "Manual")) +
                theme_minimal() 
        }else{

        # draw the scatterplot with the relationship between mpg and hp
        ggplot(data = x, aes(x = mpg, y = hp)) +
            geom_line(color = "#f442d1", linetype = 2) +
            labs(x = "Miles/Gallon (MPG)", y = "Horsepower (HP)")+
            theme_minimal() +
            theme(legend.position = "none") 
        }
        
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
