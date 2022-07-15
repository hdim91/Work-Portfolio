# -*- coding: utf-8 -*-
"""
Created on Wed Apr 27 14:32:57 2022

@author: master
"""
import requests, bs4
from io import BytesIO
import zipfile
import xmltodict
import json
import pandas as pd
import time

api = 'https://opendart.fss.or.kr/api/company.json'
crtfc_key = "[DART API KEY 입력]"
# =============================================================================
# corpcode = pd.read_excel("corpcode.xlsx")
# ccode = corpcode['corp_code']
# =============================================================================
ccode = '00126380' # 시험용 삼성전자 고유코드
years = range(2015,2022) # 2015~2021년 백터 생성
quarters = [11013,11012,11014,11011] # 1분기, 반기, 3분기, 최종보고서 코드

# 저장용 DICTIONARY 생성
data = []
base_res = requests.get(api,
                    params = {'crtfc_key':crtfc_key,
                              'corp_code':ccode})
base_itm = json.loads(base_res.content)
# =============================================================================
# # API CALL
# try: # 분기별 자료가 없을 때를 대비하여 try 사용
#     for yr in years:
#         for qrt in quarters:
#             # 각 분기별 고용 데이터 call
#             emp_res = requests.get(api,
#                                params={'crtfc_key':crtfc_key,
#                                        'corp_code':ccode, # 시험용으로 삼성전자를 사용
#                                        'bsns_year':yr,
#                                        'reprt_code':qrt
#                                        })
#             # 받은 json 데이터를 dictionary 형태로 변경
#             emp_itm = json.loads(emp_res.content)
#             for i in range(0,len(emp_itm['list'])):
#                 # 받은 분기별 dictionary에 년도와 분기 추가
#                 tmp = emp_itm['list'][i]
#                 tmp['year'] = yr
#                 tmp['quarter'] = qrt
#                 # 분기별 dictionary를 data dict에 저장
#                 data.append(tmp)
#             time.sleep(1)
# except :
#     pass
# =============================================================================
