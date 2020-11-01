SELECT 
    t1.city,
    t1.avg_daily_output,
    t2.system_size,
    t2.number_of_panels,
    t2.min_cost,
    t2.max_cost
FROM
    fct_solar_pv_sys_output t1,
    dim_solar_sys_cost t2
WHERE
    t1.dim_solar_sys_cost_key = t2.dim_solar_sys_cost_key; 
    
    
    
