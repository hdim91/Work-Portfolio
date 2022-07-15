cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 부가조사\데이터_raw"
use "경활 고령층부가조사",clear

destring 조사년월,replace
destring 계열,replace
destring 직장을구하지않은이유,replace
destring 총취업시간,replace
destring 주업시간,replace
destring 지난주주된활동상태,replace
destring 활동상태,replace
destring 최장근속기간,replace
destring 이직시기_만나이,replace
destring 이직이유,replace
destring 직장시작시기,replace

rename 조사년월 date_base
rename 만나이 age
rename 성별 sex
rename 출생년도 yob
rename 혼인상태 married
rename 취업여부 employed
rename 경제활동상태구분 activity
rename 종사상지위 rank
rename 종사자규모 size
rename 교육정도 edu_lvl
rename 수학여부 edu_stat
rename 계열 major
rename 가구주관계 relation
rename 추가취업및전직희망 addition
rename 지난4주간구직여부 search4
rename 취업가능성_실업 possible_job
rename 고용계약여부 contract_stat
rename 고용계약기간 contract_range
rename 산업_8차 ind8
rename 직업_5차 job5
rename 산업_9차 ind9
rename 직업_6차 job6
rename 산업_10차 ind10
rename 직업_7차 job7
rename 지난주주된활동상태 lastweek
rename 직장시작시기 exp_start
rename 직장을구하지않은이유 reason_not
rename 주업시간 hourmajor
rename 총취업시간 hourtotal
rename 취직가능성유무_비경활 possible_inact
rename 취업희망여부 hoping
rename 가중치 weight
rename 취업구분 workhr_type

rename 최장근속기간 longest
rename 이직시기_만나이 transfer_date
rename 이직이유 transfer_reason
rename 지난1년간구직경험 search_old
rename 지난1년간비구직사유 searchnot_old
rename 지난1년간구직경로 search_channel
rename 지난1년간취업경험 exp_employed
rename 지난1년간주된경력과관련성 relevance
rename 계속근로희망여부 hoping_continue
rename 계속근무희망주된이유 reason_continue
rename 일자리선택시고려사항 consider_empchoice
rename 희망근로형태 hoping_emp
rename 희망임금수준 hoping_wage
rename 활동상태 lastweek1
rename 월평균수령액 pension
rename 근로희망나이 hoping_age
rename 이직이전일의종류 job_b4
rename 기존일자리근무여부 job_continue
rename 이직시근로형태 transfer_job
rename 이직시업종 transfer_ind
rename 지난1년간직업능력개발훈련참여여부 training
rename 직업능력개발훈련참여경로 training_channel
rename 경제활동상태 activity_elders


gen year = round(date_base/100,1)
gen month = mod(date_base,100)
gen date = mdy(month,15,year)
format date %tdCCYY-NN

drop date_base

*=============================================================================*

replace employed = 1 if lastweek1 == 1
replace employed = 1 if year<2015&employed==2
replace employed = 2 if year<2015&employed==3

replace reason_not = . if hoping<1
replace hoping = . if search4!=2
replace addition = . if hourtotal>=36
replace search4 = . if workhr_type>1

*=============================================================================*

label variable weight "가중치(인구)"
label variable age "만나이"
label variable year "조사년도"
label variable sex "성별"
label define sex 1 "남성" 2 "여성"
label value sex sex
label variable yob "출생년도"
label variable hourtotal "총취업시간"
label variable ind8 "산업 8차"
label variable ind9 "산업 9차"
label variable ind10 "산업 10차"
label variable job5 "직업 5차"
label variable job6 "직업 6차"
label variable job7 "직업 7차"

