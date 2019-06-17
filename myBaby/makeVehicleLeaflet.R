library(tidyverse)
library(leaflet)

vehicle_merged <- readRDS("./myBaby_solutions/data/vehicle_merged.rds")

#the text we want to see when we click on a county
popup <- paste0("County: ", vehicle_merged$NAMELSAD, "<br>", 
                "Percent with no vehicle: ", round(vehicle_merged$percent,2))

#color pallette function - colorNumeric()from the leaflet package - maps values to colors
#according to a given palette. The palette can be a vector of named colors, an 
#RColorBrewer palette, a viridis palette, or a function that receives a value and 
#returns a color

pal <- colorNumeric(
  palette = "YlGnBu",
  domain =  #<<------ ADD THE VALUE TO BE MAPPED HERE!
)

map <-leaflet() %>%
  addProviderTiles("ADD PROVIDER OF YOUR CHOICE HERE") %>% #leaflet provider - http://leaflet-extras.github.io/leaflet-providers/preview/
  addPolygons(data = , 
              fillColor = ~pal(percent), 
              color = , #<<---- ADD POLYGON OUTLINE COLOR - you need to use a hex color
              fillOpacity = , #<<----- HOW OPAQUE DO YOU WANT THE COLORS DISPLAYED? 0 TO 1
              weight = 1, 
              smoothFactor = 0.2, #how much to simplify the line on each zoom
              popup = popup) %>%
  addLegend(pal = pal, 
            values = , #<<------ ADD THE VECTOR FROM VEHICLE DATA TO BE DISPLAYED ON THE LEGEND
            position = "WHERE DO YOU WANT THE LEGEND TO BE POSITIONED ON THE MAP???", 
            title = "NAME THIS LEGEND!",
            labFormat = labelFormat(suffix = "%")) 
map
