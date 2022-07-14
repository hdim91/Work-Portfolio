# plot 1
plot_1 <- function(){
  tmp <- main_nons[year>(start_date%/%100)] # 그래프를 그리기 위한 데이터를 filtering
  tmp[,emp.diff.yr := emp - lag.emp.yr]
  par(mar=c(5,4,2,4)) # 워드에서 구현될 그래프의 팔렛트 형식 설정
  xx <- barplot(tmp$emp.diff.yr,ylab = "천명",names.arg=format(tmp$date,"%Y\n %m"),yaxt="none") # 첫번째 팔렛트에 바 그래프 그리기
  axis(2,las=2,cex.axis=0.8) # y-axis의 글자 각도를 90도로 바꾸기
  par(new=T) # 바 그래프 위에 새로운 팔렛트 겹치기
  plot(tmp$date,tmp$emprate,"l",lwd=2.5,col="black",lty=1, # 고용률 그래프 그리기
       axes=F,ylab="",xlab="날짜",yaxt="none")
  lines(main_season[gender=="계"&year>(start_date%/%100)]$date,main_season[gender=="계"&year>(start_date%/%100)]$emprate,lwd=2.5,col="blue",lty=1,
        ylab="") # 계절조정 고용률 그래프
  axis(4,las=2,cex.axis=0.8)
  mtext("고용률(%)",side=4,line=3)
  title("전체 전년동월대비 취업자 수 및 고용률")
  legend("bottom", # 범례 설정
         # inset = c(0,-0.35),
         legend = c("원계열(우)","계절조정(우)"),
         lty = c(1,1),
         col=c("black","blue"),
         ncol=2,cex=0.8)
  box()
}

# 산업별 취업자
# plot 2-1 
# 산업별 취업자 수 그래프
plot_2_1 <- function(){
  tmp <- main_ind[year>(start_date%/%100)]
  # 산업별 취업자 수 그래프
  par(mar=c(5,4,2,4),xpd=TRUE) # 팔렛트 크기 설정 및 범례 위치 자유화
  plot(tmp[ind=="제조업"]$date,tmp[ind=="제조업"]$emp/10, # 제조업 취업자 수 지정
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",yaxt="none",xaxt="none" # 레이블링 및 그래프 특성 설정
  )
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  axis(2,las=2,cex.axis=0.8) # 각 틱의 특성 설정
  # lines(tmp[ind=="건설업"],lwd=2.5,col="red")
  par(new=TRUE) # double-axis를 위한 새로운 팔랫트 덧씌우기
  plot(tmp[ind=="서비스업"]$date,tmp[ind=="서비스업"]$emp/10, # 서비스업 그래프
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",yaxt="none",
       axes=FALSE)
  title("산업별 취업자")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("제조업(좌)","서비스업(우)"),
         lty = c(1,1),
         lwd = c(2,2),
         col=c("black","blue"),
         ncol=2,cex=0.6)
  box()
}

# plot 2-2
# 산업별 전년동월대비 취업자 그래프
plot_2_2 <- function(){
  tmp <- main_ind[year>(start_date%/%100)]
  par(mar=c(5,4,2,4),xpd=TRUE)
  plot(tmp[ind=="제조업"]$date,tmp[ind=="제조업"]$emp_yr_diff/10, # 제조업 취업자 수 지정
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",yaxt="none",xaxt="none" # 레이블링 및 그래프 특성 설정
  )
  lines(tmp[ind=="건설업"]$date,tmp[ind=="건설업"]$emp_yr_diff/10,lwd=2.5,col="red")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  par(new=TRUE) # double-axis를 위한 새로운 팔랫트 덧씌우기
  plot(tmp[ind=="서비스업"]$date,tmp[ind=="서비스업"]$emp_yr_diff/10, # 서비스업 그래프
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",yaxt="none",
       axes=FALSE)
  title("산업별 전년동월대비 취업자")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("제조업(좌)","건설업(좌)","서비스업(우)"),
         lty = c(1,1,1),
         lwd = c(2,2,2),
         col=c("black","red","blue"),
         ncol=3,cex=0.6)
  box()
}

