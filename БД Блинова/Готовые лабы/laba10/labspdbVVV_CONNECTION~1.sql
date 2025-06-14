BEGIN
   NULL;
END;
/

BEGIN
   DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/

BEGIN
    FOR rec IN (SELECT keyword 
                FROM gv_$reserved_words
                WHERE LENGTH(keyword) = 1 AND keyword != 'A') 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.keyword);
    END LOOP;
END;

/

BEGIN
    -- Объявление и инициализация целых number-переменных
    DECLARE
        a NUMBER := 10;
        b NUMBER := 3;
        sum_result NUMBER;
        diff_result NUMBER;
        mul_result NUMBER;
        div_result NUMBER;
        mod_result NUMBER;

        -- С фиксированной точкой
        fixed_point1 NUMBER(5,2) := 123.45;

        -- С фиксированной точкой и отрицательным масштабом (округление)
        fixed_point2 NUMBER(5,-1) := 12345; -- округлит до десятков

        -- Использование экспоненциальной формы
        exp_number NUMBER := 1.23E3;

        -- Дата
        today DATE := SYSDATE;
        custom_date DATE := TO_DATE('2025-05-12', 'YYYY-MM-DD');

        -- Символьные переменные
        var_char VARCHAR2(20) := 'Hello';
        char_var CHAR(10) := 'World';
        nchar_var NCHAR(10) := N'Привет';
        nvc_var NVARCHAR2(20) := N'Мир';

        -- Boolean-переменные
        bool_true BOOLEAN := TRUE;
        bool_false BOOLEAN := FALSE;
        bool_null BOOLEAN;
    BEGIN
        -- Арифметика
        sum_result := a + b;
        diff_result := a - b;
        mul_result := a * b;
        div_result := a / b;
        mod_result := MOD(a, b);

        -- Вывод значений
        DBMS_OUTPUT.PUT_LINE('a = ' || a || ', b = ' || b);
        DBMS_OUTPUT.PUT_LINE('a + b = ' || sum_result);
        DBMS_OUTPUT.PUT_LINE('a - b = ' || diff_result);
        DBMS_OUTPUT.PUT_LINE('a * b = ' || mul_result);
        DBMS_OUTPUT.PUT_LINE('a / b = ' || div_result);
        DBMS_OUTPUT.PUT_LINE('a mod b = ' || mod_result);

        DBMS_OUTPUT.PUT_LINE('Fixed point (2 dec) = ' || fixed_point1);
        DBMS_OUTPUT.PUT_LINE('Fixed point (-1 scale) = ' || fixed_point2);
        DBMS_OUTPUT.PUT_LINE('Exp notation number = ' || exp_number);

        DBMS_OUTPUT.PUT_LINE('Today = ' || TO_CHAR(today, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Custom date = ' || TO_CHAR(custom_date, 'YYYY-MM-DD'));

        DBMS_OUTPUT.PUT_LINE('VARCHAR2 = ' || var_char);
        DBMS_OUTPUT.PUT_LINE('CHAR = ' || char_var);
        DBMS_OUTPUT.PUT_LINE('NCHAR = ' || nchar_var);
        DBMS_OUTPUT.PUT_LINE('NVARCHAR2 = ' || nvc_var);

        IF bool_true THEN
            DBMS_OUTPUT.PUT_LINE('Boolean TRUE is true');
        END IF;

        IF NOT bool_false THEN
            DBMS_OUTPUT.PUT_LINE('Boolean FALSE is false');
        END IF;

        IF bool_null IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Boolean NULL is null');
        END IF;
    END;
END;
/


BEGIN
    DECLARE
        -- Объявление констант
        c_name       CONSTANT VARCHAR2(20) := 'Oracle';
        c_initial    CONSTANT CHAR(1) := 'O';
        c_pi         CONSTANT NUMBER := 3.14159;
        c_multiplier CONSTANT NUMBER := 2;

        -- Переменные для демонстрации операций
        greeting     VARCHAR2(50);
        repeated     VARCHAR2(50);
        area         NUMBER;
        upper_char   CHAR(1);
    BEGIN
        -- Конкатенация строк
        greeting := 'Hello from ' || c_name;

        -- Повторение символа
        repeated := RPAD(c_initial, 5, c_initial); -- "OOOOO"

        -- Арифметика с числовыми константами
        area := c_pi * c_multiplier * c_multiplier;

        -- Функции для символа
        upper_char := UPPER(c_initial);

        -- Вывод
        DBMS_OUTPUT.PUT_LINE('Greeting: ' || greeting);
        DBMS_OUTPUT.PUT_LINE('Repeated char: ' || repeated);
        DBMS_OUTPUT.PUT_LINE('Area of circle with r=2: ' || area);
        DBMS_OUTPUT.PUT_LINE('Uppercase initial: ' || upper_char);
    END;
END;
/


BEGIN
    DECLARE
        -- Объявление переменной с использованием %TYPE
        v_PULPIT_name PULPIT.PULPIT_NAME%TYPE;

    BEGIN
        -- Присвоим значение переменной
        v_PULPIT_name := 'Кафедра веб-дизайна';

        -- Выведем значение
        DBMS_OUTPUT.PUT_LINE('Pulpit name: ' || v_PULPIT_name);
    END;
END;
/

DECLARE
    v_teacher TEACHER%ROWTYPE;
BEGIN
    -- Присваиваем значения полям переменной
    v_teacher.TEACHER := 'T001';
    v_teacher.TEACHER_NAME := 'Иванов И.И.';
    v_teacher.PULPIT := 'CS';

    -- Выводим значения
    DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_teacher.TEACHER);
    DBMS_OUTPUT.PUT_LINE('TEACHER_NAME: ' || v_teacher.TEACHER_NAME);
    DBMS_OUTPUT.PUT_LINE('PULPIT: ' || v_teacher.PULPIT);
END;
/

DECLARE
    v_number NUMBER := 10;
BEGIN
    -- Простая конструкция IF THEN
    IF v_number > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Число положительное.');
    END IF;

    -- IF THEN ELSE
    IF MOD(v_number, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Число чётное.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Число нечётное.');
    END IF;

    -- IF THEN ELSIF ELSE
    IF v_number < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Число отрицательное.');
    ELSIF v_number = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Число равно нулю.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Число положительное и не равно нулю.');
    END IF;
END;
/


DECLARE
    v_day_number NUMBER := 3;
    v_score NUMBER := 87;
BEGIN
    -- Простая форма CASE
    CASE v_day_number
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('Понедельник');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('Вторник');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('Среда');
        WHEN 4 THEN DBMS_OUTPUT.PUT_LINE('Четверг');
        WHEN 5 THEN DBMS_OUTPUT.PUT_LINE('Пятница');
        WHEN 6 THEN DBMS_OUTPUT.PUT_LINE('Суббота');
        WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('Воскресенье');
        ELSE DBMS_OUTPUT.PUT_LINE('Неверный номер дня');
    END CASE;

    -- Поисковая форма CASE
    CASE 
        WHEN v_score >= 90 THEN DBMS_OUTPUT.PUT_LINE('Оценка: Отлично');
        WHEN v_score >= 75 THEN DBMS_OUTPUT.PUT_LINE('Оценка: Хорошо');
        WHEN v_score >= 60 THEN DBMS_OUTPUT.PUT_LINE('Оценка: Удовлетворительно');
        ELSE DBMS_OUTPUT.PUT_LINE('Оценка: Неудовлетворительно');
    END CASE;
END;
/

DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Итерация: ' || v_counter);
        v_counter := v_counter + 1;

        -- Прерывание цикла после 5 итераций
        EXIT WHEN v_counter > 5;
    END LOOP;
END;
/

DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE('WHILE итерация: ' || v_counter);
        v_counter := v_counter + 1;
    END LOOP;
END;
/

DECLARE
BEGIN
    -- Цикл FOR с явным указанием диапазона
    FOR v_counter IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('FOR итерация: ' || v_counter);
    END LOOP;

    
END;
/

