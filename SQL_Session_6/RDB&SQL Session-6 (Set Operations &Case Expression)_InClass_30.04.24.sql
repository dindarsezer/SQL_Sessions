

/* ///////////////SET OPERATIONS - CASE EXPRESSION//////////////// */


-------------------------- SET OPERATIONS ---------------------------

/*
Set operatörleri kullanırken dikkat edilecek iki temel husus:

1. sütunların aynı sayıda olması gerekiyor.

2. ve veri tiplerinin uyumlu olması gerekiyor.

Ayrıca ;

3. Set operatörleri ile birlikte ORDER BY, GROUP BY ve HAVING gibi diğer Query sözcükleri kullanılabiliyor.

4. Birleştirme işleminden sonra eğer ORDER BY ile bir sıralama yapmak istiyorsak 
bunu son SELECT statementta kullanmamız yeterli. 

5. UNION ve INTERSECT operatörlerini kullanacaksak hangi SELECT statement'ın başa yazılacağının 
bir önemi yok. Fakat EXCEPT'te fark ediyor.

6. Union ALL, kaynakları duplicate kayıtların filtrelenmesi ve sonuç kümesinin sıralanması konusunda 
harcamadığı için Union'a kıyasla daha iyi performans gösterir.

Ancak Union'ın Uninon All'dan daha hızlı olduğu istisnai durumlar olabilir. 
Nedeni: UNION, duplicate öğeleri silerek birleştirir. Bu işlem bellekte yapılır ve bu genellikle ağ üzerinden 
veri göndermekten daha hızlıdır. 

Ağ iletişiminin darboğaz olduğu durumlarda ve datada çok fazla sayıda 
duplicate veri varsa UNION ALL performansı UNION'a göre düşük olabilir. 

7. Set operatörleri, CTE (Common Table Expressions) ile birlikte kullanılabiliyor. 
Veya bir subquerinin parçası olabiliyor. 
 

 
 ----------UNION / UNION ALL------------

Question: List the products sold in the cities of Charlotte and Aurora

Charlotte şehrinde satılan ürünler ile Aurora şehrinde satılan ürünleri listeleyin */

SELECT product_name
FROM sale.customer c
INNER JOIN sale.orders o ON c.customer_id = o.customer_id
INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
INNER JOIN product.product p ON oi.product_id=p.product_id
WHERE city = 'Charlotte'

UNION

SELECT product_name
FROM sale.customer c
INNER JOIN sale.orders o ON c.customer_id = o.customer_id
INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
INNER JOIN product.product p ON oi.product_id=p.product_id
WHERE city = 'Aurora'

-- AYNI SORGUYU UNION ALL İLE YAPARSAK:

SELECT	p.product_name
FROM	sale.customer c, sale.orders o, sale.order_item oi, product.product p
WHERE	c.customer_id = o.customer_id
AND		o.order_id = oi.order_id
AND		oi.product_id = p.product_id
AND		city = 'Charlotte'

UNION ALL

SELECT	p.product_name
FROM	sale.customer c, sale.orders o, sale.order_item oi, product.product p
WHERE	c.customer_id = o.customer_id
AND		o.order_id = oi.order_id
AND		oi.product_id = p.product_id
AND		city = 'Aurora'


-- IN OPERATÖRÜ İLE UNION ALL İLE AYNI SONUCU ELDE EDEBİLİR MİYİZ?

SELECT product_name 
FROM sale.customer c
INNER JOIN sale.orders o ON c.customer_id=o.customer_id
INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
INNER JOIN product.product p ON oi.product_id=p.product_id
WHERE city IN ('Charlotte', 'Aurora')


-- UNION SONUCUNU ELDE ETMEK İÇİN:

SELECT DISTINCT product_name 
FROM sale.customer c
INNER JOIN sale.orders o ON c.customer_id=o.customer_id
INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
INNER JOIN product.product p ON oi.product_id=p.product_id
WHERE city IN ('Charlotte', 'Aurora')



/* SOME IMPORTANT RULES OF UNION / UNION ALL

- Sütunların içeriği farklı olsa da veri tipinin aynı olması gerekiyor.

- veri tipleri aynı diye her sütunu birletireceğiz diye bir kaide yok. 
Amacımıza hizmete edecek şekilde birleştirme yapmalıyız.

- sütun sayıları aynı olmalı.
*/

