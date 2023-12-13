-- select * from atrium.change_ydrom."hydrometers_SPATA_NEW"  a
-- where to_date(a."date",'ddmyyyy') <='30/4/2021'
-- ;
--
--
--
-- select ydr_consumers.code,
--        liable.fullname ,
--        owner.fullname,
--        ydr_status.descr,
--        ydr_hydrometers.code,
--        ydr_mtran.prevcountervalue ,
--        ydr_mtran.currcountervalue ,
--        maxtran.consumption,
--        maxtran.extraconsumption,
--        maxtran.debtconsumption,
--        ydr_tran.trandate ,
--        ydr_trantypes.descr ,
--        ( select sum(trand.netamount + trand.vatamount)
--          from ydr_tran tran inner join ydr_mtran mtran on tran.mtranid = mtran.id
--                             inner join ydr_trand trand on tran.id = trand.tranid
--          where mtran.id = ydr_mtran.id )  as mtran_amount,
--        maxtran.enanti ,
--        maxtran.proekk,
--        maxtran.changes ,
--        maxtran.to_tran
-- from ydr_mtran
--          inner join mtran_view maxtran on (
-- --              maxtran.period_id = 152 and
--                                            ydr_mtran.id = maxtran.mtran_id)
--          inner join ydr_consumers on ydr_mtran.consumerid = ydr_consumers.id
--          inner join ydr_tran on ydr_tran.id = maxtran.tran_id
--          inner join traders liable on liable.id = ydr_tran.liableid
--          inner join traders owner on owner.id = ydr_tran.ownerid
--          inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
--          inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
--          inner join ydr_status on ydr_tran.statusid = ydr_status.id
-- where ydr_mtran.periodid = 152
--
-- drop view mtran_view;
--
-- create view mtran_view as
-- select ydr_mtran.periodid           period_id,
--        ydr_mtran.id                 mtran_id,
--        max(case ydr_trantypes.trantype
--                when 1 then ydr_tran.id
--                when 2 then ydr_tran.id
--                when 3 then ydr_tran.id
--                else 0
--            end)     as                tran_id,
--        sum(case ydr_trantypes.trantype
--                when 2 then 1
--                else 0
--            end)     as                enanti,
--        sum(case ydr_trantypes.trantype
--                when 3 then 1
--                else 0
--            end)     as                proekk,
--        sum(case ydr_trantypes.trantype
--                when 4 then 1
--                else 0
--            end)     as                changes,
--        sum(ydr_tran.consumption)      consumption,
--        sum(ydr_tran.extraconsumption) extraconsumption,
--        sum(ydr_tran.debtconsumption)  debtconsumption,
--        sum(case ydr_tran.istran
--                when 0 then 1
--                else 0
--            end)     as                to_tran
-- from ydr_mtran
--          inner join ydr_tran on ydr_mtran.id = ydr_tran.mtranid
--          inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
-- --                     where ydr_mtran.periodid = 223
-- group by ydr_mtran.id , period_id;
--
--
-- select ydr_mtran.id       mtranid,
--        ydr_consumers.code consumer_code,
--        ydr_tran.liableid  liableid,
--        liable.fullname    liablename,
--        ydr_mtran.periodid periodid,
--        sum(case ydr_tran.istran
--                when 1 then 0
--                else 1
--            end)           to_tran,
--        sum(ydr_trand.netamount + ydr_trand.vatamount)           amount
-- from ydr_mtran inner join ydr_tran on ydr_mtran.id = ydr_tran.mtranid
--                inner join traders liable on ydr_tran.liableid = liable.id
--                inner join ydr_consumers on ydr_mtran.consumerid = ydr_consumers.id
--                inner join ydr_trand on ydr_tran.id = ydr_trand.tranid
-- where  ydr_mtran.periodid = 152
-- group by ydr_mtran.id,
--          ydr_tran.liableid,
--          liable.fullname,
--          ydr_consumers.code


select ydr_mtran.id                                                      mtranid,
       ydr_consumers.code                                                consumer_code,
       (select fullname
        from traders
                 inner join ydr_tran on traders.id = ydr_tran.liableid
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_tran.id = (select max(a.id)
                             from ydr_tran a
                                      inner join ydr_trantypes on a.trantypeid = ydr_trantypes.id
                             where a.mtranid = ydr_mtran.id
                               and ydr_trantypes.trantype in (1, 2, 3))) liablename,

       ydr_hydrometers.CODE                                              hydrometer,
       ydr_mtran.prevcountervalue                                        prevcountervalue,
       ydr_mtran.currcountervalue                                        currcountervalue,

       (select sum(consumption)
        from ydr_tran
        where ydr_tran.mtranid = ydr_mtran.id)                           consumption,

       (select sum(extraconsumption)
        from ydr_tran
        where ydr_tran.mtranid = ydr_mtran.id)                           extraconsumption,

       (select sum(debtconsumption)
        from ydr_tran
        where ydr_tran.mtranid = ydr_mtran.id)                           debtconsumption,

--        (select max(trandate)
--         from ydr_tran
--         where ydr_tran.mtranid = ydr_mtran.id)                     trandate,
       nvl((select sum(ydr_trand.netamount + ydr_trand.vatamount)
            from ydr_trand
                     inner join ydr_tran on ydr_trand.tranid = ydr_tran.id
            where ydr_tran.mtranid = ydr_mtran.id), 0) +
       nvl((select sum(ydr_tranx.netamount + ydr_tranx.vatamount)
            from ydr_tranx
                     inner join ydr_tran on ydr_tranx.tranid = ydr_tran.id
            where ydr_tran.mtranid = ydr_mtran.id), 0)                   amount,
    
       (select count(distinct liableid)
        from ydr_tran
        where ydr_tran.mtranid = ydr_mtran.id)                           liable_changes,

       (select count(*)
        from ydr_tran
                 inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_trantypes.trantype = 2)                                enanti,

       (select count(*)
        from ydr_tran
                 inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_trantypes.trantype = 3)                                proekk,

       (select count(*)
        from ydr_tran
                 inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_trantypes.trantype in (4, 5))                          changes,

       (select count(*)
        from ydr_tran
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_tran.istran = 0)                                       to_tran

from ydr_mtran
         inner join ydr_consumers on ydr_mtran.consumerid = ydr_consumers.id
         inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
where ydr_mtran.periodid = 223