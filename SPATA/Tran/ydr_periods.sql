
update spata."YdrPeriodos"
set "YdrPeriodArxi" = now(),
    "YdrPeriodTelos" = now()
        where "YdrPeriodArxi" is null;


delete from ydr_periods;


insert into ydr_periods(id, companyid, descr, datefrom, dateto, period, createuserid, createdate, updateuserid, updatedate, periodicityid, pyear, periodnr)
select ydrperiodos."YdrPeriodID" ,
       1,
       coalesce("YdrPeriodDescr",''),
       "YdrPeriodArxi" ,
       "YdrPeriodTelos" ,
       ( cast(to_char("YdrPeriodArxi",'yyyy') as integer) * 100) + cast(to_char("YdrPeriodArxi",'mm') as integer),
       1,
       now(),
       1,
       now(),
       4,
       cast(to_char("YdrPeriodArxi",'yyyy') as integer),
       cast(to_char("YdrPeriodTelos",'mm') as integer)
from spata."YdrPeriodos" ydrperiodos;

select max(id) from ydr_periods ;
sELECT setval('seq_traders',158 , true);


update ydr_periods
set periodnr = (select nr
                 from (select row_number() over (PARTITION BY pyear order by pyear, id) as nr, id
                       from ydr_periods
                       order by ydr_periods.pyear, id) tmp
                 where tmp.id = ydr_periods.id)


select *
from ydr_periods