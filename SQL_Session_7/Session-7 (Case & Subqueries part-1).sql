
---------Case Expression

--Her bir çalýþanýn yanýna store isimlerini yazdýrýn:
--1. Davi Techno Retail 2. Burkes Outlet 3. The BFLO Store


SELECT	first_name, last_name, store_id,
		CASE store_id
		WHEN 1 THEN 'Davi Techno Retail'
		WHEN 2 THEN 'Burkes Outlet'
		WHEN 3 THEN 'The BFLO Store'
		END AS store_name
FROM	sale.staff


SELECT	first_name, last_name, store_id,
		CASE store_id
		WHEN 1 THEN 'Davi Techno Retail'
		WHEN 2 THEN 'Burkes Outlet'
		ELSE 'The BFLO Store'
		END AS store_name
FROM	sale.staff


---Boþ býrakýlan seçenekler için NULL atanýr.

SELECT	first_name, last_name, store_id,
		CASE store_id
		WHEN 1 THEN 'Davi Techno Retail'
		WHEN 2 THEN 'Burkes Outlet'
		END AS store_name
FROM	sale.staff

---------------



------ Searched Case Expression -----



--Create  a new column with the meaning of the  values in the Order_Status column.  (use searched case ex.)
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

--Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun.


SELECT	order_id, order_status, 
		CASE 
			WHEN order_status = 4 THEN 'Completed'
			WHEN order_status = 3 THEN 'Rejected'
			WHEN order_status = 2 THEN 'Processing'
			ELSE 'Pending'
		END AS status_desc
FROM	sale.orders




-- Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.
-- Ayný sipariþte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariþ veren müþterileri bulunuz.


SELECT	F.customer_id, F.first_name, F.last_name, C.order_id,
		SUM(CASE A.category_name WHEN 'Computer Accessories' THEN 1 END) AS comp_acc,
		SUM(CASE A.category_name WHEN 'Speakers' THEN 1 END) AS speakers, 
		SUM(CASE A.category_name WHEN 'mp4 player' THEN 1 END) AS mp4_player 
FROM	product.category AS A
		INNER JOIN
		product.product AS B
		ON A.category_id = B.category_id
		INNER JOIN
		sale.order_item AS C
		ON B.product_id = C.product_id
		INNER JOIN
		sale.orders AS D
		ON C.order_id = D.order_id
		INNER JOIN
		sale.customer AS F
		ON D.customer_id = F.customer_id
GROUP BY
		F.customer_id, F.first_name, F.last_name, C.order_id
HAVING
		SUM(CASE A.category_name WHEN 'Computer Accessories' THEN 1 END) IS NOT NULL
		AND
		SUM(CASE A.category_name WHEN 'Speakers' THEN 1 END) IS NOT NULL
		AND
		SUM(CASE A.category_name WHEN 'mp4 player' THEN 1 END) IS NOT NULL






----------------///////////////////////----------------





--------------------SUBQUERIES & CTE'S-----------------



--Write a query that shows all employees in the store where Davis Thomas works.

-- Davis Thomas'nýn çalýþtýðý maðazadaki tüm personelleri listeleyin.


SELECT *
FROM	sale.staff
WHERE	store_id = (
					SELECT	store_id
					FROM	sale.staff
					WHERE	first_name = 'Davis'
					AND		last_name = 'Thomas'
					)

--------------------



-- /////////

-- Write a query that shows the employees for whom Charles Cussona is a first-degree manager. 
--(To which employees are Charles Cussona a first-degree manager?)
-- Charles	Cussona 'ýn yöneticisi olduðu personelleri listeleyin.


SELECT *
FROM	sale.staff
WHERE	manager_id = (
						SELECT	staff_id
						FROM	sale.staff
						WHERE	first_name = 'Charles'
						AND		last_name = 'Cussona'
						)

/*
SELECT *
FROM	sale.staff
WHERE	manager_id >= (1,2)


---


SELECT *
FROM	sale.staff
WHERE	manager_id = (
						SELECT	staff_id
						FROM	sale.staff
						WHERE	 store_id = 1
						)

*/



-- ///////////////


