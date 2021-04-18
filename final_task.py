import sqlalchemy as adb
from sqlalchemy import MetaData
import cx_Oracle as ora
import pandas as pd
import datetime as dt

#Подключение к Oracle
def conn_to_db(p_table):
    l_user = 'shiyanov_sd'
    l_pass = 'osb_8619'
    l_tns = ora.makedsn('13.95.167.129', 1521, service_name = 'pdb1')
    
    l_conn_ora = adb.create_engine(r'oracle://{p_user}:{p_pass}@{p_tns}'.format(
        p_user = l_user
        , p_pass = l_pass
        , p_tns = l_tns
        )
        )
    l_meta = MetaData(l_conn_ora)
    l_meta.reflect()
    l_table = l_meta.tables[p_table]
    print(l_table)
    return l_table
    
# процедура переброса данных из csv в БД
def csv_to_db(p_csv): 
    
    l_csv = p_csv
    l_db = conn_to_db(l_csv)   
    l_time = dt.datetime.now()    
    j = 1
    
    if p_csv[:1] == 'p': 
        
        l_file_csv = pd.read_csv(r'c:\Users\admin\Documents\_Обучение\reboot_DE\Final\db\restaurant-{p}-products-price.csv'.format (p = l_csv[-1:]))
        l_list_csv = l_file_csv.values.tolist()
        
        for i in l_list_csv:
            l_db.insert().values (
                                  item_name     = str(i[0])
                                , product_price = float(i[1])
                                 ).execute()
            # прогресс и остаток времени. вывод на консоль
            if j%100 == 0:
                print(r'Загрузка = {rate} %'.format(rate = round( (j * 100)/ (len(l_file_csv)), 2) ))
                l_time_n = dt.datetime.now()
                print (r'Осталось = {time}'.format (time = ((l_time_n - l_time) / j) * (len(l_file_csv) - j - 1)) )
            j += 1
    
    if p_csv[:1] =='r': 
        
        l_file_csv = pd.read_csv(r'c:\Users\admin\Documents\_Обучение\reboot_DE\Final\db\restaurant-{p}-orders.csv'.format (p = l_csv[-1:]))
        l_list_csv = l_file_csv.values.tolist()
        
        for i in l_list_csv:
            l_db.insert().values (
                                    order_number   = int(i[0]) 
                                  , order_date     = dt.datetime.strptime(i[1], '%d/%m/%Y %M:%S') #03/08/2019 20:25
                                  , item_name      = str(i[2])
                                  , quantity       = int(i[3]) 
                                  , product_price  = float(i[4])
                                  , total_products = int(i[5]) 
                                ).execute()
            # прогресс и остаток времени. вывод на консоль
            if j%100 == 0:
                print(r'Загрузка = {rate} %'.format (rate = round( (j * 100)/ (len(l_file_csv)), 2) ))
                l_time_n = dt.datetime.now()
                print (r'Осталось = {time}'.format (time = ((l_time_n - l_time) / j) * (len(l_file_csv) - j - 1)) )
            j += 1
    
    
    print(r'Загрузка {q} в db завершена'.format (q = l_csv))
    
    
    
    
    
    
#csv_to_db('prod1')
#csv_to_db('prod2')

#csv_to_db('rest2')
csv_to_db('rest1') 




