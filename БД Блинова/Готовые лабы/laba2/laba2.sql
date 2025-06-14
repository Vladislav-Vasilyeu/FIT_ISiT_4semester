ALTER SESSION SET "_oracle_script" = TRUE;
create tablespace TS_VVV
datafile 'C:\VVVFiles\TS_VVV.dbf'
size 7M
AUTOEXTEND on next 5M maxsize 30M;

create TEMPORARY tablespace TS_VVV_TEMP
tempfile 'C:\VVVFiles\TS_VVV_TEMP.dbf'
size 5M
AUTOEXTEND on next 3M maxsize 20M;

select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;

SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;

select TABLESPACE_NAME, FILE_NAME, STATUS from DBA_DATA_FILES
UNION
select TABLESPACE_NAME, FILE_NAME, STATUS from DBA_TEMP_FILES;

drop tablespace TS_VVV_TEMP



create ROLE RL_VVVCORE;
// переключение между cdb и pdb
//------------------------------------
show CON_NAME
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = FREEPDB1;
//------------------------------------

select * from DBA_SYS_PRIVS;
grant 
    create session,
    create table, alter any table, drop any table,
    create view, drop any view,
    create procedure, alter any procedure, drop any procedure
to RL_VVVCORE;

select * from DBA_SYS_PRIVS where GRANTEE = 'RL_VVVCORE';
select * from DBA_ROLES where ROLE like 'RL%';

create profile PF_VVVCORE limit
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;
    
select * from dba_profiles;
select * from dba_profiles where profile = 'PF_VVVCORE';
select * from dba_profiles where profile = 'DEFAULT';


// создание пользователя
//-------------------------------
create user VVVCORE
IDENTIFIED by "TempPass123"
DEFAULT TABLESPACE TS_VVV
TEMPORARY TABLESPACE TS_VVV_TEMP
PROFILE PF_VVVCORE
ACCOUNT UNLOCK;

alter user VVVCORE PASSWORD EXPIRE;

grant RL_VVVCORE to VVVCORE;

alter user VVVCORE QUOTA 2M on TS_VVV;

alter TABLESPACE TS_VVV offline;
alter TABLESPACE TS_VVV online;

select * from dictionary