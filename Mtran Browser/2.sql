select trands.mtranid                                 mtranid,
       sum( case trands.trantype
           when 2 then 1
           else 0
           end)                                        enanti,
       sum( case trands.trantype
           when 3 then 1
           else 0
           end)                                        Precharges,
       sum( case trands.trantype
           when 4 then 1
           when 5 then 1
           else 0
           end)                                        changes,
       sum( case trands.istran
           when 0 then 1
           else 0
           end)                                        notconfirmed,
       count(distinct trands.liableid)                 liables,
       ydr_consumers.code                              code,
       liable.fullname                                 laiblename,
       owner.fullname                                  ownername,
       ydr_hydrometers.code                            hydrometer,
       ydr_address.descr                               address,
       ydr_consumers.addrno1                           addrno1,
       ydr_consumers.addrno2                           addrno2,
       trands.prevcountervalue                         prevcountervalue,
       trands.currcountervalue                         currcountervalue,
       max(trands.confirmdate)                         confirmdate,
       sum(trands.amount)                              amount
from (select ydr_mtran.id                                   mtranid,
             ydr_mtran.prevcountervalue                     prevcountervalue,
             ydr_mtran.currcountervalue                     currcountervalue,
             ydr_mtran.consumerid                           consumerid,
             ydr_tran.id                                    tranid,
             ydr_trantypes.trantype                         trantype,
             ydr_tran.istran                                istran,
             ydr_tran.confirmdate                           confirmdate,
             ydr_tran.liableid                              liableid,
             ydr_tran.ownerid                               ownerid,
             sum(ydr_trand.netamount + ydr_trand.vatamount) amount
      from ydr_mtran
               inner join ydr_tran on ydr_mtran.id = ydr_tran.mtranid
               inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
               inner join ydr_trand on ydr_tran.id = ydr_trand.tranid
      where ydr_mtran.periodid = 223
      group by ydr_mtran.id,
               ydr_tran.id,
               ydr_tran.liableid,
               ydr_tran.ownerid,
               ydr_mtran.prevcountervalue ,
               ydr_mtran.currcountervalue,
               ydr_tran.istran    ,
               ydr_tran.confirmdate,
               ydr_trantypes.trantype
                ) trands  inner join ydr_consumers on trands.consumerid = ydr_consumers.id
                          inner join ydr_tran last_tran on  (last_tran.mtranid = trands.mtranid and
                                                  last_tran.id = (select max(a.id)
                                                                   from ydr_tran a inner join ydr_trantypes on a.trantypeid = ydr_trantypes.id
                                                                   where a.mtranid = last_tran.mtranid
                                                                     and ydr_trantypes.trantype in (1,2,3) ))
                          inner join traders liable on liable.id = last_tran.liableid
                          inner join traders owner on owner.id = last_tran.ownerid
                          inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
                          left join ydr_address on ydr_consumers.addressid = ydr_address.id
group by trands.mtranid        ,
         ydr_consumers.code,
         liable.fullname ,
         owner.fullname ,
         ydr_hydrometers.code,
         ydr_address.descr ,
         ydr_consumers.addrno1 ,
         ydr_consumers.addrno2,
         trands.prevcountervalue                           ,
         trands.currcountervalue
