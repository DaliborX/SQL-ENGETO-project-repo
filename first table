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
