show sga

SELECT component, granule_size 
FROM v$sga_dynamic_components;

SELECT pool, name, bytes 
FROM v$sgastat 
WHERE name = 'free memory';

SELECT 
  name,
  value / 1024 / 1024 AS value_mb
FROM 
  v$parameter
WHERE 
  name IN ('sga_target', 'sga_max_size');

SELECT 
  name AS pool_name,
  block_size,
  buffers,
  buffers * block_size / 1024 / 1024 AS size_mb
FROM 
  v$buffer_pool;

SELECT 
  name, 
  value / 1024 / 1024 AS size_mb 
FROM 
  v$parameter 
WHERE 
  name = 'db_keep_cache_size';

ALTER SYSTEM SET db_keep_cache_size = 50M SCOPE=BOTH;


CREATE TABLE test_keep_table (
  id NUMBER,
  name VARCHAR2(100)
)
STORAGE (BUFFER_POOL KEEP);

INSERT INTO test_keep_table 
SELECT level, 'Name_' || level 
FROM dual 
CONNECT BY level <= 1000;

COMMIT;

SELECT 
  segment_name, 
  segment_type, 
  tablespace_name, 
  buffer_pool 
FROM 
  dba_segments 
WHERE 
  segment_name = 'TEST_KEEP_TABLE';

CREATE TABLE test_default_table (
  id NUMBER,
  title VARCHAR2(100)
)
STORAGE (BUFFER_POOL DEFAULT);

INSERT INTO test_default_table
SELECT level, 'Title_' || level
FROM dual
CONNECT BY level <= 1000;

COMMIT;

SELECT 
  segment_name, 
  segment_type, 
  tablespace_name, 
  buffer_pool 
FROM 
  dba_segments 
WHERE 
  segment_name = 'TEST_DEFAULT_TABLE';

SELECT 
  name, 
  value, 
  value / 1024 AS size_kb, 
  value / 1024 / 1024 AS size_mb
FROM 
  v$parameter 
WHERE 
  name = 'log_buffer';

SELECT 
    pool,
  name, 
  bytes, 
  bytes / 1024 AS size_kb, 
  bytes / 1024 / 1024 AS size_mb
FROM 
  v$sgastat
WHERE 
  pool = 'large pool' 
  AND name = 'free memory';
  
  SELECT 
  SID,
  SERVER
FROM 
  v$session;

SELECT 
  spid, 
  pname, 
  background
FROM 
  v$process
WHERE 
  background = 1;
  
  SELECT 
  SID,
  SERIAL#,
  USERNAME,
  PROGRAM,
  SERVER
FROM 
  v$session
WHERE 
  SERVER = 'DEDICATED';


SELECT 
  COUNT(*) AS dbw_process_count
FROM 
  v$process
WHERE 
  pname LIKE 'DBW%';

SELECT 
  name,
  network_name,
  pdb
FROM 
  v$services;



SELECT 
  *
FROM 
  v$dispatcher;


