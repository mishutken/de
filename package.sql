CREATE OR REPLACE 
PACKAGE FINAL_PACK AS 

    PROCEDURE build_report_rest_1_month;
    PROCEDURE build_report_rest_1_cross_item (p_chance INTEGER := 10, p_popular INTEGER := 10);
    
END FINAL_PACK;
/
CREATE OR REPLACE PACKAGE BODY FINAL_PACK AS

--����������� ������� � ���������� ������� ��������� �1
PROCEDURE build_report_rest_1_month
IS
    CURSOR  cur_rep IS
        SELECT  LAST_DAY(TRUNC(ord1.order_date, 'MONTH'))   --date_report � ��������� ���� ������, �� ������� ���������� ������ (������, �31.12.2020� �������� � ���� ��� ������� �� ������� 2020 ����)
                , COUNT(ord1.order_number)                  --orders �  ���������� ������� �� ��������� ������
                , SUM(ord1.quantity * ord1.product_price)   --summ � ��������� ���������� ��������� ������� �� ��������� ������
                , ROUND(SUM(ord1.quantity * ord1.product_price) / COUNT(ord1.order_number) , 2) --avg_ord - ������� ���
        FROM    ord1
        GROUP BY TRUNC(ord1.order_date, 'MONTH')
        ORDER BY LAST_DAY(TRUNC(ord1.order_date, 'MONTH'));
    v_date_report   report_rest_1_month.date_report%TYPE;
    v_orders        report_rest_1_month.orders%TYPE;
    v_summ          report_rest_1_month.summ%TYPE;    
    v_avg           report_rest_1_month.avg_ord%TYPE;
    v_last_date_report  DATE;
    v_count_row_i       INTEGER := 0;
BEGIN
-- ������ �������� ���������� ������ ������
    SELECT  MAX(date_report)
    INTO    v_last_date_report
    FROM    report_rest_1_month;

    DELETE FROM report_rest_1_month 
    WHERE   v_last_date_report = date_report;

    OPEN cur_rep;
    LOOP
        FETCH cur_rep INTO v_date_report, v_orders, v_summ, v_avg;
        CONTINUE WHEN v_last_date_report > v_date_report;
        EXIT WHEN cur_rep%NOTFOUND;

        INSERT INTO report_rest_1_month 
            VALUES (v_date_report, v_orders, v_summ, v_avg);

        v_count_row_i := v_count_row_i + 1;
        IF MOD(v_count_row_i, 5) = 0 THEN
            COMMIT; 
        END IF;
        
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('����� ���������� ����������� � ������� ����� = '|| v_count_row_i);
END;
--����������� �����-������� ��������. 
--p_chance  - �����������, �������� 10 = 10%.  
--p_popular - ������������ ������ 10 = �� ���� ������ ������ ��������� ������� �������� �� ����� 10 ���.
PROCEDURE build_report_rest_1_cross_item (p_chance INTEGER := 10, p_popular INTEGER := 10)
IS
--������ ����������� ����������� ������������ ������ 
    CURSOR cur_item(p_item_name VARCHAR2) IS
        SELECT  r2.item_name
                , ROUND( 
                    100 *       
                    COUNT (r2.item_name) / 
                    (SELECT  COUNT(r3.order_number)
                    FROM    ord1 r3
                    WHERE   r3.item_name = p_item_name)
                        , 1)
        FROM    ord1 r2
        WHERE   r2.order_number IN
            (
            SELECT  r1.order_number
            FROM    ord1 r1
            WHERE   r1.item_name = p_item_name
            )
        GROUP BY r2.item_name
        ORDER BY COUNT (r2.item_name) DESC;
    --������ ��������� ��� ������������ �������, ��������� �� ������������, �������� �� ���������� ������ 
    CURSOR cur_all (p_popular INTEGER) IS
        SELECT  item_name
        FROM    ord1 
        GROUP BY item_name
        HAVING   COUNT (item_name) >= p_popular 
        ORDER BY COUNT (item_name) DESC;

    v_item_name         report_rest_1_cross_item.item_name%TYPE;
    v_item_name_cross   report_rest_1_cross_item.item_name_cross%TYPE;
    v_cross_chance      report_rest_1_cross_item.cross_chance%TYPE;
    v_chance            INTEGER := p_chance;
    v_popular           INTEGER := p_popular;
    v_count_row         INTEGER := 0;
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_rest_1_cross_item';
    OPEN cur_all (v_popular);
    LOOP
    FETCH cur_all INTO v_item_name;
        OPEN cur_item (v_item_name);
        LOOP
            FETCH cur_item INTO v_item_name_cross, v_cross_chance;   
            CONTINUE WHEN v_item_name_cross = v_item_name;    
-- ��������� ������ �� �����-�������, ����������� ������� >= v_chance
            IF v_cross_chance >= v_chance THEN 
                INSERT INTO report_rest_1_cross_item 
                    VALUES (v_item_name, v_item_name_cross, v_cross_chance);
                v_count_row := v_count_row + 1;
            END IF;
            EXIT WHEN cur_item%NOTFOUND;     
        END LOOP;
        
        COMMIT;
        CLOSE cur_item;
        EXIT WHEN cur_all%NOTFOUND;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('����� ���������� ����������� � ������� ����� = '|| v_count_row);

END;

END FINAL_PACK;

