CREATE TABLE t_Dalibor_Palatka_project_SQL_primary_final AS
SELECT
	cp.year,
	cp.average_price,
	cp.category_code,
	cp.category_name,
	pp.average_wage,
	pp.industry_branch_code,
	pp.industry_name
FROM
	(SELECT
		ROUND(AVG(value), 2) AS average_price,
 		category_code,
 		cpc.name AS category_name,
 		YEAR(date_from) AS year
	FROM
		czechia_price cpr
	LEFT JOIN
		czechia_region cr ON cpr.region_code = cr.code
	JOIN
		czechia_price_category cpc ON cpr.category_code = cpc.code
	WHERE
		region_code IS NULL
	AND
		YEAR(date_from) BETWEEN 2007 AND 2015
	GROUP BY
		year,
		cpc.name) AS cp
JOIN
	(SELECT
		ROUND(AVG(value), 2) AS average_wage,
		industry_branch_code,
		name AS industry_name,
 		payroll_year
 	FROM 
 		czechia_payroll cpa
	LEFT JOIN 
		czechia_payroll_industry_branch cpib ON cpa.industry_branch_code = cpib.code
	WHERE 
		value_type_code = 5958
	AND
		payroll_year BETWEEN 2007 AND 2015
	GROUP BY 
		industry_branch_code,
		payroll_year) AS pp
ON cp.year = pp.payroll_year
;
