delete from ydr_xrhsh;

insert into ydr_xrhsh(perxrhid, descr, isprofessional)
select YdrKatigKatanal."YdrKatKatanID",
       YdrKatigKatanal."YdrKatKatanDescr",
       0
from spata."YdrKatigKatanal" YdrKatigKatanal;

 select max(perxrhid) from ydr_xrhsh ;
sELECT setval('seq_ydr_xrhsh', 10, true);