SELECT brand_id
FROM product.brand
UNION
SELECT category_id
FROM product.category


SELECT brand_id
FROM product.brand
UNION ALL
SELECT category_id
FROM product.category

-- FARKLI İKİ VERİ TİPİNE SAHİP SÜTUNLARI BİRLEŞTİRMEYE ÇALIŞALIM.

SELECT brand_name
FROM product.brand
UNION ALL
SELECT category_id
FROM product.category

-- HATA!!  Conversion failed when converting the varchar value 'Samsung' to data type int.
-- SORGULARDAN GELEN VERİ TİPLERİNE DİKKAT!!


-- Her iki select statement da aynı sütun sayısına sahip olmalı:

SELECT *
FROM product.brand
UNION ALL
SELECT *
FROM product.category

-- sütun sayılarını bozalım ve tekrar deneyelim:

SELECT *
FROM product.brand
UNION ALL
SELECT category_id
FROM product.category

-- HATA! All queries combined using a UNION, INTERSECT or EXCEPT operator must have an equal number of expressions in their target lists.



-- FARKLI BİR DATABASE'DEN ALDIĞIMIZ RESULT'I BİRLEŞTİREBİLİR MİYİZ?

SELECT *
FROM [covid].[dbo].[covid]


SELECT county_name
FROM [covid].[dbo].[covid]
UNION ALL
SELECT city
FROM sale.customer

-- SÜTUN SAYILARI VE DATA TİPLERİ UYUŞTUĞU SÜRECE SORUN YOK. İKİ FARKI DATABASE'DEN BİLGİLER BİRLEŞTİRİLEBİLİYOR


/* Question: Write a query that returns all customers whose  first or last name is Thomas.  
 (don't use 'OR')

 Adı veya soyadı Thomas olan tüm müşterileri döndüren bir query yazın. */


 SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION ALL

SELECT first_name, last_name
FROM sale.customer
WHERE last_name  = 'Thomas'



 

--------------INTERSECT---------------

/* Question: Write a query that returns all brands with products for both 2018 and 2020 model year.

Model yılı hem 2018 hem de 2020 olan ürünlere sahip olan tüm markaları döndüren bir sorgu yazın.*/


SELECT brand_id
FROM product.product
WHERE model_year = 2018

INTERSECT

SELECT brand_id
FROM product.product
WHERE model_year = '2020'

-- brand_id'lerin yanına brand_name'leri de getirmek istersek:

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
	AND	model_year = 2018

INTERSECT

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
	AND	model_year = 2020


-- JOIN KULLANMADAN:

SELECT brand_id, brand_name
FROM product.brand
WHERE brand_id  IN
					(SELECT brand_id
					FROM product.product
					WHERE model_year = 2018
					INTERSECT
					SELECT brand_id
					FROM product.product
					WHERE model_year = '2020'
					)



-- model yılını da görmek istersek:

SELECT A.brand_id, B.brand_name, A.model_year
FROM product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
	AND	model_year = 2018

INTERSECT

SELECT A.brand_id, B.brand_name, A.model_year
FROM product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
	AND	model_year = 2020

-- INTERSECT, her iki SELECT statement'tan dönen recordların kesişim kümesini alır!!!
-- ilk SELECT'te yalnızca 2018 model_year verileri var. ikincide yalnızca 2020 model_year verileri var.
-- bunların kesişimleri boş kümedir.




/* Question: Write a query that returns the first and the last names of the customers 
who placed orders in all of 2018, 2019, and 2020.

2018, 2019 ve 2020 yıllarının hepsinde de sipariş veren müşterilerin ad ve soyadlarını 
döndüren bir query yazın.*/

SELECT *
FROM sale.orders


SELECT customer_id
FROM sale.orders
WHERE YEAR(order_date) = 2018
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE YEAR(order_date) = 2019
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE YEAR(order_date) = 2020


SELECT first_name, last_name
FROM sale.customer
WHERE customer_id IN ( 
					SELECT customer_id
					FROM sale.orders
					WHERE YEAR(order_date) = 2018
					INTERSECT
					SELECT customer_id
					FROM sale.orders
					WHERE YEAR(order_date) = 2019
					INTERSECT
					SELECT customer_id
					FROM sale.orders
					WHERE YEAR(order_date) = 2020
					);


