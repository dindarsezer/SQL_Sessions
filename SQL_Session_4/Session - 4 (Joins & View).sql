

---JOINS

--INNER JOIN
--Her iki tablodaki e�le�en kay�tlar� (kesi�im k�mesi) bize getirir

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
--Ma�aza �al��anlar�n� ma�aza bilgileriyle birlikte listeleyin.
--Select first name, last name, store name


SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff AS A
		INNER JOIN
		sale.store AS B
		ON	A.store_id = B.store_id


------ LEFT JOIN ------
--�ki tabloda ilk verilen tablonun s�tunundaki ki t�m verileri, di�er tabloda ise sadece e�le�enleri getirir

--Hi� sipari� edilmemi� �r�nleri d�nd�ren bir sorgu yaz�n
--Select product ID, product name, orderID

SELECT COUNT(product_id) -- product tablosundaki sipari�ler
FROM	product.product


SELECT COUNT(DISTINCT product_id) -- order_item tablosundaki sipari�ler
FROM	sale.order_item



SELECT	A.product_id, A.product_name, B.order_id
FROM	product.product AS A
		LEFT JOIN
		sale.order_item AS B 
		ON A.product_id = B.product_id
WHERE	B.order_id IS NULL


------////////

--�r�n kimli�i 310'dan b�y�k olan �r�nlerin ma�azalardaki stok durumunu raporlay�n.
--Expected columns: product_id, product_name, store_id, product_id, quantity


SELECT *
FROM	product.product		-- product ta 310 dan b�y�k �r�nler
WHERE	product_id > 310



SELECT	COUNT(DISTINCT product_id)-- stock tablosunda 310 dan b�y�k �r�nler
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
--�ki tabloda ilk verilen tablonun s�tununda kesi�imde olanlar� �kinci verilen tablo s�tunundaki t�m de�erleri getirir.


--�r�n kimli�i 310'dan b�y�k olan �r�nlerin ma�azalardaki stok durumunu raporlay�n.
--Expected columns: product_id, product_name, store_id, product_id, quantity


SELECT	B.product_id, B.product_name, A.*
FROM	product.stock AS A
		RIGHT JOIN
		product.product AS B
		ON	A.product_id = B.product_id
WHERE	B.product_id > 310


-----------

---T�m personel taraf�ndan yap�lan sipari� bilgilerinin raporlanmas�

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
--Her iki tabloda istenen s�tundaki t�m sat�rlar gelir e�le�meyenler NULL olur

--T�m �r�nler i�in stok ve sipari� bilgilerini birlikte d�nd�ren bir sorgu yaz�n. Yaln�zca ilk 100 sat�r� d�nd�r�n.
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
--�ki tabloda verilen s�tunlardaki her de�er i�in di�er tablodaki her de�ere ayn� de�eri atar 

SELECT	A.brand_name, B.category_name
FROM	product.brand AS A
		CROSS JOIN
		product.category AS B



/*
Stoklar tablosunda, �r�n tablosunda tutulan t�m �r�nler yok ve bu �r�nleri stok tablosuna eklemek istiyorsunuz.
T�m bu �r�nleri her �� ma�aza i�in "0 (s�f�r)" miktar ile eklemeniz gerekir.
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

--Personel adlar�n� y�netici adlar�yla birlikte d�nd�ren bir sorgu yaz�n
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
--Do�rudan database tablolar� yerine olu�turulan views ler ile �al���l�r. B�t�n tablo sistemi yorar.
--Views ler tablolara ba�l� olarak olu�turulan sanal tablolard�r.
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

