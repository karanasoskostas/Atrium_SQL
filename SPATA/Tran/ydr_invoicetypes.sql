insert into ydr_invoicetypes(id, companyid, descr, categoryid, active)
select ydrtimokat."YdrTimokatID",
       1,
       "YdrTimokatDescr",
       null,
       1
from spata."YdrTimokat" ydrtimokat
where ydrtimokat."YdrTimokatID" not in (select id from ydr_invoicetypes);

 select max(id) from ydr_invoicetypes ;
sELECT setval('seq_ydr_invoicetypes',13 , true);



