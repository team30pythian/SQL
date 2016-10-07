set long 800000
set pages 600
column osuser format a7 heading "UxUser"
column host format a6 heading "Host"
column program format a32 heading "Program"
column orauser format a7 heading "OraUser"
column status format a8 heading "Status"
column command format a75 heading "Command"
select
                ses.osuser osuser,
                ses.sid sid,
                ses.serial# serial,
                ses.machine host,
                ses.terminal terminal,
                ses.program program,
                ses.username orauser,
                ses.status,
                sql.sql_fulltext command,
                sql.disk_reads,
                sql.buffer_gets,
                sql.rows_processed,
                sql.sql_id,
                sql.child_number
from    v$session ses, v$sql sql
where   ses.sql_address = sql.address (+)
and     ses.sql_hash_value = sql.hash_value (+)
and     ses.sql_child_number = sql.child_number (+)
and     ses.sid = &sid
/

