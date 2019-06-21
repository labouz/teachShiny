library(tidyverse)
library(acs)
library(tigris)

#create a choropleth map of the percentage of people with no vehicle available
#per county in the state of FL

#lets get the spatial data
#fl_counties <- counties(state = "FL")
#saveRDS(fl_counties, "./babyApp2/data/fl_counties.rds")
fl_counties <- readRDS("./myBaby/data/fl_counties.rds")

#get the census data
geo <- geo.make(state = "FL", county = "*")

vehicle <- acs.fetch(endyear = 2015,
                      geography = geo,
                      table.number = "B08141",
                      dataset = "acs",
                      col.names = "pretty")

#print the colnames to console
attr(vehicle, "acs.colnames")

#create a dataframe that we will map
vehicle_df <- data_frame("county" = paste0(str_pad(vehicle@geography$county, 3, "left", pad = "0")),
                         "total" = vehicle@estimate[, c("MEANS OF TRANSPORTATION TO WORK BY VEHICLES AVAILABLE: Total:")],
                         "noVehicle" = vehicle@estimate[,c("MEANS OF TRANSPORTATION TO WORK BY VEHICLES AVAILABLE: No vehicle available")])

#calculate the pecentage of people with no vehicle
vehicle_df$percent <- 100 * (vehicle_df$noVehicle/vehicle_df$total)

#savedata
saveRDS(vehicle_df, "./babyApp2/data/vehicle_df.rds")

#merge data to spatial data using the geo_join function from tigris

vehicle_merged <- geo_join(fl_counties, vehicle_df,
                          by_sp="COUNTYFP", by_df = "county")

saveRDS(vehicle_merged, "./babyApp2/data/vehicle_merged.rds")
