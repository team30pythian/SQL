set lines 140
set pages 60
set verify off

col file_name for a50
accept TS_NAME prompt "Enter Tablespace Name : "

break on report;
compute sum of bytes on report;

select file_id , file_name , bytes/1024/1024 bytes from dba_data_files where tablespace_name = UPPER('&TS_NAME')
union
select file_id , file_name , bytes/1024/1024 bytes from dba_temp_files where tablespace_name = UPPER('&TS_NAME')
order by file_id
;


select a.total_mbytes 
     , a.total_mbytes - b.free_mbytes used_mbytes
     , b.free_mbytes 
     , round((b.free_mbytes / a.total_mbytes)*100) pct_free
from (
	select sum(bytes/1024)/1024 total_mbytes
	from   dba_data_files df
	where  tablespace_name = UPPER('&TS_NAME') 
     ) a
   , (
        select sum(bytes/1024)/1024 free_mbytes
        from   dba_free_space fs
        where  tablespace_name = UPPER('&TS_NAME')
     ) b
/

