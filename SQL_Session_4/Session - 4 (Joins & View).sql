

---JOINS

--INNER JOIN

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

--Select first name, last name, store name


SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff AS A
		INNER JOIN
		sale.store AS B
		ON	A.store_id = B.store_id



------ LEFT JOIN ------

--Write a query that returns products that have never been ordered
--Select product ID, product name, orderID


SELECT COUNT(product_id)
FROM	product.product


SELECT COUNT(DISTINCT product_id)
FROM	sale.order_item



SELECT	A.product_id, A.product_name, B.order_id
FROM	product.product AS A
		LEFT JOIN
		sale.order_item AS B 
		ON A.product_id = B.product_id
WHERE	B.order_id IS NULL


------////////

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: product_id, product_name, store_id, product_id, quantity


SELECT *
FROM	product.product
WHERE	product_id > 310



SELECT	COUNT(DISTINCT product_id)
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


--RIGHT JOIN

------////////

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: product_id, product_name, store_id, product_id, quantity





SELECT	B.product_id, B.product_name, A.*
FROM	product.stock AS A
		RIGHT JOIN
		product.product AS B
		ON	A.product_id = B.product_id
WHERE	B.product_id > 310


-----------


--//////

---Report the order information made by all staffs.

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

--Write a query that returns stock and order information together for all products . Return only top 100 rows.

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


SELECT	A.brand_name, B.category_name
FROM	product.brand AS A
		CROSS JOIN
		product.category AS B



/*
In the stocks table, there are not all products held on the product table and you want to insert these products into the stock table.

You have to insert all these products for every three stores with “0 (zero)” quantity.

Write a query to prepare this data.

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

--Write a query that returns the staff names with their manager names.
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


--//////

--Write a query that returns both the names of staff and the names of their 1st and 2nd managers

-- Bir önceki sorgu sonucunda gelen þeflerin yanýna onlarýn da þeflerini getiriniz
-- Çalýþan adý, þef adý, þefin þefinin adý bilgilerini getirin








--------------///////////////

-----VIEWS
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

