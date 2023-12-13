-- create table save.ydr_hydrometers_20231013 as select * from ydr_hydrometers;

-- alter table change_ydrom.spata_allages add id numeric;

-- update change_ydrom.spata_allages a
--     set id = nextval('seq_ydr_metereplacements');

-- TA ΥΔΡΟΜΕΤΡΑ ΜΕ ID > 31359 ΕΙΝΑι ΑΠΟ ΤΙΣ ΑΝΤΙΚΑΤΑΣΤΑΣΕΙΣ
insert into ydr_hydrometers(companyid, id, code, codedisplay, metertype, manufacturer, manufacturyear, firstinstalldate, active, notes, createuserid, createdate, updateuserid, updatedate)
select 1 ,
       nextval('seq_ydr_hydrometers'),

       a."New Serial number",
       a."New Serial number",
       2,
       a."Type" ,
       null,
       to_date(substring(a."Date of change",1,10),'yyyy-mm-dd'),
       1,
       a."Comment",
       1,
       now(),
       1,
       now()

from change_ydrom.spata_allages a
         inner join ydr_consumers on a."Supply" = ydr_consumers.routesortlist
         inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id

where to_char(cast(a."Date of change" as date), 'yyyymmdd') <= '20210430'
  and a."Supply" not in (select ydr_consumers.routesortlist
                         from ydr_consumers
                                  inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
                         where ydr_hydrometers.code like '8SEN%')
and not exists(select 1 from ydr_hydrometers h where h.code = a."New Serial number")
and a."New Serial number" is not null
and a.id = (select max(b.id)
            from change_ydrom.spata_allages b
            where b."New Serial number" = a."New Serial number");


-- select max(id)
-- from ydr_hydrometers
-- where code like '8S%'
--
-- select a."New Serial number", count(*)
-- from change_ydrom.spata_allages a
-- where a."New Serial number" is not null
--
-- group by a."New Serial number"
-- having count(*) >1
--
-- select row_number() over (order by a."Area")
-- from change_ydrom.spata_allages a