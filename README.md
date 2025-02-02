Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Pro zodpovězení první otázky jsem využil funkci LAG, díky které lze pozorovat srovnání mezd aktuálního a předešlého roku.
Rozdíl mezi aktuálním a předešlým rokem je ve sloupci difference 
použitím CASE Expression jsem vytvořil pomocný sloupec wage_change, aby bylo na první pohled jasné, zda mzda mezi jednotlivými roky roste (ok), nebo klesá (DECREASE)
Odpověď: Ne ve všech odvětvích se mzdy s rostoucími roky zvyšují. S poklesem mezd během let se setkáváme v mnoha odvětvích, a to předevěím  mezi roky 2012 a 2013.

Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Pro zodpovězení otázky jsem podělil sloupec average_wage s average_price.
Tím jsem vytvořil nový sloupec available_amount, kde je počet kilogramů chleba a litrů mléka, které je možné si s danou mzdou koupit.

Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Zde jsem využil spojení tabulky samy na sebe, abych v ní mohl zobrazit jednotlivé ceny potravin za první a poslední období vedle sebe.
Následně jsem podělil sloupec s cenami z roku 2015 s druhým sloupcem.
Tím jsem vytvořil sloupec percentage_change, který zobrazuje percentuální  nárůst cen jednotlivých potravin mezi lety 2007 a 2015.
Odpověď: Nejpomaleji z potravin mezi lety 2007 a 2015 zdražují Banány, jejichž cena za toto období vzrostla pouze o 3,44%.
