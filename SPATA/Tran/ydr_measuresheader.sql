delete from ydr_measuresheader;

insert into ydr_measuresheader(id, companyid, dateref, circuitid, metrkindid, katametrid, usernote, note, datefrom, dateto, dateend)
select ydr_periods.id,
       1,
       coalesce(min("YdrMetrHmMetr"),ydr_periods.datefrom),
       1,
       1,
       1,
       ydr_periods.descr,
       ydr_periods.descr,
       ydr_periods.datefrom,
       ydr_periods.dateto,
       ydr_periods.dateto
from spata."YdrMetr" ydrmetr inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
group by ydr_periods.id,
       ydr_periods.descr,
       ydr_periods.descr,
       ydr_periods.datefrom,
       ydr_periods.dateto,
       ydr_periods.dateto
;

 select max(id) from ydr_measuresheader ;
sELECT setval('seq_ydr_measuresheader',158 , true);

select *
from ydr_measuresheader