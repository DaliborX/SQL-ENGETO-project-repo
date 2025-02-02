SELECT DISTINCT
	t1.category_name,
	t1.average_price AS avg_price_2007,
	t2.average_price AS avg_price_2015,
	((t2.average_price / t1.average_price) - 1) * 100 AS percentage_change
FROM 
	t_Dalibor_Palatka_project_SQL_primary_final t1
JOIN
	t_Dalibor_Palatka_project_SQL_primary_final t2
ON 
	t1.category_name = t2.category_name
WHERE 
	t1.year = 2007
AND 
	t2.year = 2015
AND
	t2.average_price / t1.average_price > 1
ORDER BY
	t2.average_price / t1.average_price
;
