



cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 부가조사\데이터_raw"
use "경활 부가조사데이터_raw", clear



gen 비전형 = 파견근로자==1|용역근로자==1|특수고용근로자==1|가정내근로자==1|일일근로자==1

* date 변수 생성

gen year = round(조사년월/100,1)
gen month = mod(조사년월,100)
gen date = mdy(month,1,year)
format date %tdCCYY-NN


*** 모든변수 rename

rename 조사년월 date_base
rename 만나이 age
rename 성별 sex
rename 출생년도 yob
rename 혼인상태 married
rename 취업여부 employed
rename 경제활동상태 activity
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
rename 임금형태 wage_type
rename 단기근로기간형태 temporary_type
rename 계속근로가능여부 continue_stat
rename 계속근로가능여부_이유 continue_reason
rename 근속기간제한이유 range_limit
rename 근로시간형태 hour_type
rename 특수고용여부 special_stat
rename 가정내근로여부 family_stat
rename 산업_9차 ind9
rename 직업_6차 job6
rename 임금근로자 emp_wage
rename 가중치 weight
rename 한시적근로자 emp_temporary
rename 기간제근로자 emp_fixed
rename 시간제근로자 emp_parttime
rename 파견근로자 emp_dispatched
rename 용역근로자 emp_service
rename 특수고용근로자 emp_special
rename 가정내근로자 emp_family
rename 일일근로자 emp_daily
rename 비정규직 emp_irreg
rename 정규직 emp_reg
rename 산업_10차 ind10
rename 직업_7차 job7
rename 비전형 emp_atypical
rename 시급제임금 wage_time
rename 최근3개월간임금 wage
rename 졸업년도 graduation
rename 활동상태 lastweek
rename 직장시작시기 exp_start
rename 직장을구하지않은이유 reason_not
rename 주업시간 hourmajor
rename 총취업시간 hourtotal
rename 급여받은곳 wage_source
rename 취직가능성유무_비경활 possible_inact
rename 취업희망여부 hoping

rename 쉰주된이유 reason_rest
rename 향후취업창업희망여부 hoping_later
rename 의사가없는주된이유 reason_nomotive
rename 향후구직의사 search_later
rename 취업창업희망이유 reason_hoping
rename 희망고용형태 hoping_emp
rename 시간제희망주된이유 reason_temporary
rename 취업시고려사항 consider_emp
rename 취업희망업종 hoping_ind
rename 취업희망직종 hoping_job
rename 창업시고려사항 consider_business
rename 희망자영업업종 hoping_busind
rename 자영업희망주된이유 reason_selfemp
rename 취업희망임금_수입 hoping_wage

rename 계약기간반복갱신여부 repeat
rename 향후기대근속기간 expected
rename 년이하인경우_개월 expected_month
rename 평소시간 hourusual
rename 국민연금또는특수직연금 pension
rename 건강보험 ins_health
rename 고용보험 ins_labor
rename 퇴직금 retirepay
rename 상여금 bonus
rename 시간외수당 extra
rename 노동조합가입여부 union
rename 산업_8차 ind8
rename 직업_5차 job5
rename 일주간구직여부 search1
rename 근로계약작성여부 contract_work
rename 지난주일자리취업동기 motive
rename 유급휴가 paid_vac
rename 주된취업사유 reason_work
rename 교육훈련경험여부 training
rename 유연근무제활용 flex
rename 유연근무제활용형태1 flex_1
rename 유연근무제활용형태2 flex_2
rename 시간제이유 reason_part

rename 전직유무 transfer_stat
rename 이직시기_연월 transfer_date
rename 전직산업_10차 b4ind10
rename 전직산업_9차 b4ind9
rename 전직직업_7차 b4job7
rename 전직직업_6차 b4job6
rename 전직종사자규모 b4size
rename 전직종사상지위 b4rank

destring age, replace
destring graduation, replace
replace graduation=. if graduation==0
destring exp_start, replace
destring wage, replace
destring hourmajor, replace
destring hourtotal, replace
destring wage_source, replace
destring wage_time, replace
destring transfer_date, replace


