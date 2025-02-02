Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Pro zodpovězení první otázky jsem využil funkci LAG, díky které lze pozorovat srovnání mezd aktuálního a předešlého roku.
Rozdíl mezi aktuálním a předešlým rokem je ve sloupci difference 
použitím CASE Expression jsem vytvořil pomocný sloupec wage_change, aby bylo na první pohled jasné, zda mzda mezi jednotlivými roky roste (ok), nebo klesá (DECREASE)
Odpověď: Ne ve všech odvětvích se mzdy s rostoucími roky zvyšují. S poklesem mezd během let se setkáváme v mnoha odvětvích, a to předevěím  mezi roky 2012 a 2013.

Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Pro zodpovězení otázky jsem podělil sloupec average_wage s average_price.
Tím jsem vytvořil nový sloupec available_amount, kde je počet kilogramů chleba a litrů mléka, které je možné si s danou mzdou koupit.
