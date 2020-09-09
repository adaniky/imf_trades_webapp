pkgs <- c('jsonlite', 'data.table', 'batchscr', 'curl', 'shiny')
for(i in pkgs){if(!require(i, character.only = T))install.packages(i); library(i, character.only = T)}
source('raw_DOTS.R')


#dots_data <- unique(get_imf_date(2015, 'TXG_FOB_USD' , "UA"))



shiny::runApp()