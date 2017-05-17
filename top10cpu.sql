set lines 180 pages 180 numw 10
col MIN_FIRST_TIME for a25

Prompt Top sql by elapsed per execution > 5seg executed only today (from SGA)
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
set lines 180 pages 180 numw 10
col MIN_FIRST_TIME for a25
select * from (
    select min(s.first_load_time) min_first_time
--           ,trunc(s.LAST_ACTIVE_TIME) dia
           ,s.sql_id
           ,plan_hash_value
           ,sum(s.executions) execs
           ,count(distinct s.plan_hash_value)    plan_cnt
           ,sum(s.buffer_gets)      GETS
           ,sum(s.cpu_time)         CPU
           ,round(sum(s.elapsed_time)/greatest(sum(s.executions),1)/1000000,2) ELAP_XEJE
           ,round(sum(s.disk_reads)/greatest(sum(s.executions),1),2)           reads_xeje
           ,round(sum(s.buffer_gets)/greatest(sum(s.executions),1),2)          GETS_XEJE
           ,round(sum(s.cpu_time)/greatest(sum(s.executions),1)/1000000,2)     cpu_xeje
           ,max(LAST_ACTIVE_TIME)
    from gv$sql s
    where s.elapsed_time/greatest(s.executions,1)/1000000>5
       and s.LAST_ACTIVE_TIME >= trunc(sysdate)
       --and s.LAST_ACTIVE_TIME >= sysdate-2/24
  --  group by trunc(s.LAST_ACTIVE_TIME), s.sql_id, s.plan_hash_value
    group by s.sql_id, s.plan_hash_value
    order by 8 desc
) where rownum < 10;


prompt Similar but all time
select * from (
select min(s.first_load_time) min_first_time
       ,s.sql_id
	   ,plan_hash_value
	   ,sum(s.executions) execs
	   ,count(distinct s.plan_hash_value)    plan_cnt
	   ,sum(s.buffer_gets)      GETS
	   ,sum(s.cpu_time)         CPU
       ,round(sum(s.elapsed_time)/greatest(sum(s.executions),1)/1000000,2) ELAP_XEJE
	   ,round(sum(s.disk_reads)/greatest(sum(s.executions),1),2)           reads_xeje
	   ,round(sum(s.buffer_gets)/greatest(sum(s.executions),1),2)          GETS_XEJE
       ,round(sum(s.cpu_time)/greatest(sum(s.executions),1)/1000000,2)     cpu_xeje
       ,max(LAST_ACTIVE_TIME)
from gv$sql s
where s.elapsed_time/greatest(s.executions,1)/1000000>5
group by s.sql_id, s.plan_hash_value
order by 8 desc
) where rownum < 10;