# plot2-3
# 서비스업별 취업자 수 그래프
plot_2_3 <- function(){
  tmp <- main_ser[year>(start_date%/%100)]
  par(mar=c(6,4,2,4),xpd=TRUE) # 팔렛트 크기 설정 및 범례 위치 자유화
  plot(tmp[ind=="대면 서비스"]$date,tmp[ind=="대면 서비스"]$emp/10, # 대면 서비스 취업자 수 지정
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",yaxt="none",xaxt="none", # 레이블링 및 그래프 특성 설정
       ylim = c(min(tmp$emp/10),max(tmp$emp/10))
  )
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  axis(2,las=2,cex.axis=0.8) # 각 틱의 특성 설정
  lines(tmp[ind=="공공 서비스"]$date,tmp[ind=="공공 서비스"]$emp/10,lwd=2.5,col="blue")
  lines(tmp[ind=="기타 서비스"]$date,tmp[ind=="기타 서비스"]$emp/10,lwd=2.5,col="red")
  title("서비스업별 취업자")
  mtext(side = 1, line=4.5,adj=0,cex=0.6, "대면: 숙박음식·도소매·개인서비스·예술·스포츠·여가·교육 \n공공: 공공행정·보건복지\n기타: 그 외 ")
  legend("bottom",
         inset = c(0,-0.27),
         legend = c("대면 서비스(좌)","공공 서비스(좌)","기타 서비스(우)"),
         lty = c(1,1,1),
         lwd = c(2,2,2),
         col=c("black","blue","red"),
         ncol=3,cex=0.6)
  box()
}

# plot 2-4
# 전년동월대비 서비스업별 취업자 그래프
plot_2_4 <- function(){
  tmp <- main_ser[year>(start_date%/%100)]
  par(mar=c(6,4,2,4),xpd=TRUE) # 팔렛트 크기 설정 및 범례 위치 자유화
  plot(tmp[ind=="대면 서비스"]$date,tmp[ind=="대면 서비스"]$emp_yr_diff/10, # 대면 서비스 취업자 수 지정
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",yaxt="none",xaxt="none", # 레이블링 및 그래프 특성 설정
       ylim = c(min(tmp$emp_yr_diff/10),max(tmp$emp_yr_diff/10))
  )
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  axis(2,las=2,cex.axis=0.8) # 각 틱의 특성 설정
  lines(tmp[ind=="공공 서비스"]$date,tmp[ind=="공공 서비스"]$emp_yr_diff/10,lwd=2.5,col="blue")
  lines(tmp[ind=="기타 서비스"]$date,tmp[ind=="기타 서비스"]$emp_yr_diff/10,lwd=2.5,col="red")
  title(main = "서비스업별 취업자")
  mtext(side = 1, line=4.5,adj=0,cex=0.6, "대면: 숙박음식·도소매·개인서비스·예술·스포츠·여가·교육 \n공공: 공공행정·보건복지\n기타: 그 외 ")
  legend("bottom",
         inset = c(0,-0.27),
         legend = c("대면 서비스(좌)","공공 서비스(좌)","기타 서비스(우)"),
         lty = c(1,1,1),
         lwd = c(2,2,2),
         col=c("black","blue","red"),
         ncol=3,cex=0.6)
  box()
}

### 종사상지위별 ###
# plot 3-1
# 종사상지위별 취업자 수
plot_3_1 <- function(){
  tmp <- main_rank[year>(start_date%/%100)]
  par(xpd=TRUE)
  plot(tmp[ranking=="상용근로자"]$date,tmp[ranking=="상용근로자"]$emp/10,
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",yaxt="none",xaxt="none",
       ylim=c(min(tmp[ranking=="일용·임시근로자"]$emp/10),
              max(tmp[ranking=="상용근로자"]$emp/10))
  )
  lines(tmp[ranking=="일용·임시근로자"]$date,tmp[ranking=="일용·임시근로자"]$emp/10,
        lwd=2.5,col="black",lty=2,xlab="",ylab="")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  par(new=TRUE)
  plot(tmp[ranking=="개인자영자"]$date,tmp[ranking=="개인자영자"]$emp/10,
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",axes=FALSE,yaxt="none",
       ylim=c(min(tmp[ranking=="고용주"]$emp/10),
              max(tmp[ranking=="개인자영자"]$emp/10)))
  lines(tmp[ranking=="고용주"]$date,tmp[ranking=="고용주"]$emp/10,
        lwd=2.5,col="blue",lty=2,xlab="",ylab="")
  title("종사상지위별 취업자")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("상용근로자(좌)","일용·임시근로자(좌)","개인자영자(우)","고용주(우)"),
         lty = c(1,2,1,2),
         lwd = c(2,2,2,2),
         col=c("black","black","blue","blue"),
         ncol=4,cex=0.6)
  box()
}

