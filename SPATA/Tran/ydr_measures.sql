delete from ydr_measures;

insert into ydr_measures(id, measuresheaderid, hydrometerid, prevcountervalue, countervalue, countertype, status, operatorlatitude, operatorlongitude, smartvilleid, consumerid, datemetr, kind, direction, note, latitude, longitude, createuserid, createdate, updateuserid, updatedate, extraconsumption)
select "YdrMetrID",
       ydr_periods.id,
       "YdrMetrParoxID",
       "YdrMetrPrevious",
       "YdrMetrLast",
       1,
       3,
       null,
       null,
       null,
       "YdrMetrParoxID",
       coalesce("YdrMetrHmMetr",ydr_periods.datefrom),
       1,
       1,
       'IANIC ΜΕΤΑΠΤΩΣΗ',
       null,
       null,
       1,
       now(),
       1,
       now(),
       0
from spata."YdrMetr" ydrmetr inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id);

 select max(id) from ydr_measures ;
sELECT setval('seq_ydr_measures',1198306 , true);