*** 모든변수 label

lab var hourmajor "주업시간"
lab var hourtotal "총취업시간"
lab var transfer_stat "전직유무"
lab var transfer_date "이직시기"
label variable year "조사년도"
destring age, replace
label variable age "만나이"
label variable sex "성별"
label define sex 1 "남성" 2 "여성"
label value sex sex
label variable yob "출생년도"
label variable married "혼인상태"
label define married 1 "미혼" 2 "유배우" 3 "사별" 4 "이혼"
label value married married
label variable employed "취업여부 "
label variable activity "경제활동상태구분"
label define activity 1 "취업자" 2 "실업자" 3 "비경제활동인구"
label value activity
label variable rank "종사상지위"
replace rank = . if rank==0
label define rank 1 "상용근로자" 2 "임시근로자" 3 "일용근로자" 4 "고용원이 있는 자영업자" 5 "고용원이 없는 자영업자" 6 "무급가족종사자"
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
label variable exp_start "직장시작시기 "
label variable ind9 "산업_9차 "
label variable job6 "직업_6차 "
label variable weight "가중치 "
label variable ind10 "산업 10차"
label variable job7 "직업_7차 "
label variable graduation "졸업년도" 
label variable lastweek "활동상태"
destring lastweek,replace
replace lastweek = 0 if lastweek>12
label define lastweek 1 "육아" 2 "가사" 3 "정규교육기관 통학" 4 "입시학원 통학" ///
	5 "취업을 위한 학원,기관통학" 6 "취업준비" 7 "진학준비" 8 "연로" 9 "심신장애" ///
	10 "군입대 대기" 11 "쉬었음" 12 "기타"
label value lastweek lastweek
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

gen rank_=rank if hourtotal>=36|addition>0
replace rank=rank_
drop rank_

* 임금부가조사 추가 클리닝
label variable wage_type "임금형태 "
label define wage_type 1 "시간제" 2 "일급제" 3 "주급제" 4 "월급제" 5 "연봉제" 6 "실적급제" 7 "기타" 
label value wage_type wage_type
replace wage_type = . if rank>3|rank==0
label variable temporary_type "단기근로기간형태 "
label define temporary_type 1 "예" 2 "아니오"
label value temporary_type temporary_type
replace temporary_type = . if rank>3|rank==0
label variable continue_stat "계속근로가능여부 "
label define continue_stat 1 "예" 2 "아니오"
label value continue_stat continue_stat
replace continue_stat = . if rank>3|rank==0
label variable continue_reason "계속근로가능여부_이유 "
label define continue_reason 1 "근로기간을 정하지 않은 계약을 하였으므로" ///
	2 "계약의 반복,갱신으로 고용이 지속되고 있으므로" 3 "묵시적인 고용관행에 의해"
label value continue_reason continue_reason
replace continue_reason = . if rank>3|rank==0
label variable range_limit "근속기간제한이유 "
label define range_limit 1 "이미 정해진 고용계약기간이 만료되기 때문에" ///
	2 "묵시적, 관행적으로 계약이 종료될 것이기 때문에" 3 "사업주가 그만두라면 그만둔다는 조건으로 채용되었으므로" ///
	4 "현재 하는 업무(프로젝트)가 끝나기 때문에" 5 "현재의 일자리에서 전에 일하던 사람이 복귀하기 때문에" ///
	6 "특정 계절동안만 일할 수 있기 때문에" 7 "적성,근로조건,능력 등의 이유로 다른 일자리를 찾을 예정이므로" ///
	8 "규정,관행상 퇴직하는 연령에 도달하기 때문에" 9 "학업,가족부양,건강 등의 이유로" ///
	10 "직장의 경영상 이유 때문에" 11 "기타" 