# plot 3-2
# 전년동월대비 종사상지위별 취업자
plot_3_2 <- function(){
  tmp <- main_rank[year>(start_date%/%100)]
  par(xpd=TRUE)
  plot(tmp[ranking=="상용근로자"]$date,tmp[ranking=="상용근로자"]$emp_yr_diff/10,
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",yaxt="none",xaxt="none",
       ylim=c(min(tmp[ranking=="일용·임시근로자"]$emp_yr_diff/10),
              max(tmp[ranking=="상용근로자"]$emp_yr_diff/10))
  )
  lines(tmp[ranking=="일용·임시근로자"]$date,tmp[ranking=="일용·임시근로자"]$emp_yr_diff/10,
        lwd=2.5,col="black",lty=2,xlab="",ylab="")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  par(new=TRUE)
  plot(tmp[ranking=="개인자영자"]$date,tmp[ranking=="개인자영자"]$emp_yr_diff/10,
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",axes=FALSE,yaxt="none",
       ylim=c(min(tmp[ranking=="고용주"]$emp_yr_diff/10),
              max(tmp[ranking=="개인자영자"]$emp_yr_diff/10)))
  lines(tmp[ranking=="고용주"]$date,tmp[ranking=="고용주"]$emp_yr_diff/10,
        lwd=2.5,col="blue",lty=2,xlab="",ylab="")
  title("전년동월대비 종사상지위별 취업자")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("상용근로자(좌)","일용·임시근로자(좌)","개인자영자(우)","고용주(우)"),
         lty = c(1,2,1,2),
         lwd = c(2,2,2,2),
         col=c("black","black","blue","blue"),
         ncol=4,cex=0.6)
  box()
}


### 종사자규모별 ###
# plot 4-1
# 종사자규모별 취업자 수
plot_4_1 <- function(){
  sizes <- main_size$size
  tmp <- main_size[year>(start_date%/%100)]
  par(xpd=TRUE)
  plot(tmp[size==sizes[1]]$date,tmp[size==sizes[1]]$emp/10,
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",
       ylim = c(min(tmp$emp/10),max(tmp$emp/10)),
       yaxt = "none",xaxt = "none",
  )
  lines(tmp[size==sizes[3]]$date,tmp[size==sizes[3]]$emp/10,lwd=2.5,col="blue")
  lines(tmp[size==sizes[2]]$date,tmp[size==sizes[2]]$emp/10,lwd=2.5,lty=2,col="black")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  title("종사자규모별 취업자")
  
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("1-4인","5-299인","300인 이상"),
         lty = c(1,1,2),
         lwd = c(2,2,2),
         col=c("black","blue","black"),
         ncol=3,cex=0.6)
  box()
}

