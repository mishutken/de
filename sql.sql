--проверка
/
SET SERVEROUTPUT ON
/
BEGIN
    FINAL_PACK.build_report_rest_1_month;
    FINAL_PACK.build_report_rest_1_cross_item (10,100);
END;
/
SELECT  *
FROM    report_rest_1_cross_item
WHERE   item_name = 'Pilau Rice'
ORDER BY cross_chance DESC FETCH NEXT 5 ROWS ONLY;
/
SELECT  *
FROM    report_rest_1_month
WHERE   1 = 1
        AND ( date_report BETWEEN TO_DATE('01.01.2018', 'DD.MM.YYYY') AND TO_DATE('01.01.2019', 'DD.MM.YYYY') )
/