

/*============================================================================*/
/*============================================================================*/
/*                                 경활 데이터 후속 클리닝                             */
/*============================================================================*/
/*============================================================================*/

*** Working Directory
// 경활 raw자료는 [경활 분석] 폴더에 저장되어 있음
cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 본조사\데이터_raw"
*cd "D:\Dropbox\Dropox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 본조사\데이터_raw"
set more off
set linesize 255

use 경활데이터_append,clear

* date 변수 생성
gen year = round(조사년월/100,1)
gen month = mod(조사년월,100)
gen date = mdy(month,1,year)
format date %tdCCYY-NN


rename 조사년월 date_base
rename 성별 sex
rename 만나이 age
rename 출생년도 yob
rename 혼인상태 married
rename 가중치_Weight weight
rename 경제활동상태구분 activity
rename 종사상지위 rank
rename 종사자규모 size
rename 교육정도 edu_lvl
rename 수학여부 edu_stat
rename 졸업년도 yog
rename 계열 major
rename 활동상태 lastweek
rename 가구주관계 relation
rename 직장을구하지않은이유 reason_not
rename 직장시작시기 begin
rename 추가취업및전직희망 addition
rename 주업시간 hourmajor
rename 총취업시간 hourtotal
rename 지난4주간구직여부 searchjob
rename 취업가능성_실업 possible
rename 고용계약기간 contract
rename 산업_10차 ind10
rename 산업_9차 ind9
rename 직업_7차 job7
rename 직업_6차 job6
rename 취직가능성유무_비경활 possible_inact
rename 고용계약여부 contract_stat
rename 취업희망여부 hoping
rename 추가취업가능성 possible_add
rename 지난4주내추가취업구직여부 search_addition
rename 일시휴직사유 temprest
rename 전직산업_10차 b4ind10
rename 전직직업_6차 b4job6
rename 전직직업_7차 b4job7
rename 전직종사자규모 b4size
rename 전직종사상지위 b4rank
rename 이직시기 year_quit
rename 구직활동유무 searchyear
rename 부업여부 workextra
rename 부업시간 hourextra

gen attend = .
replace attend = 0 if edu_stat==1|edu_stat==3|edu_stat==5
replace attend = 1 if edu_stat==2|edu_stat==4
/*
gen edu = .
replace edu = 0 if edu_lvl<2|(edu_lvl==2&edu_stat>1) // 초졸이하
replace edu = 1 if (edu_lvl==2&edu_stat==1)|(edu_lvl==3&edu_stat>1) // 중졸
replace edu = 2 if (edu_lvl==3&edu_stat==1)|(edu_lvl==4&edu_stat>1)|(edu==5&edu_stat>1) //고졸
replace edu = 3 if (edu_lvl==4&edu_stat==1) //전문대졸
replace edu = 4 if (edu_lvl==5&edu_stat==1)|(edu_lvl>5&edu_stat!=1) //대졸
replace edu = 5 if (edu_lvl>5&edu_stat==1) //대학원졸
*/
label variable sex "성별"
label define sex 1 "남성" 2 "여성"
label value sex sex
label variable age "만나이"
label variable yob "출생년도"
label variable married "혼인상태; 미혼=1, 유배우=2, 사별=3, 이혼=4"
label define married 1 "미혼" 2 "유배우" 3 "사별" 4 "이혼"
label value married married
label variable weight "가중치=인구"
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
label variable yog "졸업년도"
label variable major "계열(종합); major3(고등학교)와 major6(초대졸이상)로 나뉨"
destring major, replace
gen major3 = major if edu_lvl==3
label variable major3 "계열(고등학교)"
replace major3=1 if year==2007&major3==3
replace major3=3 if year==2007&major3==4
label define major3 1 "인문계열" 2 "예술,체육계열" 3 "상농공수산계열 등" 
label value major3 major3
gen major6 = major if edu_lvl>3
label variable major6 "계열(초대졸 이상)" 
label define major6 1 "인문사회계열" 2 "예체능계열" 3 "사범계열" 4 "자연계열" 5 "공학계열" ///
	6 "의약계열" 7 "서비스" 10 "교육" 21 "예술" 22 "인문학" 30 "사회과학,언론 및 정보학" ///
	40 "경영, 행정 및 법학" 50 "자연과학, 수학 및 통계학" 60 "정보통신기술" ///
	70 "공학, 제조 및 건설" 80 "농림어업 및 수의학" 91 "보건" 92 "복지" 100 "서비스" 
