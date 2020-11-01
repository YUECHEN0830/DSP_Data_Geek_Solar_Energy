Use dsp_test
;
/*
  dim_postcode

  DROP TABLE IF EXISTS dim_postcode
*/
CREATE TABLE dim_postcode (
	dim_postcode_key int(11) NOT NULL AUTO_INCREMENT
	,dim_created_date datetime DEFAULT CURRENT_TIMESTAMP
	,dim_updated_date datetime DEFAULT CURRENT_TIMESTAMP
	,postcode varchar(5)
	,state varchar(4)
	,CONSTRAINT dim_postcode_pk PRIMARY KEY (dim_postcode_key)
)
;
