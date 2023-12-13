insert into ydr_trand(id, tranid, invoicecircuitsid, circuitsid, calctype, cubedtype, periodanalog, maxlimit, invamount,
                      calgkind, netamount, vatpcnt, vatamount, totaldiscount, traderstransdid)

select nextval('seq_ydr_trand')   , ydrmetr."YdrMetrID", 23, 1, 1,1 , 1 , 0 ,"YdrMetrKatanal",
       1,"YdrMetrKatanal","YdrMetrPercFPAKatan","YdrMetrFPAKatan",0,null
from spata."YdrMetr" ydrmetr
         inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
         inner join ydr_consumers on ydr_consumers.id = ydrmetr."YdrMetrParoxID";



insert into ydr_trand(id, tranid, invoicecircuitsid, circuitsid, calctype, cubedtype, periodanalog, maxlimit, invamount,
                      calgkind, netamount, vatpcnt, vatamount, totaldiscount, traderstransdid)

select nextval('seq_ydr_trand')   , ydrmetr."YdrMetrID", 23, 2, 3,null , 1 , 0 ,"YdrMetrTaktikes",
       1,"YdrMetrTaktikes","YdrMetrPercFPAKatan","YdrMetrFPATaktikes",0,null
from spata."YdrMetr" ydrmetr
         inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
         inner join ydr_consumers on ydr_consumers.id = ydrmetr."YdrMetrParoxID";

-- select max(id) from ydr_trand ;
-- sELECT setval('seq_ydr_tran',1198306 , true);



select *
from ydr_invoicecircuits
where invoicedatesid=23

select *
from  spata."YdrMetr" ydrmetr
where "YdrMetrFPAKatan" >0
order by ydrmetr."YdrMetrID" desc



