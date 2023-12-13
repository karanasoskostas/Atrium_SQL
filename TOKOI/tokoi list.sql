select comtrans.docdate              as calcdate ,             -- Ημ/νία Υπολογισμού
       traders.fullname              as liable,                -- Υπόχρεος
       case ydr_tran.id
          when null then relcomdocs.descr
          else ydr_periods.descr
       end                           as period_descr ,         -- Προέλευση
       case ydr_tran.id
           when null then concat(relcomdocs.code,cast(relcomtrans.seqnr as char))
           else ydr_trantypes.descr
           end                       as trantype_descr,        -- Είδος Κίνησης
       cominterests.interestpcnt     as interestpctn,          -- Ποσοστό Τόκων
       cominterests.interestamount   as interestamount,        -- Ποσό Τόκων
       cominterests.stampcnt         as stampcnt,              -- Ποσσοστό Χαρτοσήμου
       cominterests.stampamount      as stampamount,           -- Ποσό Χαρτοσήμου
       cominterests.calcdatefrom     as calcdatefrom,          -- Από
       cominterests.calcdateto       as calcdateto,            -- Έως
       cominterests.calcdates        as days_months,           -- Nr
       case cominterests.calcsource
           when 1 then 'PAYMENT'
           when 2 then 'CHANGE'
           when 3 then 'DEFFINITIVE'
       end                           as calcsource ,            -- Eίδος
       cominterests.taxanalysis      as taxanalysis ,           -- η ανάλυση θα εμφανίζεται σαν label
       vevcomtrans.docdate           as vevdate,                -- Βεβαιωτικός
       vevcomtrans.seqnr             as vevseqnr                --
from cominterests inner join traderstrans on cominterests.traderstransid = traderstrans.id
                  inner join comtrans on traderstrans.comtransid = comtrans.id
                  inner join traderstrans reltradertrans on cominterests.traderstransrelid = reltradertrans.id
                  inner join comtrans relcomtrans on reltradertrans.comtransid = relcomtrans.id
                  inner join comdocs relcomdocs on relcomtrans.docid = relcomdocs.id
                  inner join traders on reltradertrans.traderid = traders.id
                  left join ydr_periods on reltradertrans.ydrperiodid = ydr_periods.id
                  left join ydr_tran on reltradertrans.id = ydr_tran.tradertransid
                  left join ydr_trantypes on ydr_tran.trantypeid = ydr_trantypes.id
                  inner join cominterestkind on cominterests.cominterestkindid = cominterestkind.id
                  left join traderstrans vevtradertrans on vevtradertrans.id = cominterests.traderstransidvev
                  left join comtrans vevcomtrans on vevcomtrans.id = vevtradertrans.comtransid