SELECT	A.customer_id, first_name, last_name
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		YEAR (A.order_date) = 2018
INTERSECT 
SELECT	A.customer_id, first_name, last_name
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		YEAR (A.order_date) = 2019
INTERSECT 
SELECT	A.customer_id, first_name, last_name
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		YEAR (A.order_date) = 2020;





---------- EXCEPT-----------


/* Question: Write a query that returns the brands have  2018 model products but not 2019 model products.

2018 model ürünü olan markalarından hangilerinin 2019 model ürünü yoktur? 
(brand_id ve brand_name değerlerini listeleyin.) */


SELECT brand_id
FROM product.product
WHERE model_year = 2018

EXCEPT

SELECT brand_id
FROM product.product
WHERE model_year = 2019


CREATE VIEW t_2018 AS
				SELECT brand_id
				FROM product.product
				WHERE model_year = 2018
				EXCEPT
				SELECT brand_id
				FROM product.product
				WHERE model_year = 2019


SELECT b.brand_id, a.brand_name
FROM product.brand a, t_2018 b
WHERE a.brand_id = b.brand_id


-- JOIN YÖNTEMİ İLE ÇÖZÜM :

SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	model_year = 2018
AND		A.brand_id = B.brand_id
EXCEPT
SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	model_year = 2019
AND		A.brand_id = B.brand_id


-- SUBQUERY ÇÖZÜMÜ:
SELECT brand_id, brand_name
FROM product.brand
WHERE brand_id IN (
					SELECT brand_id
					FROM product.product
					WHERE model_year =2018

					EXCEPT

					SELECT brand_id
					FROM product.product
					WHERE model_year =2019
					)



/* Question:  Write a query that contains only products ordered in 2019
(Result not include products ordered in other years)

Sadece 2019 yılında sipariş verilen diğer yıllarda sipariş verilmeyen ürünleri getiriniz.*/

SELECT oi.product_id, product_name
FROM sale.orders o
INNER JOIN sale.order_item oi on o.order_id=oi.order_id
INNER JOIN product.product p ON oi.product_id = p.product_id
WHERE YEAR(o.order_date) = 2019

EXCEPT

SELECT oi.product_id, product_name
FROM sale.orders o
INNER JOIN sale.order_item oi on o.order_id=oi.order_id
INNER JOIN product.product p ON oi.product_id = p.product_id
WHERE YEAR(o.order_date) <> 2019


-- JOIN işlemini WHERE ile yaparsak:
SELECT  oi.product_id, p.product_name
FROM sale.orders o, sale.order_item oi, product.product p
WHERE o.order_id = oi.order_id AND oi.product_id = p.product_id AND YEAR(o.order_date)=2019

EXCEPT

SELECT  oi.product_id, p.product_name
FROM sale.orders o, sale.order_item oi, product.product p
WHERE o.order_id = oi.order_id AND oi.product_id = p.product_id AND YEAR(o.order_date)<>2019;


