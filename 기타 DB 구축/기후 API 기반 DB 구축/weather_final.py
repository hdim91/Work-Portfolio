# -*- coding: utf-8 -*-
"""
Created on Wed Jan  5 20:00:10 2022

@author: hdim9
"""

from tqdm import tqdm
from time import sleep
import requests, bs4
import pandas as pd
from lxml import html
from urllib.request import Request, urlopen
from urllib.parse import urlencode, quote_plus, unquote


sigun_df = pd.read_excel("sigun.xlsx")
url = 'http://apis.data.go.kr/1360000/AsosDalyInfoService/getWthrDataList'
my_api_key = unquote("[APIS API KEY 입력]")
sigun_df = sigun_df.loc[sigun_df['지점']!=108]
sigun_cd = sigun_df['지점'].tolist()

for x,cd in enumerate(tqdm(range(0,len(sigun_cd)))):
    for k in range(1,17):
        queryParams = '?' + urlencode({ quote_plus('ServiceKey') : my_api_key, 
                                       quote_plus('pageNo') : str(k), quote_plus('numOfRows') : '999', 
                                       quote_plus('dataType') : 'XML', quote_plus('dataCd') : 'ASOS', quote_plus('dateCd') : 'DAY',
                                       quote_plus('startDt') : '19800101', quote_plus('endDt') : '20220104', quote_plus('stnIds') : str(sigun_cd[cd])})

        response = requests.get(url + queryParams).text.encode('utf-8') # 생성된 링크의 응답요청
        xmlobj = bs4.BeautifulSoup(response,'lxml-xml') # 디버깅용
        rows = xmlobj.find_all('item') # 디버깅용
        if k==1:

            rowList = []
            nameList = []
            columnList = []

            rowsLen = len(rows)
            for i in range(0,rowsLen):
                columns = rows[i].find_all() # 다운받은 데이터를 1차로 정리
                
                columnsLen = len(columns) # 데이터 전체 row 길이
                if i == 0: # 최초 dataframe 설정
                    for j in range(0, columnsLen):
                        eachColumn = columns[j].text # 각 변수의 최초 데이터
                        columnList.append(eachColumn) # 각 데이터를 하나의 row로 통합
                        nameList.append(columns[j].name) # 최초 데이터의 변수명
                    rowList.append(columnList) # columnList를 DF화 하기 위하여 3차원 리스트로 변환
                    result = pd.DataFrame(rowList, columns = nameList) # rowList를 DF화
                    # 아래는 필수 사항
                    columnList=[]
                    rowList = []
                    nameList = []
                else:
                    for j in range(0, columnsLen):
                        eachColumn = columns[j].text 
                        columnList.append(eachColumn)
                        nameList.append(columns[j].name)
                    rowList.append(columnList)
                    tmp = pd.DataFrame(rowList,columns=nameList) # 임시 DF 생성
                    # 반드시 쓴 리스트를 초기화 할 것
                    columnList=[]
                    rowList=[]
                    nameList=[]
                    result = result.append(tmp, sort=False) # 본 DF에 임시 DF를 추가

        else:
        
            # 각 페이지별 데이터는 아래와 같이 정리함
            rowList = []
            nameList = []
            columnList = []
        
            rowsLen = len(rows)
            for i in range(0,rowsLen):
                columns = rows[i].find_all() # 다운받은 데이터를 1차로 정리
        
                columnsLen = len(columns) # 데이터 전체 row 길이
                
                for j in range(0, columnsLen):
                    eachColumn = columns[j].text 
                    columnList.append(eachColumn)
                    nameList.append(columns[j].name)
                    
                rowList.append(columnList)
                tmp = pd.DataFrame(rowList,columns=nameList) # 임시 DF 생성
                # 반드시 쓴 리스트를 초기화 할 것
                columnList=[]
                rowList=[]
                nameList=[]
                result = result.append(tmp, sort=False) # 본 DF에 임시 DF를 추가
    result.to_excel(str('지역별 데이터\\'+sigun_df.loc[sigun_df['지점']==sigun_cd[cd]]['지점명'].values[0]+'.xlsx'), index=False)
    
    sleep(0.01)