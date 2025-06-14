ALTER TABLE TEACHER 
ADD (
  BIRTHDAY DATE,
  SALARY   NUMBER(8, 2)
);
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1980-01-15', 'YYYY-MM-DD'), SALARY = 4800 WHERE TEACHER = 'ИВАНОВ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1975-06-22', 'YYYY-MM-DD'), SALARY = 5200 WHERE TEACHER = 'ПЕТРОВ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1982-03-11', 'YYYY-MM-DD'), SALARY = 4600 WHERE TEACHER = 'СИДОР';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1989-10-05', 'YYYY-MM-DD'), SALARY = 4300 WHERE TEACHER = 'СМИРН';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1978-12-09', 'YYYY-MM-DD'), SALARY = 5100 WHERE TEACHER = 'КУЗНЕЦ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1985-04-27', 'YYYY-MM-DD'), SALARY = 4400 WHERE TEACHER = 'СЕРГЕЕ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1990-07-14', 'YYYY-MM-DD'), SALARY = 4000 WHERE TEACHER = 'ЛОГВИ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1983-11-19', 'YYYY-MM-DD'), SALARY = 4700 WHERE TEACHER = 'МИХАЙЛ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1976-08-03', 'YYYY-MM-DD'), SALARY = 5300 WHERE TEACHER = 'ТАРАСО';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1981-02-28', 'YYYY-MM-DD'), SALARY = 4900 WHERE TEACHER = 'ФЕДОРО';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1988-09-07', 'YYYY-MM-DD'), SALARY = 4200 WHERE TEACHER = 'АНДРЕЕ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1991-05-12', 'YYYY-MM-DD'), SALARY = 3900 WHERE TEACHER = 'НИКОЛА';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1984-06-18', 'YYYY-MM-DD'), SALARY = 4500 WHERE TEACHER = 'ПАВЛОВ';
UPDATE TEACHER SET BIRTHDAY = TO_DATE('1979-03-25', 'YYYY-MM-DD'), SALARY = 5000 WHERE TEACHER = 'БЕЛОВ';
commit;


SELECT 
  INITCAP(REGEXP_SUBSTR(TEACHER_NAME, '^\S+')) || ' ' ||                 -- Фамилия
  SUBSTR(REGEXP_SUBSTR(TEACHER_NAME, '^\S+\s(\S+)'), INSTR(TEACHER_NAME, ' ') + 1, 1) || '.' ||  -- И.
  SUBSTR(REGEXP_SUBSTR(TEACHER_NAME, '^\S+\s\S+\s(\S+)'), INSTR(TEACHER_NAME, ' ', -1) + 1, 1) || '.'  -- О.
  AS SHORT_NAME
FROM TEACHER
WHERE TO_CHAR(BIRTHDAY, 'D', 'NLS_DATE_LANGUAGE=RUSSIAN') = '1';

CREATE OR REPLACE VIEW NEXT_MONTH_BIRTHDAYS AS
SELECT 
  TEACHER,
  TEACHER_NAME,
  TO_CHAR(BIRTHDAY, 'DD/MM/YYYY') AS BIRTHDAY_FORMATTED
FROM 
  TEACHER
WHERE 
  EXTRACT(MONTH FROM BIRTHDAY) = MOD(EXTRACT(MONTH FROM SYSDATE), 12) + 1;

SELECT * FROM NEXT_MONTH_BIRTHDAYS;

CREATE OR REPLACE VIEW TEACHERS_BY_MONTH AS
SELECT 
  MONTH_NAME,
  TEACHER_COUNT
FROM (
  SELECT 
    TO_CHAR(BIRTHDAY, 'Month', 'NLS_DATE_LANGUAGE = RUSSIAN') AS MONTH_NAME,
    TO_NUMBER(TO_CHAR(BIRTHDAY, 'MM')) AS MONTH_NUM,
    COUNT(*) AS TEACHER_COUNT
  FROM 
    TEACHER
  GROUP BY 
    TO_CHAR(BIRTHDAY, 'Month', 'NLS_DATE_LANGUAGE = RUSSIAN'),
    TO_CHAR(BIRTHDAY, 'MM')
)
ORDER BY 
  MONTH_NUM;

SELECT * FROM TEACHERS_BY_MONTH;


DECLARE
  CURSOR cur_anniversary IS
    SELECT 
      TEACHER_NAME,
      EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, 12)) - EXTRACT(YEAR FROM BIRTHDAY) AS AGE_NEXT_YEAR
    FROM TEACHER
    WHERE MOD(EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, 12)) - EXTRACT(YEAR FROM BIRTHDAY), 5) = 0
      AND BIRTHDAY IS NOT NULL;
BEGIN
  FOR rec IN cur_anniversary LOOP
    DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || rec.TEACHER_NAME || ', юбилей: ' || rec.AGE_NEXT_YEAR || ' лет.');
  END LOOP;
END;
/

UPDATE TEACHER
SET BIRTHDAY = TO_DATE('01-06-1991', 'DD-MM-YYYY')
WHERE TEACHER = 'ИВАНОВ';  -- или другой преподаватель
COMMIT;


