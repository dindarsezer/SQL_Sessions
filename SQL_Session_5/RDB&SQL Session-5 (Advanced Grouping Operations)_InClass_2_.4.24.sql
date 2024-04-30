

--GROUPING OPERATIONS

/*
SQL SERVER'DA QUERY'NÝN ÝÞLEM SIRASI!!

FROM		: Hangi tablolara gitmem gerekiyor?
WHERE		: Bu tablolardan hangi verileri çekmem gerekiyor? (Ana tablolar üzerinde bir filtreleme yapýyorum)
GROUP BY	: From ile seçilen tablolarýn, where ile seçilen satýrlarýný ne þekilde gruplayacaðým?
HAVING		: Yukarda gruplanmýþ tablo üzerinden nasýl bir filtreleme yapacaðým? (örnek: list_price > 1000)
SELECT		: Hangi bilgileri-sütunlarý getireyim? Hangi aggregate iþlemi yapayým? Sonuç tablomda neleri görmek istiyorum?
ORDER BY	: Sonuç tablosunu hangi sýralama ile getireyim.

*/

SELECT brand_name, AVG(list_price) AS avg_list_price
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
AND A.model_year > 2016
GROUP BY brand_name
HAVING AVG(list_price) > 1000
ORDER BY avg_list_price ASC; 


-- SELECT'te AVG(list_price) OLMADAN!
SELECT brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
AND A.model_year > 2016
GROUP BY brand_name
HAVING AVG(list_price) > 1000
ORDER BY AVG(list_price) ASC; 


--HAVING


--Write a query that checks if any product id is duplicated in product table.

----product tablosunda herhangi bir product id' nin çoklayýp çoklamadýðýný kontrol ediniz.

SELECT *
FROM product.product;


SELECT DISTINCT (product_id)
FROM product.product;


SELECT COUNT(DISTINCT product_id ), COUNT(*)
FROM product.product;


SELECT product_id,  COUNT(product_id) num_of_rows
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1;


--///////

--Write a query that returns category ids with conditions max list price above 4000 or a min list price below 500.

--maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz
--category name' e gerek yok.


SELECT *
FROM product.product
ORDER BY category_id, list_price;



SELECT category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500;



---/////

--Find the average product prices of the brands. Display brand name and average prices in descending order.

--Markalara ait ortalama ürün fiyatlarýný bulunuz.
--ortalama fiyatlara göre azalan sýrayla gösteriniz.

SELECT *
FROM product.brand;

SELECT *
FROM product.product;


SELECT brand_name, AVG(A.list_price) AVG_PRICE
FROM product.product A
	RIGHT JOIN 
	product.brand B
	ON 
	A.brand_id = B.brand_id
GROUP BY
	brand_name
ORDER BY 2 DESC;

-- INNER JOIN ÝLE KULLANIRSAK:
SELECT brand_name, AVG(A.list_price) AVG_PRICE
FROM product.product A
	INNER JOIN 
	product.brand B
	ON 
	A.brand_id = B.brand_id
GROUP BY
	brand_name
ORDER BY 2 DESC;


--////


--Write a query that returns the list of brands whose average product prices are more than 1000

---ortalama ürün fiyatý 1000' den yüksek olan MARKALARI getiriniz


SELECT brand_name, AVG(A.list_price) AVG_PRICE
FROM product.product A
	RIGHT JOIN 
	product.brand B
	ON 
	A.brand_id = B.brand_id
GROUP BY
	brand_name
HAVING AVG(A.list_price) > 1000
ORDER BY 2 DESC;



--////////

--Write a query that returns the list of each order id and that order's total net price 
--(please take into consideration of discounts and quantities)


--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.


SELECT *
FROM sale.orders;

SELECT *
FROM sale.order_item;


SELECT order_id, product_id, quantity * list_price * (1-discount)  AS net_price
FROM sale.order_item;



SELECT order_id, product_id, SUM(quantity * list_price * (1-discount))  AS net_price
FROM sale.order_item
GROUP BY order_id, product_id
ORDER BY order_id;


SELECT order_id, SUM(quantity * list_price * (1-discount))  AS net_price
FROM sale.order_item
GROUP BY order_id
ORDER BY order_id;

------------------/////////////////

--Write a query that returns monthly order counts of the States.

--State' lerin aylýk sipariþ sayýlarýný hesaplayýnýz

SELECT *
FROM sale.customer
ORDER BY state;

SELECT *
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id;


SELECT [state],	
		MONTH(B.order_date) months,
		COUNT (DISTINCT order_id) num_of_orders
FROM sale.customer A
	INNER JOIN
	sale.orders B
	ON A.customer_id = B.customer_id
GROUP BY state, MONTH(B.order_date)
ORDER BY state, months;


SELECT [state],	
		YEAR(B.order_date) [year],
		MONTH(B.order_date) months,
		COUNT (DISTINCT order_id) num_of_orders
