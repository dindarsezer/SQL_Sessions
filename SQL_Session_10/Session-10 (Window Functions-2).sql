

---SESSION 10 

---window frames


SELECT	*, SUM(quantity) OVER ()
FROM	sale.order_item


SELECT	*, SUM(quantity) OVER (PARTITION BY order_id)
FROM	sale.order_item


--Analitik aggregate fonksiyonlarýnda order by kullanýmý kümülatif iþlem yapýlmasýný saðlar.

SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY item_id ASC)
FROM	sale.order_item


SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY product_id ASC)
FROM	sale.order_item


-------------

SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY item_id ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) --DEFAULT WINDOW FRAME
FROM	sale.order_item


SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY item_id ASC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
FROM	sale.order_item



SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY item_id ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
FROM	sale.order_item


SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY item_id ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
FROM	sale.order_item



SELECT	*, SUM(quantity) OVER (PARTITION BY order_id ORDER BY item_id ASC ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) 
FROM	sale.order_item



------------------//////////////////////////////--------------------


-- 2. ANALYTIC NAVIGATION FUNCTIONS --





--FIRST_VALUE() - 

--Write a query that returns one of the most stocked product in each store.


--CAUTION! There are more than one product has same quantity in each store.

SELECT	DISTINCT store_id, FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC) most_stocked_prod
FROM	product.stock



-----////


--Write a query that returns customers and their most valuable order with total amount of it.

WITH T1 AS (
				SELECT	B.customer_id, A.order_id, SUM(quantity*list_price*(1-discount)) AS total_amount
				FROM	sale.order_item AS A
						INNER JOIN
						sale.orders AS B
						ON A.order_id = B.order_id
				GROUP BY
						B.customer_id, A.order_id
				)
SELECT  DISTINCT customer_id,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY total_amount DESC) most_val_order,
		FIRST_VALUE(total_amount) OVER (PARTITION BY customer_id ORDER BY total_amount DESC) total_amount
FROM	T1


-----///////////////


---Write a query that returns first order date by month
---Her ay için ilk sipariþ tarihini gösteriniz.


SELECT	order_date, YEAR (order_date) ord_year, MONTH (order_date) ord_month
FROM	sale.orders



SELECT	DISTINCT YEAR (order_date) ord_year, MONTH (order_date) ord_month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR (order_date) , MONTH (order_date) ORDER BY order_date) first_ord_date
FROM	sale.orders


--------------


--LAST VALUE

--Write a query that returns most stocked product in each store. (Use Last_Value)

--CAUTION! There are more than one product has same quantity in each store.


SELECT *
FROM	product.stock
ORDER BY 
		store_id, quantity ASC, product_id DESC



SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock


---------

--LAG() - LEAD()


--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
--1. Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)


SELECT	B.staff_id, B.first_name, B.last_name, order_id, order_date,
		LAG(order_date) OVER (PARTITION BY B.staff_id ORDER BY order_id) prev_ordr_date
		
		
FROM	sale.orders AS A
		INNER JOIN
		sale.staff AS B
		ON A.staff_id = B.staff_id
ORDER BY
		1, 4



SELECT	B.staff_id, B.first_name, B.last_name, order_id, order_date,
		LAG(order_date, 1, order_date) OVER (PARTITION BY B.staff_id ORDER BY order_id) prev_ordr_date
FROM	sale.orders AS A
		INNER JOIN
		sale.staff AS B
		ON A.staff_id = B.staff_id



SELECT	B.staff_id, B.first_name, B.last_name, order_id, order_date,
		LAG(CAST(order_date AS VARCHAR(10)), 1, 'NO PREV_ORDER') OVER (PARTITION BY B.staff_id ORDER BY order_id) prev_ordr_date
FROM	sale.orders AS A
		INNER JOIN
		sale.staff AS B
		ON A.staff_id = B.staff_id


---------------


--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)
--2. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LEAD fonksiyonunu kullanýnýz)


SELECT	B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
		LEAD(order_date) OVER (PARTITION BY B.staff_id ORDER BY order_id) next_ord_date
FROM	sale.orders AS A
		INNER JOIN
		sale.staff AS B
		ON A.staff_id = B.staff_id	



---çalýþanlarýn performanslarý


WITH T1 AS (
			SELECT	B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
					LEAD(order_date) OVER (PARTITION BY B.staff_id ORDER BY order_id) next_ord_date,
					DATEDIFF(day, order_date, LEAD(order_date) OVER (PARTITION BY B.staff_id ORDER BY order_id)) daydiff_from_ord_dates
			FROM	sale.orders AS A
					INNER JOIN
					sale.staff AS B
					ON A.staff_id = B.staff_id	
			)
SELECT	staff_id, first_name, last_name, AVG(daydiff_from_ord_dates) avg_day_diff
FROM	T1
GROUP BY staff_id, first_name, last_name




------------///////////////

--Write a query that returns the difference order count between the current month and the next month for eachh year. 
--Her bir yýl için peþ peþe gelen aylarýn sipariþ sayýlarý arasýndaki farklarý bulunuz.

WITH T1 AS (
			SELECT	DISTINCT YEAR(order_date) ord_year, MONTH(order_date) ord_month,
					COUNT(order_id) OVER (PARTITION BY YEAR(order_date), MONTH(order_date)) cnt_order
			FROM	sale.orders
			)
SELECT *,
		LEAD(ord_month) OVER(PARTITION BY ord_year ORDER BY ord_month) next_month,
		LEAD(cnt_order) OVER (PARTITION BY ord_year ORDER BY ord_month) next_month_ord_cnt,
		cnt_order - LEAD(cnt_order) OVER (PARTITION BY ord_year ORDER BY ord_month) order_cnt_diff
FROM	T1