DECLARE
  -- Переменные для хранения данных из курсора
  v_pulpit        PULPIT.PULPIT%TYPE;
  v_pulpit_name   PULPIT.PULPIT_NAME%TYPE;
  v_faculty       FACULTY.FACULTY%TYPE;
  v_faculty_name  FACULTY.FACULTY_NAME%TYPE;
  v_avg_salary    NUMBER;

  -- Переменные для подсчёта итогов
  v_sum_avg_pulpit NUMBER := 0;
  v_count_pulpit   NUMBER := 0;

  CURSOR c_avg_salary_per_pulpit IS
    SELECT 
      p.PULPIT,
      p.PULPIT_NAME,
      f.FACULTY,
      f.FACULTY_NAME,
      FLOOR(AVG(t.SALARY)) AS AVG_SALARY
    FROM TEACHER t
    JOIN PULPIT p ON t.PULPIT = p.PULPIT
    JOIN FACULTY f ON p.FACULTY = f.FACULTY
    GROUP BY p.PULPIT, p.PULPIT_NAME, f.FACULTY, f.FACULTY_NAME
    ORDER BY f.FACULTY, p.PULPIT;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Средняя зарплата по кафедрам (округлена вниз):');
  DBMS_OUTPUT.PUT_LINE('Факультет | Кафедра | Средняя зарплата');

  OPEN c_avg_salary_per_pulpit;
  LOOP
    FETCH c_avg_salary_per_pulpit INTO v_pulpit, v_pulpit_name, v_faculty, v_faculty_name, v_avg_salary;
    EXIT WHEN c_avg_salary_per_pulpit%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(v_faculty_name || ' | ' || v_pulpit_name || ' | ' || v_avg_salary);

    v_sum_avg_pulpit := v_sum_avg_pulpit + v_avg_salary;
    v_count_pulpit := v_count_pulpit + 1;
  END LOOP;
  CLOSE c_avg_salary_per_pulpit;

  IF v_count_pulpit > 0 THEN
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Общая средняя зарплата по всем кафедрам (округлена вниз): ' || FLOOR(v_sum_avg_pulpit / v_count_pulpit));
  END IF;

  -- Подсчёт средней зарплаты по факультетам
  DBMS_OUTPUT.PUT_LINE('Средняя зарплата по факультетам:');
  FOR rec IN (
    SELECT f.FACULTY_NAME, FLOOR(AVG(t.SALARY)) AS AVG_SALARY
    FROM TEACHER t
    JOIN PULPIT p ON t.PULPIT = p.PULPIT
    JOIN FACULTY f ON p.FACULTY = f.FACULTY
    GROUP BY f.FACULTY_NAME
    ORDER BY f.FACULTY_NAME
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE(rec.FACULTY_NAME || ' | ' || rec.AVG_SALARY);
  END LOOP;

END;
/

DECLARE
  numerator   NUMBER := 10;  -- делимое
  denominator NUMBER := 0;   -- делитель (можно менять для теста)
  result      NUMBER;
BEGIN
  -- Проверяем делитель вручную и генерируем ошибку, если он 0
  IF denominator = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Делитель равен нулю!');
  END IF;

  -- Выполняем деление
  result := numerator / denominator;

  DBMS_OUTPUT.PUT_LINE('Результат деления: ' || result);

EXCEPTION
  WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('Обработка исключения: попытка деления на ноль!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
END;
/

DECLARE
  v_teacher_code  TEACHER.TEACHER%TYPE := 'Васильев';
  v_teacher_name  TEACHER.TEACHER_NAME%TYPE;
BEGIN
  SELECT TEACHER_NAME
    INTO v_teacher_name
    FROM TEACHER
   WHERE TEACHER = v_teacher_code;

  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || v_teacher_name);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Преподаватель не найден!');
    RAISE;
END;
/


DECLARE
  -- Объявляем исключение в внешнем блоке
  outer_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(outer_exc, -20001);
BEGIN
    DECLARE
        inner_exc EXCEPTION;
        PRAGMA EXCEPTION_INIT(inner_exc, -20001);
  BEGIN


    -- Генерируем ошибку с кодом -20001
    RAISE_APPLICATION_ERROR(-20001, 'Ошибка из вложенного блока');
  EXCEPTION
    WHEN inner_exc THEN
      DBMS_OUTPUT.PUT_LINE('Исключение во вложенном блоке ПЕРЕДАНО наружу');
      -- Пробрасываем наружу
      RAISE;
  END;

EXCEPTION
  WHEN outer_exc THEN
    DBMS_OUTPUT.PUT_LINE('Исключение обработано во внешнем блоке');
END;
/

DECLARE
  err_common EXCEPTION; -- Внешнее исключение
BEGIN
  BEGIN
    DECLARE
      err_common EXCEPTION; -- Внутреннее исключение (затеняет внешнее)
    BEGIN
      RAISE err_common; -- Выбрасываем внутреннее исключение
    EXCEPTION
      WHEN err_common THEN
        DBMS_OUTPUT.PUT_LINE('Обработано ВНУТРЕННЕЕ исключение');
    END;
  EXCEPTION
    WHEN err_common THEN
      DBMS_OUTPUT.PUT_LINE('Обработано ВНЕШНЕЕ исключение');
  END;
END;
/


DECLARE
  max_salary NUMBER;
BEGIN
  SELECT MAX(SALARY)
  INTO max_salary
  FROM TEACHER
  WHERE 1 = 0;  -- заведомо ложное условие, вернет NULL

  IF max_salary IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Нет данных. MAX вернул NULL.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Максимальная зарплата: ' || max_salary);
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND — не будет вызвано здесь.');
END;
/


