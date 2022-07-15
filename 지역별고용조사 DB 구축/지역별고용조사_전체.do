
/**/


cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\지역별고용조사\데이터"
set more off
use 지역별고용조사13-20,clear

rename 행정구역 sigun_cd
rename 년도 year
rename 상하반기 half
rename 성별 sex
rename 만나이변환코드 ageg
rename 조사년월 date
*rename 재학신코드 attend
rename 가구주와의관계 relation
rename 연령_만나이 age
rename 교육정도_학력 edu_lvl
rename 계열고등학교인경우 major3
rename 계열_전문대이상 major6
rename 혼인상태 married
rename 지난1주간활동상태 lastweek
rename 지난1주간취업여부 employed
rename 일시휴직여부 rest
rename 구직활동여부4주내 search4
rename 부업여부 addition
rename 총일한시간구분 hour_type
rename 주업시간 hourmajor
rename 부업시간 hourminor
rename 총취업시간 hourtotal
rename 취업가능성_실업판단 possible_job
rename 구직경로1 path1
rename 구직경로2 path2
rename 구직방법1 method1
rename 구직방법2 method2
rename 구직활동기간 search_range
rename 취업희망여부 hope_search
rename 구직활동하지않은이유 reason_not
rename 지난1년간구직활동여부 lastyear
rename 전직유무 transfer
rename 이직시기 trans_date
rename 전직장이직이유 trans_reason
rename 산업코드 ind10
rename 직업코드 job7
rename 종사상지위 rank
rename 직장시작시기 start_date
rename 월평균임금 wage
rename 근로기간계약여부 contract_stat
rename 근로기간 contract_range
rename 사업체소재지 workplace
rename 교육정도컨버전 edu_con
rename 시군가중치 weight_sigun
rename 시도및전국가중치 weight
rename 경제활동상태 activity
rename 수입목적일경험여부 work4profit
rename 현직업기간 exp
rename 교육정도_수학여부 edu_stat

lab var start_date 직장시작시기
lab var contract_stat 근로기간계약여부 
lab var workplace 사업체소재지 
lab var weight_sigun 시군가중치 
lab var weight 시도및전국가중치 
lab var work4profit 수입목적일경험여부 
lab var exp 현직업기간 


lab var 대상기간수입있는일여부 대상기간수입있는일여부
lab var 대상기간무급가족종사여부 대상기간무급가족종사여부
lab var 대상기간일하지않았으나직장여부 대상기간일하지않았으나직장여부
lab var 일하지않은이유 일하지않은이유

lab var 전직장그만둔시기_1년미만 전직장그만둔시기_1년미만
lab var 이직횟수 이직횟수
lab var 전직장사업체소재지 전직장사업체소재지

rename 대상기간수입있는일여부 paid_stat
rename 대상기간무급가족종사여부 family_bus
rename 대상기간일하지않았으나직장여부 resting
rename 일하지않은이유 reason_resting

rename 전직장그만둔시기_1년미만 trans_lessyr
rename 이직횟수 trans_cnt
rename 전직장사업체소재지 b4_workplace


gen attend = edu_stat==2|edu_stat==4
replace attend = . if edu_stat==.
tab attend edu_stat,missing

label variable sigun_cd "행정구역코드, 끝자리 두개가 0일경우 시도 레벨"
label variable year "년도"
label variable half "상하반기, 1=상반기, 2 = 하반기"
label variable sex "성별, 1=남성, 2=여성"
label variable edu_con "교육정도컨버젼; 1=초졸이하, 2=중졸, 3=고졸, 4=초대졸, 5=대졸, 6=대학원졸"
label variable attend "재학신코드; 1=재학/휴학, 0=졸업/중퇴/수료"
label variable age "만나이"
label variable rank "종사상지위, 1=상용근로자,2=임시근로자,3=일용근로자,4=고용원이있는자영업자,5=고용원이없는자영업자,6=무급가종종사자"
label variable ind10 "산업코드10차"
label variable contract_range "근로기간; 0=정하지않음,1=1개월미만,2=1개월~6개월미만,3=6개월~1년미만,4=1년,5=1년초과~2년,6=2년초과~3년,7=3년초과"
label variable hourmajor "주업시간/주"
label variable date "조사년월"
label variable wage "월평균임금(만원)"
label variable activity "경제활동상태"