# plot 4-2
# 전년동월대비 종사자규모별 취업자
plot_4_2 <- function(){
  sizes <- main_size$size
  tmp <- main_size[year>(start_date%/%100)]
  par(xpd=TRUE)
  plot(tmp[size==sizes[1]]$date,tmp[size==sizes[1]]$emp_yr_diff/10,
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="만명",
       ylim = c(min(tmp$emp_yr_diff/10),max(tmp$emp_yr_diff/10)),
       yaxt = "none",xaxt = "none",
  )
  lines(tmp[size==sizes[3]]$date,tmp[size==sizes[3]]$emp_yr_diff/10,lwd=2.5,col="blue")
  lines(tmp[size==sizes[2]]$date,tmp[size==sizes[2]]$emp_yr_diff/10,lwd=2.5,lty=2,col="black")
  # lines(tmp[size==sizes[1]]$date,rep(0,length(tmp[size==sizes[1]]$date)),"l",lwd=1,col="grey60",lty=1)
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  title("전년동월대비 종사자규모별 취업자")
  
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("1-4인","5-299인","300인 이상"),
         lty = c(1,1,2),
         lwd = c(2,2,2),
         col=c("black","blue","black"),
         ncol=3,cex=0.6)
  box()
}


### 성별 ###
# plot 5-1
# 남성의 전년동월대비 취업자 수 및 고용률
plot_5_1 <- function(){
  tmp <- main_gender[gender=="남자"&ageg=="계"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4))
  xx <- barplot(tmp$emp.diff.yr/10,ylab = "만명",names.arg=format(tmp$date,"%Y\n %m"),yaxt="none")
  axis(2,las=2,cex.axis=0.8)
  par(new=T)
  plot(tmp$date,tmp$emprate,"l",lwd=2.5,col="black",lty=1,
       axes=F,ylab="",xlab="날짜",yaxt="none")
  lines(main_season[gender=="남자"&year>(start_date%/%100)]$date,main_season[gender=="남자"&year>(start_date%/%100)]$emprate,lwd=2.5,col="blue",lty=1,
        ylab="")
  axis(4,las=2,cex.axis=0.8)
  mtext("고용률(%)",side=4,line=3)
  title("남성의 전년동월대비 취업자 수 및 고용률")
  legend("bottom",
         # inset = c(0,-0.35),
         legend = c("원계열(우)","계절조정(우)"),
         lty = c(1,1),
         col=c("black","blue"),
         ncol=2,cex=0.8)
  box()
}

# plot 5-2
# 여성의 전년동월대비 취업자 수 및 고용률
plot_5_2 <- function(){
  par(mar=c(5,4,2,4))
  tmp <- main_gender[gender=="여자"&ageg=="계"&year>(start_date%/%100)]
  xx <- barplot(tmp$emp.diff.yr/10,ylab = "만명",yaxt="none",
                names.arg=format(tmp$date,"%Y\n %m"))
  axis(2,las=2,cex.axis=0.8)
  par(new=T)
  plot(tmp$date,tmp$emprate,"l",lwd=2.5,col="black",lty=1,
       axes=F,ylab="",xlab="날짜")
  lines(main_season[gender=="여자"&year>(start_date%/%100)]$date,main_season[gender=="여자"&year>(start_date%/%100)]$emprate,lwd=2.5,col="blue",lty=1,
        ylab="",yaxt="none")
  axis(4,las=2,cex.axis=0.8)
  mtext("고용률(%)",side=4,line=3)
  title("여성의 전년동월대비 취업자 수 및 고용률")
  legend("bottom",
         # inset = c(0,-0.35),
         legend = c("원계열(우)","계절조정(우)"),
         lty = c(1,1),
         col=c("black","blue"),
         ncol=2,cex=0.8)
  box()
}

