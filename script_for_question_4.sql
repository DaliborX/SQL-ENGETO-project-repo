SELECT
	`year`,
	AVG(average_price) AS AVG_price,
	LAG(AVG(average_price)) OVER (ORDER BY year) AS AVG_price_previous_year,
	CONCAT(ROUND((ROUND(AVG(average_price), 2) / ROUND(LAG(AVG(average_price)) OVER (ORDER BY `year`), 2) -1) *100, 2), "%") AS annual_growth_PRICE,
	AVG(average_wage) AS AVG_wage,
	LAG(AVG(average_wage)) OVER (ORDER BY year) AS AVG_wage_previous_year,
	CONCAT(ROUND((ROUND(AVG(average_wage), 2) / ROUND(LAG(AVG(average_wage)) OVER (ORDER BY `year`), 2) -1) *100, 2), "%") AS annual_growth_WAGE,
	ROUND((ROUND(AVG(average_price), 2) / ROUND(LAG(AVG(average_price)) OVER (ORDER BY `year`), 2) -1) *100, 2) - ROUND((ROUND(AVG(average_wage), 2) / ROUND(LAG(AVG(average_wage)) OVER (ORDER BY `year`), 2) -1) *100, 2) AS difference
FROM 
	t_Dalibor_Palatka_project_SQL_primary_final tdppspf
GROUP BY 
	`year` 
;