label value range_limit range_limit
replace range_limit = . if rank>3|rank==0
label variable hour_type "근로시간형태 "
label define hour_type 1 "전일제" 2 "시간제"
label value hour_type hour_type
replace hour_type = . if rank>3|rank==0
label variable special_stat "특수고용여부 "
replace special_stat = . if rank>3|rank==0
label variable family_stat "가정내근로여부 "
replace family_stat = . if rank>3|rank==0
label variable emp_wage "임금근로자 "
replace emp_wage = . if rank>3|rank==0
label variable emp_temporary "한시적근로자 "
replace emp_temporary = . if rank>3|rank==0
label variable emp_fixed "기간제근로자 "
replace emp_fixed = . if rank>3|rank==0
label variable emp_parttime "시간제근로자 "
replace emp_parttime = . if rank>3|rank==0
label variable emp_dispatched "파견근로자 "
replace emp_dispatched = . if rank>3|rank==0
label variable emp_service "용역근로자 "
replace emp_service = . if rank>3|rank==0
label variable emp_special "특수고용근로자 "
replace emp_special = . if rank>3|rank==0
label variable emp_family "가정내근로자"
replace emp_family = . if rank>3|rank==0
label variable emp_daily "일일근로자 "
replace emp_daily = . if rank>3|rank==0
label variable emp_irreg "비정규직 "
replace emp_irreg = . if rank>3|rank==0
label variable emp_reg "정규직 "
replace emp_reg = . if rank>3|rank==0
label variable emp_atypical "비전형 "
replace emp_atypical = . if rank>3|rank==0
destring wage_time, replace
label variable wage_time "시급제임금"
replace wage_time=. if wage_type!=1
destring wage,replace
label variable wage "최근3개월간임금"
replace wage = . if rank>3|rank==0
destring wage_source,replace
label variable wage_source "급여받은곳 "
label define wage_source 1 "지난주 일한 곳" 2 "파견업체" 3 "용역업체"
label value wage_source wage_source 
replace wage_source = . if rank>3|rank==0

lab var repeat "계약기간반복갱신여부"
replace repeat = . if rank>3|rank==0


lab var expected "향후기대근속기간"
replace expected = . if rank>3|rank==0
lab def expected 1 "1년 이하" 2 "1년초과~2년이하" 3 "2년 초과"
lab val expected expected

lab var expected_month "향후기대근속 1년이내 개월 수"

lab var hourusual "평소시간"
destring hourusual, replace
replace hourusual = . if rank>3|rank==0

lab var pension "국민연금또는특수직연금"

replace pension = . if rank>3|rank==0
replace pension = 1 if pension==111
replace pension = 2 if pension==112
replace pension = 3 if pension==12
replace pension = 4 if pension==11
lab def pension  1 "직장가입자" 2 "지역가입자" 3 "아니오" 4 "예(`08년 이전)"
lab val pension pension

lab var ins_health "건강보험"
replace ins_health = . if rank>3|rank==0
replace ins_health = 1 if ins_health == 211
replace ins_health = 2 if ins_health == 212
replace ins_health = 3 if ins_health == 213
replace ins_health = 4 if ins_health == 214
replace ins_health = 5 if ins_health == 22
replace ins_health = 6 if ins_health == 21
lab def ins_health 1 "직장가입자" 2 "의료수급권자" 3 "지역가입자" 4 "직장가입피부양자" 5 "아니오" 6 "직장의료보험(`08년도 이전)"
lab val ins_health ins_health

lab var ins_labor "고용보험 "
replace ins_labor = . if rank>3|rank==0
replace ins_labor = 1 if ins_labor == 31
replace ins_labor = 2 if ins_labor == 32
lab def ins_labor 1 "예" 2 "아니오"
lab val ins_labor ins_labor

lab var retirepay "퇴직금; 2015년부터 퇴직연금도 조사하나 mdis에서는 공개하고 있지 않고있음"
replace retirepay = . if rank>3|rank==0
replace retirepay = 1 if mod(retirepay,100) ==11
replace retirepay = 2 if mod(retirepay,100) == 12
lab def retirepay 1 "예" 2 "아니오"
lab val retirepay retirepay
lab var bonus "상여금 "
replace bonus = . if rank>3|rank==0
replace bonus = 1 if bonus==21
replace bonus = 2 if bonus == 22
lab def bonus 1 "예" 2 "아니요"
lab val bonus bonus

