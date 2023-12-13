delete from ydr_address;

insert into ydr_address(id, descr, tk, town_pydra, area_pydra)
select ydrmain."YdrID",
       ydrmain."YdrParoxOdos",
       ydrmain."YdrParoxTK",
       'ΣΠΑΤΑ',
       ydrperiox."YdrPerioxDescr"
from spata."YdrMain" ydrmain left join spata."YdrPeriox" ydrperiox on (ydrmain."YdrParoxPerioxID" = ydrperiox."YdrPerioxID");


 select max(id) from ydr_address ;
sELECT setval('seq_ydr_address', 30629, true);