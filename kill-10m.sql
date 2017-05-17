prompt execute the following to kill sessions that have been running for more than 10 minutes:
SELECT  '-- SQL: '||sql_id||' ET: '||last_call_et||' '||substr(osuser,1,10)||'@'||machine||' 
exec rdsadmin.rdsadmin_util.kill('||sid||','||serial#||');'
from v$session
where status='ACTIVE' and type = 'USER' and last_call_et>600
order by last_call_et;

Prompt sessions already killed, forcing to disconnect them:
SELECT  'exec rdsadmin.rdsadmin_util.disconnect('||sid||','||serial#||');'
from v$session
where status='KILLED' and type = 'USER'
order by last_call_et; 
