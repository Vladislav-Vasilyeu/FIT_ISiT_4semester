DECLARE
  -- Процедура локального уровня
  PROCEDURE GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE) IS
  BEGIN
    FOR rec IN (
      SELECT TEACHER, TEACHER_NAME 
      FROM TEACHER 
      WHERE PULPIT = PCODE
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Код преподавателя: ' || rec.TEACHER || ', Имя: ' || rec.TEACHER_NAME);
    END LOOP;
  END;
BEGIN
  GET_TEACHERS('ИСиТ');  
END;
/


DECLARE
  v_result NUMBER;  -- сначала объявляем переменные

  -- потом определяем функцию
  FUNCTION GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM TEACHER
    WHERE PULPIT = PCODE;

    RETURN v_count;
  END;
BEGIN
  -- Вызов функции
  v_result := GET_NUM_TEACHERS('ИСиТ');  
  DBMS_OUTPUT.PUT_LINE('Количество преподавателей на кафедре: ' || v_result);
END;
/

DECLARE
  -- Локальная процедура
  PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) IS
  BEGIN
    FOR rec IN (
      SELECT T.TEACHER_NAME
      FROM TEACHER T
      JOIN PULPIT P ON T.PULPIT = P.PULPIT
      WHERE P.FACULTY = FCODE
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || rec.TEACHER_NAME);
    END LOOP;
  END;
BEGIN
  GET_TEACHERS('ФИТ');
END;
/

DECLARE
  -- Локальная процедура
  PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) IS
  BEGIN
    FOR rec IN (
      SELECT SUBJECT_NAME
      FROM SUBJECT
      WHERE PULPIT = PCODE
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Дисциплина: ' || rec.SUBJECT_NAME);
    END LOOP;
  END;
BEGIN
 
  GET_SUBJECTS('ИСиТ');
END;
/


DECLARE
    V_RESULT NUMBER;
  -- Локальная функция
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER IS
    V_COUNT NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM TEACHER T
    JOIN PULPIT P ON T.PULPIT = P.PULPIT
    WHERE P.FACULTY = FCODE;

    RETURN V_COUNT;
  END;

  
BEGIN
  
  V_RESULT := GET_NUM_TEACHERS('ФИТ');
  DBMS_OUTPUT.PUT_LINE('Количество преподавателей на факультете: ' || V_RESULT);
END;
/


SET SERVEROUTPUT ON;

DECLARE
    V_RESULT NUMBER;
  -- Локальная функция
  FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER IS
    V_COUNT NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM SUBJECT
    WHERE PULPIT = PCODE;

    RETURN V_COUNT;
  END;

  
BEGIN
  
  V_RESULT := GET_NUM_SUBJECTS('ИСиТ');
  DBMS_OUTPUT.PUT_LINE('Количество дисциплин на кафедре: ' || V_RESULT);
END;
/


CREATE OR REPLACE PACKAGE TEACHERS AS
  PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE);
  PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
  FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
END TEACHERS;
/

CREATE OR REPLACE PACKAGE BODY TEACHERS AS

  PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) IS
  BEGIN
    FOR rec IN (
      SELECT T.TEACHER_NAME
      FROM TEACHER T
      JOIN PULPIT P ON T.PULPIT = P.PULPIT
      WHERE P.FACULTY = FCODE
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || rec.TEACHER_NAME);
    END LOOP;
  END;

  PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) IS
  BEGIN
    FOR rec IN (
      SELECT SUBJECT_NAME
      FROM SUBJECT
      WHERE PULPIT = PCODE
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Дисциплина: ' || rec.SUBJECT_NAME);
    END LOOP;
  END;

  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER IS
    V_COUNT NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM TEACHER T
    JOIN PULPIT P ON T.PULPIT = P.PULPIT
    WHERE P.FACULTY = FCODE;
    RETURN V_COUNT;
  END;

  FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER IS
    V_COUNT NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM SUBJECT
    WHERE PULPIT = PCODE;
    RETURN V_COUNT;
  END;

END TEACHERS;
/

SET SERVEROUTPUT ON;

BEGIN
  
  TEACHERS.GET_TEACHERS('ФИТ');
  TEACHERS.GET_SUBJECTS('ИСиТ');

  DBMS_OUTPUT.PUT_LINE('Преподавателей на факультете: ' || TEACHERS.GET_NUM_TEACHERS('CS'));
  DBMS_OUTPUT.PUT_LINE('Дисциплин на кафедре: ' || TEACHERS.GET_NUM_SUBJECTS('CS_PUL'));
END;
/

SET SERVEROUTPUT ON;

DECLARE
  v_faculty_code FACULTY.FACULTY%TYPE := 'ФИТ';         
  v_pulpit_code SUBJECT.PULPIT%TYPE := 'ИСиТ';      
  v_num_teachers NUMBER;
  v_num_subjects NUMBER;
BEGIN
  -- Вызов процедуры для вывода преподавателей по факультету
  DBMS_OUTPUT.PUT_LINE('--- Список преподавателей факультета ' || v_faculty_code || ' ---');
  TEACHERS.GET_TEACHERS(v_faculty_code);

  -- Вызов процедуры для вывода предметов по кафедре
  DBMS_OUTPUT.PUT_LINE('--- Список дисциплин кафедры ' || v_pulpit_code || ' ---');
  TEACHERS.GET_SUBJECTS(v_pulpit_code);

  -- Вызов функции для получения количества преподавателей по факультету
  v_num_teachers := TEACHERS.GET_NUM_TEACHERS(v_faculty_code);
  DBMS_OUTPUT.PUT_LINE('Количество преподавателей на факультете ' || v_faculty_code || ': ' || v_num_teachers);

  -- Вызов функции для получения количества дисциплин по кафедре
  v_num_subjects := TEACHERS.GET_NUM_SUBJECTS(v_pulpit_code);
  DBMS_OUTPUT.PUT_LINE('Количество дисциплин на кафедре ' || v_pulpit_code || ': ' || v_num_subjects);
END;
/
