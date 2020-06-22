#map the state of wy counties and potentially income data
library(tidyverse)
library(tigris)
library(leaflet)
library(tidycensus)


wy <- tigris::counties(state = "WY")

tigris::places()

#convert from spdf to df
wy_df <- sf::st_as_sf(wy)

#get information on median income from the census
income <- get_acs(geography = "county",
                  state = "WY",
                  variables = "S1901_C01_012")

wy_income <- wy_df %>% 
  left_join(income, by = "GEOID")

pal <- colorBin("inferno", domain = wy_income$estimate)

leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(data = wy_income,
              fillColor = ~pal(estimate),
              color = "grey",
              popup = wy_df$NAMELSAD) %>% 
  addMarkers(lng = -110.828052, lat = 44.460617) %>% 
  addLegend(position = "bottomright",
            pal = pal,
            values = wy_income$estimate)

