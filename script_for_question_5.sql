SELECT 
	tdp.`year`,
	AVG(tdp.average_price) AS avg_price,
	AVG(tdp.average_wage) AS avg_wage,
	e.GDP 
FROM 
	t_Dalibor_Palatka_project_SQL_primary_final tdp
JOIN 
	economies e
ON 
	tdp.`year` = e.`year`
WHERE
	e.country = "Czech Republic"
GROUP BY
	`year`
;
