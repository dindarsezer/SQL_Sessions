

--GROUPING OPERATIONS

/*
SQL SERVER'DA QUERY'N�N ��LEM SIRASI!!

FROM		: Hangi tablolara gitmem gerekiyor?
WHERE		: Bu tablolardan hangi verileri �ekmem gerekiyor? (Ana tablolar �zerinde bir filtreleme yap�yorum)
GROUP BY	: From ile se�ilen tablolar�n, where ile se�ilen sat�rlar�n� ne �ekilde gruplayaca��m?
HAVING		: Yukarda gruplanm�� tablo �zerinden nas�l bir filtreleme yapaca��m? (�rnek: list_price > 1000)
SELECT		: Hangi bilgileri-s�tunlar� getireyim? Hangi aggregate i�lemi yapay�m? Sonu� tablomda neleri g�rmek istiyorum?
ORDER BY	: Sonu� tablosunu hangi s�ralama ile getireyim.

*/

--Model y�l� 2016 dan b�y�k olan marka(brand) lar� � marka ismine(brand_name) g�re grupla,
--ortalama liste fiyatlar�[AVG(list_price)] 1000 den b�y�k olanlar�,
--brand_name ve avg_list_price ad� alt�nda iki s�tunu getir,
--bunlar� AVG(list_price) a g�re artan s�rada s�rala

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


----1-HAVING---------------------------------------------------------------------------------
--GROUP BY ile gruplanan tabloda, gruplar� belirli bir ko�ula g�re filtreleme yapmam�z�z sa�lar

----product tablosunda herhangi bir product id' nin �oklay�p �oklamad���n� kontrol ediniz.

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


--maximum list price' � 4000' in �zerinde olan veya minimum list price' � 500' �n alt�nda olan categori id' leri getiriniz
--category name' e gerek yok.


SELECT *
FROM product.product
ORDER BY category_id, list_price;


SELECT category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500;


--Markalara ait ortalama �r�n fiyatlar�n� bulunuz.
--ortalama fiyatlara g�re azalan s�rayla g�steriniz.

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

-- INNER JOIN �LE KULLANIRSAK:
SELECT brand_name, AVG(A.list_price) AVG_PRICE
FROM product.product A
	INNER JOIN 
	product.brand B
	ON 
	A.brand_id = B.brand_id
GROUP BY
	brand_name
ORDER BY 2 DESC;


---ortalama �r�n fiyat� 1000' den y�ksek olan MARKALARI getiriniz

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


--bir sipari�in toplam net tutar�n� getiriniz. (m��terinin sipari� i�in �dedi�i tutar)
--discount' � ve quantity' yi ihmal etmeyiniz.

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


--State' lerin ayl�k sipari� say�lar�n� hesaplay�n�z

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
GROUP BY [state], YEAR(B.order_date), MONTH(B.order_date)
ORDER BY 1,2,3;


--�imdi, a�a��daki konular i�in bir �zet tablo olu�turaca��z 
--Summary Table

--we are going to use SELECT * INTO .... FROM ... instruction

--SYNTAX
--�NTO ile yeni bir tablo olu�tururuz
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


------2-GRUPING SETS------------------------------------------------------------------------------------------------------------------
--Anlaml� �zet istatistiklere ula�mak i�in gruplama setlerini kullanabiliriz.
--GROUPING SETS operat�r�, ayn� sorguda farkl� gruplama d�zeylerinde toplamalar elde etmek ve
--�ok y�nl� raporlar olu�turmak i�in kullan�lan bir SQL �zelli�idir.

/*SORU 1. Calculate the total sales price of each brands.
TR - 1. Her markan�n toplam sat�� miktar�n� hesaplay�n�z.
*/

SELECT Brand, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY Brand;

/*
SORU 2. Calculate the total sales price by the Model Years
TR - 2. Model Y�llar�na g�re toplam sat�� miktar�n� hesaplay�n�z.
*/

SELECT	Model_Year, SUM(total_sales_price) total_sales_price
FROM	sale.sales_summary
GROUP BY Model_Year;


-- SORU-3. Calculate the total sales amount by brand and model year.
--TR - 3. Marka ve Model Y�l� k�r�l�m�nda toplam sat�� miktar�n� hesaplay�n�z

SELECT	Brand, Model_Year, SUM(total_sales_price) total_sales_price
FROM	sale.sales_summary
GROUP BY Brand, Model_Year;


-- SORU 4. Calculate the total sales amount from all sales.
-- TR - 4. T�m sat��lardan elde edilen toplam sat�� tutar�n� hesaplay�n�z:

SELECT	SUM(total_sales_price)
FROM	sale.sales_summary;



