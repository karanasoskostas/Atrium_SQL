select ydr_mtran.id,
       (select count(*)
        from ydr_tran
                 inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_trantypes.trantype = 2) enanti,
       (select count(*)
        from ydr_tran
                 inner join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
        where ydr_tran.mtranid = ydr_mtran.id
          and ydr_trantypes.trantype = 3) precharges,
        ydr_consumers.code                              code,
        liable.fullname                                 laiblename,
        owner.fullname                                  ownername,
        ydr_hydrometers.code                            hydrometer,
        ydr_address.descr                               address,
        ydr_consumers.addrno1                           addrno1,
        ydr_consumers.addrno2                           addrno2,
        ydr_mtran.prevcountervalue                      prevcountervalue,
        ydr_mtran.currcountervalue                      currcountervalue,
        ydr_mtran.currcountervalue - ydr_mtran.prevcountervalue  consumption ,


from ydr_mtran
         inner join ydr_tran last_tran on (last_tran.mtranid = ydr_mtran.id and
                                           last_tran.id = (select max(a.id)
                                                           from ydr_tran a
                                                                    inner join ydr_trantypes on a.trantypeid = ydr_trantypes.id
                                                           where a.mtranid = last_tran.mtranid
                                                             and ydr_trantypes.trantype in (1, 2, 3)))
         inner join ydr_consumers on ydr_mtran.consumerid = ydr_consumers.id
         inner join traders liable on liable.id = last_tran.liableid
         inner join traders owner on owner.id = last_tran.ownerid
         inner join ydr_hydrometers on ydr_consumers.hydrometerid = ydr_hydrometers.id
         left join ydr_address on ydr_consumers.addressid = ydr_address.id
where ydr_mtran.periodid = 223