lab var extra "시간외수당 "
replace extra = . if rank>3|rank==0
replace extra = mod(extra,30)
lab def extra 1 "예" 2 "아니오"
lab val extra extra

lab var union "노동조합가입여부 "
replace union = . if rank>3|rank==0
lab def union 1 "노동조합이 없음" 2 "노동조합이 있으나 가입대상이 아님" ///
	3 "노동조합이 있고 가입대상이나 가입하지 않았음" 4 "노동조합에 가입하였음"
lab val union union

lab var ind8 "산업_8차 "
lab var job5 "직업_5차 "
lab var search1 "일주간구직여부 "

lab var contract_work "근로계약작성여부 "
lab var motive "지난주일자리취업동기 "
lab var paid_vac "유급휴가 "
lab var reason_work "주된취업사유 "
lab var training "교육훈련경험여부 "
lab var flex "유연근무제활용 "
lab var flex_1 "유연근무제활용형태1 "
lab var flex_2 "유연근무제활용형태2 "
lab var reason_part "시간제이유"

gen emp_nstd = emp_dispatched==1|emp_service==1|emp_special==1|emp_family==1|emp_daily==1
lab var emp_nstd "비전형근로자"

replace wage_type = . if rank>3|rank==0
replace temporary_type = . if rank>3|rank==0
replace continue_stat = . if rank>3|rank==0
replace continue_reason = . if rank>3|rank==0
replace range_limit = . if rank>3|rank==0
replace hour_type = . if rank>3|rank==0
replace wage_source = . if rank>3|rank==0
replace special_stat = . if rank>3|rank==0
replace family_stat = . if rank>3|rank==0
replace wage_time = . if wage_type!=1


*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================비임금 부가조사 관련 클리닝===============================*
*==============================================================================*

rename 현재사업_일자리시작 business_start
rename 사업체의주된장소 business_site
rename 사업체의조직형태 business_org
rename 사업자금조달방법_1순위 business_fin1
rename 사업자금조달방법_2순위 business_fin2
rename 국민연금가입수혜여부 pension_stat
rename 산재보험가입여부 insurance
rename 일주일간근무시간 weeklyhr
rename 향후일자리계획 future_emp
rename 그만둘계획인경우 if_quit
rename 사업준비기간 business_prepare
rename 사업시작동기 business_motive
rename 사업시작시애로사항 business_error
rename 직전사업유지_운영기간 business_oper
rename 업종전환사유 change_reason
rename 현재사업직전에한일 b4business
rename 창업자금규모 business_fund
rename 현재일시작전일한경험 b4work
rename 경험한일자리형태 b4work_job
rename 일자리그만두려는이유 reason_quit
tab reason_quit
* 현재사업_일자리시작
destring business_start,replace
label variable business_start "현재사업_일자리시작"
replace business_site = . if rank<4
replace business_start = . if business_start<100
* 사업체의주된장소
label variable business_site "사업체의주된장소"
label define business_site 1 "사업장(건물 등)" 2 "자기 집(나의 집에서 과외 지도 등)" ///
	3 "남의 집(방문과외 등)" 4 "거리(노점, 행상, 방문.이동판매등)" ///
	5 "야외 작업현장(논, 밭, 건설 및 토목공사 현장 등)" 6 "운송수단(자동차, 트럭, 선박 등)" 7 "기타" 
label value business_site business_site
replace business_site = . if rank<4
* 사업체의조직형태
label variable business_org "사업체의조직형태"
label define business_org 1 "사업자 등록이 있는 개인 사업체" 2 "사업자 등록이 없는 개인 사업체"
label value business_org business_org
replace business_org = . if rank<4
* 사업자금조달규모
label variable business_fund "사업자금조달규모"
* 사업자금조달방법_1순위 
label variable business_fin1 "사업자금조달방법_1순위 "
label define business_fin1 1 "본인 또는 가족이 마련한 목돈(적금, 퇴직금, 명퇴금 등)" ///
	2 "친지 또는 동업자의 자금" 3 "친지 또는 동업자 이외 타인에게 빌려서 마련" ///
	4 "은행, 보험회사, 상호신용금고등" 5 "사채, 대부회사 등" 6 "정부의 보조 또는 지원 등" ///
	7 "별도의 자본이 필요 없었음(사업승계, 무자본 창업등)" 8 "기타" 
