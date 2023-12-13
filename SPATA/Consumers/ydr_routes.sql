delete from ydr_routes;

insert into ydr_routes(companyid, id, code, descr, active)
select 1 ,
       "YdrDiadromID",
       cast("YdrDiadromID" as varchar),
       trim("YdrDiadromDescr"),
       "IsEnabled"
from spata."YdrDiadrom";



 select max(id) from ydr_routes ;
sELECT setval('seq_ydr_routes',41 , true);