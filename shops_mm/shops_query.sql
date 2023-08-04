/*
TASK 1.1
Из справочника по магазинам (v_whs) 
по всем работающим магазинам (working=1) 
формата "гипермаркет" (frmt_id=2)
выгрузить следующие данные: название (name), регион (region), филиал (branch), город (city).
*/

SELECT
	name,
	region,
	branch,
	city
FROM v_whs
WHERE working = 1 AND frmt_id = 2

/*
TASK 1.2
Из справочника по магазинам (v_whs) по всем работающим магазинам формата "магазин у дома" (frmt_id=1)
 города Краснодар выгрузить следующую информацию: 
 Название (name), субформат (subfrmt), дата открытия (open_dt), торговая площадь (square_trade), потенциал (potential). 
*/

SELECT
	name,
	subfrmt,
	open_dt,
	square_trade,
	potential
FROM v_whs
WHERE working = 1 AND frmt_id = 1 AND city = 'Краснодар'

/*
TASK 1.3
По магазину "Монтаж" из витрины с продажами (PRD_VD_MD2000.V_INDICATORS_MONTH) 
выгрузить название, месяц (month_id), продажи в рублях (opsum), 
количество чеков (txn_cnt) и количество отработанных дней (sales_day_cnt) 
с января по июнь 2018. 
Связка витрин по полю  идентификатора магазина (whs_id).
 */

SELECT
	v.name, 
	m.month_id,
	m.opsum,
	m.txn_cnt,
	m.sales_day_cnt
FROM V_INDICATORS_MONTH m
JOIN v_whs v USING (whs_id)
WHERE v.name = 'Монтаж' AND 
		EXTRACT(MONTH FROM m.month_id) BETWEEN 01 AND 06 AND 
		EXTRACT(YEAR FROM m.month_id) = 2018

/*
TASK 2.1
*/

-- ММ Авторучка: Продажи за прошлый месяц по дням
SELECT
	d.day_id,
	d.opsum
FROM V_INDICATORS_DAY d
JOIN V_WHS v USING (whs_id)
WHERE v.name = 'Авторучка' AND 
	d.day_id >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
    AND d.day_id < DATE_TRUNC('month', CURRENT_DATE)

-- ММ Авторучка: Продажи за весь 2022 год по месяцам  	
SELECT
	m.month_id,
	m.opsum
FROM V_INDICATORS_MONTH m
JOIN V_WHS v USING (whs_id)
WHERE v.name = 'Авторучка' AND 	
	EXTRACT(YEAR FROM m.month_id) = 2022
	
-- ММ Авторучка: Cуммарный оборот в целом за 2021 и 2022 г
SELECT 
	EXTRACT(YEAR FROM m.month_id) AS "year",
	sum(m.opsum) AS opsum
FROM V_INDICATORS_MONTH m
JOIN V_WHS v USING (whs_id)
GROUP BY 1, v.name
HAVING v.name = 'Авторучка'
	
-- ММ Авторучка: Средний оборот в месяц за 2021 и 2022 г	
SELECT 
	EXTRACT(YEAR FROM m.month_id) AS "year",
	round(AVG(m.opsum), 2) AS opsum
FROM V_INDICATORS_MONTH m
JOIN V_WHS v USING (whs_id)
GROUP BY 1, v.name
HAVING v.name = 'Авторучка'	
	
	
/*
TASK 2.2
По всем действующим ТТ формата ММ, открытым до 01.01.2020 выгрузить:
Оборот за август 2021 - июль 2022
Разделить ТТ на группы по следующим условиям (с помощью функции CASE)
-- По площади – «до 200 кв.м.», «200-300 кв.м.», «более 300 кв.м.»
-- По численности населенного пункта – 
«до 15 тыс.чел.», «15-50 тыс.чел», «50-100 тыс.чел», «более 100 тыс.чел»
*/	
	
SELECT
	sum(m.opsum) AS opsum,
	CASE WHEN square_trade < 200 THEN 'до 200 кв.м.'
		WHEN square_trade >= 200 AND square_trade <= 300 THEN '200-300 кв.м.'
		WHEN square_trade > 300 THEN 'более 300 кв.м.'
	END AS square_trade,
	CASE WHEN size_of_population < 15 THEN 'до 15 тыс.чел.'
		WHEN size_of_population >= 15 AND size_of_population < 50 THEN '15-50 тыс.чел'
		WHEN size_of_population >= 50 AND size_of_population <= 100 THEN '50-100 тыс.чел'
		WHEN size_of_population > 100 THEN 'более 100 тыс.чел'
	END AS size_of_population
FROM V_INDICATORS_MONTH m
JOIN V_WHS v  ON v.whs_id= m.whs_id AND
	v.frmt_id = 1 AND 
	v.working = 1 AND 
	v.open_dt < '2020-01-01' AND 
	m.month_id BETWEEN '2021-08-01' AND '2022-07-01'
GROUP BY 2, 3
 
	





















