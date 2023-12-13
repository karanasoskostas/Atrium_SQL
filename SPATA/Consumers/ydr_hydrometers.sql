
delete from ydr_hydrometers;

drop index ydr_meters_index_1;

insert into ydr_hydrometers(companyid, id, code, codedisplay, metertype, active, notes, createuserid, createdate,
                            updateuserid, updatedate)
select 1                   as companyid,
       ydrmain."YdrID"     as id,
        case coalesce(trim(ydrmain."YdrArYdrom"),'')
           when '' then cast(ydrmain."YdrID" as varchar)
           when null then cast(ydrmain."YdrID" as varchar)
           else coalesce(trim(ydrmain."YdrArYdrom"),'')
           end     as code,
              case coalesce(trim(ydrmain."YdrArYdrom"),'')
           when '' then cast(ydrmain."YdrID" as varchar)
           when null then cast(ydrmain."YdrID" as varchar)
           else coalesce(trim(ydrmain."YdrArYdrom"),'')
           end   as codedisplay,
       1                   as metertype,
       1                   as active,
       'IANIC MIGRATION'   as notes,
       1                   as createuserid,
       now()               as createdate,
       1                   as updateuserid,
       now()               as updatedate

from spata."YdrMain" ydrmain
;

 select max(id) from ydr_hydrometers ;
sELECT setval('seq_ydr_hydrometers',30629 , true);

update ydr_hydrometers
set code = code || cast(id as varchar)
where code <> cast(id as varchar)
and code in (select code
             from (select code, count(*) cnt
                   from ydr_hydrometers
                   group by code
                   having count(*) > 1) tmp)

create unique index ydr_meters_index_1 on ydr_hydrometers(code);


update  ydr_hydrometers
set metertype = 3
where code like '8SEN%';