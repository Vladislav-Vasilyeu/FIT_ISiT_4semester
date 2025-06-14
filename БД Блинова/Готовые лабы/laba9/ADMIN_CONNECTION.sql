show CON_NAME
alter session set container = labspdb

create user VVV identified by 12345678
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED on users

grant create session to VVV;
grant create table to VVV;
grant create view to VVV;
grant create PROCEDURE to VVV;
grant UNLIMITED TABLESPACE to VVV;
grant create SEQUENCE to VVV
grant create CLUSTER to VVV
GRANT CREATE SYNONYM TO VVV
GRANT CREATE PUBLIC SYNONYM TO VVV
GRANT CREATE MATERIALIZED VIEW TO VVV
GRANT QUERY REWRITE TO VVV
SELECT * FROM PUB_SYN;
GRANT CREATE DATABASE LINK TO VVV