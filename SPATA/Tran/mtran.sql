delete from ydr_mtran;

insert into ydr_mtran(id, periodid, consumerid, prevperiodid, prevlogperiodid, prevcountervalue, currcountervalue)
select ydrmetr."YdrMetrID",
       ydr_periods.id,
       ydrmetr."YdrMetrParoxID",
       2
           as prevperiodid,
       2,
       ydrmetr."YdrMetrPrevious",
       ydrmetr."cYdrMetrLast"
from spata."YdrMetr" ydrmetr inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
;

select max(id) from ydr_mtran ;
sELECT setval('seq_ydr_mtran',1198306 , true);
