

---JOINS

--INNER JOIN
--Her iki tablodaki eþleþen kayýtlarý (kesiþim kümesi) bize getirir

-- Make a list of products showing the product ID, product name, category ID, and category name.

SELECT	product_id, product_name, product.category.category_id, product.category.category_name
FROM	product.product
		INNER JOIN
		product.category 
		ON product.product.category_id = product.category.category_id


SELECT	product_id, product_name, pc.category_id, pc.category_name
FROM	product.product AS pp
		INNER JOIN
		product.category AS pc
		ON pp.category_id = pc.category_id


SELECT	product_id, product_name, pc.category_id, pc.category_name
FROM	product.product AS pp
		JOIN
		product.category AS pc
		ON pp.category_id = pc.category_id



--List employees of stores with their store information.
--Maðaza çalýþanlarýný maðaza bilgileriyle birlikte listeleyin.
--Select first name, last name, store name


SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff AS A
		INNER JOIN
		sale.store AS B
		ON	A.store_id = B.store_id


------ LEFT JOIN ------
--Ýki tabloda ilk verilen tablonun sütunundaki ki tüm verileri, diðer tabloda ise sadece eþleþenleri getirir

--Hiç sipariþ edilmemiþ ürünleri döndüren bir sorgu yazýn
--Select product ID, product name, orderID

SELECT COUNT(product_id) -- product tablosundaki sipariþler
FROM	product.product


SELECT COUNT(DISTINCT product_id) -- order_item tablosundaki sipariþler
FROM	sale.order_item



SELECT	A.product_id, A.product_name, B.order_id
FROM	product.product AS A
		LEFT JOIN
		sale.order_item AS B 
		ON A.product_id = B.product_id
WHERE	B.order_id IS NULL


------////////

--Ürün kimliði 310'dan büyük olan ürünlerin maðazalardaki stok durumunu raporlayýn.
--Expected columns: product_id, product_name, store_id, product_id, quantity


SELECT *
FROM	product.product		-- product ta 310 dan büyük ürünler
WHERE	product_id > 310



SELECT	COUNT(DISTINCT product_id)-- stock tablosunda 310 dan büyük ürünler
FROM	product.stock
WHERE	product_id > 310


SELECT	COUNT (DISTINCT A.product_id)
FROM	product.product AS A
		INNER JOIN
		product.stock AS B
		ON	A.product_id = B.product_id
WHERE	A.product_id > 310



SELECT	A.product_id, A.product_name, B.*
FROM	product.product AS A
		LEFT JOIN
		product.stock AS B
		ON	A.product_id = B.product_id
WHERE	A.product_id > 310


SELECT	COUNT (DISTINCT A.product_id), COUNT (DISTINCT B.product_id)
FROM	product.product AS A
		LEFT JOIN
		product.stock AS B
		ON	A.product_id = B.product_id
WHERE	A.product_id > 310


----------------------


--RIGHT JOIN------////////
--Ýki tabloda ilk verilen tablonun sütununda kesiþimde olanlarý Ýkinci verilen tablo sütunundaki tüm deðerleri getirir.


--Ürün kimliði 310'dan büyük olan ürünlerin maðazalardaki stok durumunu raporlayýn.
--Expected columns: product_id, product_name, store_id, product_id, quantity


SELECT	B.product_id, B.product_name, A.*
FROM	product.stock AS A
		RIGHT JOIN
		product.product AS B
		ON	A.product_id = B.product_id
WHERE	B.product_id > 310


-----------

---Tüm personel tarafýndan yapýlan sipariþ bilgilerinin raporlanmasý

--Expected columns: staff_id, first_name, last_name, all the information about orders


SELECT	COUNT (DISTINCT staff_id)
FROM	sale.orders

SELECT	COUNT (DISTINCT staff_id)
FROM	sale.staff


SELECT	B.staff_id, B.first_name, B.last_name, A.*
FROM	sale.orders AS A
		RIGHT JOIN
		sale.staff AS B
		ON	A.staff_id = B.staff_id
ORDER BY 
		order_id


------ FULL OUTER JOIN ------
--Her iki tabloda istenen sütundaki tüm satýrlar gelir eþleþmeyenler NULL olur

--Tüm ürünler için stok ve sipariþ bilgilerini birlikte döndüren bir sorgu yazýn. Yalnýzca ilk 100 satýrý döndürün.
--Expected columns: Product_id, store_id, quantity, order_id, list_price


SELECT	TOP 100 A.product_id, B.order_id, B.list_price, C.store_id, C.quantity
FROM	product.product AS A
		FULL JOIN
		sale.order_item AS B
		ON	A.product_id = B.product_id
		FULL OUTER JOIN
		product.stock AS C
		ON A.product_id = C.product_id
ORDER BY
		2,4


------ CROSS JOIN ------
--Ýki tabloda verilen sütunlardaki her deðer için diðer tablodaki her deðere ayný deðeri atar 

SELECT	A.brand_name, B.category_name
FROM	product.brand AS A
		CROSS JOIN
		product.category AS B



/*
Stoklar tablosunda, ürün tablosunda tutulan tüm ürünler yok ve bu ürünleri stok tablosuna eklemek istiyorsunuz.
Tüm bu ürünleri her üç maðaza için "0 (sýfýr)" miktar ile eklemeniz gerekir.
*/


SELECT	B.store_id, A.product_id, 0 AS quantity
FROM	product.product AS A
		CROSS JOIN
		sale.store AS B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY 
		2


/*
INSERT product.stock
SELECT	B.store_id, A.product_id, 0 AS quantity
FROM	product.product AS A
		CROSS JOIN
		sale.store AS B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock) 
ORDER BY 
		2
*/


------ SELF JOIN ------

--Personel adlarýný yönetici adlarýyla birlikte döndüren bir sorgu yazýn
--Expected columns: staff first name, staff last name, manager name

SELECT	A.first_name AS manager_name, B.first_name AS staff_name
FROM	sale.staff AS A
		INNER JOIN
		sale.staff AS B
		ON A.staff_id = B.manager_id


SELECT	A.first_name AS staff_name, B.first_name AS manager_name
FROM	sale.staff AS A
		LEFT JOIN
		sale.staff AS B
		ON A.manager_id = B.staff_id



-----VIEWS
--Doðrudan database tablolarý yerine oluþturulan views ler ile çalýþýlýr. Bütün tablo sistemi yorar.
--Views ler tablolara baðlý olarak oluþturulan sanal tablolardýr.
;GO

CREATE VIEW customer_after_2019 AS
SELECT	B.first_name, B.last_name
FROM	sale.orders AS A
		INNER JOIN
		sale.customer AS B
		ON A.customer_id = B.customer_id
WHERE	A.order_date > '2019-01-01';


SELECT *
FROM	customer_after_2019

