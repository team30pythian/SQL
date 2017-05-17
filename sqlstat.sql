set long 10000
select sql_fulltext from v$sqlarea where sql_id='&1';

select child_number, bind_mismatch, ROLL_INVALID_MISMATCH, reason
from V$SQL_SHARED_CURSOR
where CHILD_ADDRESS in 
   (select child_address from v$sql 
    where sql_id='&&1')
order by 1;

prompt pause to display plans next, cancel if you don't want that

pause;

select * from table(dbms_xplan.display_cursor('&&1',null, 'outline peeked_binds'));
