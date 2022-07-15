# -*- coding: utf-8 -*-
"""
Created on Sun Jun 12 12:09:20 2022

@author: hdim9
"""

import os
import glob
import zipfile
import time
import pandas as pd
import itertools

from selenium import webdriver
from bs4 import BeautifulSoup as bs
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time
import re
import datetime

def wishket_login():
    driver.implicitly_wait(5)
    driver.get("https://www.wishket.com/accounts/login/")
    login_x_path='//*[@id="submit"]'
    driver.find_element_by_name('identification').send_keys('[아이디 입력]') # 아이디 입력
    driver.find_element_by_name('password').send_keys('[비밀번호 입력]') # 비밀번호 입력
    driver.find_element_by_xpath(login_x_path).click()
    
def remove_html_tags(data):
    p = re.compile(r'<.*?>')
    return p.sub(' ',str(data))


chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
driver = webdriver.Chrome("C:\\chromedriver_win32\\chromedriver.exe")

driver.implicitly_wait(5)
driver.get("https://www.wishket.com/accounts/login/")
login_x_path='//*[@id="submit"]'
driver.find_element_by_name('identification').send_keys('hdim91')
driver.find_element_by_name('password').send_keys('Dlaguseh12!')
driver.find_element_by_xpath(login_x_path).click()

whole_hrefs = []
reg_cd = []
cat_cd = []

driver.maximize_window()
driver.get("https://www.wishket.com/partners/#clear")
time.sleep(2)

# =============================================================================
# # 법인사업자 대상
# driver.find_element_by_xpath('//*[@id="corporate_business"]').click()
# =============================================================================

# =============================================================================
# # 개인사업자 대상
# driver.find_element_by_xpath('//*[@id="individual_business"]').click()
# =============================================================================

# =============================================================================
# # 팀 대상
# driver.find_element_by_xpath('//*[@id="team"]').click()
# =============================================================================

# 개인 대상
driver.find_element_by_xpath('//*[@id="individual"]').click()
# =============================================================================
# driver.find_element_by_xpath('//*[@id="address-box"]/button').click()
# =============================================================================

def scraping_wishket(startpoint,region_name):
    try:
        html = driver.page_source
        bs7 = bs(html,"html.parser")
        pg_num = int(remove_html_tags(bs7.find_all('small',{'id':'total_list_num'})[0]).replace('명의 파트너스가 있습니다.',"").replace(",","").replace(' ',''))//10
        time.sleep(1)
        try:
            for j in range(int(startpoint),pg_num):
                time.sleep(5)
                html = driver.page_source
                bs7 = bs(html,"html.parser")
                tmp = remove_html_tags(bs7.find_all("a","partners-unit-username-link"))
                reg_cd.append(reg_)
                whole_hrefs.append(tmp)
                driver.execute_script("window.scrollTo(0,2500)") # 스크롤 다운
                time.sleep(0.3)
                driver.find_element_by_class_name("next").click()
        except:
            pass
        
        for idx in range(0,len(whole_hrefs)):
            whole_hrefs[idx] = whole_hrefs[idx].replace(" ","").replace("[","").replace("]","").split(",")

        whole_hrefs = [x for x in whole_hrefs if len(x)>1]

        export_hrefs = list(itertools.chain(*whole_hrefs))
        v1 = []
        v2 = []

        for idx in range(0,len(export_hrefs)):
            if idx%2==1:
                v1.append(export_hrefs[idx])
            else:
                v2.append(export_hrefs[idx])

        dd = {'v1':v1,'v2':v2}
        df = pd.DataFrame(dd)
        df.to_excel("freelancer_list_individual_"+region_name+".xlsx")
        


