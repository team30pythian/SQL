set lines 140
set pages 500
set verify off

col os_user for a12
col oracle_user for a20
col oracle_sid for a15
col f_ground for a10
col b_ground for a10
col sql_id for a15

SELECT nvl(S.OSUSER,S.type)  OS_User,
       S.USERNAME            Oracle_User,
       S.sid||','||S.serial# Oracle_SID,
       S.process             F_Ground,
       P.spid                B_Ground,
       s.status,
       s.sql_id
FROM   V$SESSION S,
       V$PROCESS P
WHERE  nvl(upper(S.OSUSER),'?')   like nvl(upper('&OS_User'),'%')
And    nvl(upper(S.Username),'?') like nvl(upper('&Oracle_User'),'%')
And    s.paddr  = p.addr
order  by s.sid
/

