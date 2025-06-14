DECLARE
  v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  SELECT TEACHER_NAME
  INTO v_teacher_name
  FROM TEACHER
  WHERE TEACHER = 'ИВАНОВ';

  DBMS_OUTPUT.PUT_LINE('Имя преподавателя: ' || v_teacher_name);
END;


DECLARE
  v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  SELECT TEACHER_NAME
  INTO v_teacher_name
  FROM TEACHER
  WHERE PULPIT = 'ИСиТ'; -- намеренно допускаем ситуацию "несколько строк"

  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || v_teacher_name);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' - ' || SQLERRM);
END;


DECLARE
  v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  -- Пытаемся выбрать имя преподавателя по PULPIT — но их несколько
  SELECT TEACHER_NAME
  INTO v_teacher_name
  FROM TEACHER
  WHERE PULPIT = 'ИСиТ';

  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || v_teacher_name);

EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: выбрано более одной строки (TOO_MANY_ROWS).');
END;


DECLARE
  v_subject_name SUBJECT.SUBJECT_NAME%TYPE;
BEGIN
  SELECT SUBJECT_NAME
  INTO v_subject_name
  FROM SUBJECT
  WHERE SUBJECT = 'ПИ';  -- такого предмета нет

  DBMS_OUTPUT.PUT_LINE('Предмет: ' || v_subject_name);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: данных не найдено (NO_DATA_FOUND).');
END;


DECLARE
  v_pulpit_name PULPIT.PULPIT_NAME%TYPE;
BEGIN
  SELECT PULPIT_NAME
  INTO v_pulpit_name
  FROM PULPIT
  WHERE PULPIT = 'ИСиТ';

  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Найден кафедра: ' || v_pulpit_name);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Кафедра не найдена.');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Количество строк: ' || SQL%ROWCOUNT);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: данных не найдено (NO_DATA_FOUND).');
END;

DECLARE
  -- Для демонстрации
  v_error_msg VARCHAR2(200);
BEGIN
  -- 1) Нарушение внешнего ключа при INSERT (например, вставим кафедру с несуществующим факультетом)
  BEGIN
    INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
    VALUES ('PUL999', 'Фейковая кафедра', 'ПИМ'); -- ПИМ не существует
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      v_error_msg := SQLERRM;
      DBMS_OUTPUT.PUT_LINE('Ошибка вставки PULPIT: ' || v_error_msg);
      ROLLBACK;
  END;

  -- 2) Нарушение уникальности при INSERT (попытка добавить существующий первичный ключ)
  BEGIN
    INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
    VALUES ('ФИТ', 'Дублирующий факультет'); -- ФИТ уже существует
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Ошибка: дублирование значения первичного ключа FACULTY.');
      ROLLBACK;
  END;

  -- 3) Нарушение внешнего ключа при UPDATE (обновляем у кафедры ссылку на несуществующий факультет)
  BEGIN
    UPDATE PULPIT
    SET FACULTY = 'ПИМ' -- несуществующий факультет
    WHERE PULPIT = 'ИСиТ';
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ошибка обновления PULPIT: ' || SQLERRM);
      ROLLBACK;
  END;

  -- 4) Нарушение ссылочной целостности при DELETE (удаляем факультет, на который ссылается кафедра)
  BEGIN
    DELETE FROM FACULTY WHERE FACULTY = 'ФИТ'; -- предположим, на этот факультет есть ссылки
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ошибка удаления FACULTY: ' || SQLERRM);
      ROLLBACK;
  END;

END;


DECLARE
  -- Объявляем курсор для выборки всех учителей
  CURSOR cur_teacher IS
    SELECT TEACHER, TEACHER_NAME, PULPIT FROM TEACHER;

  -- Объявляем переменные с %TYPE для хранения данных из курсора
  v_teacher TEACHER.TEACHER%TYPE;
  v_teacher_name TEACHER.TEACHER_NAME%TYPE;
  v_pulpit TEACHER.PULPIT%TYPE;
BEGIN
  OPEN cur_teacher;  -- открываем курсор

  LOOP
    FETCH cur_teacher INTO v_teacher, v_teacher_name, v_pulpit;  -- считываем строку
    EXIT WHEN cur_teacher%NOTFOUND;  -- выход из цикла, если больше строк нет

    -- Выводим данные на экран
    DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_teacher || ', NAME: ' || v_teacher_name || ', PULPIT: ' || v_pulpit);
  END LOOP;

  CLOSE cur_teacher;  -- закрываем курсор
END;


DECLARE
  -- Явный курсор для выборки из таблицы SUBJECT
  CURSOR cur_subject IS
    SELECT * FROM SUBJECT;

  -- Запись с типом строки из SUBJECT
  rec_subject cur_subject%ROWTYPE;

  -- Счетчик для цикла
  v_index PLS_INTEGER := 0;
  -- Количество записей, чтобы знать, когда выйти из цикла
  v_count PLS_INTEGER;
