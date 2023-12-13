delete from ydr_tran;

insert into traders(id, vatnumber, individual, fullname,  kepyo,  gengov, active, createuserid, createdate, updateuserid, updatedate)
select distinct ydrmetr."YdrMetrYpoxrID",
       cast(ydrmetr."YdrMetrYpoxrID" as varchar),
       1,
       'ΑΓΝΩΣΤΟΣ ΣΥΝΑΛΛΑΣΟΜΕΝΟΣ',
       0,
       0,
       1,
       1,
       now(),
       1,
       now()
from spata."YdrMetr" ydrmetr inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
where ydrmetr."YdrMetrYpoxrID" not in ( select id from traders);


insert into ydr_tran(id, reltranid, trantypeid, invpoliciesid, invoicedatesid, invoicetypesid, daysuntilend, bonusdays,
                     envtax, resourcetax, minimumconsuption, perdatefrom, perdateto, measuredate, prevcountervalue,
                     currcountervalue, consumption, extraconsumption, debtconsumption, istran, trandate, tranuserid,
                     createuserid, createdate, calcuserid, calcdate, mtranid, measuresid, direction, invoiceanalogy,
                     dataentryconsumption, ownerid, liableid, discpoliciesdatesid, statusid, xrhshid, diamagogid,
                     deiktapoid, invpolicydiscid, periodagainstsid, againstcalcway, againstcalcperiod, againsperiodnr,
                     confirmdate, tradertransid)

select ydrmetr."YdrMetrID",  null, 1, 1,    23,  1,  0,  0,
       0,   0,        0,            "YdrMetrApo",  "YdrMetrEos",  "YdrMetrHmMetr", "YdrMetrPrevious",
       "YdrMetrLast", "YdrMetrDiaf", 0, "YdrMetrDiaf", 1, "YdrMetrEos", 1,
       1, now(), 1, "YdrMetrEos", ydrmetr."YdrMetrID", ydrmetr."YdrMetrID", 1, 1,
       0, "YdrMetrIdioktID", "YdrMetrYpoxrID", null, ydr_consumers.statusid, ydr_consumers.xrhshid, ydr_consumers.diamagogid,
       ydr_consumers.deikthsapoxid, 1, null, null, null,null,
       "YdrMetrEos", null
from spata."YdrMetr" ydrmetr
         inner join ydr_periods on (ydrmetr."YdrMetrPerID" = ydr_periods.id)
         inner join ydr_consumers on ydr_consumers.id = ydrmetr."YdrMetrParoxID";


select max(id) from ydr_tran ;
sELECT setval('seq_ydr_tran',1198306 , true);




select *
from ydr_tran



