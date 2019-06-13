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
            
            #####>>>>>add button to show table of cars!<<<<<<<
            
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
           plotOutput("mpgVshp"),
           br()
           #####>>>>Add datatable from the DT package of the cars in your subset!<<<<
           
          
           
        )#end  main panel
    )#end sidebarlayout
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    #reactive dataset
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
    
    ###>>>Add a new eventReactive expression for the 
    ### for the show cars button called theCars which relies on analysisSub()<<<<
    
 
    
    ###>>>>Add the datatable (using DT) that will be displayed on the screen under or scatterplot!<<<
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
