




--Assign an ordinal number to the product prices for each category in ascending order

--1. Herbir kategori içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT category_id, list_price,
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price)
FROM	product.product
ORDER BY category_id, list_price




SELECT category_id, list_price,
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) rownum,
		ROW_NUMBER() OVER (ORDER BY list_price DESC) rn_2,
		ROW_NUMBER() OVER (ORDER BY category_id, list_price DESC) rn_2
FROM	product.product
ORDER BY category_id, list_price DESC



SELECT category_id, list_price,
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) rownum,
		RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) RANK_NUM,
		DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) DENSE_NUM
FROM	product.product



--SELECT COUNT(DISTINCT list_price) 
--from (
--SELECT category_id, list_price,
--		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) rownum,
--		RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) RANK_NUM,
--		DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) DENSE_NUM
--FROM	product.product
--WHERE category_id = 1) a


----------/////


-- Write a query that returns the cumulative distribution of the list price in product table by brand.

-- product tablosundaki list price' larýn kümülatif daðýlýmýný marka kýrýlýmýnda hesaplayýnýz


SELECT brand_id, list_price, 
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) CUMEDIST
FROM	product.product





---//////////////////


--Write a query that returns the relative standing of the list price in product table by brand.


SELECT brand_id, list_price, 
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) PERCENTRANK
FROM	product.product




---NTILE

SELECT	category_id, list_price, product_id,
		NTILE(10) OVER (PARTITION BY category_id ORDER BY list_price) NTILEE
FROM	product.product




----------------/////////////////////////---------------------


--Write a query that returns how many days are between the third and fourth order dates of each staff.
--Her bir personelin üçüncü ve dördüncü sipariþleri arasýndaki gün farkýný bulunuz.


WITH T1 AS (
			SELECT	staff_id, order_id, order_date,
					ROW_NUMBER() OVER (PARTITION BY staff_id ORDER BY order_id) row_num
			FROM	sale.orders
			)
, T2 AS (
			SELECT *
			FROM	T1
			WHERE	row_num = 3
		)
SELECT	T1.staff_id, T2.order_date AS third_order_date, T1.order_date AS forth_order_date,
		DATEDIFF(day, T2.order_date, T1.order_date) datedif
FROM	T1 INNER JOIN T2 ON T1.staff_id = T2.staff_id
WHERE	T1.row_num = 4



---lag


WITH T1 AS (
			SELECT	staff_id, order_id, order_date,
					LAG(order_date) OVER (PARTITION BY staff_id ORDER BY order_id) prev_ord_date,
					ROW_NUMBER() OVER (PARTITION BY staff_id ORDER BY order_id) row_num
			FROM	sale.orders
			)
SELECT	*, 
		DATEDIFF(day, prev_ord_date , order_date)
FROM	T1
WHERE	row_num = 4




-----------///////////////


--Write a query that returns both of the followings:
--Average product price.
--The average product price of orders.

SELECT	order_id,
					AVG(list_price) OVER () AS avg_prod_price,
					AVG(list_price) OVER (PARTITION BY order_id) AS avg_prod_price_by_order
			FROM	sale.order_item

-----

WITH T1 AS (
			SELECT	order_id,
					AVG(list_price) OVER () AS avg_prod_price,
					AVG(list_price) OVER (PARTITION BY order_id) AS avg_prod_price_by_order
			FROM	sale.order_item
			)
SELECT DISTINCT *
FROM	T1
WHERE	avg_prod_price < avg_prod_price_by_order



----------

--------///////

--Calculate the stores' weekly cumulative count of orders for 2018


--maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz


SELECT	DISTINCT B.store_id, B.store_name,
		DATEPART(WEEK, A.order_date) week_of_year,
		COUNT(order_id) OVER (PARTITION BY B.store_id, DATEPART(WEEK, A.order_date)) order_cnt_of_week
FROM	sale.orders AS A
		INNER JOIN
		sale.store AS B
		ON A.store_id = B.store_id
WHERE	YEAR(order_date) = 2018



--1. YOL
SELECT	DISTINCT B.store_id, B.store_name,
		DATEPART(WEEK, A.order_date) week_of_year,
		COUNT(order_id) OVER (PARTITION BY B.store_id ORDER BY DATEPART(WEEK, A.order_date)) cume_ord_cnt
FROM	sale.orders AS A
		INNER JOIN
		sale.store AS B
		ON A.store_id = B.store_id
WHERE	YEAR(order_date) = 2018

--2. YOL
WITH T1 AS (
			SELECT	DISTINCT B.store_id, B.store_name,
					DATEPART(WEEK, A.order_date) week_of_year,
					COUNT(order_id) OVER (PARTITION BY B.store_id, DATEPART(WEEK, A.order_date)) order_cnt_of_week
			FROM	sale.orders AS A
					INNER JOIN
					sale.store AS B
					ON A.store_id = B.store_id
			WHERE	YEAR(order_date) = 2018
			)
SELECT *, SUM(order_cnt_of_week) OVER (PARTITION BY store_id ORDER BY week_of_year)
FROM	T1



-------------


-----/////


--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.

--WITH T1 AS (
--			SELECT	DISTINCT order_date, SUM(quantity) OVER (PARTITION BY order_date) AS cnt_product
--			FROM	sale.orders AS A
--					INNER JOIN
--					sale.order_item AS B
--					ON A.order_id = B.order_id
--			WHERE	order_date BETWEEN '2018-03-12' AND '2018-04-12'
--			)
--SELECT *, AVG(cnt_product) OVER (ORDER BY order_date ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AVG_PROD_CNT
--FROM T1


WITH T1 AS (
			SELECT CAST('2018-03-12' AS DATE) ord_date
			UNION ALL
			SELECT	DATEADD(day, 1, ord_date) 
			FROM	T1
			WHERE	ord_date  < '2018-04-12'
		)
, T2 AS(
SELECT	DISTINCT T1.ord_date, ISNULL(SUM(quantity) OVER (PARTITION BY T1.ord_date), 0) AS cnt_product
FROM	sale.orders AS A
		RIGHT JOIN
		sale.order_item AS B
		ON A.order_id = B.order_id
		RIGHT JOIN
		T1 
		ON A.order_date = T1.ord_date
) 
SELECT *, AVG(cnt_product) OVER (ORDER BY ord_date ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AVG_PROD_CNT
FROM T2


