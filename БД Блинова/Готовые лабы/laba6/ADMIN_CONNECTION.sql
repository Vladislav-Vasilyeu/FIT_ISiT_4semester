SHOW PARAMETER spfile;

CREATE PFILE = 'C:\app\vasil\product\23ai\dbhomeFree\database\VVV_PFILE.ORA' FROM SPFILE;

CREATE SPFILE='C:\app\vasil\product\23ai\dbhomeFree\database\custom_spfile.ora' FROM PFILE='C:\app\vasil\product\23ai\dbhomeFree\database\VVV_PFILE.ORA';


SHOW PARAMETER open_cursors;

ALTER SYSTEM SET open_cursors=300 SCOPE=SPFILE;

SHOW PARAMETER control_files;

SELECT * FROM V$PASSWORDFILE_INFO;

SELECT * FROM V$DIAG_INFO;
