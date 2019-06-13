library(shiny)
library(tidyverse)

data("mtcars")

#subset data

analysis <- mtcars %>% 
    rownames_to_column(var = "carName") %>% 
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
         
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
           plotOutput("mpgVshp")
           
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
    
    
    #adding reactivity for transmission type
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
