SPO repo_edb360_drop_log.txt;
EXEC DBMS_APPLICATION_INFO.SET_MODULE('EDB360','DROP');
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET ECHO ON VER ON TIM ON TIMI ON LONG 32000000 LONGC 2000 PAGES 1000 LIN 1000 TRIMS ON SERVEROUT ON; 

-- prefix for eadam3 tables
DEF tool_prefix_0 = 'eadam3#';
-- prefix for AWR "dba_hist_" views
DEF tool_prefix_1 = 'dba_hist#';
-- prefix for data dictionary "dba_" views
DEF tool_prefix_2 = 'dba#';
-- prefix for dynamic "gv$" views
DEF tool_prefix_3 = 'gv#';
-- prefix for dynamic "v$" views
DEF tool_prefix_4 = 'v#';

-- list of repository owners
SELECT owner, COUNT(*) tables FROM dba_tables WHERE (table_name LIKE UPPER('&&tool_prefix_0.')||'%' OR table_name LIKE UPPER('&&tool_prefix_1.')||'%' OR table_name LIKE UPPER('&&tool_prefix_2.')||'%' OR table_name LIKE UPPER('&&tool_prefix_3.')||'%' OR table_name LIKE UPPER('&&tool_prefix_4.')||'%') GROUP BY owner;

-- parameter
ACC tool_repo_user PROMPT 'tool repository user: '

------------------------------------------------------------------------------------------
-- repository tables
------------------------------------------------------------------------------------------

DECLARE
  PROCEDURE execute_immediate (p_dynamyc_string IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_dynamyc_string);
    EXECUTE IMMEDIATE p_dynamyc_string;
  END execute_immediate;
BEGIN
  FOR i IN (SELECT owner, table_name FROM dba_tables WHERE owner = UPPER('&&tool_repo_user.') AND (table_name LIKE UPPER('&&tool_prefix_0.%') OR table_name LIKE UPPER('&&tool_prefix_1.%') OR table_name LIKE UPPER('&&tool_prefix_2.%') OR table_name LIKE UPPER('&&tool_prefix_3.%') OR table_name LIKE UPPER('&&tool_prefix_4.%')) ORDER BY table_name)
  LOOP
    execute_immediate('DROP TABLE '||i.owner||'.'||i.table_name);
  END LOOP;
END;
/

SPO OFF;
WHENEVER SQLERROR CONTINUE;
EXEC DBMS_APPLICATION_INFO.SET_MODULE(NULL,NULL);
