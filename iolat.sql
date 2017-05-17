prompt last minute value only
col name for a25
select m.inst_id, /*m.intsize_csec, */
       n.name ,
       round(m.time_waited,3) time_waited,
       m.wait_count,
       round(10*m.time_waited/nullif(m.wait_count,0),3) avgms
from gv$eventmetric m,
     gv$event_name n
where m.inst_id=n.inst_id and m.event_id=n.event_id
  and n.name in (
                  'db file sequential read',
                  'db file scattered read',
                  'direct path read',
                  'direct path read temp',
                  'direct path write',
                  'direct path write temp',
                  'log file sync',
                  'log file parallel write'
)
order by m.inst_id, n.name
/