-- Write a query that returns the customers located where ‘The BFLO Store' is located.
-- 'The BFLO Store' isimli maðazanýn bulunduðu þehirdeki müþterileri listeleyin.


SELECT	*
FROM	sale.customer
WHERE	city = (SELECT city FROM sale.store WHERE store_name = 'The BFLO Store')



SELECT	*
FROM	sale.customer
WHERE	city IN (SELECT city FROM sale.store WHERE store_name = 'The BFLO Store')


----

SELECT	b.*
FROM	sale.store AS A
		INNER JOIN 
		sale.customer AS B
		ON A.city = B.city
WHERE	A.store_name = 'The BFLO Store'		




--//////

--Write a query that returns the list of products that are more expensive than the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr.

SELECT *
FROM	product.product
WHERE	list_price > 4295.98


---

SELECT *
FROM	product.product
WHERE	list_price > (
						SELECT	list_price
						FROM	product.product
						WHERE	product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
						)



------ MULTIPLE ROW SUBQUERIES ------


--/////////////////


-- Write a query that returns customer first names, last names and order dates. 
-- The customers who are order on the same dates as Laurel Goldammer.

-- Laurel Goldammer isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.


SELECT	order_date
FROM	sale.customer AS A
		INNER JOIN
		sale.orders AS B
		ON A.customer_id = B.customer_id
WHERE	first_name = 'Laurel'
AND		last_name = 'Goldammer'


----

SELECT	DISTINCT B.first_name, B.last_name, A.order_date
FROM	sale.orders A
		INNER JOIN 
		sale.customer B
		ON A.customer_id = B.customer_id
WHERE	order_date IN (
							SELECT	order_date
							FROM	sale.customer AS A
									INNER JOIN
									sale.orders AS B
									ON A.customer_id = B.customer_id
							WHERE	first_name = 'Laurel'
							AND		last_name = 'Goldammer'
						)

/*
SELECT *
FROM	sale.orders
WHERE	order_date = ANY (
							SELECT	order_date
							FROM	sale.customer AS A
									INNER JOIN
									sale.orders AS B
									ON A.customer_id = B.customer_id
							WHERE	first_name = 'Laurel'
							AND		last_name = 'Goldammer'
						)
*/
----------

SELECT	DISTINCT Y.first_name, Y.last_name, X.order_date
FROM	(
			SELECT	order_date
			FROM	sale.customer AS A
					INNER JOIN
					sale.orders AS B
					ON A.customer_id = B.customer_id
			WHERE	first_name = 'Laurel'
			AND		last_name = 'Goldammer'
		) lo_or
		INNER JOIN
		sale.orders X
		ON lo_or.order_date = X.order_date
		INNER JOIN 
		sale.customer Y
		ON X.customer_id = Y.customer_id


-----/////////////



--List the products that ordered in the last 10 orders in Buffalo city.
-- Buffalo þehrinde son 10 sipariþte sipariþ verilen ürünleri listeleyin.


SELECT	TOP (10) B.*
FROM	sale.customer A 
		INNER JOIN
		sale.orders B
		ON A.customer_id = B.customer_id
WHERE	city = 'Buffalo'
ORDER BY 
		B.order_id DESC


SELECT	DISTINCT product_name
FROM	sale.order_item AS X
		INNER JOIN 
		product.product AS Y
		ON X.product_id = Y.product_id
WHERE
		X.order_id IN (
							SELECT	TOP (10) order_id
							FROM	sale.customer A 
									INNER JOIN
									sale.orders B
									ON A.customer_id = B.customer_id
							WHERE	city = 'Buffalo'
							ORDER BY 
									B.order_id DESC
						)


----


SELECT	product_name 
FROM	product.product 
WHERE	product_id = any (
							select	product_id 
							FROM	sale.order_item 
							where	order_id = any (
													SELECT	top 10 order_id 
													FROM	sale.orders 
													WHERE	customer_id IN (
																				SELECT customer_id 
																				from sale.customer   
																				WHERE city = 'Buffalo') 
													ORDER by order_id DESC
												)
) 
ORDER by product_name


----------------------------






















