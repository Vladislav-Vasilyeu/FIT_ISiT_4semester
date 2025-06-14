show con_name
ALTER SESSION SET CONTAINER=VVV_PDB;
ALTER SESSION SET CONTAINER=CDB$ROOT;

SELECT tablespace_name, status
FROM dba_tablespaces;

CREATE TABLESPACE VVV_QDATA 
DATAFILE 'C:/VVVFiles/VVV_QDATA.dbf' 
SIZE 10M 
OFFLINE;

ALTER TABLESPACE VVV_QDATA ONLINE;

drop TABLESPACE VVV_QDATA

create user VVV IDENTIFIED BY Vlad060606
DEFAULT TABLESPACE VVV_QDATA

ALTER USER VVV QUOTA 2M ON VVV_QDATA;

grant create session to VVV
grant create table to VVV

SELECT segment_name, segment_type, bytes / 1024 / 1024 AS size_mb
FROM dba_segments
WHERE tablespace_name = 'VVV_QDATA';

drop table VVV_QDATA.VVV_T1


SELECT 
    segment_name,
    COUNT(*) AS extent_count,
    SUM(bytes) / 1024 AS size_kb,
    SUM(bytes) AS size_bytes,
    SUM(bytes) / (SELECT value FROM v$parameter WHERE name = 'db_block_size') AS size_blocks
FROM 
    dba_extents
WHERE 
    segment_name = 'VVV_T1'
GROUP BY 
    segment_name;

SELECT 
    segment_name,
    segment_type,
    tablespace_name,
    extent_id,
    bytes / 1024 AS size_kb,
    block_id
FROM 
    dba_extents
ORDER BY 
    segment_name, extent_id;

SELECT ROWID, 
FROM VVV_PDB.VVV_T1 
WHERE ROWNUM <= 10; 