# BLS에서 데이터를 받기 위한 함수수
blsAPI <- function(payload=NA, api_version=1, return_data_frame=FALSE){
  if (class(payload) == "logical"){
    # Payload not defined
    message("blsAPI: No payload specified.")
  }
  else{
    # Payload specified so make the request
    api_url <- paste0("https://api.bls.gov/publicAPI/v",
                      api_version,
                      "/timeseries/data/")
    if (is.list(payload)){
      # Multiple Series or One or More Series, Specifying Years request
      payload <- rjson::toJSON(payload)
      m <- regexpr('\\"seriesid\\":\\"[a-zA-Z0-9-]*\\",', payload)
      str <- regmatches(payload, m)
      if (length(str) > 0){
        # wrap single series in []
        replace <- sub(",", "],", sub(":", ":[", str))
        payload <- sub(str, replace, payload)
      }
      response <- httr::POST(url = api_url, body = payload, httr::content_type_json())
    }
    else{
      # Single Series request
      response <- httr::GET(url = paste0(api_url, payload))
    }
    
    
    # Return the results of the API call
    if (return_data_frame){
      json <- rjson::fromJSON(rawToChar(response$content))
      if (json$status != "REQUEST_SUCCEEDED") {
        stop(paste("blsAPI call failed",
                   paste(json$message, collapse = ";"),
                   sep=":"))
      }
      # Iterate over the series
      number_of_series <- length(json$Results$series)
      for (i in 1:number_of_series){
        # Set the default structure of the data frame
        df_start <- data.frame(year = character(),
                               period = character(),
                               periodName = character(),
                               value = character(),
                               stringsAsFactors = FALSE)
        # Get the data
        series_data <- json$Results$series[[i]]$data
        # Can get no data after a successful request
        if (length(series_data) > 0) {
          j <- 0
          for (d in series_data) {
            j <- j + 1
            # Remove the footnotes from the list to stop the warnings
            d$footnotes <- NULL
            d$latest <- NULL
            # Add record to the data frame
            df_start[j, ] <- unlist(d)
          }
          # Add in the series id
          df_start$seriesID <- json$Results$series[[i]]$seriesID
        }
        # Create the data frame that will be returned
        if (!exists("df_to_return")){
          # Data frame to return not defined so create it
          df_to_return <- df_start
        }
        else {
          # Append to the existing data frame
          df_to_return <- rbind(df_to_return, df_start)
        }
      }
      return(df_to_return)
    }
    else {
      # Return the JSON results
      return(rawToChar(response$content))
    }
  }
}

api_call <- function(link,level=1){
  # require(plyr) 
  # require(httr)
  # require(jsonlite)
  # require(data.table)
  if(level==1){
    tmp_resp <- GET(link) # 통계청 사이트에 해당 링크의 정보 다운로드
    tmp_json <- content(tmp_resp, as='text') # 해당 데이터의 json화
    tmp <- fromJSON(txt = tmp_json %>% as.character()) %>% # json형태의 데이터를 data.frame화 시킴
      as.data.table() # data.frame을 data.table 형태로 변환
    tmp <- tmp %>% select(PRD_DE,DT,ITM_NM,C1_NM) # 사용할 변수들을 추출
    tmp$PRD_DE <- as.numeric(tmp$PRD_DE) # 날짜 변수의 상수화
    tmp
  }else if(level==2){
    tmp_resp <- GET(link) # 통계청 사이트에 해당 링크의 정보 다운로드
    tmp_json <- content(tmp_resp, as='text') # 해당 데이터의 json화
    tmp <- fromJSON(txt = tmp_json %>% as.character()) %>% # json형태의 데이터를 data.frame화 시킴
      as.data.table() # data.frame을 data.table 형태로 변환
    tmp <- tmp %>% select(PRD_DE,DT,ITM_NM,C1_NM,C2_NM) # 사용할 변수들을 추출
    tmp$PRD_DE <- as.numeric(tmp$PRD_DE) # 날짜 변수의 상수화
    tmp
  }else{
    tmp <- NA
  }
}

initial_cleaning <- function(data,level=1){
  # require(data.table)
  tmp <- data
  tmp <- as.data.table(tmp) # 완성된 데이터를 data.table화
  tmp$year <- tmp$PRD_DE%/%100 # 년도 변수 생성
  tmp$month <- tmp$PRD_DE%%100 # 월 변수 생성
  tmp$date <-as.Date(paste0(tmp$year,"-",tmp$month,"-01")) # 날짜 변수를 Date()형식으로 생성
  tmp$DT <- as.numeric(tmp$DT) # 전 변수의 수치를 상수화
  if(level==1){
    tmp <- dcast(tmp,formula = date+year+month+C1_NM~ITM_NM, value.var = "DT") # wide 형태로 변환
  } else if(level==2){
    tmp <- dcast(tmp,formula = date+year+month+C1_NM+C2_NM~ITM_NM, value.var = "DT") # wide 형태로 변환
  } else if(level==0){
    tmp <- dcast(tmp,formula = date+year+month~ITM_NM, value.var = "DT") # wide 형태로 변환
  } else{tmp <- NA}
  tmp
}