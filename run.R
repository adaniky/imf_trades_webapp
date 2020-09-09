pkgs <- c('jsonlite', 'batchscr', 'curl', 'shiny')
for(i in pkgs){if(!require(i, character.only = T))install.packages(i); library(i, character.only = T)}

source('raw_DOTS.R')

port <- Sys.getenv('PORT')
shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)