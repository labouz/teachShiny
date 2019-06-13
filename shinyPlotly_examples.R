library(tidyverse)
library(plotly)

data(mtcars)

#translate a ggplot object

g <- ggplot(data = mtcars)

plot <- g + 
  geom_point(mapping = aes(x = hp, y = mpg, color = cyl))

ggplotly(plot)


#create plotly object directly

p <- plot_ly(data = mtcars, x = ~hp, y = ~ mpg, type = "scatter", mode = "markers")
p