label variable married "혼인상태; 미혼=1, 유배우=2, 사별=3, 이혼=4"
label define married 1 "미혼" 2 "유배우" 3 "사별" 4 "이혼"
label value married married
label variable employed "취업여부 "
label variable activity "경제활동상태구분; 취업자=1, 실업자=2, 비경제활동인구=3"
label define activity 1 "취업자" 2 "실업자" 3 "비경제활동인구"
label value activity
label variable rank "종사상지위"
replace rank = . if rank==0
label define rank 1 "상용근로자" 2 "임시근로자" 3 "일용근로자" 4 "고용주" 5 "자영업자" 6 "무급가족종사자"
label value rank rank
label variable size "종사장규모; 1-4=1, 5-9=2, 10-29=3,30-99=4,100-299=5,300-=6"
label define size 1 "1-4" 2 "5-9" 3 "10-29" 4 "30-99" 5 "100-299" 6 "300인 이상"
label value size size
label variable edu_lvl "교육정도"
label define edu_lvl 0 "무학" 1 "초등학교" 2 "중학교" 3 "고등학교" 4 "전문대(초급대,2/3년제 대학포함)" ///
	5 "대학교(4년제 대학포함)" 6 "대학원(석사); 2007년은 대학원" 7 "대학원(박사)" 
label value edu_lvl edu_lvl 
label variable edu_stat "수학여부"
label define edu_stat 1 "졸업" 2 "재학" 3 "중퇴" 4 "휴학" 5 "수료" 
label value edu_stat edu_stat
label variable major "계열(종합); major3(고등학교)와 major6(초대졸이상)로 나뉨"
destring major, replace
gen major3 = major if edu_lvl==3
label variable major3 "계열(고등학교)"
replace major3=1 if year<=2007&major3==3
replace major3=3 if year<=2007&major3==4
label define major3 1 "인문계열" 2 "예술,체육계열" 3 "상농공수산계열 등" 
label value major3 major3
gen major6 = major if edu_lvl>3
label variable major6 "계열(초대졸 이상)" 
label define major6 1 "인문사회계열" 2 "예체능계열" 3 "사범계열" 4 "자연계열" 5 "공학계열" ///
	6 "의약계열" 7 "서비스" 10 "교육" 21 "예술" 22 "인문학" 30 "사회과학,언론 및 정보학" ///
	40 "경영, 행정 및 법학" 50 "자연과학, 수학 및 통계학" 60 "정보통신기술" ///
	70 "공학, 제조 및 건설" 80 "농림어업 및 수의학" 91 "보건" 92 "복지" 100 "서비스" 
label value major6 major6
label variable relation "가구주관계"
label define relation 1 "가구주" 2 "배우자" 3 "미혼자녀" 4 "기혼자녀" 5 "손자녀" ///
	6 "부모(장인,장모)" 7 "조부모" 8 "미혼형제자매" 9 "기타" 
label value relation relation
label variable addition "추가취업및전직희망"
label define addition 1 "현재 보다 시간을 늘리고 싶음" 2 "현재 보다 다른일도 하고 싶음" ///
	3 "더 많이 일할수 있는 일로 바꾸고 싶음" 4 "계속 그대로 일하고 싶음"
label value addition addition
label variable search4 "지난4주간구직여부"
label define search4 1 "예" 2 "아니오"
label value search4 search4
label variable possible_job "취업가능성_실업"
label define possible_job 1 "예" 2 "아니오"
label value possible_job possible_job
label variable contract_stat "고용계약여부"
label define contract_stat 1 "예" 2 "아니오"
label value contract_stat contract_stat
label variable contract_range "고용계약기간 "
label define contract_range 1 "1개월 미만" 2 "1개월~6개월 미만" 3 "6개월~1년 미만" ///
	4 "1년" 5 "1년 초과~2년" 6 "2년 초과~3년" 7 "3년 초과" 8 "1년초과~3년이하" ///
	9 "3년초과" 10 "1년초과~2년이하 - 2007년 7월~12월" 11 "2년 초과" 
label value contract_range contract_range 
lab var hourmajor "주업시간"

label variable lastweek "활동상태"
destring lastweek,replace
replace lastweek = 0 if lastweek>12
label define lastweek 1 "육아" 2 "가사" 3 "정규교육기관 통학" 4 "입시학원 통학" ///
	5 "취업을 위한 학원,기관통학" 6 "취업준비" 7 "진학준비" 8 "연로" 9 "심신장애" ///
	10 "군입대 대기" 11 "쉬었음" 12 "기타"
