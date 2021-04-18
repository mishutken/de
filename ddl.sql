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
--������� �������
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
--������� ������ � ������� �������
INSERT INTO ORD1 (order_number, order_date, item_name, quantity, product_price)
    SELECT        order_number, order_date, item_name, quantity, product_price FROM REST1;

INSERT INTO ORD2 (order_number, order_date, item_name, quantity, product_price)
    SELECT        order_number, order_date, item_name, quantity, product_price FROM REST2;

COMMIT;
/
-- �������� �������-�������, ������� ����� �������������� ��� ���������, ������� 1 �������
CREATE TABLE report_rest_1_month
    (
    date_report     DATE            -- ����� ������. � ������� ���������� ��� ������ 30.09.15
    , orders        NUMBER(5)       -- ���������� ������� � �����
    , summ          NUMBER(10,2)    -- ������� � �����
    , avg_ord       NUMBER(10,2)    -- ������� ��� � �����
    );
-- �������-�������, ����������� �����-������� ��������. 
CREATE TABLE report_rest_1_cross_item
    (
    item_name           VARCHAR2(30) -- ���������� �������
    , item_name_cross   VARCHAR2(30) -- �������������� ������� � ������
    , cross_chance      NUMBER(4,1)  -- ����������� ������� ��������������� ������
    );
/