BEGIN
  OPEN cur_subject;

  -- Получаем количество записей в курсоре (нужно перебрать все, чтобы считать - либо отдельным запросом)
  SELECT COUNT(*) INTO v_count FROM SUBJECT;

  WHILE v_index < v_count LOOP
    FETCH cur_subject INTO rec_subject;
    EXIT WHEN cur_subject%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('SUBJECT: ' || rec_subject.SUBJECT || 
                         ', NAME: ' || rec_subject.SUBJECT_NAME || 
                         ', PULPIT: ' || rec_subject.PULPIT);

    v_index := v_index + 1;
  END LOOP;

  CLOSE cur_subject;
END;

DECLARE
  -- Курсор с параметром: диапазон вместимости
  CURSOR cur_auditorium(p_min NUMBER, p_max NUMBER) IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN p_min AND p_max
    ORDER BY AUDITORIUM_CAPACITY;

  -- Переменные для FETCH
  v_auditorium AUDITORIUM.AUDITORIUM%TYPE;
  v_name AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  -- 1. Цикл с OPEN, FETCH, EXIT WHEN, CLOSE
  DBMS_OUTPUT.PUT_LINE('Способ 1: LOOP с FETCH');
  OPEN cur_auditorium(1, 20);
  LOOP
    FETCH cur_auditorium INTO v_auditorium, v_name, v_capacity;
    EXIT WHEN cur_auditorium%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Aud: ' || v_auditorium || ', Name: ' || v_name || ', Capacity: ' || v_capacity);
  END LOOP;
  CLOSE cur_auditorium;

  -- 2. Цикл FOR IN (упрощённый перебор курсора)
  DBMS_OUTPUT.PUT_LINE('Способ 2: FOR ... IN cursor');
  FOR rec IN cur_auditorium(21, 30) LOOP
    DBMS_OUTPUT.PUT_LINE('Aud: ' || rec.AUDITORIUM || ', Name: ' || rec.AUDITORIUM_NAME || ', Capacity: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

  -- 3. Цикл WHILE с явным OPEN и CLOSE
  DBMS_OUTPUT.PUT_LINE('Способ 3: WHILE с FETCH');
  OPEN cur_auditorium(31, 60);
  LOOP
    FETCH cur_auditorium INTO v_auditorium, v_name, v_capacity;
    EXIT WHEN cur_auditorium%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Aud: ' || v_auditorium || ', Name: ' || v_name || ', Capacity: ' || v_capacity);
  END LOOP;
  CLOSE cur_auditorium;

  -- Повторим для оставшихся диапазонов (61-80 и 81+)
  DBMS_OUTPUT.PUT_LINE('Диапазон 61-80 (FOR ... IN):');
  FOR rec IN cur_auditorium(61, 80) LOOP
    DBMS_OUTPUT.PUT_LINE('Aud: ' || rec.AUDITORIUM || ', Name: ' || rec.AUDITORIUM_NAME || ', Capacity: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Диапазон 81 и выше (FOR ... IN):');
  FOR rec IN cur_auditorium(81, 9999) LOOP
    DBMS_OUTPUT.PUT_LINE('Aud: ' || rec.AUDITORIUM || ', Name: ' || rec.AUDITORIUM_NAME || ', Capacity: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

END;



DECLARE
  -- Объявляем тип курсорной переменной (REF CURSOR)
  TYPE ref_cursor_type IS REF CURSOR;

  -- Объявляем переменную курсорного типа
  rc ref_cursor_type;

  -- Переменные для FETCH
  v_auditorium AUDITORIUM.AUDITORIUM%TYPE;
  v_name AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;

  -- Параметр для фильтра
  v_min_capacity NUMBER := 20;
  v_max_capacity NUMBER := 60;
BEGIN
  -- Открываем курсорную переменную с параметризованным запросом
  OPEN rc FOR
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN v_min_capacity AND v_max_capacity
    ORDER BY AUDITORIUM_CAPACITY;

  -- Цикл по результатам курсора
  LOOP
    FETCH rc INTO v_auditorium, v_name, v_capacity;
    EXIT WHEN rc%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Aud: ' || v_auditorium || ', Name: ' || v_name || ', Capacity: ' || v_capacity);
  END LOOP;

  CLOSE rc;
END;


DECLARE
  -- Явный курсор с параметрами
  CURSOR c_auditors(p_min NUMBER, p_max NUMBER) IS
    SELECT ROWID, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN p_min AND p_max
    FOR UPDATE;  -- Обязательное условие для UPDATE CURRENT OF

BEGIN
  -- Цикл FOR автоматически открывает, перебирает и закрывает курсор
  FOR rec IN c_auditors(40, 80) LOOP
    -- Уменьшаем вместимость на 10%
    UPDATE AUDITORIUM
    SET AUDITORIUM_CAPACITY = ROUND(rec.AUDITORIUM_CAPACITY * 0.9)
    WHERE ROWID = rec.ROWID;
  END LOOP;

  COMMIT; -- Сохраняем изменения
END;

