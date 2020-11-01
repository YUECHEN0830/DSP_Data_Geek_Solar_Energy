Use dsp_test
;
-- DROP TABLE IF EXISTS dim_date
;
CREATE TABLE dim_date (
        dim_date_key INTEGER PRIMARY KEY NOT NULL
	    ,CalendarDate DATE NOT NULL
	    ,CalendarYear INTEGER
--	    ,CalendarQuater INTEGER
--	    ,CalendarQuaterName NVARCHAR(10)
	    ,CalendarMonth INTEGER
	    ,CalendarMonthName NVARCHAR(10)
-- 	    ,CalendarWeek INTEGER
--	    ,CalendarWeekName NVARCHAR(10)
	    ,CalendarDay INTEGER
	    ,CalendarDayOfWeek NVARCHAR(30)
);

CREATE UNIQUE INDEX dim_date_CalendarDate_IDX ON dim_date (CalendarDate);
;
SET SESSION cte_max_recursion_depth = 1000000; -- permit deeper recursion
;
INSERT INTO dim_date (
        dim_date_key
	    ,CalendarDate
	    ,CalendarYear
	    ,CalendarMonth
	    ,CalendarMonthName
-- 	    ,CalendarWeek
	    ,CalendarDay
	    ,CalendarDayOfWeek
)
WITH RECURSIVE cte_dates (CalendarDate) AS (
    SELECT DATE('2009-01-01') as CalendarDate

    UNION ALL

    SELECT DATE_ADD( CalendarDate, INTERVAL 1 DAY )
    FROM cte_dates d
    WHERE 1=1
    and CalendarDate < DATE('2021-01-01')
)
select
		CAST(DATE_FORMAT(CalendarDate, '%Y%m%d') AS SIGNED) as dim_date_key
 	    ,DATE(CalendarDate) as CalendarDate
	    ,CAST(DATE_FORMAT(CalendarDate, '%Y') AS SIGNED) as CalendarYear
	    ,CAST(DATE_FORMAT(CalendarDate, '%m') AS SIGNED) as CalendarMonth
	    ,case CAST(DATE_FORMAT(CalendarDate, '%m') AS SIGNED)
			when 1 then 'January'
			when 2 then 'February'
			when 3 then 'March'
			when 4 then 'April'
			when 5 then 'May'
			when 6 then 'June'
			when 7 then 'July'
			when 8 then 'August'
			when 9 then 'September'
			when 10 then 'October'
			when 11 then 'November'
			when 12 then 'December'
		end as CalendarMonthName
-- 	    ,CAST(DATE_FORMAT(CalendarDate, '%W') AS SIGNED) as CalendarWeek
	    ,CAST(DATE_FORMAT(CalendarDate, '%d') AS SIGNED) as CalendarDay
	    ,case CAST(DATE_FORMAT(CalendarDate, '%w') AS SIGNED)
			when 0 then 'Sunday'
			when 1 then 'Monday'
			when 2 then 'Tuesday'
			when 3 then 'Wednesday'
			when 4 then 'Thursday'
			when 5 then 'Friday'
			else 'Saturday' 
		end as DayOfWeek
from cte_dates
;
