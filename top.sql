col event for a35
col username for a16
set lines 180 pages 180

select count(1), state, status
from v$session 
where type = 'USER'  
group by state, status
order by 2;

prompt Active queries waiting:
select event, sql_id, username, count(*), avg(last_call_et), max(last_call_et)
from v$session 
where status='ACTIVE' and type = 'USER' 
group by event , sql_id, username
order by count(*), event, max(last_call_et);

prompt Only top 10 long running queries:
select * from (
    select event, sql_id, username, last_call_et, sid, serial#
    from v$session 
    where status='ACTIVE' and type = 'USER' 
    order by last_call_et desc, event, sql_id
) where rownum<10;
