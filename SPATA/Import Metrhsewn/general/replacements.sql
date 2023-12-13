insert into ydr_hydrometers(companyid, id, code, codedisplay, metertype, active, notes, createuserid, createdate,
                            updateuserid, updatedate)
select  1,
        nextval('seq_ydr_hydrometers'),
        a.ydrom,
        a.ydrom,
        2                   as metertype,
        1                   as active,
        'IANIC MIGRATION'   as notes,
        1                   as createuserid,
        now()               as createdate,
        1                   as updateuserid,
        now()               as updatedate
from spata.metr_imp  a inner join ydr_consumers on a.diadromh = ydr_consumers.routesortlist
where a.ydrom like '8SEN%'
and not exists ( select 1 from ydr_hydrometers where code = a.ydrom)
;

insert into ydr_metereplacements(id, consumerid, newhydrometerid, ydrtrantypeid, datereplacement, initcountervalue, direction, prevhydrometerid, prevcountervalue,
                                 notes, createdate, createuserid, updatedate, updateuserid)
select nextval('seq_ydr_metereplacements'),
       ydr_consumers.id,
       (select b.id
        from spata.metr_imp a
                 inner join ydr_hydrometers b on a.ydrom = b.code
        where a.diadromh = ydr_consumers.routesortlist
        and b.code like '8SEN%'),
       15,
       to_date('01/06/2023','dd/mm/yyyy'),
       a.nea,
       1,
       ydr_consumers.hydrometerid,
       a.prohg,
       'IANIC MIGRATION'   as notes,
       cast(now() as date)               as createdate,
       1                   as createuserid,
       cast(now() as date)               as updatedate,
       1                   as updateuserid
from spata.metr_imp  a inner join ydr_consumers on a.diadromh = ydr_consumers.routesortlist
where a.ydrom like '8SEN%';

update ydr_consumers
set hydrometerid =
       (select b.id
        from spata.metr_imp a
                 inner join ydr_hydrometers b on a.ydrom = b.code
        where a.diadromh = ydr_consumers.routesortlist
        and b.code like '8SEN%')
where routesortlist in (select a.diadromh from spata.metr_imp a)
and  (select b.id
        from spata.metr_imp a
                 inner join ydr_hydrometers b on a.ydrom = b.code
        where a.diadromh = ydr_consumers.routesortlist
        and b.code like '8SEN%') is not null ;