label value lastweek lastweek
label variable exp_start "직장시작시기 "
label variable reason_not "직장을구하지않은이유"
destring reason_not, replace
label define reason_not 1 "전공이나 경력에 맞는 일거리가 없을것 같아" ///
	2 "원하는 임금수준이나 근로조건이 맞는 일거리가 없을것 같아" 3 "근처에 일거리가 없을것 같아서" ///
	4 "교육, 기술, 경험이 부족해서" 5 "나이가 너무 어리거나 많다고 고용주가 생각할것 같아서" ///
	6 "이전에 찾아보았지만 일거리가 없었기 때문에" 7 "육아" 8 "가사" 9 "통학" 10 "심신장애" 11 "기타" 
label value reason_not reason_not
label variable possible_inact "취직가능성유무_비경활"
label define possible_inact 1 "예" 2 "아니오"
label value possible_inact possible_inact
label variable hoping "취업희망여부"
label define hoping 1 "예" 2 "아니오"
label value hoping hoping 


lab var longest "최장근속기간; 시계열 연결상 이유로 아래에 추가 변수들 존재"
lab var transfer_date "이직시 만나이"
lab var transfer_reason "이직이유"
lab def transfer_reason 1 "정년퇴직" 2 "권고사직, 명예퇴직, 정리해고" ///
	3 "일거리가 없어서, 사업부진, 조업중단" 4 "직장의 휴업, 폐업" 5 "가족을 돌보기 위해" ///
	6 "건강이 좋지 않아서" 7 "일을 그만 둘 나이가 되었다고 생각해서" ///
	8 "경제적으로 여유가 있어서 또는 여가를 즐기기 위해" 9 "자영업을 하기 위해" 10 "기타" 
lab val transfer_reason transfer_reason 
lab var search_old "지난1년간 구직경험"
lab def search_old 1 "없음" 2 "한 번" 3 "두 번" 4 "세 번 이상" 
lab val search_old search_old
lab var searchnot_old "지난1년간 비구직사유"
lab def searchnot_old 1 "본인에게 맞는 적당한 일자리가 없을 것 같아서" ///
	2 "가사 일을 하므로/가족들의 반대로" 3 "현재 일자리(직장)에 계속 근무하여" ///
	4 "건강상의 이유로" 5 "일을 하고 싶지 않아서" 6 "취업을 소개시켜 주는 기관을 몰라서" ///
	7 "나이가 많아서" 8 "기  타" 
lab val searchnot_old searchnot_old
lab var search_channel "지난1년간 구직경로 "
lab def search_channel 1 "고용노동부 고용센터/고령자인재은행 등을 통해" ///
	2 "기타 공공 취업알선기관(지역사회 시니어클럽 등)을 통해 " 3 "민간 취업알선기관을 통해" ///
	4 "신문, 잡지, 인터넷 등을 통해" 5 "사업체 문의 또는 방문" 6 "친구, 친지 소개 부탁" 7 "자영업 준비" 8 "기  타" 
lab val search_channel search_channel
lab var exp_employed "지난1년간 취업경험"
lab def exp_employed 1 "없 음" 2 "한 번" 3 "두 번" 4 "세 번 이상" 
lab val exp_employed exp_employed
lab var relevance "지난1년간 주된경력과 관련성"
lab def relevance 1 "전혀 관련 없음" 2 "별로 관련 없음" 3 "약간 관련 있음" 4 "매우 관련 있음" 
lab val relevance relevance
lab var hoping_continue "계속근로 희망여부"
lab def hoping_continue 1 "원함" 2 "원하지 않음"
lab val hoping_continue hoping_continue
lab var consider_empchoice "일자리 선택시 고려사항"
lab def consider_empchoice 1 "임금수준" 2 "일의 양과 시간대" 3 "일의 내용(사무직/생산직 등)" ///
	4 "출퇴근 거리 등 편리성(위치)" 5 "사업장 규모" 6 "계속 근로가능성" 7 "과거 취업경험과의 연관성" ///
	8 "사회적 지위 유지 가능성" 9 "기 타" 
