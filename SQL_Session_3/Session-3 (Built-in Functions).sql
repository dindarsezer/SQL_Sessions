


-------///


---BUILT-IN FUNCTIONS

--DATE FUNCTIONS



CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


SELECT *
FROM	t_date_time


--SELECT 'ALÝ' AS name, 20 AS age


SELECT GETDATE()


INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


SELECT *
FROM	t_date_time



---RETURN DATE OR TIME PARTS 

SELECT GETDATE(),
		DATENAME(DW, GETDATE()),
		DATEPART(NANOSECOND, GETDATE()),
		DAY(GETDATE()), 
		MONTH(GETDATE()),
		YEAR(GETDATE()),
		DATEPART(WEEK, GETDATE())


---GET DIFFERENCE 

SELECT GETDATE(),
		DATEDIFF(YEAR, '01-01-1985', GETDATE()),
		DATEDIFF(DAY, '01-01-1985', GETDATE())


SELECT *, DATEDIFF(DAY, order_date, required_date) AS differences
FROM sale.orders


---------DATEADD, EOMONTH

SELECT	GETDATE(),
		DATEADD(day, 5, GETDATE()),
		DATEADD(day, -5, GETDATE()),
		DATEADD(HOUR, 5, GETDATE())


SELECT GETDATE(),
		EOMONTH(GETDATE()),
		EOMONTH(GETDATE(), 2),
		EOMONTH(GETDATE(), -2)


---ISDATE

YMD

SELECT ISDATE (GETDATE())


SELECT ISDATE ('2024-04-30')

SELECT	ISDATE ('24-04-2024')

SELECT	ISDATE ('04-24-2024')

SELECT	ISDATE ('04/24/2024')

SELECT	ISDATE ('20240424')


--------------



SELECT 'ALÝ' AS name, 20 AS age


SELECT *
FROM	sale.order_item

SELECT	order_id, item_id, product_id
FROM	sale.order_item



SELECT	SUM(quantity) AS total_quantity
FROM	sale.order_item


SELECT	order_id, SUM(quantity) AS total_quantity
FROM	sale.order_item
GROUP BY order_id

---COUNT(), MAX(), MIN(), AVG(), SUM()

SELECT	COUNT(DISTINCT product_id)
FROM	sale.order_item


SELECT	COUNT (customer_id)
FROM	sale.customer


SELECT	COUNT (DISTINCT customer_id), COUNT (*)
FROM	sale.customer


SELECT	COUNT (phone)
FROM	sale.customer


----


SELECT *
FROM	sale.customer
WHERE	[state] = 'TX'


SELECT *
FROM	sale.customer
WHERE	state <> 'TX'


SELECT *
FROM	sale.customer
WHERE	phone IS NULL -- IS NOT NULL


/*
LEMAK
YEY
*/


SELECT *
FROM	sale.customer
WHERE	street LIKE '8%'


SELECT *
FROM	sale.customer
WHERE	street LIKE '%#__'



SELECT *
FROM	sale.customer
WHERE	city IN ('Billings', 'Allen')


SELECT *
FROM	sale.customer
WHERE	city = 'Billings' 
OR		city = 'Allen'


SELECT *
FROM	sale.customer
WHERE	city = 'Billings' 
AND		city = 'Allen'


SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
AND		city = 'Ann Arbor'
OR		city = 'Allen'


SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
AND		(city = 'Ann Arbor'   OR	city = 'Allen')



-------------


SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
ORDER BY 
		last_name -- = last_name ASC



SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
ORDER BY 
		last_name DESC, customer_id ASC


SELECT	TOP 10 * -- TOP 10 customer_id, first_name, last_name
FROM	sale.customer
WHERE	first_name LIKE 'D%'
ORDER BY 
		last_name DESC, customer_id ASC


--------

------Write a query returns orders that are shipped more than two days after the order date. 
--2 günden geç kargolanan sipariþlerin bilgilerini getiriniz.

