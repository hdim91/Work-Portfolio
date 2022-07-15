

cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 부가조사\데이터_raw"
use "경활 청년층부가조사",clear

destring 조사년월,replace
destring 계열,replace
destring 직장을구하지않은이유,replace
destring 총취업시간,replace
destring 첫일자리취업시기,replace
destring 첫일자리이직시기,replace
destring 주업시간,replace
destring rest1,replace
destring 지난주주된활동상태,replace
destring 졸업년도,replace
destring 직장시작시기,replace
destring 입학편입시기,replace
destring 활동상태,replace


replace 조사년월 = 200206 if 조사년월==20615
replace 조사년월=200305 if 조사년월==30515

gen year = round(조사년월/100,1)
gen month = mod(조사년월,100)
gen date = mdy(month,15,year)
format date %tdCCYY-NN

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
rename 직업교육수혜여부 jobedu_stat
rename 첫일자리취업시기 first_date
rename 첫일자리이직사유 first_quit
rename 첫일자리이직시기 first_quitdate
rename 직장과전공관련성 jobmajor
rename 첫일자리직업 firstjob
rename 취업경로 firstchannel
rename 취업횟수 seekcount
rename 재학휴학중직장체험 jobtraining
rename 첫일자리업종 firstind
rename 직장체험주된형태 jobtraining_type
rename 입학편입시기 enterdate
rename 최종학교학제 schoolyears
rename 편입경험유무 transfer
rename 미취업기간 unemployed
rename 미취업기간의활동 unemployed_activity
rename 전일제시간제여부 contract_type
rename 첫일자리월임금 firstwage

rename 활동상태 lastweek1

*=============================================================================*

drop date_base
replace employed=1 if lastweek1==1
replace employed=1 if year<2015&employed==2
replace employed=2 if year<2015&employed==3

gen attend = .
replace attend = 0 if edu_stat==1|edu_stat==3|edu_stat==5
replace attend = 1 if edu_stat==2|edu_stat==4
replace first_quit=11 if first_quit==12
replace firstind = firstind-10 if (year>=2006&year<=2009)&firstind>10
replace enterdate = . if enterdate==5

replace reason_not = . if hoping<1
replace hoping = . if search4!=2
replace addition = . if hourtotal>=36
replace search4 = . if 취업구분>1


preserve
drop if rank==6&hourtotal<18
tab hourtotal search4 if year==2019
restore
tab 취업구분 search4
tab search4
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

label variable jobedu_stat "직업교육수혜여부"
label define jobedu_stat 1 "없음" 2 "재학,휴학 중 받았음" 3 "졸업,중퇴 후 받았음" ///
	4 "재학,휴학 중 및 졸업,중퇴 후 모두 받았음" 10 "있음(2002,3년)" 
label value jobedu_stat jobedu_stat
label variable first_date "첫일자리취업시기 "
label variable first_quit "첫일자리이직사유 "
label define first_quit 1 "근로여건 불만족으로" 2 "전공,지식,기술,적성 등이 맞지 않아서" ///
	3 "직장이나 하고 있는 일이 전망이 없다고 생각되어서" 4 "개인 또는 가족적인 이유로" ///
	5 "창업 또는 가족사업에 참여하려고" 6 "일이 임시적이거나 계절적인 일이 완료되어" 7 "계약기간이 끝나서" ///
	8 "일자리가 없거나 회사사정이 어려워져서,권고사직 및 정리해고 등으로" 9 "직장의 휴업,폐업,파산 등으로 인해" ///
	10 "기타" 11 "회사내 인간관계 때문에" 
label value first_quit first_quit
label variable first_quitdate "첫일자리이직시기 "
label variable jobmajor "직장과전공관련성 "
label define jobmajor 1 "매우 불일치" 2 "약간 불일치" 3 "그런대로 일치" 4 "매우 일치" 
label value jobmajor jobmajor
label variable firstjob "첫일자리직업"
label variable firstjob08 "첫일자리직업(02~08년)"
label define firstjob08 1 "의회의원,고위임직원 및 관리자" 2 "전문가" 3 "기술공 및 준전문가" ///
	4 "사무종사자" 5 "서비스종사자" 6 "판매종사자" 7 "농업,임업 및 어업 숙련종사자" 8 "기능원 및 관련기능종사자" ///
	9 "장치,기계조작 및 조립종사자" 10 "단순 노무종사자" 
