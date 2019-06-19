library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(title = "ShinyDashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("First", tabName = "first"),
      menuItem("Second",tabName = "sec"),
      menuItem("Third", tabName = "terd")

    )
  ),
  
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "first",
             p("hi mom")
      ),
      
      # Second tab content
      tabItem(tabName = "sec",
              p("my mom is cooler than your mom")
      ),
      
      # Second tab content
      tabItem(tabName = "terd",
              p("Yo mama so fat....")
      )
    )
  )#end dashboardBody
)#end ui

server <- function(input, output) {

}

shinyApp(ui, server)