label value business_fin1 business_fin1
replace business_fin1 = . if rank<4
* 사업자금조달방법_2순위 
label variable business_fin2 "사업자금조달방법_2순위 "
label define business_fin2 1 "본인 또는 가족이 마련한 목돈(적금, 퇴직금, 명퇴금 등)" ///
	2 "친지 또는 동업자의 자금" 3 "친지 또는 동업자 이외 타인에게 빌려서 마련" ///
	4 "은행, 보험회사, 상호신용금고등" 5 "사채, 대부회사 등" 6 "정부의 보조 또는 지원 등" ///
	7 "별도의 자본이 필요 없었음(사업승계, 무자본 창업등)" 8 "기타" 
label value business_fin2 business_fin2
replace business_fin2 = . if rank<4
* 국민연금가입수혜여부 
label variable pension_stat "국민연금가입수혜여부 "
label define pension_stat 1 "사업장(직장)가입자" 2 "지역가입자" ///
	3 "국민연금 및 특수직역연금 수급(권)자" 4 "가입되지 않았음" 
label value pension_stat pension_stat
replace pension_stat = . if rank<4
* 산재보험가입여부 
label variable insurance "산재보험가입여부 "
label define insurance 1 "가입되어 있음" 2 "가입되지 않았음"
label value insurance insurance
replace insurance = . if rank<4
* 일주일간근무시간 
destring weeklyhr,replace
label variable weeklyhr "일주일간근무시간 "
replace weeklyhr = . if rank<4
* 향후일자리계획
label variable future_emp "향후일자리계획"
label define future_emp 1 "1년 이내 확장할 계획임" 2 "계속 유지할 계획임" ///
	3 "그만둘 계획임" 4 "잘 모르겠음" 
label value future_emp future_emp
replace future_emp = . if rank<4
* 그만둘계획인경우 
destring if_quit,replace
label variable if_quit "그만둘계획인경우 "
replace if_quit = if_quit - 20 if if_quit>10
replace if_quit = if_quit - 10 if if_quit>10
label define if_quit 1 "6개월 이내에 그만 둘 계획" 2 "6개월~1년 이내에 그만 둘 계획" ///
	3 "1년 이후에 그만 둘 계획" 
label value if_quit if_quit
replace if_quit = . if rank<4
* 사업준비기간
label variable business_prepare "사업준비기간"
replace business_prepare = . if rank<4
* 사업시작동기
label variable business_motive "사업시작동기(전체)"
replace business_motive = business_motive*10 if year==2015
replace business_motive = 1 if business_motive==20
replace business_motive = 2 if business_motive==30
replace business_motive = 3 if business_motive==60
label define business_motive 1 "임금근로자로 취업이 어려워서" 2 "자신만의 사업을 직접 경영하고 싶어서" ///
	3 "기타" 10 "현재 사업외 다른 선택의 여지가 없어서" 40 "현재 사업을 통해 사회에 봉사" ///
	50 "나의 아이디어를 사업으로 실현하고 싶어서"
label value business_motive business_motive
replace business_motive= . if rank<4
gen business_motive1719 = business_motive if year>2016
label variable business_motive1719 "사업시작동기(17~19년)"
* 사업시작시애로사항
label variable business_error "사업시작시애로사항"
label define business_error 1 "사업관련 인.허가, 지원기관 협조 등" 2 "사업 자금의 조달" ///
	3 "입지선정, 기술개발 및 시설 확보" 4 "필요인력의 확보" 5 "사업정보 경영노하우 습득" ///
	6 "판매선 확보 및 홍보" 7 "기타" 
