CREATE TABLE PROD1
    (
      Item_Name         VARCHAR2(30)    CONSTRAINT Item_Name1_pk PRIMARY KEY
    , Product_Price     NUMBER(5,2)
    );

CREATE TABLE PROD2
    (
      Item_Name         VARCHAR2(30)    CONSTRAINT Item_Name2_pk PRIMARY KEY
    , Product_Price     NUMBER(5,2)
    );    

CREATE TABLE REST1
    (
      Order_Number      NUMBER(10)
    , Order_Date        DATE
    , Item_Name         VARCHAR2(30)    CONSTRAINT Item_Name1_fk REFERENCES PROD1 (Item_Name)
    , Quantity          NUMBER(3)
    , Product_Price     NUMBER(5,2)
    , Total_products    NUMBER(3)
    );

CREATE TABLE REST2
    (
      Order_Number      NUMBER(10)
    , Order_Date        DATE
    , Item_Name         VARCHAR2(30)    CONSTRAINT Item_Name2_fk REFERENCES PROD2 (Item_Name)
    , Quantity          NUMBER(3)
    , Product_Price     NUMBER(5,2)
    , Total_products    NUMBER(3)
    );
/
--Базовая витрина
CREATE TABLE ORD1
    (
      order_number      NUMBER(10)
    , order_date        DATE
    , item_name         VARCHAR2(30) 
    , quantity          NUMBER(3)
    , product_price     NUMBER(5,2)
    );
    
CREATE TABLE ORD2
    (
      order_number      NUMBER(10)
    , order_date        DATE
    , item_name         VARCHAR2(30)
    , quantity          NUMBER(3)
    , product_price     NUMBER(5,2)
    );    
/
--Перенос данных в базовую витрину
INSERT INTO ORD1 (order_number, order_date, item_name, quantity, product_price)
    SELECT        order_number, order_date, item_name, quantity, product_price FROM REST1;

INSERT INTO ORD2 (order_number, order_date, item_name, quantity, product_price)
    SELECT        order_number, order_date, item_name, quantity, product_price FROM REST2;

COMMIT;
/
-- итоговая витрина-агрегат, которая будет использоваться для аналитики, минимум 1 витрина
CREATE TABLE report_rest_1_month
    (
    date_report     DATE            -- месяц отчета. в формате последнего дня месяца 30.09.15
    , orders        NUMBER(5)       -- количество заказов в месяц
    , summ          NUMBER(10,2)    -- выручка в месяц
    , avg_ord       NUMBER(10,2)    -- средний чек в месяц
    );
-- витрина-агрегат, вероятность кросс-продажи продукта. 
CREATE TABLE report_rest_1_cross_item
    (
    item_name           VARCHAR2(30) -- покупаемый продукт
    , item_name_cross   VARCHAR2(30) -- дополнительный продукт в заказе
    , cross_chance      NUMBER(4,1)  -- вероятность покупки дополнительного товара
    );
/