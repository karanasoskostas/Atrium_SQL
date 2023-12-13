insert into  ydr_measures(id, measuresheaderid, hydrometerid, prevcountervalue, countervalue, countertype, status,
                          consumerid, datemetr, kind, direction, note,  createuserid, createdate, updateuserid, updatedate)

select nextval('seq_ydr_measures') ,
       164,
       ydr_consumers.hydrometerid,
       a.prohg,
       a.nea,
       1,
       2,
       ydr_consumers.id,
       to_date('01/08/2023','dd/mm/yyyy'),
       1,
       1,
       'IANIC ΜΕΤΑΠΤΩΣΗ',
       1,
       now(),
       1,
       now()

from spata.metr_imp  a inner join ydr_consumers on a.diadromh = ydr_consumers.routesortlist;

