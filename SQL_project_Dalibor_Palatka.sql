-- first table --
/*
 Pro vytvoření první tabulky pro svůj projekt jsem využil tabulku czechia_price, ke které jsem pomocí JOIN připojil i tabulky czechia_region a czechia_price_category.
 Pro připojení tabulky czechia_region jsem zvolil LEFT JOIN z toho důvodu, aby nedošlo k vynechání řádků s hodnotou NULL u region_code.
 Tato NULL hodnota u region_code znamená, že hodnoty v takovém řádku jsou průměry pro celou ČR, se kterými budu v projektu dále pracovat, tudíž jsem je chtěl zachovat.
 Jelikož sloupec code v tabulce category_code, kterou potřebuji také připojit, nemůže být NULL, lze v tomto případě využít klasiký JOIN, aniž bych ztratil nějaké záznamy.
 */

SELECT 
 	ROUND(AVG(value), 2) AS average_price,
 	category_code,
 	cpc.name AS category_name,
 	YEAR(date_from) AS year
FROM
	czechia_price cpr
LEFT JOIN
	czechia_region cr 
ON 
	cpr.region_code = cr.code
JOIN
	czechia_price_category cpc 
ON
	cpr.category_code = cpc.code
WHERE
	region_code IS NULL 
AND
	YEAR(date_from) BETWEEN 2007 AND 2015
GROUP BY
	year,
	cpc.name 
;

-- second table --
-- Tvorba druhé tabulky --
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
-- Vytvoření nové tabulky t_Dalibor_Palatka_project_SQL_primary_final (spojení první a druhé tabulky) --

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
 

/* 
Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Pro zodpovězení první otázky jsem využil funkci LAG, díky které lze pozorovat srovnání mezd aktuálního a předešlého roku.
Rozdíl mezi aktuálním a předešlým rokem je ve sloupci difference 
použitím CASE Expression jsem vytvořil pomocný sloupec wage_change, aby bylo na první pohled jasné, zda mzda mezi jednotlivými roky roste (ok), nebo klesá (DECREASE)
Odpověď: Ne ve všech odvětvích se mzdy s rostoucími roky zvyšují. S poklesem mezd během let se setkáváme v mnoha odvětvích, a to předevěím  mezi roky 2012 a 2013.
 */
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

/*
Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Pro zodpovězení otázky jsem podělil sloupec average_wage s average_price.
Tím jsem vytvořil nový sloupec available_amount, kde je počet kilogramů chleba a litrů mléka, které je možné si s danou mzdou koupit.
*/
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

 
/*
Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Zde jsem využil spojení tabulky samy na sebe, abych v ní mohl zobrazit jednotlivé ceny potravin za první a poslední období vedle sebe.
Následně jsem podělil sloupec s cenami z roku 2015 s druhým sloupcem.
Tím jsem vytvořil sloupec percentage_change, který zobrazuje percentuální  nárůst cen jednotlivých potravin mezi lety 2007 a 2015.
Odpověď: Nejpomaleji z potravin mezi lety 2007 a 2015 zdražují Banány, jejichž cena za toto období vzrostla pouze o 3,44%.
 */
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

/*
Otázka č. 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Využil jsem opět funkci LAG k získání sloupce s cenami a mzdami předchozích roků k těm aktuálním.
Stejně jako u otázky č. 3 jsem tyto sloupce podělil a vytvořil další sloupec s procentuální změnou.
Dále jsem od procentuálních změn cen potravin v jednotlivých letech odečetl procentuální rozdíl mezd pro stejný rok.
Tím jsem vytvořil poslední sloupec difference, který tento rozdíl zobrazuje.
Odpověď: Ve sledovaném období mezi roky 2007 a 2015 neexistuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (tedy větší než 10%).
K 10% se však nejvíce blíží rozdíl v roce 2009, který je 9,58%.
 */

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

/*
Otázka č. 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
Z dostupných dat ve sledovaném období mezi lety 2007 - 2015 nevyplývá, že má výška HDP velký vliv na výši mezd a cen potravin.
 */
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

 -- Tvorba tabulky s HDP, gini koeficientem a populací pro další evropské země


CREATE TABLE t_Dalibor_Palatka_project_SQL_secondary_final AS
SELECT
	e.`year`, 
	e.country, 
	e.GDP,
	e.gini,
	e.population,
	c.continent
FROM
	economies e
JOIN 
	countries c
ON
	e.country = c.country 
WHERE
	`year` BETWEEN 2007 AND 2015
AND 
	continent = "Europe"
ORDER BY 
	`year` 
;
