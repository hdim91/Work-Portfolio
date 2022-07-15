# -*- coding: utf-8 -*-
"""
Created on Wed Apr 27 13:32:10 2022

@author: master
"""
import requests, bs4
from io import BytesIO
import zipfile
import xmltodict
import json
import pandas as pd
import time


api = 'https://opendart.fss.or.kr/api/empSttus.json'
crtfc_key = ["[DART API KEY 입력]"]
corpcode = pd.read_excel("corpcode_final.xlsx") # 최종 기업 리스트 Import
ccode_emp = corpcode['corp_code'] # 기업 고유코드 벡터 생성

years = range(2015,2022) # 2015~2021년 백터 생성
quarters = [11013,11012,11014,11011] # 1분기, 반기, 3분기, 최종보고서 코드

# 저장용 DICTIONARY 생성
data = []

# API CALL
try: # 분기별 자료가 없을 때를 대비하여 try 사용
    seq_ = 0 # Initializing api call count
    keys = 0 # Initializing api key order count
    for ccode in ccode_emp:
        for yr in years:
            for qrt in quarters:
                
                # Operate regular loop until the task seeks 700 companies
                if seq_<19600: 
                    # 각 분기별 고용 데이터 call
                    emp_res = requests.get(api,
                                       params={'crtfc_key':crtfc_key[keys],
                                               'corp_code':ccode_emp[ccode], 
                                               'bsns_year':yr,
                                               'reprt_code':qrt
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
                    time.sleep(1)
                    
                # Initialize call count once info of 700 companies are collected
                elif seq_==19600:
                    # Initialize api call count
                    seq_==0 
                    # Move to the next api call
                    keys = keys + 1
                    # 각 분기별 고용 데이터 call
                    emp_res = requests.get(api,
                                       params={'crtfc_key':crtfc_key[keys],
                                               'corp_code':ccode_emp[ccode], 
                                               'bsns_year':yr,
                                               'reprt_code':qrt
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
                    time.sleep(1)
                
            # Exit the loop if there is no more api key left
            else: 
                break
                
except :
    pass

df = pd.DataFrame(data)
df.to_excel('dart_emp_final.xlsx')