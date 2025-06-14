CREATE TABLE VVV_T1 (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);
INSERT INTO VVV_T1 (id, name) VALUES (1, 'Row 1');
INSERT INTO VVV_T1 (id, name) VALUES (2, 'Row 2');
INSERT INTO VVV_T1 (id, name) VALUES (3, 'Row 3');

select * from VVV_T1

drop table VVV_T1

SELECT * FROM USER_RECYCLEBIN;

FLASHBACK TABLE VVV_T1 TO BEFORE DROP;

BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO VVV_T1 (id, name)
        VALUES (i, 'Row ' || i);
    END LOOP;
    COMMIT; 
END;

SELECT ROWID, id, name
FROM VVV_T1 
WHERE ROWNUM <= 10; 

SELECT ROWSCN, id, name
FROM VVV_T1 
WHERE ROWNUM <= 10; 

SELECT column_name 
FROM user_tab_columns 
WHERE table_name = 'VVV_T1';
