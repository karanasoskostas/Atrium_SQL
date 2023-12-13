drop index ind_trader_1;
delete from tradersglacc;
delete from traders;
delete from traderaddresses;

insert into traders(id, vatnumber, individual, fullname, idnumber, lastname, fistname, fathername, mothername, birthday,
                    countryid, doyid, vatkid, aadenofpacategid, kepyo, kepyocateg, gengov, job, phones, mobile, email,
                    responsible, notes, active, createuserid, createdate, updateuserid, updatedate)
select "OikOfeilID"                               as id,
       case coalesce(trim(oikofeil."OikOfeilAFM"),'')
           when '' then cast("OikOfeilID" as varchar)
           when null then cast("OikOfeilID" as varchar)
           else trim(oikofeil."OikOfeilAFM")
           end                                    as vatnumber,
       0                                          as individual,
       trim("OikOfeilEponymia")                   as fullname,
       trim("OikOfeilADT")                        as idnumber,
       trim("OikOfeilEponymo")                    as lastname,
       trim("OikOfeilOnoma")                      as fistname,
       trim("OikOfeilFather")                     as fathername,
       trim("OikOfeilMother")                     as mothername,
       null                                       as birthday,
       88                                         as countryid,
       case taxauthority.code
           when null then 1
           else taxauthority.doyid
           end                                    as doyid,
       1                                          as vatkid,
       null                                       as aadenofpacategid,
       0                                          as kepyo,
       null                                       as kepyocateg,
       0                                          as gengov,
       trim(oikjob."OikJobDescr")                 as job,
       trim("OikOfeilTelephon")                   as phones,
       trim("OikOfeil_Mobile")                    as mobile,
       trim("OikOfeilEmail")                      as email,
       null                                       as responsible,
       trim(substring("OikOfeilSxolia", 1, 2000)) as notes,
       1                                          as active,
       1                                          as createuserid,
       now()                                      as createdate,
       1                                          as updateuserid,
       now()                                      as updatedate

from spata."OikOfeil" oikofeil
         left join spata."OikDoy" oikodoy on oikofeil."OikOfeilDoyID" = oikodoy."OikDoyID"
         left join taxauthority on taxauthority.code = oikodoy."OikDoyCode"
         left join spata."OikJob" oikjob on oikjob."OikJobID" = oikofeil."OikOfeilJobID";


insert into traders(id, vatnumber, individual, fullname,  kepyo,  gengov, active, createuserid,  updateuserid)
values(0,'0',1,'ΧΩΡΙΣ ΣΥΝΑΛΛΑΣΟΜΕΝΟ',1,1,1,1,1);


 select max(id) from traders ;
sELECT setval('seq_traders',168725 , true);


insert into traderaddresses(id, traderid, addessdescr, addresstype, mainaddress, fulladdress, street, streetnumber,
                            zipcode, area, city, state, countryid, active, createuserid, createdate, updateuserid,
                            updatedate)
select nextval('seq_traderaddresses')             as id,
       "OikOfeilID"                               as traderid,
       trim("OikOfeilAddress")                    as addessdescr,
       1                                          as addresstype,
       1                                          as mainaddress,
       coalesce(trim("OikOfeilAddress"), '') || ' ' || coalesce(trim("OikOfeilZip"), '') || ' ' ||
       coalesce(trim(oikpoli."OikPoliDescr"), '') as fulladdress,
       null                                       as street,
       null                                       as streetnumber,
       trim(coalesce("OikOfeilZip", ''))          as zipcode,
       null                                       as area,
       trim(coalesce(oikpoli."OikPoliDescr", '')) as city,
       null                                       as state,
       88                                         as countryid,
       1                                          as active,
       1                                          as createuserid,
       now()                                      as createdate,
       1                                          as updateuserid,
       now()                                      as updatedate

from spata."OikOfeil" oikofeil
         left join spata."OikPoli" oikpoli on oikofeil."OikOfeilPoliID" = oikpoli."OikPoliID";


insert into tradersglacc(id,companyid,moduleid , traderid)
select nextval('seq_tradersglacc')         as id,
       1                                   as companyid,
       1000                                as moduleid,
       id                                  as traderid
from traders;
