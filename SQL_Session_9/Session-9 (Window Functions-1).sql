


---SESSION 9 

----WINDOW FUNCTIONS-1



------//////////////////


--List the stores whose turnovers are under the average store turnovers in 2018.
--2018 yýlýnda tüm maðazalarýn ortalama cirosunun altýnda ciroya sahip maðazalarý listeleyin.

WITH T1 AS (
			SELECT	B.store_id, 
					SUM(quantity*list_price*(1-discount)) turnover
			FROM	sale.order_item AS A
					INNER JOIN
					sale.orders AS B
					ON A.order_id = B.order_id
			WHERE	YEAR (B.order_date) = 2018
			GROUP BY B.store_id
			)
, T2 AS (
		SELECT	AVG(turnover) avg_turnover
		FROM	T1
		)
SELECT	X.store_id, X.store_name, turnover, avg_turnover
FROM	T1 
		INNER JOIN 
		T2 
		ON T1.turnover < T2.avg_turnover
		INNER JOIN
		sale.store AS X
		ON T1.store_id = X.store_id
ORDER BY x.store_id


-------------

-----------/////////////


-- Write a query that returns the net amount of their first order for customers who placed their first order after 2019-10-01.
--Ýlk sipariþini 2019-10-01 tarihinden sonra veren müþterilerin ilk sipariþlerinin net tutarýný döndürünüz.


WITH T1 AS (
			SELECT	customer_id, MIN(order_date) first_ord_date, MIN (order_id) first_ord
			FROM	sale.orders
			GROUP BY customer_id
			HAVING	MIN(order_date) > '2019-10-01'
			)
SELECT	C.customer_id, C.first_name, C.last_name, T1.first_ord, SUM (list_price*quantity*(1-discount)) net_total
FROM	T1
		INNER JOIN
		sale.order_item AS B
		ON T1.first_ord = B.order_id
		INNER JOIN
		sale.customer AS C
		ON T1.customer_id = C.customer_id
GROUP BY
		C.customer_id, C.first_name, C.last_name, T1.first_ord




----------------------////////////////////////////////-------------------



----WINDOW FUNCTIONS

--Write a query that returns the total stock amount of each product in the stock table.
--ürünlerin stock sayýlarýný bulunuz


SELECT	product_id, SUM(quantity)
FROM	 product.stock
GROUP BY
		product_id
ORDER BY
			1


SELECT	SUM(quantity) OVER ()
FROM	 product.stock


SELECT	 product_id, SUM(quantity) OVER ()
FROM	 product.stock



SELECT	*, SUM(quantity) OVER (PARTITION BY product_id) total_quantity
FROM	product.stock


SELECT	DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) AS total_quantity
FROM	product.stock
ORDER BY total_quantity
		
----

----/////


-- Write a query that returns average product prices of brands. 

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.



SELECT	brand_id, AVG(list_price) avg_brand_price
FROM	 product.product
GROUP BY brand_id


SELECT	DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) avg_brand_price
FROM	 product.product


---///////////////



-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()

--///

-- What is the cheapest product price for each category?
-- Herbir kategorideki en ucuz ürünün fiyatý

SELECT	DISTINCT category_id, MIN (list_price) OVER(PARTITION BY category_id)
FROM	product.product



--///


-- How many different product in the product table?
-- Product tablosunda toplam kaç faklý product bulunduðu


SELECT	COUNT(product_name)
FROM	product.product

SELECT	COUNT(DISTINCT product_name)
FROM	product.product




SELECT	DISTINCT COUNT(product_id) OVER ()
FROM	product.product

SELECT	COUNT(DISTINCT product_id) OVER ()
FROM	product.product



---////

-- How many different product in the order_item table?
-- Order_item tablosunda kaç farklý ürün bulunmaktadýr?

SELECT	 *
FROM	 sale.order_item



SELECT	 DISTINCT COUNT(product_id) OVER ()
FROM	 sale.order_item



SELECT	 COUNT(DISTINCT product_id)
FROM	 sale.order_item




SELECT	DISTINCT COUNT(product_id) OVER ()
FROM	(
		SELECT	 DISTINCT product_id
		FROM	 sale.order_item
		) AS A

-------------------



--////

-- How many different product are in each brand in each category?
-- Herbir kategorideki herbir markada kaç farklý ürünün bulunduðunu raporlayýn.


SELECT	DISTINCT category_id, brand_id, COUNT (product_id) OVER (PARTITION BY category_id, brand_id)
FROM	product.product