# plot 5-3
# 남성 연령별 취업자 수
plot_5_3 <- function(){
  tmp <- main_gender[gender=="남자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$emp/10,"l",
       lwd=2.5,xlab="날짜",ylab="만명",ylim=c(min(tmp[ageg!="계"]$emp/10),max(tmp[ageg!="계"]$emp/10)),
       cex.lab=0.8,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$emp/10,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$emp/10,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$emp/10,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$emp/10,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$emp/10,lty=2,lwd=2.5,col="red")
  title("남성 연령별 취업자 수")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3,cex=0.8)
  box()
}
# plot 5-4
# 전년동월대비 남성 연령별 취업자
plot_5_4 <- function(){
  tmp <- main_gender[gender=="남자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$emp.diff.yr/10,"l",
       lwd=2.5,xlab="날짜",ylab="만명",ylim=c(min(tmp[ageg!="계"]$emp.diff.yr/10),max(tmp[ageg!="계"]$emp.diff.yr/10)),
       cex.lab=0.8,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$emp.diff.yr/10,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$emp.diff.yr/10,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$emp.diff.yr/10,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$emp.diff.yr/10,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$emp.diff.yr/10,lty=2,lwd=2.5,col="red")
  title("전년동월대비 남성 연령별 취업자")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3,cex=0.8)
  box()
}
# plot 5-5
# 여성 연령별 취업자 수
plot_5_5 <- function(){
  tmp <- main_gender[gender=="여자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$emp/10,"l",
       lwd=2.5,xlab="날짜",ylab="만명",ylim=c(min(tmp[ageg!="계"]$emp/10),max(tmp[ageg!="계"]$emp/10)),
       cex.lab=0.8,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$emp/10,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$emp/10,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$emp/10,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$emp/10,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$emp/10,lty=2,lwd=2.5,col="red")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  title("여성 연령별 취업자 수")
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3, cex=0.8)
  box()
}
# plot 5-6
# 전년동월대비 여성 연령별 취업자
plot_5_6 <- function(){
  tmp <- main_gender[gender=="여자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$emp.diff.yr/10,"l",
       lwd=2.5,xlab="날짜",ylab="만명",ylim=c(min(tmp[ageg!="계"]$emp.diff.yr/10),max(tmp[ageg!="계"]$emp.diff.yr/10)),
       cex.lab=0.8,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$emp.diff.yr/10,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$emp.diff.yr/10,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$emp.diff.yr/10,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$emp.diff.yr/10,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$emp.diff.yr/10,lty=2,lwd=2.5,col="red")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  title("전년동월대비 여성 연령별 취업자")
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3, cex=0.8)
  box()
}

# plot 5-7
# 남성 연령별 고용률
plot_5_7 <- function(){
  tmp <- main_gender[gender=="남자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$emprate,"l",
       lwd=2.5,xlab="날짜",ylab="%",ylim=c(min(tmp[ageg!="계"]$emprate),max(tmp[ageg!="계"]$emprate)),
       cex.lab=0.7,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$emprate,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$emprate,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$emprate,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$emprate,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$emprate,lty=2,lwd=2.5,col="red")
  title("남성 연령별 고용률")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3,cex=0.8)
  box()
}
# plot 5-8
# 전년동월대비 남성 연령별 고용률
plot_5_8 <- function(){
  tmp <- main_gender[gender=="남자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$empr.diff.yr,"l",
       lwd=2.5,xlab="날짜",ylab="%p",ylim=c(min(tmp[ageg!="계"]$empr.diff.yr),max(tmp[ageg!="계"]$empr.diff.yr)),
       cex.lab=0.7,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$empr.diff.yr,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$empr.diff.yr,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$empr.diff.yr,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$empr.diff.yr,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$empr.diff.yr,lty=2,lwd=2.5,col="red")
  title("전년동월대비 남성 연령별 고용률")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3,cex=0.8)
  box()
}

