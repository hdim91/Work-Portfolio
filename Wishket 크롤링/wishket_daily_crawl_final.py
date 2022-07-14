# -*- coding: utf-8 -*-
"""
Created on Thu May 19 07:30:35 2022

@author: hdim9
"""

import pandas as pd
from bs4 import BeautifulSoup as bs
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
import re
import datetime
import os

def wishket_login():
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


driver.get("https://www.wishket.com/accounts/login/")
time.sleep(1)
wishket_login()
time.sleep(5)
#driver.implicitly_wait(5)
#driver.find_element_by_xpath('/html/body/header/section[1]/div/div[1]/a[2]').click()

current_time = datetime.datetime.now()

whole_hrefs = []
wishket_df = pd.DataFrame(columns = ['link','date_register','current_status','project_name','outsourcing',
                                     'project_cat','project_sector',
                                     'budget','time_len','applicants',
                                     'project_labels','project_conditions','technology',
                                     'applicants_desc',
                                     'initial_meeting','onboard_meeting','client_destination','project_description',
                                    'badge','client_intro','client_rating',
                                    'nproject_uploaded','nproject_contracted','nproject_proceeding','nproject_completed','nproject_percentile','cumulative_price'])
wishket_resident = pd.DataFrame(columns = ['link','date_register','current_status','project_name','outsourcing',
                                          'project_cat','project_sector',
                                          'budget_exp_len','total_budget','budget_type','budget_price_medium',
                                          'time_len','applicants','project_labels','project_conditions','applicants_desc','technology',
                                          'initial_meeting','work_place','work_time','work_extra_work','work_equipment','work_meal','work_miscellaneous',
                                          'project_description','badge','client_intro','client_rating',
                                          'nproject_uploaded','nproject_contracted','nproject_proceeding','nproject_completed','nproject_percentile','cumulative_price'])

#hrefs = driver.find_elements_by_xpath('//*[@id="resultListWrap"]/div/div/div[1]/div[2]/h4/a')
driver.maximize_window()
driver.get("https://www.wishket.com/project")
def page_crawl(rng):
    whole_hrefs = []
    try:
        for j in range(rng,35):
            html = driver.page_source
            bs7 = bs(html,"html.parser")
            hrefs = bs7.find_all("a","subtitle-2-medium project-link")
            for i in range(0,len(hrefs)):
                whole_hrefs.append("https://www.wishket.com"+hrefs[i]['href'])
            driver.execute_script("window.scrollTo(0,2500)") # 스크롤 다운
            time.sleep(0.3)
            links = driver.find_elements_by_class_name("page-link")
            next_ = links[len(links)-1]
            next_.click()
            time.sleep(4.9)
    except:
        print("page start from: ",j)
        raise
    return whole_hrefs



