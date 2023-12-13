delete from ydr_tranx;

insert into ydr_tranx(id, tranid, perxreid, netamount, vatpcnt, vatamount, traderstransdid)
select nextval('seq_ydr_tranx')   , ydrmetr."YdrMetrID", 1, "YdrMetrEktaktes" , 0,0,null
from spata."YdrMetr" ydrmetr
         inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
         inner join ydr_consumers on ydr_consumers.id = ydrmetr."YdrMetrParoxID"
where "YdrMetrEktaktes" >0;