label value business_error business_error
replace business_error= . if rank<4
* 직전사업유지_운영기간
label variable business_oper "직전사업유지_운영기간"
label define business_oper 1 "1년미만" 2 "1년이상~2년미만" 3 "2년이상~3년미만" ///
	4 "3년이상~5년미만" 5 "5년이상" 
label value business_oper business_oper
replace business_oper= . if rank<4
* 업종전환사유
label variable change_reason "업종전환사유"
replace change_reason = 11 if year==2015&change_reason==3
replace change_reason = change_reason-1 if year==2015&change_reason>3
label define change_reason 1 "직전 사업보다 수익이 더 나은 업종으로 바꾸기 위해" ///
	2 "직전 사업보다 적성에 맞는 다른 사업(일)을 하기위해" 3 "직전 사업이 전망이 없어서(사양산업등)" ///
	4 "직전 사업이 부진하여" 5 "기타" 10 "직전 사업장의 계약기간이 만료되어" 
label value change_reason change_reason
replace change_reason= . if rank<4
gen change_reason1719 = change_reason if year>2016
* 현재사업직전에한일
label variable b4business "현재사업직전에한일"
label define b4business 1 "다른 업종 사업" 2 "동일 업종 사업" 3 "현재 사업이 최초 사업" 4 "임금근로자" 
label value b4business b4business
replace b4business= . if rank<4
* 현재일시작전일한경험
label variable b4work "현재일시작전일한경험"
label define b4work 1 "예" 2 "아니오"
label value b4work b4work
replace b4work= . if rank<4
* 경험한일자리형태
label variable b4work_job "경험한일자리형태"
label define b4work_job 1 "임금근로자" 2 "비임금근로자"
label value b4work_job b4work_job
replace b4work_job= . if rank<4
* 일자리그만두려는이유
label variable reason_quit "일자리그만두려는이유"
replace reason_quit = 10 if year<2017&reason_quit==4
replace reason_quit = 20 if year<2012&reason_quit==5
replace reason_quit = 30 if year<2012&reason_quit==6
replace reason_quit = 30 if (year>=2012&year<2015)&reason_quit==7
replace reason_quit = 40 if year<2012&reason_quit==7
replace reason_quit = 40 if (year>=2012&year<2015)&reason_quit==8
replace reason_quit =51 if year==2015&reason_quit ==4
replace reason_quit = 8 if (year>=2012&year<2017)&reason_quit==9
replace reason_quit = reason_quit -1 if year==2015&reason_quit >4
replace reason_quit = reason_quit -1 if (year>=2012&year<2015)&(reason_quit==5|reason_quit==6)
label define reason_quit 1 "현 사업에서 수익이 더 나은 업종으로 바꾸기 위해" ///
	2 "보다 적성에 맞는 다른 사업(일)을 하기 위해" 3 "임금근로로 취업을 원하여" ///
	4 "향후 전망이 없어서(사양산업 등)" 5 "현 사업이 부진하여" 6 "개인적인 사유(건강문제 등 자신의 신변문제)로" ///
	7 "개인적인 사유(가족돌봄 등 자신외의 신변문제)로 일하기가 곤란하여" 8 "기타" ///
	10 "프리미엄(권리금) 수익을 목적으로" 20 "전망이 없거나(사양산업), 사업이 부진하여" ///
	30 "개인적인 사유(건강문제, 가족돌봄 등)로 일하기가 곤란하여" ///
	40 "당분간 일을 하지 않고 사업구상 또는 자기계발을 하기 위하여" 50 "사업장의 계약기간이 만료될 예정이여서"
label value reason_quit reason_quit
replace reason_quit= . if rank<4









*==============================================================================*
*==============================================================================*

rename 추가취업가능성 possible_addition
rename 지난4주내추가취업구직여부 search_addition

lab var possible_addition "추가취업가능성"
lab var search_addition "지난4주내추가취업구직여부"

gen attend = .
replace attend = 0 if edu_stat==1|edu_stat==3|edu_stat==5
replace attend = 1 if edu_stat==2|edu_stat==4

