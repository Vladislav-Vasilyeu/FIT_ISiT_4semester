-- DROP TABLE FACULTY
CREATE TABLE FACULTY
  (
   FACULTY      CHAR(25)      NOT NULL,
   FACULTY_NAME VARCHAR2(100), 
   CONSTRAINT PK_FACULTY PRIMARY KEY(FACULTY) 
  );
     
delete FACULTY;
insert into FACULTY (FACULTY, FACULTY_NAME) values ('ФИТ', 'Факультет информационных технологий');
insert into FACULTY (FACULTY, FACULTY_NAME) values ('ФЭФ', 'Финансово-экономический факультет');
insert into FACULTY (FACULTY, FACULTY_NAME) values ('ФМФ', 'Физико-математический факультет');
insert into FACULTY (FACULTY, FACULTY_NAME) values ('ФГС', 'Факультет гуманитарных и социальных наук');
insert into FACULTY (FACULTY, FACULTY_NAME) values ('ФБИ', 'Факультет биоинженерии');
insert into FACULTY (FACULTY, FACULTY_NAME) values ('ФИЯ', 'Факультет иностранных языков');


--------------------------------------------------------------------------------------------
-- DROP TABLE PULPIT
CREATE TABLE PULPIT 
(
 PULPIT       CHAR(25)      NOT NULL,
 PULPIT_NAME  VARCHAR2(100), 
 FACULTY      CHAR(25)      NOT NULL, 
 CONSTRAINT FK_PULPIT_FACULTY FOREIGN KEY(FACULTY)   REFERENCES FACULTY(FACULTY), 
 CONSTRAINT PK_PULPIT PRIMARY KEY(PULPIT) 
 ); 
 
delete PULPIT;  
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ИСиТ', 'Информационные системы и технологии', 'ФИТ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ПМиИ', 'Прикладная математика и информатика', 'ФИТ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ВМ',   'Высшая математика', 'ФМФ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ФМ',   'Физика и математика', 'ФМФ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ФХ',   'Физика и химия', 'ФМФ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('БЖД',  'Безопасность жизнедеятельности', 'ФГС');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ИС',   'Информационная безопасность и защита информации', 'ФГС');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ПП',   'Педагогика и психология', 'ФБИ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ИЯ',   'Иностранные языки', 'ФИЯ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('Линг', 'Лингвистика', 'ФИЯ');
-- Прочие:
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ПР',   'Правоведение', 'ФГС');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ЭК',   'Экономика и управление', 'ФЭФ');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('ФКиС', 'Физическая культура и спорт', 'ФГС');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY) values ('МПиЗ', 'Менеджмент, предпринимательство и занятость', 'ФЭФ');
 
------------------------------------------------------------------------------------------------------------------------        - DROP  TABLE TEACHER
CREATE TABLE TEACHER
 ( 
  TEACHER       CHAR(25) NOT  NULL,
  TEACHER_NAME  VARCHAR2(100), 
  PULPIT        CHAR(25) NOT NULL, 
  CONSTRAINT PK_TEACHER  PRIMARY KEY(TEACHER), 
  CONSTRAINT FK_TEACHER_PULPIT FOREIGN   KEY(PULPIT)   REFERENCES PULPIT(PULPIT)
 ) ;
 
 
delete  TEACHER;
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('ИВАНОВ', 'Иванов Сергей Владимирович', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('ПЕТРОВ', 'Петров Алексей Геннадьевич', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('СИДОР', 'Сидоренко Иван Павлович', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('СМИРН', 'Смирнов Олег Викторович', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('КУЗНЕЦ', 'Кузнецов Дмитрий Анатольевич', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('СЕРГЕЕ', 'Сергеева Наталья Юрьевна', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('ЛОГВИ', 'Логвинов Николай Иванович', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('МИХАЙЛ', 'Михайлова Елена Васильевна', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('ТАРАСО', 'Тарасов Петр Сергеевич', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('ФЕДОРО', 'Федоров Алексей Александрович', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('АНДРЕЕ', 'Андреев Игорь Евгеньевич', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('НИКОЛА', 'Николаев Владимир Ильич', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('ПАВЛОВ', 'Павлов Михаил Сергеевич', 'ИСиТ');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT) values ('БЕЛОВ',  'Белов Андрей Валерьевич', 'ИСиТ');

---------------------------------------------------------------------------------------------------------------------
-- DROP TABLE SUBJECT 
CREATE TABLE SUBJECT
    (
     SUBJECT      CHAR(25)     NOT NULL, 
     SUBJECT_NAME VARCHAR2(100)  NOT NULL,
     PULPIT       CHAR(25)     NOT NULL,  
     CONSTRAINT PK_SUBJECT PRIMARY KEY(SUBJECT),
     CONSTRAINT FK_SUBJECT_PULPIT FOREIGN  KEY(PULPIT)  REFERENCES PULPIT(PULPIT)
    );

delete SUBJECT;
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('БД', 'Базы данных', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('ОАиП', 'Основы алгоритмизации и программирования', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('ОП', 'Объектно-ориентированное программирование', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('СП', 'Системное программирование', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('СУБД', 'Системы управления базами данных', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('ОС', 'Операционные системы', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('КГ', 'Компьютерная графика', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('КС', 'Компьютерные сети', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('ИТ', 'Информационные технологии', 'ИСиТ');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) values ('ВЕБ', 'Web-программирование', 'ИСиТ');
  
---------------------------------------------------------------------------------------------------------------------
-- DROP TABLE AUDITORIUM_TYPE 
create table AUDITORIUM_TYPE 
(
  AUDITORIUM_TYPE   char(25) constraint AUDITORIUM_TYPE_PK  primary key,  
  AUDITORIUM_TYPENAME  varchar2(60) constraint AUDITORIUM_TYPENAME_NOT_NULL not null         
);

delete AUDITORIUM_TYPE;
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('ЛК', 'Лекционная аудитория');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('ПЗ', 'Практическое занятие');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('ЛБ', 'Лабораторная аудитория');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('К',  'Компьютерный класс');

---------------------------------------------------------------------------------------------------------------------
-- DROP TABLE AUDITORIUM 
create table AUDITORIUM 
(
 AUDITORIUM           char(25) primary key,  -- ��� ���������
 AUDITORIUM_NAME      varchar2(200),          -- ��������� 
 AUDITORIUM_CAPACITY  number(4),              -- �����������
 AUDITORIUM_TYPE      char(25) not null      -- ��� ���������
                      references AUDITORIUM_TYPE(AUDITORIUM_TYPE)  
);

delete  AUDITORIUM;
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('101', 'Аудитория 101', 60, 'ЛК');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('102', 'Аудитория 102', 30, 'ПЗ');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('103', 'Аудитория 103', 25, 'ЛБ');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('104', 'Аудитория 104', 20, 'К');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('201', 'Аудитория 201', 60, 'ЛК');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('202', 'Аудитория 202', 30, 'ПЗ');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('203', 'Аудитория 203', 25, 'ЛБ');
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values ('204', 'Аудитория 204', 20, 'К');

-----------------------------------------------------------------------------------------------------------------------







 