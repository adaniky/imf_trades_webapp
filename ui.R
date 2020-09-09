library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Europian Country Trades"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    selectInput("country", "Select country:", 
                choices = iso_countries),
    
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