FROM sale.customer A
	INNER JOIN
	sale.orders B
	ON A.customer_id = B.customer_id
GROUP BY state, YEAR(B.order_date), MONTH(B.order_date)
ORDER BY 1,2,3;

--///////////////////////////

--Just now, we're gonna create a summary table for following topics 

--Summary Table


--we are going to use SELECT * INTO .... FROM ... instruction

--SYNTAX

SELECT * 
INTO	NEW_TABLE
FROM	SOURCE_TABLE
WHERE ...


--Anyway, we create summary table

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D  
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year;


SELECT *
FROM sale.sales_summary;

-----///////////////////////------

--GRUPING SETS

/*SORU 1. Calculate the total sales price of each brands.
TR - 1. Her markanýn toplam satýþ miktarýný hesaplayýnýz.
*/

SELECT Brand, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY Brand;

/*
SORU 2. Calculate the total sales price by the Model Years
TR - 2. Model Yýllarýna göre toplam satýþ miktarýný hesaplayýnýz.
*/

SELECT Model_Year, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY Model_Year;


-- SORU-3. Calculate the total sales amount by brand and model year.
--TR - 3. Marka ve Model Yýlý kýrýlýmýnda toplam satýþ miktarýný hesaplayýnýz

SELECT Brand, Model_Year, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY Brand, Model_Year;


-- SORU 4. Calculate the total sales amount from all sales.

-- TR - 4. Tüm satýþlardan elde edilen toplam satýþ tutarýný hesaplayýnýz:

SELECT SUM(total_sales_price)
FROM sale.sales_summary;



/* Perform the above four variations in a single query using 'Grouping Sets'.

Yukarýdaki 4 maddede istenileni tek bir sorguda getirmek için Grouping sets kullanýlabilir
Yani brand, Category, brand + category, total

1. brand
2. Model_Year
3. Brand + Model_Year
4. total
*/

SELECT brand, Model_Year, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY 
		GROUPING SETS (
		(Brand), 
		(Model_Year),
		(Brand, Model_Year),
		()
		)
ORDER BY 1,2;


---------////////////////////////----------




---------- ROLLUP ---------

--Generate different grouping variations that can be produced with the brand and Model_Year columns using 'ROLLUP'.
-- Calculate sum total_sales_price

-- SORU: brand ve Model_Year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýn.


SELECT Brand, Model_Year, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY
		ROLLUP (Brand, Model_Year)
ORDER BY
		1 DESC;




	-------////////////////////////----------

------------ CUBE ------------


--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
-- Calculate sum total_sales_price


--brand, category, model_year sütunlarý için cube kullanarak total sales hesaplamasý yapýn.

--üç sütun için 8 farklý gruplama varyasyonu oluþturulacak!

SELECT Brand, Category, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY 
		CUBE (Brand, Category, Model_Year)
ORDER BY Brand, Category;




-----/////////////--------


--------- PIVOT ----------

--Generate a query that you use its result as basic table for PIVOT.
--pivot table oluþturacaðýnýz kaynak tabloyu belirleyin

-- that is what:

--Question: Write a query using summary table that returns the total turnover from each category by model year. (in pivot table format)
--kategorilere ve model yýlýna göre toplam ciro miktarýný summary tablosu üzerinden hesaplayýn

SELECT *
FROM sale.sales_summary

SELECT Category, Model_Year, SUM(total_sales_price) total_turnover
FROM sale.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1,2;


SELECT Category, Model_Year,total_sales_price
FROM sale.sales_summary


CREATE VIEW v_category_model_turnover AS
SELECT Category, Model_Year,total_sales_price
FROM sale.sales_summary;

select *
from v_category_model_turnover


SELECT *
FROM v_category_model_turnover
PIVOT
(
SUM(total_sales_price)
FOR Model_Year
IN ([2018], [2019], [2020], [2021])
) AS PVT


-- PIVOT TABLE'DA SADECE MODEL_YEAR OLSUN. CATEGORY KIRILIMI OLMASIN:

SELECT *
FROM v_category_model_turnover


SELECT Model_Year, total_sales_price 
FROM v_category_model_turnover



SELECT *
FROM (
		SELECT Model_Year, total_sales_price FROM v_category_model_turnover
		) A 
PIVOT
(
SUM(total_sales_price)
FOR Model_Year
IN ([2018], [2019], [2020], [2021])
) AS PVT
		

-- sadece SELECT içinde seçim yaparak ayný sonucu döndürebilir miyiz?

SELECT [2018], [2019], [2021]
FROM v_category_model_turnover
PIVOT
(
SUM(total_sales_price)
FOR Model_Year
IN ([2018], [2019], [2020], [2021])
) AS PVT





--Now, you create a pivot table using above query result.
--Yukarýdaki sonucu pivot tabloya dönüþtür.









	
--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.
-- Ýki günden geç kargolanan sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz.








