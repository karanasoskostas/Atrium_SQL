-- create table save.ydr_metereplacements_20231013 as select * from ydr_metereplacements;
-- delete
-- from ydr_metereplacements;
insert into ydr_metereplacements(id, consumerid, newhydrometerid, ydrtrantypeid, datereplacement, initcountervalue,
                                 direction, prevhydrometerid, prevcountervalue, notes, createdate, createuserid,
                                 updatedate, updateuserid)

select nextval('seq_ydr_measures'),
       ydr_consumers.id,
       newydrometers.id,
       15,
       to_date(substring(a."Date of change",1,10),'yyyy-mm-dd'),
       a."New counter",
       1,
       ydr_hydrometers.id,
       a."Old counter",
       a."Comment",
       now(),
       1,
       now(),
       1
from change_ydrom.spata_allages a
         inner join ydr_consumers on a."Supply" = ydr_consumers.routesortlist
         inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
         inner join ydr_hydrometers newydrometers on a."New Serial number" = newydrometers.code
where to_char(cast(a."Date of change" as date), 'yyyymmdd') <= '20210430'
  and a."Supply" not in (select ydr_consumers.routesortlist
                         from ydr_consumers
                                  inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
                         where ydr_hydrometers.code like '8SEN%');
--   and not exists(select 1 from ydr_hydrometers h where h.code = newydrometers.code)




select *
from change_ydrom.spata_allages a;

select *
from ydr_metereplacements