label value firstjob08 firstjob08
label variable firstjob09 "첫일자리직업(09년~)"
label define firstjob09 1 "관리자" 2 "전문가" 3 "사무종사자" 4 "서비스종사자" 5 "판매종사자" ///
	6 "농림어업 숙련 종사자" 7 "기능원 및 관련기능종사자" 9 "장치,기계조작 및 조립종사자" 10 "단순 노무종사자" 
label value firstjob09 firstjob09
label variable firstchannel "취업경로 "
label define firstchannel 1 "채용시험을 통하여" 2 "회사측의 특별채용(스카우트)에 의하여" ///
	3 "신문,잡지,인터넷,벽보 등을 보고 응모하여" 4 "학교 선생님의 소개나 추천을 통하여" ///
	5 "가족이나 친지의 소개,추천을 통하여" 6 "그 직장에 근무하고 있는 사람의 소개,추천을 통하여" ///
	7 "공공 취업알선기관을 통하여" 8 "민간 취업알선기관을 통하여" 9 "학교내 취업소개기관을 통하여" ///
	10 "자영업 준비" 11 "기타" 20 "본인의 직접적인 문의,면담을 통하여" ///
	30 "공공,사설 직업소개기관을 통하여" 40 "학교내에 직업소개기관을 통하여" 100 "기타(2002년)" 
label value firstchannel firstchannel
label variable seekcount "취업횟수 "
label define seekcount 1 "없음" 2 "한번" 3 "두번" 4 "세번" 5 "네번 이상" 10 "두번 이상" 
label value seekcount seekcount
label variable jobtraining "재학휴학중직장체험 "
label define jobtraining 1 "있음" 2 "없음" 
label value jobtraining jobtraining
label variable firstind
label define firstind 1 "농림어업" 2 "광업,제조업" 3 "건설업" 4 "도매 및 소매업" 5 "숙박 및 음식점업" ///
	6 "금융 및 보험업" 7 "교육서비스업" 8 "전기,가스,증기 및 공기조절공급업" 9 "운수 및 창고업,정보통신업" ///
	10 "전문,과학 및 기술서비스업" 11 "공공행정,국방 및 사회보장 행정" 12 "보건업 및 사회복지 서비스업" ///
	13 "사업시설관리,사업지원 및 임대 서비스업" 14 "기타(부동산,수도,하수,폐기물처리,예술 등)" ///
	30 "도소매업 및 음식숙박업" 40 "전기,가스 및 수도사업" 50 "기타(부동산,교육,보건,공공행정 등)" ///
	60 "기타(부동산,보건,공공행정 등)" 
label value firstind firstind
label variable jobtraining_type "직장체험주된형태 "
label define jobtraining_type 1 "전일제 취업" 2 "시간제 취업" 3 "인턴(기업인턴 등)" ///
	4 "학교의 현장실습 참여" 5 "정부 지원 직장체험 프로그램 참여" 6 "기타" 
label value jobtraining_type jobtraining_type
label variable enterdate "입학편입시기 "
label variable schoolyears "최종학교학제 "
label variable transfer "편입경험유무 "
label define transfer 1 "예" 2 "아니요"
label value transfer transfer
label variable unemployed "미취업기간 "
label define unemployed 1 "6개월 미만" 2 "6개월~1년 미만" 3 "1년~2년 미만" 4 "2년~3년 미만" ///
	5 "3년 이상" 
label value unemployed unemployed
label variable unemployed_activity "미취업기간의활동 "
label define unemployed_activity 1 "직업교육(훈련)을 받았음" ///
	2 "취업관련 시험 준비를 위해 학원 또는 도서관 등에 다님" 3 "집 등에서 그냥 시간을 보냄" ///
	4 "여행, 독서 등 여가시간을 보냄" 5 "구직활동을 함" 6 "육아, 가사" 7 "기타" 
label value unemployed_activity unemployed_activity
label variable contract_type "전일제시간제여부 "
label define contract_type 1 "전일제 근로" 2 "시간제 근로"
label value contract_type contract_type
label variable firstwage "첫일자리월임금 "
destring rest0714, replace
label variable attend "재학/휴학 구분"
label define attend 0 "졸업/중퇴" 1 "재학/휴학"
label value attend attend
label variable rest0206 "휴학시기(02~06);휴학생만"
gen rest0719 = rest0714
replace rest0719=rest1519 if year>2014
label variable rest0719 "휴학시기(07~19);재학/휴학자만"
label variable firstind "첫일지리 업종"


*=============================================================================*
cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 부가조사\데이터"
save "경활 청년층부가조사_cleaned",replace
*/