lab val consider_empchoice consider_empchoice
lab var hoping_emp "희망근로 형태"
lab def hoping_emp 1 "전일제 근로" 2 "시간제 근로"
lab val hoping_emp hoping_emp
lab var hoping_wage "희망임금수준"
replace hoping_wage = 20 if hoping_wage==40
replace hoping_wage = 20 if hoping_wage==50
lab def hoping_wage 1 "월평균 30만원 미만" 2 "월평균 30~50만원 미만" ///
	3 "월평균 50~100만원 미만" 4 "월평균 100~150만원 미만" 5 "월평균 150~200만원 미만" ///
	6 "월평균 200~250만원 미만" 7 "월평균 250~300만원 미만" 8 "월평균 300만원 이상" ///
	10 "50만원 미만" 20 "150~300만원 미만"
lab val hoping_wage hoping_wage

lab var longest5579 "최장근속기간(55~79세)"
lab var longest5564 "최장근속기간(55~64세)"
lab var pension "연금 월평균수령액"
lab var hoping_age "근로희망나이"

lab var job_b4 "이직 이전 일의종류" 
lab def job_b4 1 "관리자" 2 "전문가 및 관련 종사자" 3 "사무 종사자" 4 "서비스 종사자" 5 "판매 종사자" ///
	6 "농림어업 숙련 종사자" 7 "기능원 및 관련 기능 종사자" 8 "장치ㆍ기계 조작 및 조립 종사자" 9 "단순 노무 종사자" 
lab val job_b4 job_b4
lab var job_continue " 기존 일자리 근무 여부" 
lab def job_continue 1 "예" 2 "아니오"
lab val job_continue job_continue
lab var transfer_job "이직 시 근로형태 " 
lab def transfer_job 1 "임금근로자" 2 "비임근근로자"
lab val transfer_job transfer_job
lab var transfer_ind "이직 시 업종" 
lab def transfer_ind 1 "농림어업" 2 "광업제조업" 3 "건설업" 4 "도소매음식숙박업" ///
	5 "전기운수통신금융업" 6 "그외 기타(사업개인공공서비스업)" 
lab val transfer_ind transfer_ind
lab var training "지난1년간 직업능력개발훈련 참여여부" 
lab def training 1 "예" 2 "아니오"
lab val training training
lab var training_channel "직업능력개발훈련 참여 경로" 
lab def training_channel 1 "사업주 제공훈련" 2 "개인훈련" 3 "사업주 제공훈련 및 개인훈련" 
lab val training_channel training_channel

lab var activity_elders "현재 경제활동상태(고령층); "
lab def activity_elders 1 "일을 하고 있음" 2 "현재는 일을 하지 않고 있고, 일을 한 경험 유" ///
	3 "평생 일을 한 경험 무"
lab val activity_elders activity_elders

lab var reason_continue "계속근무희망주된이유"
lab def reason_continue 1 "건강이 허락하는 한 일하고 싶어서/일하는 즐거움 때문에" ///
	2 "생활비에 보탬/돈이 필요해서" 3 "사회가 아직 나의 능력(기술)을 필요로 함" ///
	4 "건강을 유지" 5 "집에 있기 무료/ 시간을 보내기 위해" 6 "기타"
lab val reason_continue reason_continue 

lab var workhr_type "실제 취업시간 구분"
lab def workhr_type 1 "1~17시간 무급가족종사자" 2 "0~35시간" 3 "36시간 이상"
lab val workhr_type workhr_type 

lab var lastweek1 "활동상태(비클리닝 변수)"
lab var transferage5579 "이직시 만나이(55~79세)"
lab var transferage5564 "이직시 만나이(55~64세)"

