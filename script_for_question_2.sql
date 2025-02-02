 SELECT
 	year,
 	category_name,
 	average_price,
 	average_wage,
 	ROUND((average_wage / average_price), 2) AS available_amount
 FROM 
 	t_Dalibor_Palatka_project_SQL_primary_final tdppspf 
 WHERE
 	year IN (2007, 2015)
 	AND (category_name LIKE '%mléko%' OR category_name LIKE '%chléb%')
 ;