def wish_crwal(rng,whole_hrefs):
    try:
        for i in range(rng,len(whole_hrefs)):
            driver.get(whole_hrefs[i])
            time.sleep(1)
            html_tmp = driver.page_source
            bs_tmp = bs(html_tmp,"html.parser")
            if len(bs_tmp.find_all('p',{'class':'client-badge-name body-3-medium text600'}))<1:
                badge_ = ''
            else:
                badge_ = remove_html_tags(bs_tmp.find_all('p',{'class':'client-badge-name body-3-medium text600'}))
            # budget_exp_len
            if len(bs_tmp.find_all('div',{'class':'represent-arrow'}))<1:
                budget_exp_len = ''
            else:
                budget_exp_len = remove_html_tags(bs_tmp.find_all('div',{'class':'represent-arrow'})[0]), # budget_exp_len
            # nproject_
            if len(bs_tmp.find_all('p',{'class':'client-project-info-data body-2-medium text900'}))<1:
                nproject = ['','','','','','']
            else:
                nproject = [remove_html_tags(bs_tmp.find_all('p',{'class':'client-project-info-data body-2-medium text900'})[0]), # 'nproject_uploaded',
                            remove_html_tags(bs_tmp.find_all('p',{'class':'client-project-info-data body-2-medium text900'})[1]), # 'nproject_contracted',
                            remove_html_tags(bs_tmp.find_all('p',{'class':'client-project-info-data body-3-medium text600'})[0]), # 'nproject_proceeding',
                            remove_html_tags(bs_tmp.find_all('p',{'class':'client-project-info-data body-3-medium text600'})[1]), # 'nproject_completed',
                            remove_html_tags(bs_tmp.find_all('p',{'class':'client-project-info-data body-2-medium text900'})[2]), # 'nproject_percentile','
                            remove_html_tags(bs_tmp.find_all('p',{'class':'client-project-info-data body-2-medium text900'})[3]), # cumulative_price'
                           ]
            if len(bs_tmp.find_all('p',{'class':'budget-type body-3 text500'}))<1:
                budget_type = ['','']
            else:
                budget_type = [remove_html_tags(bs_tmp.find_all('p',{'class':'budget-type body-3 text500'})[0]),
                              remove_html_tags(bs_tmp.find_all('p',{'class':'budget-price body-2-medium text600'})[0])]
            if len(bs_tmp.find_all('div',{'class':'subcategory-box body-3 text600'}))<1:
                technologies = ['']
            else:
                technologies = remove_html_tags(bs_tmp.find_all('div',{'class':'subcategory-box body-3 text600'}))
            if len(bs_tmp.find_all('p',{'class':'caption-1 text500 mb16'}))<1:
                client_intro = ['']
            else:
                client_intro = remove_html_tags(bs_tmp.find_all('p',{'class':'caption-1 text500 mb16'}))
            if len(remove_html_tags(bs_tmp.find_all('p',{'class':'client-rating-point body-2-bold text900'})))<1:
                client_rating = ['']
            else:
                client_rating = remove_html_tags(bs_tmp.find_all('p',{'class':'client-rating-point body-2-bold text900'}))
            
            if remove_html_tags(bs_tmp.find('div',{'class':'project-classification mb24'}).find('div',{'class':'simple-chip inhouse-chip caption-1-medium'}))==" 기간제(상주) ":
                tmp_list=[whole_hrefs[i], #link
                          remove_html_tags(bs_tmp.find('p',{'class':'project-recruit-guide body-3 text300'})), # date_register
                          remove_html_tags(bs_tmp.find('div',{'class':'status-mark recruiting-mark'})), #current_status
                          remove_html_tags(bs_tmp.find('h1',{'class':'subtitle-1-medium mb8 text900'})),
                          remove_html_tags(bs_tmp.find('div',{'class':'simple-chip outsourcing-chip caption-1-medium'})),
                          remove_html_tags(bs_tmp.find_all('p',{'class':'project-category body-2 text400'})[0]),
                          remove_html_tags(bs_tmp.find_all('p',{'class':'project-category body-2 text400'})[1]),
                          budget_exp_len, # budget_exp_len
                          remove_html_tags(bs_tmp.find_all('p')[10]), # total_budget
                          budget_type[0], # budget_type
                          budget_type[1], # budget_price_medium
                          remove_html_tags(bs_tmp.find_all('p',{'class':'project-condition-data body-1-medium text900'})[0]), # time_len
                          remove_html_tags(bs_tmp.find_all('p',{'class':'project-condition-data body-1-medium text900'})[1]), # applicants
                          remove_html_tags(bs_tmp.find_all('p',{'class':'condition-label body-2 text500'})), #project_labels
                          remove_html_tags(bs_tmp.find_all('p',{'class':'condition-data body-2 text900'})), #project_conditions
                          technologies, #technology
                          remove_html_tags(bs_tmp.find_all('p',{'class':'recruit-condition-data body-2 text900'})), # applicants_desc
                          remove_html_tags(bs_tmp.find_all('p',{'class':'meeting-condition-data body-2 text900'})[0]), # initial_meeting
                          remove_html_tags(bs_tmp.find_all('div',{'class':'project-work-condition-box'})[0]), # work_place
                          remove_html_tags(bs_tmp.find_all('div',{'class':'project-work-condition-box'})[1]), # work_time
                          remove_html_tags(bs_tmp.find_all('div',{'class':'project-work-condition-box'})[2]), # work_extra_work
                          remove_html_tags(bs_tmp.find_all('div',{'class':'project-work-condition-box'})[3]), # work_equipment
                          remove_html_tags(bs_tmp.find_all('div',{'class':'project-work-condition-box'})[4]), # work_meal
                          remove_html_tags(bs_tmp.find_all('div',{'class':'project-work-condition-box'})[5]), # work_micsellaneous
                         remove_html_tags(bs_tmp.find('div',{'class':'project-description-box body-2 mb40 text900'})), # project_description
                          badge_, # badges
                          client_intro, #client_intro
                          client_rating, #client_rating
                          nproject[0], # 'nproject_uploaded',
                          nproject[1], # 'nproject_contracted',
                          nproject[2], # 'nproject_proceeding',
                          nproject[3], # 'nproject_completed',
                          nproject[4], # 'nproject_percentile','
                          nproject[5] # cumulative_price'
                         ]
                wishket_resident.loc[len(wishket_resident)] = tmp_list
            else:
                tmp_list=[whole_hrefs[i], #link
                          remove_html_tags(bs_tmp.find('p',{'class':'project-recruit-guide body-3 text300'})), # date_register
                         remove_html_tags(bs_tmp.find('div',{'class':'status-mark recruiting-mark'})), # current_status
                         remove_html_tags(bs_tmp.find('h1',{'class':'subtitle-1-medium mb8 text900'})), # project_name
                          remove_html_tags(bs_tmp.find('div',{'class':'simple-chip outsourcing-chip caption-1-medium'})), # outsourcing
                         remove_html_tags(bs_tmp.find_all('p',{'class':'project-category body-2 text400'})[0]), # project_cat
                         remove_html_tags(bs_tmp.find_all('p',{'class':'project-category body-2 text400'})[1]), # project_sector
                         remove_html_tags(bs_tmp.find_all('p',{'class':'project-condition-data body-1-medium text900'})[0]), # budget
                         remove_html_tags(bs_tmp.find_all('p',{'class':'project-condition-data body-1-medium text900'})[1]), # time_len
                         remove_html_tags(bs_tmp.find_all('p',{'class':'project-condition-data body-1-medium text900'})[2]), # applicants
                        remove_html_tags(bs_tmp.find_all('p',{'class':'condition-label body-2 text500'})), #project_labels
                         remove_html_tags(bs_tmp.find_all('p',{'class':'condition-data body-2 text900'})), #project_conditions
                          technologies, #technology
                         remove_html_tags(bs_tmp.find_all('p',{'class':'recruit-condition-data body-2 text900'})), # applicants_desc
                         remove_html_tags(bs_tmp.find_all('p',{'class':'meeting-condition-data body-2 text900'})[0]), # initial_meeting
                         remove_html_tags(bs_tmp.find_all('p',{'class':'meeting-condition-data body-2 text900'})[1]), # onboard_meeting
                         remove_html_tags(bs_tmp.find_all('p',{'class':'meeting-condition-data body-2 text900'})[2]), # client_destination
                         remove_html_tags(bs_tmp.find('div',{'class':'project-description-box body-2 mb40 text900'})), # project_description
                          badge_, # badges
                          client_intro, #client_intro
                          client_rating, #client_rating
                          nproject[0], # 'nproject_uploaded',
                          nproject[1], # 'nproject_contracted',
                          nproject[2], # 'nproject_proceeding',
                          nproject[3], # 'nproject_completed',
                          nproject[4], # 'nproject_percentile','
                          nproject[5] # cumulative_price'
                        ]
                wishket_df.loc[len(wishket_df)] = tmp_list
            time.sleep(4)
            if i % 5 == 0:
                print(i)
    except:
        print("page start from: ",i)
        raise

whole_hrefs = page_crawl(0)
wish_crwal(0,whole_hrefs)

wishket_df['query_date'] = current_time.strftime("%Y-%m-%d,%H:%M")
wishket_resident['query_date'] = current_time.strftime("%Y-%m-%d,%H:%M")
wishket_df.to_excel("일일 데이터\\외주"+current_time.strftime("%y%m%d")+".xlsx")
wishket_resident.to_excel("일일 데이터\\상주"+current_time.strftime("%y%m%d")+".xlsx")
# =============================================================================
# wishket_df.to_excel("일일 데이터\\외주"+current_time.strftime("%y%m%d")+"_add.xlsx")
# wishket_resident.to_excel("일일 데이터\\상주"+current_time.strftime("%y%m%d")+"_add.xlsx")
# =============================================================================

