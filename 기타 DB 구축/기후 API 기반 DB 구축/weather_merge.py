# -*- coding: utf-8 -*-
"""
Created on Mon Feb 14 13:06:45 2022

@author: master
"""
import os
import pandas as pd
from tqdm import tqdm
from time import sleep

files = os.listdir("지역별 데이터/")
files_xlsx = [f for f in files if f[-4:]=="xlsx"]
df = pd.DataFrame()


for x,f in enumerate(tqdm(range(0,len(files_xlsx)))):
    data = pd.read_excel("지역별 데이터//"+files_xlsx[f],'Sheet1')
    df = df.append(data)
    
    sleep(0.01)