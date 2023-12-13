truncate table  ydr_measures cascade ;
truncate table  ydr_measuresheader cascade ;

insert into ydr_measures(id, measuresheaderid, consumerid, nea,  direction, ydrometro, kind, note, createuserid, createdate, updateuserid, updatedate, datemetr)
select ydr_ftran_h.id ,
       ydr_ftran_h.rtr_etos * ydr_ftran_h.rtr_trim,
       rtr_maa,
       rtr_nea,
       1,
       rtr_ydrom,
       1,
       'ΜΕΤΑΠΤΩΣΗ',
       1,
       now(),
       1,
       now(),
       rtr_date_orist
from ydr_ftran_h
where exists ( select 1 from ydr_consumers where rtr_maa = ydr_consumers.id);

insert into ydr_measuresheader(id, companyid, dateref, circuitid, metrkindid, katametrid, usernote, note)
select ydr_ftran_h.rtr_etos * ydr_ftran_h.rtr_trim ,
       1,
       max(rtr_date_orist) ,
       1,
       99,
       1 ,
       'ΜΕΤΑΠΤΩΣΗ',
       'ΠΕΡΙΟΔΟΣ '||cast(rtr_trim as varchar)||'/'||cast(rtr_etos as varchar)||'  (ΜΕΤΑΠΤΩΣΗ)'
from ydr_ftran_h
where exists ( select 1 from ydr_consumers where rtr_maa = ydr_consumers.id)
group by ydr_ftran_h.rtr_etos , ydr_ftran_h.rtr_trim;

update ydr_measuresheader
set dateref = ( select max(datemetr) from ydr_measures where ydr_measures.measuresheaderid = ydr_measuresheader.id);

insert into ydr_invoicetypes(id, companyid, descr, active)
select id, companyid, descr, 1
    from ydr_pertim;

insert into ydr_invpolicies(id, companyid, descr, invoicetypeid,  active, createuserid, createdate, updateuserid, updatedate)
select id, companyid, descr , id , 1,1,now(),1,now()
from ydr_invoicetypes;

select * from ydr_invoicetypes
