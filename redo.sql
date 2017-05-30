set lines 140
set pages 500

break on thread# skip 1

set feed off

select thread#
     , group#
     , bytes/1024/1024 mbytes
     , members
     , archived
     , status
from   v$log
order by thread#
       , group#
/

col member for a60

select l.thread# 
     , lf.group#
     , lf.type
     , lf.member 
from   v$log l
       right outer join v$logfile lf
       on l.group# = lf.group#
order by l.thread#
       , lf.group#
/

prompt
prompt Time for Log Switches
prompt

SELECT SUM(CASE WHEN time_diff < 1/1440 THEN 1 ELSE 0 END) "<1 min"
     , SUM(CASE WHEN time_diff >=1/1440 AND time_diff < 2/1440 THEN 1 ELSE 0 END) "<2 min"
     , SUM(CASE WHEN time_diff >=2/1440 AND time_diff < 3/1440 THEN 1 ELSE 0 END) "<3 min"
     , SUM(CASE WHEN time_diff >=3/1440 AND time_diff < 4/1440 THEN 1 ELSE 0 END) "<4 min"
     , SUM(CASE WHEN time_diff >=4/1440 AND time_diff < 4/1440 THEN 1 ELSE 0 END) "<5 min"
     , SUM(CASE WHEN time_diff >=5/1440 AND time_diff < 10/1440 THEN 1 ELSE 0 END) "<10 min"
     , SUM(CASE WHEN time_diff >=10/1440 THEN 1 ELSE 0 END) ">10 min"
FROM (
        SELECT sequence#
             , thread#
             , first_time
             , first_time - LAG(first_time) OVER (ORDER BY sequence#) time_diff
          FROM gv$log_history
         WHERE TRUNC(first_time,'MON') = TRUNC(sysdate,'MON')
         ORDER BY sequence#
) WHERE time_diff IS NOT NULL
/

col day for a8
col "00" for 999
col "01" for 999
col "02" for 999
col "03" for 999
col "04" for 999
col "05" for 999
col "06" for 999
col "07" for 999
col "08" for 999
col "09" for 999
col "10" for 999
col "11" for 999
col "12" for 999
col "13" for 999
col "14" for 999
col "15" for 999
col "16" for 999
col "17" for 999
col "18" for 999
col "19" for 999
col "20" for 999
col "21" for 999
col "22" for 999
col "23" for 999

prompt
Prompt Table: Frequency of Log Switches by hour and day
prompt

SELECT TO_CHAR(FIRST_TIME, 'YY-MM-DD') DAY, 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'00',1,0)) "00", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'01',1,0)) "01", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'02',1,0)) "02", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'03',1,0)) "03", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'04',1,0)) "04", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'05',1,0)) "05", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'06',1,0)) "06", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'07',1,0)) "07", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'08',1,0)) "08", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'09',1,0)) "09", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'10',1,0)) "10", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'11',1,0)) "11", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'12',1,0)) "12", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'13',1,0)) "13", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'14',1,0)) "14", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'15',1,0)) "15", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'16',1,0)) "16", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'17',1,0)) "17", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'18',1,0)) "18", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'19',1,0)) "19", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'20',1,0)) "20", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'21',1,0)) "21", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'22',1,0)) "22", 
         SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'23',1,0)) "23" 
FROM     V$LOG_HISTORY 
GROUP BY TO_CHAR(FIRST_TIME, 'YY-MM-DD') 
order by 1;

set lines 250

prompt
Prompt Table: Transaction total (Millions) within Log Switches by hour and day
prompt

col "00" for 990.9
col "01" for 990.9
col "02" for 990.9
col "03" for 990.9
col "04" for 990.9
col "05" for 990.9
col "06" for 990.9
col "07" for 990.9
col "08" for 990.9
col "09" for 990.9
col "10" for 990.9
col "11" for 990.9
col "12" for 990.9
col "13" for 990.9
col "14" for 990.9
col "15" for 990.9
col "16" for 990.9
col "17" for 990.9
col "18" for 990.9
col "19" for 990.9
col "20" for 990.9
col "21" for 990.9
col "22" for 990.9
col "23" for 990.9