/* Perform the above four variations in a single query using 'Grouping Sets'.

Yukar�daki 4 maddede istenileni tek bir sorguda getirmek i�in Grouping sets kullan�labilir
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


-----3 - ROLLUP -----------------------------------------------------------------------------------------------------------------

--Generate different grouping variations that can be produced with the brand and Model_Year columns using 'ROLLUP'.
-- Calculate sum total_sales_price

-- SORU: brand ve Model_Year s�tunlar� i�in Rollup kullanarak total sales hesaplamas� yap�n.


SELECT Brand, Model_Year, SUM(total_sales_price) total_sales_price
FROM sale.sales_summary
GROUP BY
		ROLLUP (Brand, Model_Year)
ORDER BY
		1 DESC;


------ 4- CUBE ------------------------------------------------------------------------------------------------------------------

--CUBE operat�r�, SELECT operat�r�nde belirtilen t�m alanlar i�in m�mk�n olan t�m kombinasyonlar� sa�lar.
--S�tunlar�n yaz�lma s�ras� �nemli DE��LD�R


--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
--CUBE kullanarak marka ve kategori s�tunlar� ile �retilebilecek farkl� gruplama varyasyonlar� olu�turun
--Calculate sum total_sales_price


--brand, category, model_year s�tunlar� i�in cube kullanarak total sales hesaplamas� yap�n.
--�� s�tun i�in 8 farkl� gruplama varyasyonu olu�turulacak!

SELECT	Brand, Category, Model_Year, SUM(total_sales_price)
FROM	sale.sales_summary
GROUP BY 
		CUBE (Brand, Category, Model_Year)
ORDER BY Brand, Category;


-----5 - PIVOT -----------------------------------------------------------------------------------------------------------------
/*
P�VOT operat�r�, sonu�lar tablosunda g�r�len benzersiz g�zlemleri s�tunlara d�n��t�r�r ve kar��l�k gelen toplam de�erleri sat�rlar halinde belirler.
P�VOT operat�r�nde GROUP BY kullan�lmaz.
-	�ncelikle pivotlamak i�in bir temel veri k�mesi se�ilir
-	Olu�turulan yeni bir tablo(VIEW) veya ortak tablo ifadesi (CTE) kullanarak ge�ici bir sonu� olu�turulur
-	Sonra PIVOT operat�r� uygulan�r
*/


--Question: Write a query using summary table that returns the total turnover from each category by model year. (in pivot table format)
--kategorilere ve model y�l�na g�re toplam ciro miktar�n� summary tablosu �zerinden hesaplay�n

--Sonucunu PIVOT i�in temel tablo olarak kulland���n�z bir sorgu olu�turun


SELECT *
FROM sale.sales_summary

--Olu�turaca��m�z tablo bunun sonucunda ��kan tablo fakat Create ederken Group by order sum gibi fonksiyonlar� ��kart�yoruz, bunlar� pivot yapacak
SELECT Category, Model_Year, SUM(total_sales_price) total_turnover
FROM sale.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1,2;

-- ��kard�ktan sonra bunu vreate edip yeni tablomuzu olu�turuyoruz
CREATE VIEW v_category_model_turnover AS
SELECT Category, Model_Year,total_sales_price
FROM sale.sales_summary;

SELECT	*
FROM	v_category_model_turnover

--Yukar�daki sonucu pivot tabloya d�n��t�r.

SELECT	*
FROM	v_category_model_turnover
	PIVOT (
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
FROM	(
		SELECT Model_Year, total_sales_price FROM v_category_model_turnover
		) A 
	PIVOT (
	SUM(total_sales_price)
	FOR Model_Year
	IN ([2018], [2019], [2020], [2021])
) AS PVT
		

-- sadece SELECT i�inde se�im yaparak ayn� sonucu d�nd�rebilir miyiz?

SELECT [2018], [2019], [2021]
FROM v_category_model_turnover
PIVOT
(
SUM(total_sales_price)
FOR Model_Year
IN ([2018], [2019], [2020], [2021])
) AS PVT


-- �ki g�nden ge� kargolanan sipari�lerin haftan�n g�nlerine g�re da��l�m�n� hesaplay�n�z.

SELECT *
FROM (
		SELECT DATENAME(DW, order_date) AS OrderDay,order_id
		FROM sale.orders
		WHERE DATEDIFF(DAY, order_date,shipped_date)>2
) AS A
PIVOT(
COUNT(order_id)
FOR OrderDay
IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday])
) AS PVT

---PIVOTSUZ ��Z�M

SELECT
    COUNT(CASE WHEN DATENAME(dw, order_date)='Monday' THEN 1 END) AS Monday,
	COUNT(CASE WHEN DATENAME(dw, order_date)='Tuesday' THEN 1 END) AS Tuesday,
	COUNT(CASE WHEN DATENAME(dw, order_date)='Wednesday' THEN 1 END) AS Wednesday,
	COUNT(CASE WHEN DATENAME(dw, order_date)='Thursday' THEN 1 END) AS Thursday,
	COUNT(CASE WHEN DATENAME(dw, order_date)='Friday' THEN 1 END) AS Friday,
	COUNT(CASE WHEN DATENAME(dw, order_date)='Saturday' THEN 1 END) AS Saturday,
	COUNT(CASE WHEN DATENAME(dw, order_date)='Sunday' THEN 1 END) AS Sunday
FROM sale.orders
WHERE DATEDIFF(DAY, order_date,shipped_date)>2;
