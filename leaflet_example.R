library(tidyverse)
library(leaflet)
library(tigris)



#geospatial data
fl_state <- counties(state = 12) %>% 
  filter(COUNTYFP %in% c("086","011"))

theColor <- c("#ed9128")

map <-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(data = fl_state, 
              fillColor = "#ed9128",  
              color = "#b2aeae",  
              fillOpacity = 0.4, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = fl_state@data$NAME) %>%
  addLegend(colors = theColor,
            labels = "Florida", 
            position = "bottomleft", 
            title = "This is a Legend") 

map
