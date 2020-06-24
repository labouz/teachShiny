library(tidyverse)
library(plotly)

data(mtcars)

p <- plot_ly(data = mtcars,
             type = "scatter",
             mode = "markers") %>% 
  add_trace(
    x = ~hp,
    y = ~mpg,
    marker = list(
      color = '#22F082',
      size = 10),
    showlegend = FALSE) %>% 
  layout(title = "1974 Motor Trend US - MPG vs HP",
         xaxis = list(title = "Gross Horsepower",
                      zeroline = TRUE,
                      range = c(0, 300)),
         yaxis = list(title = "Miles/(US) Gallon",
                      range = c(0, 35))
  )

p