label value major6 major6
destring lastweek, replace
label variable lastweek "지난주 활동상태(종합)"
replace lastweek = 0 if lastweek>12
label define lastweek 1 "육아" 2 "가사" 3 "정규교육기관 통학" 4 "입시학원 통학" ///
	5 "취업을 위한 학원,기관통학" 6 "취업준비" 7 "진학준비" 8 "연로" 9 "심신장애" ///
	10 "군입대 대기" 11 "쉬었음" 12 "기타"
label value lastweek lastweek
label variable relation "가구주관계"
label define relation 1 "가구주" 2 "배우자" 3 "미혼자녀" 4 "기혼자녀" 5 "손자녀" ///
	6 "부모(장인,장모)" 7 "조부모" 8 "미혼형제자매" 9 "기타" 
label value relation relation
label variable reason_not "직장을구하지않은이유"
label define reason_not 1 "전공이나 경력에 맞는 일거리가 없을것 같아" ///
	2 "원하는 임금수준이나 근로조건이 맞는 일거리가 없을것 같아" 3 "근처에 일거리가 없을것 같아서" ///
	4 "교육, 기술, 경험이 부족해서" 5 "나이가 너무 어리거나 많다고 고용주가 생각할것 같아서" ///
	6 "이전에 찾아보았지만 일거리가 없었기 때문에" 7 "육아" 8 "가사" 9 "통학" 10 "심신장애" 11 "기타" 
label value reason_not reason_not
label variable begin "직장시작시기"
label variable addition "추가취업및전직희망"
label define addition 1 "현재 보다 시간을 늘리고 싶음" 2 "현재 보다 다른일도 하고 싶음" ///
	3 "더 많이 일할수 있는 일로 바꾸고 싶음" 4 "계속 그대로 일하고 싶음"
label value addition addition
label variable hourmajor "주업시간"
label variable hourtotal "총취업시간"
label variable searchjob "지난4주간구직여부"
label define searchjob 1 "예" 2 "아니오"
label value searchjob searchjob 
label variable possible "취업가능성_실업"
label define possible 1 "예" 2 "아니오"
label value possible possible
label variable possible_inact "취직가능성유무_비경활"
label define possible_inact 1 "예" 2 "아니오"
label value possible_inact possible_inact
label variable contract_stat "고용계약여부"
label define contract_stat 1 "예" 2 "아니오"
label value contract_stat contract_stat
label variable contract "고용계약기간"
label variable hoping "취업희망여부"
label define hoping 1 "예" 2 "아니오"
label value hoping hoping 
label variable possible_add 추가취업가능성 
label define possible_add 1 "예" 2 "아니오"
label value possible_add possible_add
label variable search_addition 지난4주내추가취업구직여부 
label define search_addition 1 "있었음" 2 "없었음"
label value search_addition search_addition 
lab var temprest 일시휴직사유 
lab def temprest 1 "일시적 병, 사고" 2 "연가, 휴가" 3 "교육, 훈련" 4 "육아" 5 "가족적이유" ///
	6 "노사분규" 7 "사업부진, 조업중단" 8 "기타" 10 "연가,교육(05~06년)" 11 "육아,가족적이유(07~14년)" 
lab val temprest temprest
destring year_quit, replace
destring b4ind10, replace
lab val b4rank rank
lab val b4size size
lab var searchyear "지난 1년간 구직활동유무"
lab def searchyear 1 "있었음" 2 "없었음"
lab val searchyear searchyear
lab var workextra "부업여부 "
lab var hourextra "부업시간 "

*drop date_base

cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 본조사\데이터"
*cd "D:\Dropbox\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 본조사\데이터"

save 경활총괄_append,replace

use 경활총괄,clear
drop if year==2022

append using 경활총괄_append

save 경활총괄,replace


