SELECT DISTINCT 
	industry_name,
	year,
	average_wage,
	LAG(average_wage) OVER (PARTITION BY industry_name ORDER BY year) AS previous_year,
	average_wage - LAG(average_wage) OVER (PARTITION BY industry_name ORDER BY year) as difference,
	CASE 
		WHEN average_wage - LAG(average_wage) OVER (PARTITION BY industry_name ORDER BY year) < 0 THEN "DECREASE"
		WHEN average_wage - LAG(average_wage) OVER (PARTITION BY industry_name ORDER BY year) > 0 THEN  "ok"
		ELSE NULL
	END AS wage_change
FROM
	t_Dalibor_Palatka_project_SQL_primary_final tdppspf
GROUP BY
	`year`, industry_name 
ORDER BY 
	wage_change, `year` 
;