try:
    for reg_ in range(1,18):
        driver.find_element_by_xpath('//*[@id="address-box"]/button').click()
        driver.find_element_by_id('address-'+str(reg_)).click()
        driver.find_element_by_xpath('//*[@id="address-box"]/ul/li[2]/div[1]').click()
        html = driver.page_source
        bs7 = bs(html,"html.parser")
        pg_num = int(remove_html_tags(bs7.find_all('small',{'id':'total_list_num'})[0]).replace('명의 파트너스가 있습니다.',"").replace(",","").replace(' ',''))//10
        time.sleep(1)
        if reg_==1: # 서울특별시는 {개발,디자인}과 {기획}으로 나눠서 크롤링
            cat_ = ['develop','design','plan']
            driver.find_element_by_id(cat_[0]).click()
            driver.find_element_by_id(cat_[1]).click()
            time.sleep(1)
            try:
                for j in range(0,pg_num):
                    time.sleep(5)
                    html = driver.page_source
                    bs7 = bs(html,"html.parser")
                    tmp = remove_html_tags(bs7.find_all("a","partners-unit-username-link"))
                    reg_cd.append(reg_)
                    whole_hrefs.append(tmp)
                    driver.execute_script("window.scrollTo(0,2500)") # 스크롤 다운
                    time.sleep(0.3)
                    driver.find_element_by_class_name("next").click()
            except:
                driver.execute_script("window.scrollTo(0,-2500)") # 스크롤 다운
                driver.find_element_by_id(cat_[0]).click()
                driver.find_element_by_id(cat_[1]).click()
            driver.find_element_by_id(cat_[2]).click()
            time.sleep(1)
            try:
                for j in range(0,pg_num):
                    time.sleep(5)
                    html = driver.page_source
                    bs7 = bs(html,"html.parser")
                    tmp = remove_html_tags(bs7.find_all("a","partners-unit-username-link"))
                    reg_cd.append(reg_)
                    cat_cd.append(cat_)
                    whole_hrefs.append(tmp)
                    driver.execute_script("window.scrollTo(0,2500)") # 스크롤 다운
                    time.sleep(0.3)
                    driver.find_element_by_class_name("next").click()
            except:
                driver.execute_script("window.scrollTo(0,-2500)") # 스크롤 다운
                driver.find_element_by_id(cat_[2]).click()
                # 서울특별시 크롤링 끝
        else: # 나머지 지역 크롤링
                try:
                    
                    for j in range(0,pg_num):
                        time.sleep(5)
                        html = driver.page_source
                        bs7 = bs(html,"html.parser")
                        tmp = remove_html_tags(bs7.find_all("a","partners-unit-username-link"))
                        reg_cd.append(reg_)
                        whole_hrefs.append(tmp)
                        driver.execute_script("window.scrollTo(0,2500)") # 스크롤 다운
                        time.sleep(0.3)
                        driver.find_element_by_class_name("next").click()
                except:
                    pass
        driver.execute_script("window.scrollTo(0,-2500)") # 스크롤 다운
        driver.find_element_by_xpath('//*[@id="address-box"]/button').click()
        driver.find_element_by_id('address-'+str(reg_)).click()
        driver.find_element_by_xpath('//*[@id="address-box"]/ul/li[2]/div[1]').click()
        time.sleep(1)
except:
    pass

for idx in range(0,len(whole_hrefs)):
    whole_hrefs[idx] = whole_hrefs[idx].replace(" ","").replace("[","").replace("]","").split(",")

whole_hrefs = [x for x in whole_hrefs if len(x)>1]

export_hrefs = list(itertools.chain(*whole_hrefs))
v1 = []
v2 = []

for idx in range(0,len(export_hrefs)):
    if idx%2==1:
        v1.append(export_hrefs[idx])
    else:
        v2.append(export_hrefs[idx])

dd = {'v1':v1,'v2':v2}
df = pd.DataFrame(dd)

# =============================================================================
# # 법인사업자 저장
# df.to_excel("freelancer_list_corporate.xlsx")
# =============================================================================
# =============================================================================
# # 개인사업자 저장
# df.to_excel("freelancer_list_individual_bus.xlsx")
# =============================================================================
# =============================================================================
# # 팀 저장
# df.to_excel("freelancer_list_team.xlsx")
# =============================================================================
# 개인 저장
df.to_excel("freelancer_list_individual_new.xlsx")
