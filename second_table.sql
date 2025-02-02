SELECT
	ROUND(AVG(value), 2) AS average_wage,
	industry_branch_code,
	name AS industry_name,
	payroll_year 
FROM
	czechia_payroll cpa
LEFT JOIN
	czechia_payroll_industry_branch cpib 
ON 
	cpa.industry_branch_code = cpib.code
WHERE
	value_type_code = 5958
AND
	payroll_year BETWEEN 2007 AND 2015
GROUP BY
	industry_branch_code,
	payroll_year
ORDER  BY
	cpa.industry_branch_code 
;
