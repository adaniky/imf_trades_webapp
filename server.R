library(shiny)
library(datasets)
# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  
  datasetInput <- reactive({
    unique(get_imf_date(input$year,
                        input$type,
                        input$country))
  })
  
  # Show the dataset
  output$view <- renderTable({
    datasetInput()
  })
})