/* EXCEPT zaten unique değerlerle çalıştığı için sorgularda DISTINCT kullanarak
maliyeti arttırmaya gerek yok.

------------- ÖNEMLİ NOKTALARI TEKRAR EDELİM --------------

Set operatörleri kullanırken dikkat edilecek iki temel husus:

1. sütunların aynı sayıda olması gerekiyor.

2. ve veri tiplerinin uyumlu olması gerekiyor.

Ayrıca ;

3. Set operatörleri ile birlikte ORDER BY, GROUP BY ve HAVING gibi diğer Query sözcükleri kullanılabiliyor.

4. Birleştirme işleminden sonra eğer ORDER BY ile bir sıralama yapmak istiyorsak 
bunu son SELECT statementta kullanmamız yeterli. 

5. UNION ve INTERSECT operatörlerini kullanacaksak hangi SELECT statement'ın başa yazılacağının 
bir önemi yok. Fakat EXCEPT'te fark ediyor.

6. Union ALL, kaynakları duplicate kayıtların filtrelenmesi ve sonuç kümesinin sıralanması konusunda 
harcamadığı için Union'a kıyasla daha iyi performans gösterir.

Ancak Union'ın Uninon All'dan daha hızlı olduğu istisnai durumlar olabilir. 
Nedeni: UNION, duplicate öğeleri silerek birleştirir. Bu işlem bellekte yapılır ve bu genellikle ağ üzerinden 
veri göndermekten daha hızlıdır. 

Ağ iletişiminin darboğaz olduğu durumlarda ve datada çok fazla sayıda 
duplicate veri varsa UNION ALL performansı UNION'a göre düşük olabilir. 

7. Set operatörleri, CTE (Common Table Expressions) ile birlikte kullanılabiliyor. 
Veya bir subquerinin parçası olabiliyor. 
  



---------------------------- CASE EXPRESSION ----------------------------


CASE ifadesi, belirli koşullara bağlı olarak farklı değerlerin döndürülmesini sağlayan bir kontrol yapısıdır.

İki tür CASE ifadesi var:

1. Simple CASE:

Simple CASE, bir alanı ya da ifadeyi bir basit ifadeyle karşılaştırarak sonucu belirler.

Syntax:

CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ...
    ELSE default_result
END



2. Searched CASE:

Searched CASE ifadesi; her bir WHEN koşulunun bir dizi Boolean ifadeyle ayrı ayrı 
değerlendirildiği bir kontrol yapısıdır.

Sytax:

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE default_result
END


- CASE ifadesi, SELECT ifadesinde yeni sütunlar oluşturmak için kullanılabilir.

- Bunu sorgu sonuçlarını kategorilere ayırmak veya farklı koşullara göre farklı değerler 
döndürmek için kullanıyoruz.

- Oluşturulacak yeni sütunu, END keywordünden sonra AS keywordü ile adlandırıyoruz.

- SELECT ifadesindeki diğer sütunlara neler uygulanabiliyorsa CASE ifadesine de bunlar uygulanabiliyor
(örneğin bunlara sıralama, gruplama veya filtreleme yapılabilir.)



------ 1. Simple Case Expression -----


Question: Create  a new column with the meaning of the  values in the Order_Status column. 

Order_Status isimli alandaki değerlerin ne anlama geldiğini içeren yeni bir alan oluşturun.

 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed */

 

 SELECT *
 FROM sale.orders


SELECT order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Proccessing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END  order_status_mapping
FROM sale.orders



/* Create a new column with the names of the stores to be consistent with the values 
in the store_ids column.

store_id'leri sütunundaki değerlerle tutarlı olacak şekilde mağaza adlarını içeren 
yeni bir sütun oluşturun */

SELECT store_id
FROM sale.staff


SELECT DISTINCT store_id
FROM sale.staff


SELECT	first_name, last_name, store_id,
		CASE store_id  -- store_id value'larını teker teker kontrol et..
			WHEN 1 THEN 'Davi techno Retail'  -- eğer 1 ise 'Davi techno Retail yaz.
			WHEN 2 THEN 'The BFLO Store'  -- eğer 2 ise 'The BFLO Store' yaz.
			ELSE 'Burkes Outlet' -- diğer tüm durumlarda 'Burkes Outlet' yaz.
		END Store_name
FROM	sale.staff;



-------- 2. Searched Case Expression -------


/* Question: Create  a new column with the meaning of the  values in the Order_Status column.  
(use searched case ex.)

 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

Order_Status isimli alandaki değerlerin ne anlama geldiğini içeren yeni bir alan oluşturun.*/







/* Create a new column that shows which email service provider 
("Gmail", "Hotmail", "Yahoo" or "Other" ).

Müşterilerin e-mail adreslerindeki servis sağlayıcılarını yeni bir sütun oluşturarak belirtiniz.*/








/* Question: Write a query that gives the first and last names of customers 
who have ordered products from the computer accessories, speakers, and mp4 player categories 
in the same order.

Aynı siparişte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde
ürün sipariş veren müşterileri bulunuz.*/









/*
Question: By creating a new column, label the orders according to the instructions below:

Label the products as 'Not Shipped' if they were NOT shipped.
Label the products as 'Fast' if they were shipped on the day of order.
Label the products as 'Normal' if they were shipped within two days of the order date.
Label the products as 'Slow' if they were shipped later than two days after the order date.
*/










/* Question: Write a query that returns the count of the orders day by day 
in a pivot table format that has been shipped two days later.

2 günden geç kargolanan siparişlerin haftanın günlerine göre dağılımını hesaplayınız.*/