lab var b4ind10 "전직산업_10차"
lab var b4size "전직 종사자규모"
lab var b4rank "전직 종사상지위"
lab var b4job7 "전직직업 7차"
lab var b4ind9 "전직산업 9차"
lab var b4job6 "전직직업 6차"



*** 임시코드
*==============================================================================*
*==============================================================================*
*==============================================================================*
*===========================비경제활동인구 부가조사 관련 클리닝==============================*
*==============================================================================*
* 쉰주된이유 
label variable reason_rest "쉰주된이유 "
label define reason_rest 1 "중대한 질병이나 장애는 없지만 몸이 좋이 않아 쉬고 있음" ///
	2 "퇴사(정년 퇴직)후 계속 쉬고 있음" ///
	3 "임시 또는 특정 계절 동안만 일할수 있는 일의 완료, 고용계약이 만료되어 쉬고 있음" ///
	4 "직장의 휴ㆍ폐업으로 쉬고 있음" 5 "원하는 일자리(일거리)를 찾기 어려워 쉬고 있음" ///
	6 "일자리(일거리)가 없어서 쉬고 있음" 7 "다음일 준비를 위해 쉬고 있음" 8 "기타" 
label value reason_rest reason_rest
replace reason_rest= . if activity<3
* 향후취업창업희망여부 
label variable hoping_later "향후취업창업희망여부 "
label define hoping_later 1 "예" 2 "아니오"
label value hoping_later hoping_later
replace hoping_later= . if activity<3
* 의사가없는주된이유 
destring reason_nomotive,replace
label variable reason_nomotive "의사가없는주된이유 "
label define reason_nomotive 1 "결혼, 임신, 출산" 2 "육아(자녀돌봄), 자녀교육" ///
	3 "가족돌봄" 4 "가사" 5 "연로" 6 "심신장애" 7 "질병이나 사고로 인한 건강문제로" ///
	8 "통학(학업), 진학준비로" 9 "전공이나 경력에 맞는일자리(일거리)가 없어서" ///
	10 "원하는 임금수준이나 근로조건에 맞는 일자리(일거리)가 없어서" ///
	11 "이전에 찾아보았지만 일자리(일거리)가 없어서" 12 "배우자 등 가족의 수입이 있어서" ///
	13 "연금, 임대료 등의 수입이 있어서" 14 "창업 준비(비용, 아이템 등) 부족" 15 "기타" 
label value reason_nomotive reason_nomotive
replace reason_nomotive = . if activity<3
* 향후구직의사 
label variable search_later "향후구직의사 "
label define search_later 1 "예" 2 "아니오"
label value search_later search_later
replace search_later = . if activity<3
* 취업창업희망이유 
label variable reason_hoping "취업창업희망이유 "
label define reason_hoping 1 "생활비, 용돈을 벌려고" 2 "자기 계발, 자아 발전을 위해" ///
	3 "지식이나 기술을 활용하려고" 4 "자녀의 교육비에 보태기 위해" 5 "기타" 
label value reason_hoping reason_hoping
replace reason_hoping = . if activity<3
* 희망고용형태 
label variable hoping_emp "희망고용형태 "
label define hoping_emp 1 "전일제 근로" 2 "시간제 근로" 3 "고용원이 있는 자영업자" ///
	4 "고용원이 없는 자영업자" 5 "무급가족종사자" 
label value hoping_emp hoping_emp
replace hoping_emp = . if activity<3
* 시간제희망주된이유 
label variable reason_temporary "시간제희망주된이유 "
label define reason_temporary 1 "결혼, 임신, 출산" 2 "육아, 자녀교육" 3 "가족돌봄" ///
	4 "본인의 건강 때문에" 5 "수입이 있는다른 일과 병행하려고" 6 "학업, 취미생활 등 다른 활동과 병행하려고" ///
	7 "전일제 일자리를 구할 수 없어서" 8 "기타" 
label value reason_temporary reason_temporary
replace reason_temporary = . if activity<3
* 취업시고려사항 
label variable consider_emp "취업시고려사항 "
label define consider_emp 1 "수입(수익)ㆍ임금수준" 2 "자신의적성 및 전공" 3 "일자리의 안전성" ///
	4 "사업체 규모" 5 "근무여건(근무시간ㆍ장소 유연성, 근무지역 등)" 6 "기타" 
