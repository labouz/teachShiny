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
  domain = vehicle_merged$percent #the mapped values
)

map <-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>% #leaflet provider - http://leaflet-extras.github.io/leaflet-providers/preview/
  addPolygons(data = vehicle_merged, 
              fillColor = ~pal(percent), 
              color = "#b2aeae", # outline color- you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2, #how much to simplify the line on each zoom
              popup = popup) %>%
  addLegend(pal = pal, 
            values = vehicle_merged$percent, 
            position = "bottomright", 
            title = "Percent with no vehicle",
            labFormat = labelFormat(suffix = "%")) 
map
