--проверка
/
SET SERVEROUTPUT ON
/
BEGIN
    FINAL_PACK.build_report_rest_1_month;
    FINAL_PACK.build_report_rest_1_cross_item (25,100);
END;
/
SELECT  *
FROM    report_rest_1_month
/
SELECT  *
FROM    report_rest_1_cross_item
/