label value consider_emp consider_emp
replace consider_emp = . if activity<3
* 취업희망업종 
destring hoping_ind,replace
label variable hoping_ind "취업희망업종 "
label define hoping_ind 1 "농림어업" 2 "광ㆍ제조업" 3 "전기,가스,증기 및 공기조절공급업" ///
	4 "건설업" 5 "도매 및 소매업" 6 "운수 및 창고업" 7 "숙박 및 음식점업" 8 "정보통신업" ///
	9 "금융 및 보험업" 10 "전문, 과학 및 기술서비스업" 11 "사업시설관리 및 사업지원 및 임대서비스업" ///
	12 "공공행정, 국방 및 사회보장 행정" 13 "교육서비스업" 14 "보건업 및 사회복지 서비스업" ///
	15 "기타(부동산업, 수도ㆍ하수ㆍ폐기물처리, 예술 등)" 
label value hoping_ind hoping_ind
replace hoping_ind = . if activity<3
* 취업희망직종 
label variable hoping_job "취업희망직종 "
label define hoping_job 1 "관리자" 2 "전문가 및 관련종사자" 3 "사무 종사자" ///
	4 "서비스 종사자" 5 "판매 종사자" 6 "농림어업 숙련 종사자" 7 "기능원 및 관련 기능 종사자" ///
	8 "장치ㆍ기계조작 및 조립 종사자" 9 "단순 노무 종사자" 
label value hoping_job hoping_job
replace hoping_job = . if activity<3
* 창업시고려사항 
label variable consider_business "창업시고려사항 "
label define consider_business 1 "수입(수익)" 2 "자신의 적성 및 전공" 3 "자본금 규모" ///
	4 "이전 직장(일)과의 연관성" 5 "성장 가능성" 6 "기타" 
label value consider_business consider_business
replace consider_business = . if activity<3
* 희망자영업업종 
destring hoping_busind,replace
label variable hoping_busind "희망자영업업종 "
label define hoping_busind 1 "농림어업" 2 "광ㆍ제조업" 3 "건설업" 4 "도매 및 소매업" 5 "운수업" ///
	6 "숙박 및 음식점업" 7 "부동산업 및 임대업" 8 "전문,과학 및 기술서비스업" 9 "교육서비스업" ///
	10 "협회 및 단체, 수리 및 기타 개인 서비스업" 11 "기타(금융 및 보험업, 보건업 및 사회복지서비스업, 수도ㆍ하수ㆍ폐기물처리, 예술 등)" 
label value hoping_busind hoping_busind
replace hoping_busind = . if activity<3
* 자영업희망주된이유 
label variable reason_selfemp "자영업희망주된이유 "
label define reason_selfemp 1 "연령에 구애받지 않아서" 2 "원하는 일자리에 취업이 어려워서" ///
	3 "시간을 자유롭게 활용하고 싶어서" 4 "수입이 더 많을 것 같아서" 5 "하고 싶은 업종이 있어서" 6 "기타" 
label value reason_selfemp reason_selfemp
replace reason_selfemp = . if activity<3
* 취업희망임금_수입
label variable hoping_wage "취업희망임금_수입"
label define hoping_wage 1 "50만원 미만" 2 "50만원~100만원 미만" 3 "100만원~150만원 미만" ///
	4 "150만원~200만원 미만" 5 "200만원~300만원 미만" 6 "300만원~400만원 미만" ///
	7 "400만원~500만원 미만" 8 "500만원~1000만원 미만" 9 "1000만원 이상" 
label value hoping_wage hoping_wage
replace hoping_wage = . if activity<3

*==============================================================================*
*==============================================================================*
sort year month
cd "C:\Users\master\Dropbox\한요셉 박사님\코어 데이터 - 경활 본조사 및 부가조사\경활 부가조사\데이터"
save "경활 부가조사데이터_cleaned", replace



