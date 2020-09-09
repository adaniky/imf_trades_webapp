library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("European countries trades"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    selectInput("country", "Select country:", 
                choices = countries),
    selectInput("year", "Select year:", 
                choices = gfi_dates),
    selectInput("type", "Select trade type:", 
                choices = trade_types)
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    tableOutput("view")
  )
))