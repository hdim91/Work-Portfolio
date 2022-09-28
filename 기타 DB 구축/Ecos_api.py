# -*- coding: utf-8 -*-
"""
Created on Mon Sep 26 16:30:35 2022

@author: master
"""

import requests
import xml.etree.ElementTree as ET
import xml.dom.minidom
import pandas as pd
from matplotlib import pyplot as plt

# =============================================================================
# # ECOS API 신청 방법은 아래와 같음:
#     1. https://ecos.bok.or.kr/api/#/ 접속
#     2. 회원가입 후 로그인
#     3. MY PAGE에서 인증키 신청
# =============================================================================
api_key="[API KEY]"



class ecos_call():
    '''
    한국은행 데이터를 불러내기 위한 Class 구축
    api_key를 최초 input으로 받음
    ecos_call() 내 명령어 사용 순서는 아래와 같음:
        
    1. ecos_tablelist()로 대분류 항목 선택
    2. ecos_itmlist()로 세부 변수의 아이템 코드 탐색
    3. 1번과 2번에서 얻은 정보로 ecos_data_call() 작성 후 데이터 Call
    
    필요한 패키지들은 requests와 pandas임
    '''
    
    # init
    def __init__(self,api_key):
        self.api_key = api_key
        
    # 한국은행 API 통계 변수 리스트 확인
    def ecos_tablelist(self,start,end,stat_code=None): 
        '''
        한국은행 API 통계 변수 리스트를 확인하기 위한 명령어로, 두 가지 용도가 있음
        1. 전체 변수 확인: 명령어 실행 시 stat_code를 추가하지 말 것
        2. 특정 변수 확인: 특정 변수의 세부사항을 볼 시 stat_code를 입력
        '''
        # 전체 변수 확인
        if stat_code is None:
            url = "http://ecos.bok.or.kr/api/StatisticTableList/{}/json/kr/{}/{}/".format(
                self.api_key,
                start,
                end
                )
        # 특정 변수 확인
        else:
            url = "http://ecos.bok.or.kr/api/StatisticTableList/{}/json/kr/{}/{}/{}/".format(
                self.api_key,
                start,
                end,
                stat_code
                )
        
        # 한국은행 DB에서 데이터 Call
        resp = requests.get(url)
        data = resp.json()
        rdata = data['StatisticTableList']['row']
        df = pd.DataFrame(rdata)
        
        # 최종 데이터프레임 형태의 데이터 
        return df
        
    
    # 한국은행 100대 지수 call
    def ecos_keystat_call(self):
        url = "http://ecos.bok.or.kr/api/KeyStatisticList/{}/json/kr/1/100/".format(
            self.api_key
            )
        
        resp = requests.get(url)
        data = resp.json()
        rdata = data['KeyStatisticList']['row']
        
        df = pd.DataFrame(rdata)
        df.set_index('KEYSTAT_NAME', inplace = True)
        return df
    
    
    # ECOS 세부항목 변수명 및 아이템 코드 CALL
    def ecos_itmlist(self,start,end,stat_code=None):
        if stat_code==None:
            raise ValueError('통계코드를 입력하시오')
            
        url = "https://ecos.bok.or.kr/api/StatisticItemList/{}/json/kr/{}/{}/{}".format(
            self.api_key,
            start,
            end,
            stat_code
            )
        # 한국은행 DB에서 데이터 Call
        resp = requests.get(url)
        data = resp.json()
        rdata = data['StatisticItemList']['row']
        df = pd.DataFrame(rdata)
        
        # 최종 데이터프레임 형태의 데이터 
        return df
    
    
    
    # 한국은행 통계 조회
    def ecos_data_call(self,start,end,stat_code=None,level=None,start_date=None,end_date=None,itm_code1=None,itm_code2=None):
        '''
        ECOS 통계 데이터를 조회하는 명령어로, start~itm_code1까지의 정보들을 모두 입력할 것을 권장함
        '''
        if stat_code==None:
            raise ValueError("통계표 코드를 입력하시오")
        if level==None:
            raise ValueError("주기를 입력하시오(예: 년:A, 반년:S, 월:M, 반월:SM, 일:D")
        if start_date==None:
            raise ValueError("검색시작일자를 입력하시오")
        if end_date==None:
            raise ValueError("검색종료일자를 입력하시오")
                    
        
        if itm_code2==None:
            url = "https://ecos.bok.or.kr/api/StatisticSearch/{}/json/kr/{}/{}/{}/{}/{}/{}/{}".format(
                self.api_key,
                start,
                end,
                stat_code,
                level,
                start_date,
                end_date,
                itm_code1
                )
        else:
            url = "https://ecos.bok.or.kr/api/StatisticSearch/{}/json/kr/{}/{}/{}/{}/{}/{}/{}/{}".format(
                self.api_key,
                start,
                end,
                stat_code,
                level,
                start_date,
                end_date,
                itm_code1,
                itm_code2
                )
        
        # 한국은행 DB에서 데이터 Call
        resp = requests.get(url)
        data = resp.json()
        rdata = data['StatisticSearch']['row']
        df = pd.DataFrame(rdata)
        
        # 최종 데이터프레임 형태의 데이터 
        return df


# =============================================================================
# 
# # 한국은행 ECOS 데이터를 불러오기 위한 모듈 ON
# ecos = ecos_call(api_key)
# # ECOS 내 데이터 코드 리스트 업
# table_list = ecos.ecos_tablelist(1, 1000)
# 
# # ECOS 내 통계 세부항목 리스트(아래 예시는 '1.3.1. 한국은행 기준금리 및 여수신금리')
# itm_code_list = ecos.ecos_itmlist(1,1000,'722Y001')
# 
# # 한국은행 기준금리
# discount_rate = ecos.ecos_data_call(1,2000,'722Y001','D',20190101,20220925,'0101000')
# 
# # 한국은행 100대 지수 LOAD
# list_100 = ecos.ecos_keystat_call()
# 
# =============================================================================

