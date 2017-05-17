SELECT 'exec rdsadmin.rdsadmin_util.kill('||sid||','||serial#||');  -- ET: '||last_call_et
from v$session
where sql_id='&1' and status='ACTIVE'
order by last_call_et;