/*
SELECT *, DATEDIFF(DAY, order_date, shipped_date)  AS DATEDIF
FROM	sale.orders
WHERE	DATEDIF > 2
*/   -- HATALI


SELECT *, DATEDIFF(DAY, order_date, shipped_date)  AS DATEDIF
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date)  > 2


SELECT *
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date)  > 2


---------------


---STRING FUNCTIONS

--LEN

SELECT LEN ('Clarusway')

SELECT LEN ('Clarusway  ')

SELECT LEN ('  Clarusway  ')


---CHARINDEX

SELECT CHARINDEX('l', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway', 4)


SELECT CHARINDEX('ar', 'Clarusway')


SELECT CHARINDEX('as', 'Clarusway')



--PATINDEX

SELECT PATINDEX('%la%', 'Clarusway')


SELECT PATINDEX('__a%', 'Clarusway')


SELECT	first_name, PATINDEX('%th', first_name) pattindex
FROM	sale.customer
WHERE	PATINDEX('%th', first_name)  > 0


----------------

---LEFT

SELECT LEFT ('Clarusway', 3)
---RIGHT
SELECT RIGHT ('Clarusway', 3)

--SUBSTRING

SELECT SUBSTRING ('Clarusway', 3, 4)

SELECT SUBSTRING ('Clarusway', 1, 4)



SELECT SUBSTRING ('Clarusway', 4, 2)

SELECT SUBSTRING ('Clarusway', 4, LEN('Clarusway'))



SELECT SUBSTRING ('Clarusway', -4, 2)

SELECT SUBSTRING ('Clarusway', -4, 6)



SELECT	first_name, SUBSTRING(first_name, 3, LEN(first_name))
FROM	sale.customer


---------------------

---lower, upper, string_spilit

SELECT LOWER ('CLARUSWAY'), UPPER ('reinvent yourself'),
		LOWER ('CLARUSWAY') + UPPER (' reinvent yourself')



SELECT *
FROM	string_split ('Ali,Veli,Ahmet,Zeynep', ',')


---soru: clarusway kelimesinin ilk harfini büyük, diðerlerini küçük olacak þekilde gösterin.


SELECT UPPER(SUBSTRING('clarusway', 1, 1)) + SUBSTRING('clarusway',2,LEN('clarusway'))

SELECT UPPER(SUBSTRING('clarusway', 1, 1))

SELECT LOWER(SUBSTRING('clarusway',2,LEN('clarusway')))

SELECT UPPER(SUBSTRING('clarusway', 1, 1)) + LOWER(SUBSTRING('clarusway',2,LEN('clarusway')))


SELECT	email, UPPER(SUBSTRING(email, 1, 1)) + LOWER(SUBSTRING(email, 2, LEN(email)))
FROM	sale.customer



---TRIM, LTRIM, RTRIM


SELECT TRIM('  Clarusway   ')

SELECT LTRIM('  Clarusway   ')

SELECT RTRIM('  Clarusway   ')


SELECT TRIM('/* ' FROM '/*  Clarusway   /*')


-----REPLACE, STR


SELECT REPLACE ('Clarusway', 'way', 'path')


SELECT REPLACE ('Clarusway', 'way', '')

SELECT REPLACE ('Clarus-way', '-', '')



SELECT STR(1265465455.216, 14, 3)


-----CAST, CONVERT

SELECT CAST(123.25 as INT)

SELECT CAST('2024-04-26' as DATE)



SELECT CAST('2024-04-26' as varchar(7))


SELECT CONVERT(VARCHAR(7), '2024-04-26')


SELECT *,  CONVERT(VARCHAR(7), order_date)
FROM	sale.orders



SELECT *,  CONVERT(VARCHAR(50), order_date, 105)
FROM	sale.orders



SELECT *,  datepart (month, CONVERT(VARCHAR(50), order_date, 106))
FROM	sale.orders


SELECT CONVERT(DATE, '03-01-2018')


SELECT CONVERT(DATE, '03 jan 2018')


----ROUND , ISNULL

SELECT ROUND(123456.5678, 2)


SELECT ROUND(123456.5638, 2)


SELECT ROUND(123456.5678, 2, 0)--3. argüman opsiyonel ve 0 ya da 1 deðeri alabilir.


SELECT ROUND(123456.5678, 2, 1)


SELECT ROUND(123456.5638, 2, 1)


SELECT phone, ISNULL (phone, '+111111111')
FROM	sale.customer


----COALESCE

SELECT COALESCE(NULL, NULL, 'A')

SELECT COALESCE(NULL, 1, 'A')



SELECT phone, COALESCE (phone, '1')
FROM	sale.customer

SELECT phone, COALESCE (phone, first_name)
FROM	sale.customer


----NULLIF

SELECT NULLIF(10, 10)

SELECT NULLIF(10, 11)


SELECT	STATE, NULLIF(state, 'NC')
FROM	sale.customer


---ISNUMERIC

SELECT ISNUMERIC(12354651232)

SELECT ISNUMERIC('ALÝ')


SELECT	zip_code, ISNUMERIC(zip_code)
FROM	sale.customer



------------//////////////////////////

-- How many customers have yahoo mail?

--yahoo mailine sahip kaç müþteri vardýr?



SELECT	COUNT(customer_id)
FROM	sale.customer
WHERE	email LIKE '%yahoo.com%'



SELECT	COUNT(customer_id)
FROM	sale.customer
WHERE	PATINDEX('%yahoo.com%', email) > 0



----/////////


--Write a query that returns the characters before the '@' character in the email column.

SELECT	email, CHARINDEX('@', email), LEFT(email, CHARINDEX('@', email)-1) 
FROM	sale.customer



----------
--Add a new column to the customers table that contains the customers' contact information. 
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.



SELECT	phone, email, COALESCE(phone, email) as contact
FROM	sale.customer

SELECT	*, COALESCE(phone, email) as contact
FROM	sale.customer


---///////////////////

--Write a query that returns the name of the streets, where the third character of the streets is numeric.


SELECT	street, SUBSTRING(street, 3, 1), ISNUMERIC(SUBSTRING(street, 3, 1))
FROM	sale.customer 
WHERE	ISNUMERIC(SUBSTRING(street, 3, 1)) = 1


SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer 
WHERE	SUBSTRING(street, 3, 1) LIKE '[0-9]'


SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer 
WHERE	SUBSTRING(street, 3, 1) NOT LIKE '[^0-9]'


-----



------///////////

--Split the mail addresses into two parts from ‘@’, and place them in separate columns.

--@ iþareti ile mail sütununu ikiye ayýrýn. Örneðin
--ronna.butler@gmail.com	/ ronna.butler	/ gmail.com



SELECT	email, 
		SUBSTRING (email, 1, CHARINDEX('@', email)-1), 
		SUBSTRING(email, (CHARINDEX('@', email)+1), LEN(email))
FROM sale.customer





--The street column has some string characters (5C, 43E, 234F, etc.) 
--that are mistakenly added to the end of the numeric characters in the first part of the street records. Remove these typos in this column. 

--street sütununda baþtaki rakamsal ifadenin sonuna yanlýþlýkla eklenmiþ string karakterleri temizleyin
--önce boþluða kadar olan kýsmý alýnýz
--sonra where ile sonunda harf olan kayýtlarý bulunuz
--bu harfi kaldýrýn


SELECT street, REPLACE (street, target_chars,numerical_chars) new_street
FROM	(
			SELECT	street,
					LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
					RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars,

					LEFT (street, CHARINDEX(' ', street)-2) AS numerical_chars

			FROM	sale.customer
		) A

WHERE	ISNUMERIC (string_chars) = 0