library(shiny)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  
  datasetInput <- reactive({
    if (input$type == 'Imports (million USD)'){
      trade_type <- 'TMG_FOB_USD+TMG_CIF_USD'
    }
    else {
      trade_type <- 'TXG_FOB_USD'
    }
    iso_country <- bridge[bridge$i_iso_name==input$country,'i_iso'] 
    data <- unique(get_imf_date(input$year,
                        trade_type,
                        iso_country))
    
    names(bridge) <- c("j_iso", "j_iso_name")
    data <- merge(data, bridge)
    
    names(bridge) <- c("i_iso", "i_iso_name")
    data <- merge(data, bridge)
    
    data[(data$ind=='TMG_CIF_USD'),"value"] <- data[(data$ind=='TMG_CIF_USD'),"value"] / (1.+cif_margin_exog)
    data <- data[,c("i_iso_name", "j_iso_name", "value")]
    names(data) <- c("reporter", "partner", "trade")
    data
  })
  
  # Show the dataset
  output$view <- renderTable({
    datasetInput()
  })
})