label define half 1 상반기 2 하반기
label value half half
label define sex 1 남성 2 여성
label value sex sex
label define attend 0 "졸업/중퇴/수료" 1 "재학/휴학"
label value attend attend
label define rank 1 상용근로자 2 임시근로자 3 일용근로자 4 교용원있는자영업자 5 고용원없는자영업자 6 무급가족종사자 
label value rank rank
label define contract_range 0 정하지않음 1 1개월미만 2 "1개월~6개월미만" 3 "6개월~1년미만" 4 "1년" 5 "1년초과~2년" 6 "2년초과~3년" 7 "3년초과"
label value contract_range contract_range


lab var relation "가구주관계"
lab def relation 1 가구주 2 배우자 3 미혼자녀 4 "기혼자녀(배우자)" 5 "손자녀(배우자)" ///
	6 "부모(장인,장모)" 7 조부모 8 미혼형제자매 9 기타
lab val relation relation
lab var edu_lvl 교육정도_학력
lab def edu_lvl 0 "안받았음(무학)" 1 초등학교 2 중학교 3 고등학교 4 전문대 5 대학교 6 석사 7 박사
lab val edu_lvl edu_lvl
lab var major3 계열고등학교인경우
lab def major3 1 인문계열 2 "예술ㆍ체육계열" 3 "상공농수산계열 등"
lab val major3 major3
lab var major6 계열_전문대이상

lab var edu_stat 교육정도_수학여부
lab def edu_stat 1 졸업 2 재학 3 중퇴 4 휴학 5 수료
lab val edu_stat edu_stat
* 여기서부터
lab var married 혼인상태
lab var lastweek 지난1주간활동상태
lab var employed 지난1주간취업여부
lab var rest 일시휴직여부
lab var search4 구직활동여부4주내
lab var addition 부업여부
lab var hour_type 총일한시간구분
lab var hourminor 부업시간
lab var hourtotal 총취업시간
lab var possible_job 취업가능성_실업판단
lab var path1 구직경로1
lab var path2 구직경로2
lab var method1 구직방법1
lab var method2 구직방법2
lab var search_range 구직활동기간
lab var hope_search 취업희망여부
lab var reason_not 구직활동하지않은이유 
lab var lastyear 지난1년간구직활동여부
lab var transfer 전직유무 
lab var trans_date 이직시기 
lab var trans_reason 전직장이직이유 
lab var job7 직업코드7차

replace hour_type=총취업시간구분 if year<2015
drop 총취업시간구분
replace possible_job = 취업가능여부 if year>2014
drop 취업가능여부 

gen sigun = 0
replace sigun = 1 if mod(sigun_cd,100)!=0&sigun_cd!=2901
label variable sigun "시군 dummy; 0=시도(특별시,광역시 등), 1=시군"
/*
gen long order1 = _n
egen order2 = min(order1),by(sigun_nm)
egen sigun_new = group(order2)
labmask sigun_new, values(sigun_nm)
drop order1 order2

drop sigun_nm
rename sigun_new sigun_nm
label variable sigun_nm "지역명"
*/

gen wodo = 0
replace wodo = 1 if sigun_cd!=3100&sigun_cd!=3200&sigun_cd!=3300& ///
	sigun_cd!=3400&sigun_cd!=3500&sigun_cd!=3600&sigun_cd!=3700& ///
	sigun_cd!=3800&sigun_cd!=3900&sigun_cd!=2901
label variable wodo "도 구분 변수(without do) = (0 도) (1 시군): 이 변수에서 시군이랑 특별시,광역시,일반시,군을 포함하고 있음"
	
save "지역별고용조사2013-2020", replace

*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================================================================*
/*cd "C:\Users\master\Desktop\정년연장 관련\지역고용조사\MDIS"
use 지역별고용조사_2013-2018,clear

preserve
keep if sigun==0
gen time_range = .
replace time_range = 0 if workhr>=1&workhr<18
replace time_range = 1 if workhr>=18&workhr<35
replace time_range = 2 if workhr>=35
collapse (sum) emp_pop active_pop, by(date time_range)
by date: egen act_pop = sum(active_pop)
gen emp_rate=emp_pop/act_pop
sort date time_range
gen emp_chng = (emp_pop-emp_pop[_n-4])/emp_pop[_n-4]

list
twoway (line emp_chng date if time_range==0) (line emp_chng date if time_range==1) ///
	(line emp_chng date if time_range==2)
restore
*/
