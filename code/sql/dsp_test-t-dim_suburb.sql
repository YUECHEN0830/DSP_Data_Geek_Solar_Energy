Use dsp_test
;
/*
  dim_suburb

  DROP TABLE IF EXISTS dim_suburb
*/
CREATE TABLE dim_suburb (
	dim_suburb_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,suburb varchar(100)
	,state varchar(4)
	,CONSTRAINT dim_suburb_pk PRIMARY KEY (dim_suburb_key)
)
;
/*
 * dim_suburb
*/
insert into dim_suburb (suburb, state)
select DISTINCT suburb, state
from dsp_test.dim_postcode_suburb
order by 2,1
;
select * from dim_suburb
;
