Use `db_dsp01`
;
select fuel_group, fuel_type, `2008-09` value, 2009 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2009-10` value, 2010 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2010-11` value, 2011 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2011-12` value, 2012 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2012-13` value, 2013 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2013-14` value, 2014 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2014-15` value, 2015 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2015-16` value, 2016 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2016-17` value, 2017 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2017-18` value, 2018 fin_year
from stg_DISER_TableO_NSW
union all
select fuel_group, fuel_type, `2018-19` value, 2019 fin_year
from stg_DISER_TableO_NSW
;