*=============================================================================*
rename transfer_date retire_age
rename transfer_reason retire_rea
rename hoping_continue cont_hope
rename consider_empchoice empchoice
rename longest5579 long5579
rename longest5564 long5564
rename transferage5579 retire5579
rename transferage5564 retire5564
rename reason_continue cont_rea
rename training_channel train_chan
rename activity_elders act_old
rename transfer_job retire_rank
rename job_b4 retire_job
rename transfer_ind	retire_ind
rename search_channel search_chan
rename exp_employed exp_emp
rename hoping_age hope_age
rename hoping_emp hope_emp
rename hoping_wage hope_wage
*******************************************************************************
* 2018~2019
**
replace long5579=. if act_old==3 & year>2017
replace long5564=. if act_old==3 & year>2017
replace job_continue = . if act_old==3 & year>2017
replace retire5579 = . if job_continue == 1 & year>2017
replace retire5564 = . if job_continue == 1 & year>2017
**
replace retire_job = . if !(age<65 & job_continue == 2) & year>2017
replace retire_rank = . if !(age<65 & job_continue == 2) & year>2017
replace retire_ind = . if !(age<65 & job_continue == 2) & year>2017
replace retire_rea = . if !(age<65 & job_continue == 2) & year>2017
**
replace searchnot_old = . if search_old>1&year>2017
replace search_chan = . if search_old==1&year>2017
**
replace relevance = . if exp_emp==1&year>2017
**
replace cont_rea = . if cont_hope==2 & year>2017
replace hope_age = . if cont_hope==2 & year>2017
replace empchoice = . if cont_hope==2 & year>2017
replace hope_emp = . if cont_hope==2 & year>2017
replace hope_wage = . if cont_hope==2 & year>2017
**
replace pension = . if pension==0
*******************************************************************************
* 2014~2017
**
replace long5579 = . if !(age<65 & act_old<3) & (year>2013&year<2018)
replace long5564 = . if !(age<65 & act_old<3) & (year>2013&year<2018)
replace job_continue = . if !(age<65 & act_old<3) & (year>2013&year<2018)
replace retire5579 = . if job_continue == 1 & (year>2013&year<2018)
replace retire5564 = . if job_continue == 1 & (year>2013&year<2018)
**
replace retire_rank = . if job_continue != 2 & (year>2013&year<2018)
replace retire_ind = . if job_continue != 2 & (year>2013&year<2018)
replace retire_job = . if job_continue != 2 & (year>2013&year<2018)
replace retire_rea = . if job_continue != 2 & (year>2013&year<2018)
**
replace searchnot_old = . if search_old>1&(year>2013&year<2018)
replace search_chan = . if search_old==1&(year>2013&year<2018)
**
replace relevance = . if exp_emp==1&(year>2013&year<2018)
**
replace cont_rea = . if cont_hope==2 & (year>2013&year<2018)
replace hope_age = . if cont_hope==2 & (year>2013&year<2018)
replace empchoice = . if cont_hope==2 & (year>2013&year<2018)
replace hope_emp = . if cont_hope==2 & (year>2013&year<2018)
replace hope_wage = . if cont_hope==2 & (year>2013&year<2018)
*******************************************************************************
* ~2015
replace retire_rea = 11 if retire_rea==10 & year<2016 // 자영업을 하기 위해 구분
replace retire_rea = 2 if retire_rea==3 & year<2016 // 정리해고를 구분하기 위해 구분
replace retire_rea = retire_rea - 1 if retire_rea>2 & retire_rea<20 & year<2016
*******************************************************************************
* 2011~2013
** 
replace long5579 = . if act_old == 3 & year<2014
replace long5564 = . if act_old == 3 & year<2014
replace retire5579 = . if retire5579 ==0 & year<2014
replace retire5564 = . if retire5564 ==0 & year<2014
**
replace retire_rank = . if retire5579 == . & year<2014
replace retire_ind = . if retire5579 == . & year<2014
replace retire_job = . if retire5579 == . & year<2014
replace retire_rea = . if retire5579 == . & year<2014
** 
replace searchnot_old = . if search_old>1 & year<2014
replace search_chan = . if search_old== 1 & year<2014
**
replace relevance = . if exp_emp == 1 & year<2014
**
replace cont_rea = . if cont_hope==2 & year<2014
replace hope_age = . if cont_hope==2 & year<2014
replace empchoice = . if cont_hope==2 & year<2014
replace hope_emp = . if cont_hope==2 & year<2014
replace hope_wage = . if cont_hope==2 & year<2014
*******************************************************************************
* ~2013
**
replace job_continue = 1 if long5579 != . & retire5579 == . & year<2014
replace job_continue = 2 if long5579 != . & retire5579 != . & act_old != 3 & year<2014

*=============================================================================*

cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 부가조사\데이터"
save "경활 고령층부가조사_cleaned",replace