SELECT TO_CHAR(FIRST_TIME, 'YY-MM-DD') DAY, 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'00',(next_change#-first_change#)/1000000,0)),1) "00", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'01',(next_change#-first_change#)/1000000,0)),1) "01", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'02',(next_change#-first_change#)/1000000,0)),1) "02", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'03',(next_change#-first_change#)/1000000,0)),1) "03", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'04',(next_change#-first_change#)/1000000,0)),1) "04", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'05',(next_change#-first_change#)/1000000,0)),1) "05", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'06',(next_change#-first_change#)/1000000,0)),1) "06", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'07',(next_change#-first_change#)/1000000,0)),1) "07", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'08',(next_change#-first_change#)/1000000,0)),1) "08", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'09',(next_change#-first_change#)/1000000,0)),1) "09", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'10',(next_change#-first_change#)/1000000,0)),1) "10", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'11',(next_change#-first_change#)/1000000,0)),1) "11", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'12',(next_change#-first_change#)/1000000,0)),1) "12", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'13',(next_change#-first_change#)/1000000,0)),1) "13", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'14',(next_change#-first_change#)/1000000,0)),1) "14", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'15',(next_change#-first_change#)/1000000,0)),1) "15", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'16',(next_change#-first_change#)/1000000,0)),1) "16", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'17',(next_change#-first_change#)/1000000,0)),1) "17", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'18',(next_change#-first_change#)/1000000,0)),1) "18", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'19',(next_change#-first_change#)/1000000,0)),1) "19", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'20',(next_change#-first_change#)/1000000,0)),1) "20", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'21',(next_change#-first_change#)/1000000,0)),1) "21", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'22',(next_change#-first_change#)/1000000,0)),1) "22", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'23',(next_change#-first_change#)/1000000,0)),1) "23" 
FROM     V$LOG_HISTORY 
GROUP BY TO_CHAR(FIRST_TIME, 'YY-MM-DD') 
order by 1;

prompt
Prompt Table: Archived Log Size (Mb) by hour and day for min destination
prompt


SELECT TO_CHAR(FIRST_TIME, 'YY-MM-DD') DAY, 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'00',(blocks*block_size)/1024/1024/1024,0)),1) "00", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'01',(blocks*block_size)/1024/1024/1024,0)),1) "01", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'02',(blocks*block_size)/1024/1024/1024,0)),1) "02", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'03',(blocks*block_size)/1024/1024/1024,0)),1) "03", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'04',(blocks*block_size)/1024/1024/1024,0)),1) "04", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'05',(blocks*block_size)/1024/1024/1024,0)),1) "05", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'06',(blocks*block_size)/1024/1024/1024,0)),1) "06", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'07',(blocks*block_size)/1024/1024/1024,0)),1) "07", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'08',(blocks*block_size)/1024/1024/1024,0)),1) "08", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'09',(blocks*block_size)/1024/1024/1024,0)),1) "09", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'10',(blocks*block_size)/1024/1024/1024,0)),1) "10", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'11',(blocks*block_size)/1024/1024/1024,0)),1) "11", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'12',(blocks*block_size)/1024/1024/1024,0)),1) "12", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'13',(blocks*block_size)/1024/1024/1024,0)),1) "13", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'14',(blocks*block_size)/1024/1024/1024,0)),1) "14", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'15',(blocks*block_size)/1024/1024/1024,0)),1) "15", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'16',(blocks*block_size)/1024/1024/1024,0)),1) "16", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'17',(blocks*block_size)/1024/1024/1024,0)),1) "17", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'18',(blocks*block_size)/1024/1024/1024,0)),1) "18", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'19',(blocks*block_size)/1024/1024/1024,0)),1) "19", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'20',(blocks*block_size)/1024/1024/1024,0)),1) "20", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'21',(blocks*block_size)/1024/1024/1024,0)),1) "21", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'22',(blocks*block_size)/1024/1024/1024,0)),1) "22", 
         ROUND(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'),'23',(blocks*block_size)/1024/1024/1024,0)),1) "23" 
FROM     V$ARCHIVED_LOG
WHERE    dest_id = ( SELECT MIN(dest_id) FROM V$ARCHIVED_LOG )
GROUP BY TO_CHAR(FIRST_TIME, 'YY-MM-DD') 
order by 1;

set feed 5


