# -*- coding: utf-8 -*-
"""
Created on Mon May  2 09:42:52 2022

@author: master
"""
import requests, bs4
from io import BytesIO
import zipfile
import xmltodict
import json
import pandas as pd
import time


api = 'https://opendart.fss.or.kr/api/fnlttSinglAcntAll.json'
crtfc_key = "[DART API KEY 입력]"
corp_df = pd.read_excel('rsc\\emission_code.xlsx',converters={'corp_code':str})
corpcode = corp_df['corp_code']

fs_type = ['CFS','OFS'] # CFS:연결재무제표 / OFS:재무제표
years = range(2015,2022) # 2015~2021년 백터 생성
quarters = [11013,11012,11014,11011] # 1분기, 반기, 3분기, 최종보고서 코드

# 저장용 DICTIONARY 생성
data = []

# =============================================================================
# # API CALL (first half)
# for ftype in fs_type: # 연결재무제표 및 비연결재무제표 구분
#     for yr in years: # 년도 구분
#         for qrt in quarters: # 분기 구분
#             for ccode in corpcode[:int(len(corpcode)/2)]:
#             # 각 분기별 고용 데이터 call
#                 try: # 분기별 자료가 없을 때를 대비하여 try 사용
#                     emp_res = requests.get(api,
#                                        params={'crtfc_key':crtfc_key,
#                                                'corp_code':ccode, # 시험용으로 삼성전자를 사용
#                                                'bsns_year':yr,
#                                                'reprt_code':qrt,
#                                                'fs_div':ftype
#                                                })
#                     # 받은 json 데이터를 dictionary 형태로 변경
#                     emp_itm = json.loads(emp_res.content)
#                     for i in range(0,len(emp_itm['list'])):
#                         # 받은 분기별 dictionary에 년도와 분기 추가
#                         tmp = emp_itm['list'][i]
#                         tmp['year'] = yr
#                         tmp['quarter'] = qrt
#                         # 분기별 dictionary를 data dict에 저장
#                         data.append(tmp)
#                 except :
#                     pass
#                 time.sleep(0.25)
# 
# 
# df = pd.DataFrame(data)
# df.to_excel('archive\\financial_statement\\dart_fs1.xlsx')
# =============================================================================
# API CALL (first half)
for ftype in fs_type: # 연결재무제표 및 비연결재무제표 구분
    for yr in years: # 년도 구분
        for qrt in quarters: # 분기 구분
            for ccode in corpcode[int(len(corpcode)/2):len(corpcode)]:
            # 각 분기별 고용 데이터 call
                try: # 분기별 자료가 없을 때를 대비하여 try 사용
                    emp_res = requests.get(api,
                                       params={'crtfc_key':crtfc_key,
                                               'corp_code':ccode, # 시험용으로 삼성전자를 사용
                                               'bsns_year':yr,
                                               'reprt_code':qrt,
                                               'fs_div':ftype
                                               })
                    # 받은 json 데이터를 dictionary 형태로 변경
                    emp_itm = json.loads(emp_res.content)
                    for i in range(0,len(emp_itm['list'])):
                        # 받은 분기별 dictionary에 년도와 분기 추가
                        tmp = emp_itm['list'][i]
                        tmp['year'] = yr
                        tmp['quarter'] = qrt
                        # 분기별 dictionary를 data dict에 저장
                        data.append(tmp)
                except :
                    pass
                time.sleep(0.25)


df = pd.DataFrame(data)
df.to_excel('archive\\financial_statement\\dart_fs2.xlsx')