# plot 5-9
# 여성 연령별 고용률
plot_5_9 <- function(){
  tmp <- main_gender[gender=="여자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$emprate,"l",
       lwd=2.5,xlab="날짜",ylab="%",ylim=c(min(tmp[ageg!="계"]$emprate),max(tmp[ageg!="계"]$emprate)),
       cex.lab=0.7,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$emprate,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$emprate,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$emprate,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$emprate,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$emprate,lty=2,lwd=2.5,col="red")
  title("여성 연령별 고용률")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3, cex=0.8)
  box()
}
# plot 5-10
# 전년동월대비 여성 연령별 고용률
plot_5_10 <- function(){
  tmp <- main_gender[gender=="여자"&year>(start_date%/%100)]
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(tmp[ageg==ageg[1]]$date,tmp[ageg==ageg[1]]$empr.diff.yr,"l",
       lwd=2.5,xlab="날짜",ylab="%p",ylim=c(min(tmp[ageg!="계"]$empr.diff.yr),max(tmp[ageg!="계"]$empr.diff.yr)),
       cex.lab=0.7,yaxt="none",xaxt="none")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[2]]$empr.diff.yr,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[3]]$empr.diff.yr,lwd=2.5,col="red")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[4]]$empr.diff.yr,lty=2,lwd=2.5,col="black")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[5]]$empr.diff.yr,lty=2,lwd=2.5,col="blue")
  lines(tmp[ageg==ageg[2]]$date,tmp[ageg==ageg[6]]$empr.diff.yr,lty=2,lwd=2.5,col="red")
  title("전년동월대비 여성 연령별 고용률")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c(ageg[1:6]),
         lty = c(rep(1,3),rep(2,3)),
         lwd = rep(2,6),
         col=c("black","blue","red","black","blue","red"),
         ncol=3,cex=0.8)
  box()
}
# plot 5-11
# 남녀 계절조정 고용률 비교
plot_5_11 <- function(){
  gender_season <- main_season %>% filter(gender!="계") %>% select(date,gender,emprate) %>% dcast(date~gender,value.var="emprate")
  tmp <- gender_season
  names(tmp) <- c("date","male","female")
  par(mar=c(5,4,2,4),xpd=TRUE) # 워드에서 구현될 그래프의 팔렛트 형식 설정
  plot(tmp$date,tmp$male, # 서비스업 고용률
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="(%)",yaxt="none",xaxt="none", # 레이블링 및 그래프 특성 설정
       ylim = c(round(min(tmp$male)-1,0),round(max(tmp$male)+1,0))
  )
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  axis(2,las=2,cex.axis=0.8) # 각 틱의 특성 설정
  # lines(tmp$date,tmp$female,lwd=2.5,col="blue")
  par(new=TRUE) # double-axis를 위한 새로운 팔랫트 덧씌우기
  plot(tmp$date,tmp$female, # 서비스업 그래프
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",yaxt="none",
       ylim = c(round(min(tmp$female),0),round(max(tmp$female)+1,0)),
       axes=FALSE)
  title("남녀 계절조정 고용률 비교")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",inset=c(0,-.22),c("남성(좌)","여성(우)"),col = c("black","blue"),lty=c(1,1),lwd=c(2.5,2.5),ncol=2)
  box()
}
# plot 5-12
# 전년동월대비 여성 연령별 고용률
plot_5_12 <- function(){}
  

### 고용보조지표 ###
# plot 6
plot_6_1 <- function(){
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  tmp <- rbind(main_sub_total %>% mutate(group_="전체"),main_sub_youth %>% mutate(group_="청년"))
  tmp$DT <- as.numeric(tmp$DT)
  plot(tmp[group_=="전체"]$date,tmp[group_=="전체"]$DT,"l",
       lwd=2.5,xlab="날짜",ylab="%",ylim=c(min(tmp[group_=="전체"]$DT),max(tmp[group_=="청년"]$DT)),
       cex.lab=0.7,yaxt="none",xaxt="none")
  lines(main_sub_youth$date,main_sub_youth$DT,lwd=2.5,col="blue")
  title("전체 및 청년(15-29세) 고용보조지표3")
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(tmp$date), max(tmp$date), by="months"), format="%Y\n %m",tick=FALSE)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("전체","청년"),
         lty = c(1,1),
         lwd = rep(2,2),
         col=c("black","blue"),
         ncol=2,cex=0.8)
  box()
}

