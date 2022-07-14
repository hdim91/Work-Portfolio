source("report_functions.R")

## 계절조정 데이터 추출 ##
main_season_cleaning <- function(data){
  # require(plyr)
  # require(tidyverse)
  # require(data.table)
  
  data[,emprate := emp/pop*100] # 고용률 변수 생성
  
  # 변화율
  data[,lag.active.month := lag(active),by=gender] # 성별X월별 lag 변수 생성
  data[,lag.active.yr := lag(active),by=c("gender","month")] # 성별X년도별 lag 변수 생성
  data[,active_mth_diff := (active-lag.active.month)/lag.active.month*100] # 전월대비 변수 생성
  data[,active_yr_diff := (active-lag.active.yr)/lag.active.yr*100] # 전년동월대비 변수 생성
  
  # 위와 같은 방식으로 변수 생성
  data[,lag.unemp.month := lag(unemp),by=gender]
  data[,lag.unemp.yr := lag(unemp),by=c("gender","month")]
  data[,unemp_mth_diff := (unemp-lag.unemp.month)/lag.unemp.month*100]
  data[,unemp_yr_diff := (unemp-lag.unemp.yr)/lag.unemp.yr*100]
  
  data[,lag.emp.month := lag(emp),by=gender]
  data[,lag.emp.yr := lag(emp),by=c("gender","month")]
  data[,emp_mth_diff := (emp-lag.emp.month)/lag.emp.month*100]
  data[,emp_yr_diff := (emp-lag.emp.yr)/lag.emp.yr*100]
  
  data[,unemprate := round(unemp/active*100,1)]
  data[,lag.unempr.month := lag(unemprate), by = gender]
  data[,lag.unempr.yr := lag(unemprate), by = c("gender","month")]
  
  data[,actrate := round(active/pop*100,1)]
  data[,lag.actr.month := lag(actrate), by = gender]
  data[,lag.actr.yr := lag(actrate), by = c("gender","month")]
}
gen_main_season <- function(api_key){
  # T10 = 인구, T20 = 경제활동인구, T30 = 취업자, T40 = 실업자
  glist <- expand.grid(c("T10","T20","T30","T40"),
                       c("00",10,20)) # 성별 및 변수 조합 data frame 생성
  
  # expand.grid()는 특정 벡터들을 조합하여 관계 DB를 만드는 명령어로서, 위처럼 4*3의 조합을 만들때 유용
  
  front <- paste0("https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=",
                  api_key,
                  "&itmId=")
  mid1 <- "+&objL1="
  mid2 <- paste0("+&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=M&startPrdDe=",start_date-100,"&endPrdDe=")
  back <- "&loadGubun=1&orgId=101&tblId=DT_1DA9001S"
  
  # merge를 시킬 대상 데이터를 먼저 다운로드
  # 전체 인구 데이터를 먼저 다운로드 하여 merge할 대상으로서의 데이터 기반 구축
  active_1_00 <- paste0(front,glist[1,1],mid1,glist[1,2],mid2,latest_date,back) # 전체 15세 이상 인구 데이터 링크 생성
  main_season <- api_call(active_1_00) # api_call 명령어를 통해 api기반 DB 생성성
  
  for(i in 2:dim(glist)[1]){ # [glist]를 활용하여 for loop를 통해 데이터 취합
    tmp <- paste0(front,glist[i,1],mid1,glist[i,2],mid2,latest_date,back) # 나머지 DB들도 통합
    main_season <- rbind(main_season,api_call(tmp))
  }
  
  main_season <- initial_cleaning(main_season)
  # main_season <- dcast(main_season,formula = date+year+month+C1_NM~ITM_NM, value.var = "DT") # wide 형태로 변환
  names(main_season) <- c("date","year","month","gender", "pop","active","unemp","emp") # 변수명들을 사용하기 쉽게 변환
  
  main_season_cleaning(main_season)
}
#######################################
## 원계열 총괄 데이터 추출 ##
main_nons_cleaning <- function(main_nons){
  # require(plyr)
  # require(tidyverse)
  # require(data.table)
  
  main_nons[,emprate := emp/pop*100]
  main_nons[,lag.active.month := lag(active)]
  main_nons[,lag.active.yr := lag(active),by=month]
  main_nons[,active_mth_diff := (active-lag.active.month)]
  main_nons[,active_yr_diff := (active-lag.active.yr)]
  main_nons[,lag.unemp.month := lag(unemp)]
  main_nons[,lag.unemp.yr := lag(unemp),by=month]
  main_nons[,unemp_mth_diff := (unemp-lag.unemp.month)]
  main_nons[,unemp_yr_diff := (unemp-lag.unemp.yr)]
  main_nons[,lag.emp.month := lag(emp)]
  main_nons[,lag.emp.yr := lag(emp),by=month]
  main_nons[,emp_mth_diff := (emp-lag.emp.month)]
  main_nons[,emp_yr_diff := (emp-lag.emp.yr)]
  main_nons[,emprate :=round(emp/pop*100,1)]
  main_nons[,lag.empr.yr := lag(emprate), by=month]
  main_nons[,unemprate := round(unemp/active*100,1)]
  main_nons[,lag.unempr.yr := lag(unemprate), by = month]
}
gen_main_nons <- function(api_key){
  varlist <- c("T10","T20","T30","T40")
  front <- paste0("https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=",
                  api_key,
                  "&itmId=")
  mid <- paste0("+&objL1=0+&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=M&startPrdDe=",start_date,"&endPrdDe=")
  back <- "&loadGubun=1&orgId=101&tblId=DT_1DA7001S"
  
  active_1_00 <- paste0(front,varlist[1],mid,latest_date,back)
  main_nons <- api_call(active_1_00)
  
  for(i in 2:length(varlist)[1]){
    tmp <- paste0(front,varlist[i],mid,latest_date,back)
    main_nons <- rbind(main_nons,api_call(tmp))
  }
  
  main_nons <- initial_cleaning(data=main_nons,level=0)
  names(main_nons)[4:7] <- c("pop","active","unemp","emp")
  main_nons_cleaning(main_nons)
}
#######################################
## 보고서용 변수들 생성 ##
# gen_report_vecs <- function(main_nons){
#   assign("report_active_mth",main_nons[main_nons$date==max(main_nons$date)]$active_mth_diff)
#   assign("report_active_yr",main_nons[main_nons$date==max(main_nons$date)]$active_yr_diff)
#   assign("report_unemp_mth",main_nons[main_nons$date==max(main_nons$date)]$unemp_mth_diff)
#   assign("report_unemp_yr",main_nons[main_nons$date==max(main_nons$date)]$unemp_yr_diff)
#   assign("report_emp_mth",main_nons[main_nons$date==max(main_nons$date)]$emp_mth_diff)
#   assign("report_emp_yr",main_nons[main_nons$date==max(main_nons$date)]$emp_yr_diff)
#   c()
# }
#######################################
## 성별X연령별 데이터 추출 ##
newageg_nons_cleaning <- function(newageg){
  # require(plyr)
  # require(tidyverse)
  # require(data.table)
  newageg[, pop := pop-lag(pop), by = c("date","gender","year","month")]
  newageg[, active := active-lag(active), by = c("date","gender","year","month")]
  newageg[, unemp := unemp-lag(unemp), by = c("date","gender","year","month")]
  newageg[, emp := emp-lag(emp), by = c("date","gender","year","month")]
}
gen_main_gender <- function(api_key){
  agelist <- c("00",70,75,30,40,50,60)
  glist <- expand.grid(c("T10","T20","T30","T40"),
                       c(2,3),
                       agelist)
  front <- paste0("https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=",
                  api_key,
                  "&itmId=")
  unemp <- "T40"
  active <- "T20"
  emp <- "T30"
  mid1 <- "+&objL1="
  mid2 <- "+&objL2="
  mid3 <- paste0("+&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=M&startPrdDe=",start_date,"&endPrdDe=")
  back <- "&loadGubun=1&orgId=101&tblId=DT_1DA7012S"
  
  active_1_00 <- paste0(front,glist[1,1],mid1,glist[1,2],mid2,glist[1,3],mid3,latest_date,back)
  main <- api_call(active_1_00,level = 2)
  
  for(i in 2:dim(glist)[1]){
    tmp <- paste0(front,glist[i,1],mid1,glist[i,2],mid2,glist[i,3],mid3,latest_date,back)
    main <- rbind(main,api_call(tmp, level=2))
  }
  main <- initial_cleaning(data = main,level = 2)
  names(main) <- c("date","year","month","gender","ageg","pop","active","unemp","emp")
  
  ageg <- unique(main$ageg)
  newageg <- main[ageg %in% ageg[c(1,2)]]
  newageg_nons_cleaning(newageg)
  newageg <- newageg[!is.na(pop)]
  newageg[,ageg := "25 - 29세"]
  main <- rbind(main,newageg)
  main <- main[ageg != "15 - 29세"]
  main <- main[order(date,gender,ageg)]
  
  main[,emp.diff.mth := emp - lag(emp)][,lag.emp.yr := lag(emp), by=c("month","gender","ageg")][,emp.diff.yr := emp-lag.emp.yr]
  main[,emprate := emp/pop*100]
  main[,empr.diff.mth := emprate - lag(emprate)][,lag.empr.yr := lag(emprate), by = c("month","gender","ageg")][,empr.diff.yr := emprate - lag.empr.yr]
}
#######################################
## 산업별 데이터 클리닝 ##
call_main_ind <- function(api_key){
  indlist <- c(10,41:45,49,55,58,64,68,70,74,84,85,86,90,94,97,99)
  front <- paste0("https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=",
                  api_key,
                  "&itmId=T30")
  mid1 <- "+&objL1="
  mid2 <- paste0("+&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=M&startPrdDe=",start_date,"&endPrdDe=")
  back <- "&loadGubun=1&orgId=101&tblId=DT_1DA7E06S"
  
  active_1_00 <- paste0(front,mid1,indlist[1],mid2,latest_date,back)
  main_ind <- api_call(active_1_00)
  
  for(i in 2:length(indlist)){
    tmp <- paste0(front,mid1,indlist[i],mid2,latest_date,back)
    main_ind <- rbind(main_ind,api_call(tmp))
  }
  main_ind_ <- as.data.table(main_ind)
  main_ind$year <- main_ind$PRD_DE%/%100
  main_ind$month <- main_ind$PRD_DE%%100
  main_ind$date <-as.Date(paste0(main_ind$year,"-",main_ind$month,"-01"))
  main_ind$DT <- as.numeric(main_ind$DT)
  main_ind
}
main_ind_cleaning <- function(main_ind){
  main_ind[,lag.emp.month := lag(emp),by=c("ind")]
  main_ind[,lag.emp.yr := lag(emp),by=c("ind","month")]
  main_ind[,emp_mth_diff := (emp-lag.emp.month)]
  main_ind[,emp_yr_diff := (emp-lag.emp.yr)]
}
# 서비스업별 데이터 클리닝 #
main_ser_cleaning <- function(main_ser){
  main_ser[,lag.emp.month := lag(emp),by=c("ind")]
  main_ser[,lag.emp.yr := lag(emp),by=c("ind","month")]
  main_ser[,emp_mth_diff := (emp-lag.emp.month)]
  main_ser[,emp_yr_diff := (emp-lag.emp.yr)]
}
gen_main_ser <- function(main_ind){
  main_ser <- dcast(main_ind,formula = date+C1_NM+month+year~ITM_NM,value.var = "DT")
  industry <- unique(main_ind$C1_NM)
  names(main_ser) <- c("date","ind10","month","year","emp")
  service <- industry[6:length(industry)]
  main_ser[ind10 %in% service]
  main_ser[,ind := ifelse(ind10 %in% service[c(3,1,13,12,10)],"대면 서비스",
                          ifelse(ind10 %in% service[c(9,11)], "공공 서비스","기타 서비스"))]
  main_ser <- main_ser[,keyby = c("date","year","month","ind"),
                       .(emp = sum(emp,na.rm = TRUE))]
  main_ser_cleaning(main_ser)
}
gen_main_ind <- function(main_ind){
  main_ind <- dcast(main_ind,formula = date+C1_NM+month+year~ITM_NM,value.var = "DT")
  names(main_ind)[5] <- "emp"
  names(main_ind)[2] <- "ind10"
  industry <- unique(main_ind$ind10)
  main_ind[,ind:=ifelse(ind10==industry[4],"제조업",
                        ifelse(ind10==industry[5],"건설업",
                               ifelse(ind10 %in% industry[6:length(industry)],"서비스업",NA)))]
  main_ind <- main_ind[!is.na(ind)]
  main_ind <- main_ind[,keyby=c("date","year","month","ind"),
                       .(emp = sum(emp,na.rm = TRUE))]
  main_ind_cleaning(main_ind)
}
#######################################
## 계절조정 산업별 데이터 클리닝 ##
# 계절조정 산업별 기본 데이터 클리닝 #
season_ind_cleaning <- function(api_key){
  tmp_link <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/101/DT_1DA9003S/2/1/20220531134510_",1,"&prdSe=M&startPrdDe=201701&endPrdDe=202204")
  season_ind <- api_call(tmp_link)
  for(i in 2:17){
    tmp_link <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/101/DT_1DA9003S/2/1/20220531134510_",i,"&prdSe=M&startPrdDe=201701&endPrdDe=202204")
    season_ind <- rbind(season_ind,api_call(tmp_link))
  }
  season_ind <- as.data.table(season_ind)
  season_ind$year <- season_ind$PRD_DE%/%100
  season_ind$month <- season_ind$PRD_DE%%100
  season_ind$date <-as.Date(paste0(season_ind$year,"-",season_ind$month,"-01"))
  season_ind$DT <- as.numeric(season_ind$DT)
  season_ind
}
# 계절조정 서비스업 세부 클리닝 #
season_ser_cleaning <- function(season_ind){
  industry <- unique(season_ind$C1_NM)
  season_ser <- dcast(season_ind,formula = date+C1_NM+month+year~ITM_NM,value.var = "DT")
  names(season_ser) <- c("date","ind10","month","year","emp")
  service <- industry[3:length(industry)]
  season_ser <- season_ser[ind10 %in% service]
  season_ser[,ind := ifelse(ind10 %in% service[c(3,1,13,12,10)],"대면지역서비스",
                            ifelse(ind10 %in% service[c(9,11)], "공공 서비스",
                                   ifelse(ind10 %in% service[c(4,5,7)],"지식기반서비스","비대면지역서비스")))]
  season_ser <- season_ser[,keyby = c("date","year","month","ind"),
                           .(emp = sum(emp,na.rm = TRUE))]
  
  season_ser[,lag.emp.month := lag(emp),by=c("ind")]
  season_ser[,lag.emp.yr := lag(emp),by=c("ind","month")]
  season_ser[,emp_mth_diff := (emp-lag.emp.month)]
  season_ser[,emp_yr_diff := (emp-lag.emp.yr)]
  season_ser
}
# 계절조정 산업별 단순분류 클리닝 #
season_ind_cleaning2 <- function(season_ind){
  season_ind <- dcast(season_ind,formula = date+C1_NM+month+year~ITM_NM,value.var = "DT")
  names(season_ind)[5] <- "emp"
  names(season_ind)[2] <- "ind10"
  industry <- unique(season_ind$ind10)
  season_ind[,ind:=ifelse(ind10==industry[1],"제조업",
                          ifelse(ind10==industry[2],"건설업",
                                 ifelse(ind10 %in% industry[3:length(industry)],"서비스업",NA)))]
  season_ind <- season_ind[!is.na(ind)]
  season_ind <- season_ind[,keyby=c("date","year","month","ind"),
                           .(emp = sum(emp,na.rm = TRUE))]
  
  season_ind[,lag.emp.month := lag(emp),by=c("ind")]
  season_ind[,lag.emp.yr := lag(emp),by=c("ind","month")]
  season_ind[,emp_mth_diff := (emp-lag.emp.month)]
  season_ind[,emp_yr_diff := (emp-lag.emp.yr)]
  pop <- main_season %>% filter(gender=="계") %>% select(date,pop)
  season_ind <- season_ind %>% left_join(pop,by="date")
  season_ind <- season_ind %>% mutate(emprate = emp/pop*100)
}
#######################################
## 종사상지위별 클리닝 ##
main_rank_cleaning <- function(main_rank){
  main_rank[,lag.emp.month := lag(emp),by=c("ranking")]
  main_rank[,lag.emp.yr := lag(emp),by=c("ranking","month")]
  main_rank[,emp_mth_diff := (emp-lag.emp.month)]
  main_rank[,emp_yr_diff := (emp-lag.emp.yr)]
}
gen_main_rank <- function(api_key){
  # start_date <- 198207 # 최소기간
  ranklist <- c(41,51,52,10,21)
  front <- paste0("https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=",
                  api_key,
                  "&itmId=T30")
  mid1 <- "+&objL1="
  mid2 <- paste0("+&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=M&startPrdDe=",start_date,"&endPrdDe=")
  back <- "&loadGubun=1&orgId=101&tblId=DT_1DA7010S"
  
  active_1_00 <- paste0(front,mid1,ranklist[1],mid2,latest_date,back)
  main_rank <- api_call(active_1_00)
  
  for(i in 2:length(ranklist)){
    tmp <- paste0(front,mid1,ranklist[i],mid2,latest_date,back)
    main_rank <- rbind(main_rank,api_call(tmp))
  }
  main_rank <- initial_cleaning(main_rank)
  
  
  names(main_rank)[5] <- "emp"
  names(main_rank)[4] <- "rank"
  
  ranks <- unique(main_rank$rank)
  main_rank[,ranking:=ifelse(rank==ranks[3],"상용근로자",
                             ifelse(rank%in%ranks[c(4:5)],"일용·임시근로자",
                                    ifelse(rank==ranks[2],"고용주","개인자영자")))]
  main_rank <- main_rank[,keyby=c("date","year","month","ranking"),
                         .(emp = sum(emp,na.rm = TRUE))]
  main_rank_cleaning(main_rank)
}
#######################################
## 종사자규모별 클리닝 ##
main_size_cleaning <- function(main_size){
  main_size[,lag.emp.month := lag(emp),by=c("size")]
  main_size[,lag.emp.yr := lag(emp),by=c("size","month")]
  main_size[,emp_mth_diff := (emp-lag.emp.month)]
  main_size[,emp_yr_diff := (emp-lag.emp.yr)]
}
gen_main_size <- function(api_key){
  sizelist <- c(10,15,65)
  front <- paste0("https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=",
                  api_key,
                  "&itmId=T30")
  mid1 <- "+&objL1="
  mid2 <- paste0("+&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=M&startPrdDe=",start_date,"&endPrdDe=")
  back <- "&loadGubun=1&orgId=101&tblId=DT_1DA7A64S"
  
  active_1_00 <- paste0(front,mid1,sizelist[1],mid2,latest_date,back)
  main_size <- api_call(active_1_00)
  
  for(i in 2:length(sizelist)){
    tmp <- paste0(front,mid1,sizelist[i],mid2,latest_date,back)
    main_size <- rbind(main_size,api_call(tmp))
  }
  main_size <- initial_cleaning(main_size)
  
  names(main_size)[5] <- "emp"
  names(main_size)[4] <- "size"
  sizes <- unique(main_size$size)
  main_size_cleaning(main_size)
}
#######################################
## 청년 부가지표 ##
sub_youth_cleaning <- function(){

  sub_link <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/101/DT_1DA7300AS/2/1/20220216110514_1&prdSe=M&startPrdDe=201501&endPrdDe=",latest_date)
  sub_df <- api_call(sub_link)
  sub_df$year <- sub_df$PRD_DE%/%100
  sub_df$month <- sub_df$PRD_DE%%100
  sub_df$date <- as.Date(paste0(sub_df$year,"-",sub_df$month,"-01")) # 날짜 변수를 Date()형식으로 생성
  sub_df$DT <- as.numeric(sub_df$DT)
  sub_df
}
main_sub_total_cleaning <- function(){

  sub_link <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/101/DT_1DA7300S/2/1/20220216115358_1&prdSe=M&startPrdDe=201501&endPrdDe=",latest_date)
  sub_df <- api_call(sub_link)
  sub_df$year <- sub_df$PRD_DE%/%100
  sub_df$month <- sub_df$PRD_DE%%100
  sub_df$date <- as.Date(paste0(sub_df$year,"-",sub_df$month,"-01")) # 날짜 변수를 Date()형식으로 생성
  sub_df$DT <- as.numeric(sub_df$DT)
  sub_df
}
#######################################
# 전체임금총액 import 및 클리닝
main_wage_cleaning <- function(){

  wage_link1 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON041/2/1/20220526145017_1&prdSe=M&startPrdDe=201701&endPrdDe=201912")
  wage_df1 <- api_call(wage_link1)
  wage_link2 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON051/2/1/20220526144927_1&prdSe=M&startPrdDe=202001&endPrdDe=",latest_date)
  wage_df2 <- api_call(wage_link2)
  wage_df <- rbind(wage_df1,wage_df2)
  
  wage_df$year <- wage_df$PRD_DE%/%100
  wage_df$month <- wage_df$PRD_DE%%100
  wage_df$date <-as.Date(paste0(wage_df$year,"-",wage_df$month,"-01"))
  wage_df$DT <- as.numeric(wage_df$DT)
  wage_df
}
main_wage_total_cleaning <- function(main_wage_total){
  names(main_wage_total)[2] <- "wage"
  main_wage_total[,lag.wage.month := lag(wage)]
  main_wage_total[,lag.wage.yr := lag(wage),by=c("month")]
  main_wage_total[,wage_mth_diff := (wage-lag.wage.month)]
  main_wage_total[,wage_yr_diff := (wage-lag.wage.yr)]
  main_wage_total[,wage_mth_diff_rate := round((wage-lag.wage.month)/lag.wage.month*100,1)]
  main_wage_total[,wage_yr_diff_rate := round((wage-lag.wage.yr)/lag.wage.yr*100,1)]
}
#######################################
# 상용임금총액 import 및 클리닝
main_wage_reg_cleaning <- function(){

  wage_link1 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON041/2/1/20220526145017_2&prdSe=M&startPrdDe=201701&endPrdDe=201912")
  wage_df1 <- api_call(wage_link1)
  wage_link2 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON051/2/1/20220526144927_2&prdSe=M&startPrdDe=202001&endPrdDe=",latest_date)
  wage_df2 <- api_call(wage_link2)
  wage_df <- rbind(wage_df1,wage_df2)
  
  wage_df$year <- wage_df$PRD_DE%/%100
  wage_df$month <- wage_df$PRD_DE%%100
  wage_df$date <-as.Date(paste0(wage_df$year,"-",wage_df$month,"-01"))
  wage_df$DT <- as.numeric(wage_df$DT)
  wage_df
}
main_wage_reg_cleaning2 <- function(main_wage_reg){
  names(main_wage_reg)[2] <- "wage"
  main_wage_reg[,lag.wage.month := lag(wage)]
  main_wage_reg[,lag.wage.yr := lag(wage),by=c("month")]
  main_wage_reg[,wage_mth_diff := (wage-lag.wage.month)]
  main_wage_reg[,wage_yr_diff := (wage-lag.wage.yr)]
  main_wage_reg[,wage_mth_diff_rate := round((wage-lag.wage.month)/lag.wage.month*100,1)]
  main_wage_reg[,wage_yr_diff_rate := round((wage-lag.wage.yr)/lag.wage.yr*100,1)]
}
#######################################
# 상용정액급여 import 및 클리닝
base_wage_reg_cleaning <- function(){

  wage_link1 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON041/2/1/20220526145017_3&prdSe=M&startPrdDe=201701&endPrdDe=201912")
  wage_df1 <- api_call(wage_link1)
  wage_link2 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON051/2/1/20220526144927_3&prdSe=M&startPrdDe=202001&endPrdDe=",latest_date)
  wage_df2 <- api_call(wage_link2)
  wage_df <- rbind(wage_df1,wage_df2)
  
  wage_df$year <- wage_df$PRD_DE%/%100
  wage_df$month <- wage_df$PRD_DE%%100
  wage_df$date <-as.Date(paste0(wage_df$year,"-",wage_df$month,"-01"))
  wage_df$DT <- as.numeric(wage_df$DT)
  wage_df
}
base_wage_reg_cleaning2 <- function(base_wage_reg){
  names(base_wage_reg)[2] <- "wage"
  base_wage_reg[,lag.wage.month := lag(wage)]
  base_wage_reg[,lag.wage.yr := lag(wage),by=c("month")]
  base_wage_reg[,wage_mth_diff := (wage-lag.wage.month)]
  base_wage_reg[,wage_yr_diff := (wage-lag.wage.yr)]
  base_wage_reg[,wage_mth_diff_rate := round((wage-lag.wage.month)/lag.wage.month*100,1)]
  base_wage_reg[,wage_yr_diff_rate := round((wage-lag.wage.yr)/lag.wage.yr*100,1)]
}
#######################################
# 상용초과급여 import 및 클리닝
extra_wage_reg_cleaning <- function(){

  wage_link1 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON041/2/1/20220526145017_4&prdSe=M&startPrdDe=201701&endPrdDe=201912")
  wage_df1 <- api_call(wage_link1)
  wage_link2 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON051/2/1/20220526144927_4&prdSe=M&startPrdDe=202001&endPrdDe=",latest_date)
  wage_df2 <- api_call(wage_link2)
  wage_df <- rbind(wage_df1,wage_df2)
  
  wage_df$year <- wage_df$PRD_DE%/%100
  wage_df$month <- wage_df$PRD_DE%%100
  wage_df$date <-as.Date(paste0(wage_df$year,"-",wage_df$month,"-01"))
  wage_df$DT <- as.numeric(wage_df$DT)
  wage_df
}
extra_wage_reg_cleaning2 <- function(extra_wage_reg){
  names(extra_wage_reg)[2] <- "wage"
  extra_wage_reg[,lag.wage.month := lag(wage)]
  extra_wage_reg[,lag.wage.yr := lag(wage),by=c("month")]
  extra_wage_reg[,wage_mth_diff := (wage-lag.wage.month)]
  extra_wage_reg[,wage_yr_diff := (wage-lag.wage.yr)]
  extra_wage_reg[,wage_mth_diff_rate := round((wage-lag.wage.month)/lag.wage.month*100,1)]
  extra_wage_reg[,wage_yr_diff_rate := round((wage-lag.wage.yr)/lag.wage.yr*100,1)]
}
#######################################
# 임시일용임금 총액 import 및 클리닝
main_wage_tmp_cleaning <- function(){

  wage_link1 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON041/2/1/20220526145017_6&prdSe=M&startPrdDe=201701&endPrdDe=201912")
  wage_df1 <- api_call(wage_link1)
  wage_link2 <- paste0("https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=YjUyNTA0OTdjOTlkYjI5NmJlZGE4NGFkNTUwZDU5OWU=&format=json&jsonVD=Y&userStatsId=hdim91/118/DT_118N_MON051/2/1/20220526144927_6&prdSe=M&startPrdDe=202001&endPrdDe=",latest_date)
  wage_df2 <- api_call(wage_link2)
  wage_df <- rbind(wage_df1,wage_df2)
  
  wage_df$year <- wage_df$PRD_DE%/%100
  wage_df$month <- wage_df$PRD_DE%%100
  wage_df$date <-as.Date(paste0(wage_df$year,"-",wage_df$month,"-01"))
  wage_df$DT <- as.numeric(wage_df$DT)
  wage_df
}
main_wage_tmp_cleaning2 <- function(main_wage_tmp){
  
  names(main_wage_tmp)[2] <- "wage"
  main_wage_tmp[,lag.wage.month := lag(wage)]
  main_wage_tmp[,lag.wage.yr := lag(wage),by=c("month")]
  main_wage_tmp[,wage_mth_diff := (wage-lag.wage.month)]
  main_wage_tmp[,wage_yr_diff := (wage-lag.wage.yr)]
  main_wage_tmp[,wage_mth_diff_rate := round((wage-lag.wage.month)/lag.wage.month*100,1)]
  main_wage_tmp[,wage_yr_diff_rate := round((wage-lag.wage.yr)/lag.wage.yr*100,1)]
}
