# -*- coding: utf-8 -*-
"""
Created on Fri Jul  1 10:29:09 2022

@author: master
"""

import os
import sys
import datetime
import urllib.request
import pandas as pd
import json
client_id = "nh_U6NYwIuU4FV8TNwei" # API 아이디
client_secret = "7XNYDoNLpQ" # API 비밀번호
# =============================================================================
# naver_call_agegroup(client_id,client_secret,"실업","실업",365)
# =============================================================================
def naver_call_agegroup(client_id, client_secret,keyword,keywords,days,timeunit):

    # 1년
    end_date = datetime.datetime.now()
    start_date = end_date - datetime.timedelta(days=days)
    end_date = end_date.strftime('%Y-%m-%d')
    start_date = start_date.strftime('%Y-%m-%d')
    age_group = {'3':'19-24세','4':'25-29세','5':'30-34세','6':'35-39세','7':'40-44세','8':'45-49세','9':'50-54세','10':'55-59세','11':'60세 이상'}
# =============================================================================
#     keyword = "실업"
#     keywords = "실업"
# =============================================================================
    url = "https://openapi.naver.com/v1/datalab/search";
    body = "{\"startDate\":\""+start_date+"\",\"endDate\":\""+end_date+"\",\"timeUnit\":\""+timeunit+"\",\"keywordGroups\":[{\"groupName\":\""+keyword+"\",\"keywords\":[\""+keywords+"\"]}],\"ages\":[\"3\"],\"gender\":\"f\"}";
    # ages input: [1="0-12세",2='13-18세',3='19-24세',4='25-29세',5='30-34세',6,7,8,9,10,11]
    # gender  input: ['f','m']
    #body = json.dumps(body,ensure_ascii=False)
    
    request = urllib.request.Request(url)
    request.add_header("X-Naver-Client-Id",client_id)
    request.add_header("X-Naver-Client-Secret",client_secret)
    request.add_header("Content-Type","application/json")
    response = urllib.request.urlopen(request, data=body.encode("utf-8"))
    rescode = response.getcode()
    if(rescode==200):
        response_body = response.read()
    else:
        print("Error Code:" + rescode)
        
    raw_data = json.loads(response_body) # json 형태의 데이터를 리스트화
    tmp = pd.DataFrame(raw_data['results']) 
    res = raw_data['results'][0]['data'] # 결과값을 추출
    
    unemp_df = pd.DataFrame(res) # 결과값을 DataFrame의 형태로 변환
    #unemp_df.index = pd.to_datetime(unemp_df['period'])
    unemp_df.columns = ['period',age_group['3']+'여성']
    
    main = unemp_df
    
    # 나머지 여성, 남성 x 연령별 데이터 얻기
    for i in ['4','5','6','7','8','9','10','11']:
        body = "{\"startDate\":\""+start_date+"\",\"endDate\":\""+end_date+"\",\"timeUnit\":\"date\",\"keywordGroups\":[{\"groupName\":\""+keyword+"\",\"keywords\":[\""+keyword+"\"]}],\"ages\":[\""+i+"\"],\"gender\":\"f\"}";
        request = urllib.request.Request(url)
        request.add_header("X-Naver-Client-Id",client_id)
        request.add_header("X-Naver-Client-Secret",client_secret)
        request.add_header("Content-Type","application/json")
        response = urllib.request.urlopen(request, data=body.encode("utf-8"))
        rescode = response.getcode()
        if(rescode==200):
            response_body = response.read()
        else:
            print("Error Code:" + rescode)
        
        tmp = json.loads(response_body)
        raw = pd.DataFrame(tmp['results'])
        res = tmp['results'][0]['data']
        
        tmp = pd.DataFrame(res)
        tmp.columns = ['period',age_group[i]+'여성']
        
        main = main.join(tmp.set_index('period'),on='period')
    
    for i in ['3','4','5','6','7','8','9','10','11']:
        body = "{\"startDate\":\""+start_date+"\",\"endDate\":\""+end_date+"\",\"timeUnit\":\"date\",\"keywordGroups\":[{\"groupName\":\""+keyword+"\",\"keywords\":[\""+keyword+"\"]}],\"ages\":[\""+i+"\"],\"gender\":\"m\"}";
        request = urllib.request.Request(url)
        request.add_header("X-Naver-Client-Id",client_id)
        request.add_header("X-Naver-Client-Secret",client_secret)
        request.add_header("Content-Type","application/json")
        response = urllib.request.urlopen(request, data=body.encode("utf-8"))
        rescode = response.getcode()
        if(rescode==200):
            response_body = response.read()
        else:
            print("Error Code:" + rescode)
        
        tmp = json.loads(response_body)
        raw = pd.DataFrame(tmp['results'])
        res = tmp['results'][0]['data']
        
        tmp = pd.DataFrame(res)
        tmp.columns = ['period',age_group[i]+'남성']
        
        main = main.join(tmp.set_index('period'),on='period')
    return main