### 사업체노동력조사 임금 데이터 ###
# plot 7-1
#전체임금총액
plot_7_1 <- function(){
  par(mar=c(5,4,2,4),
      xpd=TRUE)
  plot(main_wage_total$date,main_wage_total$wage/10000,"l",
       lwd=2.5,xlab="날짜",ylab="",ylim=c(min(main_wage_total$wage/10000),max(main_wage_total$wage/10000)),
       cex.lab=0.7,xaxt="none",yaxt="none")
  title("전체임금총액(만 원)")
  axis(2,las=2,cex.axis=0.8) # 각 틱의 특성 설정
  axis.Date(1, at=seq(min(main_wage_total$date), max(main_wage_total$date), by="months"), format="%Y\n %m",tick=FALSE)
  box()
}
# plot 7-2
# 상용근로자 및 임시일용근로자 임금총액
plot_7_2 <- function(){
  par(mar=c(5,4,2,4),xpd=TRUE)
  plot(main_wage_reg$date,main_wage_reg$wage/10000, # 제조업 취업자 수 지정
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="",yaxt="none",xaxt="none", # 레이블링 및 그래프 특성 설정
       ylim=c(min(main_wage_reg$wage/10000),max(main_wage_reg$wage/10000))
  )
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(main_wage_reg$date), max(main_wage_reg$date), by="months"), format="%Y\n %m",tick=FALSE)
  par(new=TRUE) # double-axis를 위한 새로운 팔랫트 덧씌우기
  plot(main_wage_tmp$date,main_wage_tmp$wage/10000, # 서비스업 그래프
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",yaxt="none",
       ylim = c(min(main_wage_tmp$wage/10000),max(main_wage_tmp$wage/10000)),
       axes=FALSE)
  title("상용근로자 및 임시일용근로자 임금총액(만 원)")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("상용근로자(좌)","임시일용근로자(우)"),
         lty = c(1,1),
         lwd = c(2,2),
         col=c("black","blue"),
         ncol=2,cex=0.6)
  box()
}
# plot 7-3
# 상용근로자 정액급여 및 초과급여
plot_7_3 <- function(){
  par(mar=c(5,4,2,4),xpd=TRUE)
  plot(base_wage_reg$date,base_wage_reg$wage/10000, # 제조업 취업자 수 지정
       "l",lwd=2.5,col="black",lty=1,xlab="",ylab="",yaxt="none",xaxt="none", # 레이블링 및 그래프 특성 설정
       ylim=c(min(base_wage_reg$wage/10000),max(base_wage_reg$wage/10000))
  )
  axis(2,las=2,cex.axis=0.8)
  axis.Date(1, at=seq(min(base_wage_reg$date), max(base_wage_reg$date), by="months"), format="%Y\n %m",tick=FALSE)
  par(new=TRUE) # double-axis를 위한 새로운 팔랫트 덧씌우기
  plot(extra_wage_reg$date,extra_wage_reg$wage/10000, # 서비스업 그래프
       "l",lwd=2.5,col="blue",lty=1,xlab="",ylab="",yaxt="none",
       ylim = c(min(extra_wage_reg$wage/10000),max(extra_wage_reg$wage/10000)),
       axes=FALSE)
  title("상용근로자 정액급여 및 초과급여(만 원)")
  axis(4,las=2,cex.axis=0.8)
  legend("bottom",
         inset = c(0,-0.35),
         legend = c("정액급여(좌)","초과급여(우)"),
         lty = c(1,1),
         lwd = c(2,2),
         col=c("black","blue"),
         ncol=2,cex=0.6)
  box()
}
# plot 7-4
#
plot_7_4 <- function(){}


### 8 구직급여 ###
# plot 8-1
plot_8_1 <- function(){
  par(mar=c(5,4,2,4))
  plot(main_unin$date,main_unin$apply/1000,"l",
       ylab = "천명",xlab="",lwd=2.5,
       ylim = c(min(main_unin$apply/1000),max(main_unin$recipient)/1000),
       col="black",yaxt="none",xaxt="none")
  axis(2,las=2,cex.axis=0.8,tick = FALSE)
  axis.Date(1, at=seq(min(main_unin$date), max(main_unin$date), by="months"), format="%Y\n %m",tick=FALSE)
  lines(main_unin$date,main_unin$recipient/1000,col="red",lwd=2.5,ylab="")
  par(new=TRUE)
  plot(main_unin$date,main_unin$benefit,"l",
       axes=FALSE,col="blue",ylab="",lwd=2.5,yaxt="none",xlab="")
  mtext("억원",side=4,line=3)
  axis(4,las=2,cex.axis=0.8)
  legend("topleft",
         legend=c("신청자","수급자","지급액(우)"),
         lty=c(1,1,1),
         lwd=c(2,2,2),
         col=c("black","red","blue"))
  title("구직급여 신청 및 수급 동향")
}



























