library(shiny)
library(tidyverse)

data("mtcars")

#subset data

analysis <- mtcars %>% 
    rownames_to_column(var = "carName") %>% 
    filter(hp >= 70)
    

# Define UI for application that draws a histogram
ui <- fluidPage(

    # >>>>>add application title!<<<<<<<
    

    # Sidebar LAYOUT
    sidebarLayout(
        sidebarPanel(
            #>>>add input of choice for number of forward gears!<<<
            
            
            
         
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
            ###>>>>Add plotOutout for your scatterplot!<<<<
            
            
           
        )#end  main panel
    )#end sidebarlayout
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$mpgVshp <- renderPlot({
        # generate plot based on number of gears selected  
        x  <- analysis %>% 
            filter(gear == input$fgears) %>%
            mutate(am = as.character(am))
        
        
        ###>>>> draw the scatterplot with the relationship between mpg and hp!<<<
        
            
            
    })
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
