delete
from ydr_consumers;


insert into ydr_consumers(id, code, companyid, routeid, routesortlist, hydrometerid, comcounter, sectorid, ownerid,
                          liableid, receiverid,
                          addressid, addrno1, comments,
                          xrhshid,
                          aposlog,
                          epidaddress, epidar, epidpolh, epidtk, epidperioxh,
                          statusid, createuserid, createdate, updateuserid, updatedate, active,
                          tokoixreosi, manual,
                          departmentid, areaid, direction, printnote,periodicityid)
select ydrmain."YdrID"                                       as id,
       coalesce(trim("YdrParoxi"), cast("YdrID" as varchar)) as code,
       1                                                     as companyid,
       ydrmain."YdrDiadromID"                                as routeid,
       null                                                  as routesortlist,
       ydrmain."YdrID"                                       as hydrometerid,
       1                                                     as comcounter,
       1                                                     as sectorid,
       coalesce(ydrmain."YdrIdioktID", 0)                    as ownerid,
       coalesce(ydrmain."YpoxrID", 0)                        as liableid,
       coalesce(ydrmain."YpoxrID", 0)                        as recieverid,
       ydrmain."YdrID"                                       as addressid,
       ydrmain."YdrParoxNumber"                              as addrno1,
       substring(trim("YdrSxolia"),1,1000)                   as comments,
       ydrmain."YdrKatigID"                                  as xrhshid,
       4                                                     as aposlog,
       trim("YdrDiefEidop")                                  as epidaddress,
       null                                                  as epidar,
       trim(oikpoli."OikPoliDescr")                          as epidpolh,
       trim(ydrmain."YdrDiefZip")                            as epidtk,
       null                                                  as epidperioxh,
       coalesce("YdrStatusID", 1)                            as statusid,
       1                                                     as createuserid,
       now()                                                 as createdate,
       1                                                     as updateuserid,
       now()                                                 as updatedate,
       1                                                     as active,
       1                                                     as tokoixreosi,
       1                                                     as manual,
       1                                                     as departmentid,
       1                                                     as areaid,
       1                                                     as direction,
       1                                                     as direction,
       4                                                     as periodicityid
from spata."YdrMain" ydrmain
         left join spata."YdrDiadrom" ydrdiadrom on (ydrmain."YdrDiadromID" = ydrdiadrom."YdrDiadromID")
         left join spata."OikPoli" oikpoli on (ydrmain."YdrDiefPoliID" = oikpoli."OikPoliID");


 select max(id) from ydr_consumers ;
sELECT setval('seq_ydr_consumers',30629 , true);

update ydr_consumers
set code = cast(id as varchar);

    update ydr_consumers
    set sectorid = 2
    where routeid in (select id
    from ydr_routes
    where descr  like '%Αρτέ%');

    update ydr_consumers
    set code = trim(to_char(sectorid,'00')) ||trim(to_char(id,'00000'))
;


-- update ydr_consumers
-- set routesortlist = (select case substr(ydrmain."YdrAaDiadrom", 1, 1)
--                                 when '-' then substr(ydrmain."YdrAaDiadrom", 2, 30)
--                                 else ydrmain."YdrAaDiadrom"
--                                 end
--                      from spata."YdrMain" ydrmain
--                      where ydrmain."YdrID" = ydr_consumers.id)
update ydr_consumers
set routesortlist = (select ydrmain."YdrParoxi"
                     from spata."YdrMain" ydrmain
                     where ydrmain."YdrID" = ydr_consumers.id)
;