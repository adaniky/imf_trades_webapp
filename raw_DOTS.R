data_DIR = getwd()  

  gfi_dates <- 2020:2000
  cif_margin_exog <- .06       # CIF/FOB margin applied to imports for countries not reporting on FOB basis (Marini-Dippelsman-Stanger[2018] p. 11)
  
  get_imf_date <- function(gfi_dates, trade_type, countries)
  { 
    res <-data.frame(ind=character(0), i_iso=character(0), j_iso=character(0),year=integer(0),  value=numeric(0))
    min_date <- min(gfi_dates)
    max_date <- max(gfi_dates)
    for (country in countries) {
        cat(paste('Gettin data from IMF for country:', country, sep='' ))
        url_rep <- paste(
          'http://dataservices.imf.org/REST/SDMX_JSON.svc/CompactData/DOT/A.',
          as.character(country), '.',
          trade_type,
          '.?startPeriod=',
          min_date,
          '&endPeriod=',
          max_date,
          sep = ''
        )
        ecycle(resp_rep <- fromJSON(url_rep), 
          {Sys.sleep(3)}, 
          max_try=5, 
          {print(paste('Succesfull Reporter: ', country, sep=''))},
          {Sys.sleep(20)}, 
          cond = is.list(resp_rep))
        url_part <- paste(
          'http://dataservices.imf.org/REST/SDMX_JSON.svc/CompactData/DOT/A..',
          trade_type, '.',
          country,
          '.?startPeriod=',
          min_date,
          '&endPeriod=',
          max_date,
          sep = ''
        )
        ecycle(resp_part <- fromJSON(url_part), 
               {Sys.sleep(3)}, 
               max_try=5, 
               {print(paste('Succesfull Partner: ', country, sep=''))},
               {Sys.sleep(20)}, 
               cond = is.list(resp_part))
        for (resp in c(resp_rep, resp_part) ){
          
          source_data <- resp$DataSet$Series
          if (is.null(source_data)){
            source_data <- resp$CompactData$Series
          }
         
          ind <- c()
          i_iso <- c()
          j_iso <- c()
          year <- c()
          value <- c()
          if (!is.null(source_data)){
          n_rows <- nrow(source_data)
          for (i in 1:n_rows) {
            meta <- source_data[i,]
            values <- as.data.frame(source_data[i,]$Obs)
            n_years <- nrow(values)
            if (!n_years==0) {
              for (j in 1:n_years) 
              { if (!is.null(values[j,"X.TIME_PERIOD"])){
                
                ind <- c(ind, as.character(meta[1, 3]))
                i_iso <- c(i_iso, as.character(meta[1, 2]))
                j_iso <- c(j_iso, as.character(meta[1, 4]))
                year <- c(year, as.integer(as.character(values[j,"X.TIME_PERIOD"])))
                value <- c(value, as.numeric(as.character(values[j,"X.OBS_VALUE"])))
              }
                if (!is.null(values[j,"@TIME_PERIOD"])){
                  
                  ind <- c(ind, as.character(meta[1, 3]))
                  i_iso <- c(i_iso, as.character(meta[1, 2]))
                  j_iso <- c(j_iso, as.character(meta[1, 4]))
                  year <- c(year, as.integer(as.character(values[j,"@TIME_PERIOD"])))
                  value <- c(value, as.numeric(as.character(values[j,"@OBS_VALUE"])))
                }
              }
            }
          }}
          df <- data.frame(ind, i_iso, j_iso, year,  value)
          res <- rbind(res, df)
        }
      
    } 
    res<-res[!is.na(res$year),]
    return(res)
  }
 
    bridge <- fread(file=paste(data_DIR,"/countries.csv",sep=""),header=TRUE,colClasses=c("character","character"), sep=",",na.strings="")
    bridge <- as.data.frame(bridge)
    colnames(bridge) <- c('i_iso', 'i_iso_name')
    iso_countries <- bridge[, 'i_iso']
    trade_types = c('TMG_FOB_USD', 'TXG_FOB_USD')