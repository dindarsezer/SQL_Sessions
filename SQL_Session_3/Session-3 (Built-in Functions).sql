


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


--SELECT 'AL�' AS name, 20 AS age SQL de bu �ekilde bir ifade ile bir tablo format�nda g�rebiliriz


SELECT GETDATE()
-- �u anki zaman� g�sterir

INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())
-- Bir tablonun mevcut s�tunlar�na de�er olarak atayabiliriz

SELECT *
FROM	t_date_time



---RETURN DATE OR TIME PARTS 

SELECT GETDATE(),
		DATENAME(DW, GETDATE()),			--tarih i�indeki almak istedi�in par�a, hangi tarihten alacaks�n (sonu� dtype � nvarchar)
		DATEPART(NANOSECOND, GETDATE()),	--tarih i�indeki almak istedi�in par�a, hangi tarihten alacaks�n (sonu� dtype � int)
		DAY(GETDATE()),						--(dtype � int)
		MONTH(GETDATE()),					--(dtype � int)
		YEAR(GETDATE()),					--(dtype � int)
		DATEPART(WEEK, GETDATE())			--


---GET DIFFERENCE 

SELECT GETDATE(),
		DATEDIFF(YEAR, '06-15-1983', GETDATE()), -- Y�l cinsinden, ba�lang�� tarihi �u olan, �u anda 
		DATEDIFF(DAY, '06-15-1983', GETDATE())	-- Do�al� ka� g�n ge�mi�


SELECT *, DATEDIFF(DAY, order_date, required_date) AS differences	-- sale.order tablosunda ordet_date ile required_date aras�ndaki g�n fark�n� al�p
FROM sale.orders													-- AS differences ile yeni bir s�tun olu�turduk


---------DATEADD, EOMONTH


SELECT	GETDATE(),
		DATEADD(day, 5, GETDATE()),		--�u andan 5 g�n sonra
		DATEADD(day, -5, GETDATE()),	--�u andan 5 g�n �nde
		DATEADD(HOUR, 5, GETDATE())		--�u andan 5 saat sonra


SELECT GETDATE(),
		EOMONTH(GETDATE()),		-- Bulundu�un ay�n son g�n�
		EOMONTH(GETDATE(), 2),	-- Bu Aydan 2 ay sonraki ay�n son g�n�
		EOMONTH(GETDATE(), -2)	-- Bu Aydan 2 ay �nceki ay�n son g�n�



---ISDATE

YMD

SELECT ISDATE (GETDATE())


SELECT ISDATE ('2024-04-30') -- string olmas�na ra�men tarih olarak alg�layabiliyor

SELECT	ISDATE ('24-04-2024') -- bizim format�m�zn tam tersi ise kabul etmiyor

SELECT	ISDATE ('04-24-2024') -- MDY �eklinide kabul etti

SELECT	ISDATE ('04/24/2024')

SELECT	ISDATE ('20240424')


--------------



SELECT 'AL�' AS name, 20 AS age

-- SELECT * yazd���m�zda t�m s�tunlar gelir
SELECT *
FROM	sale.order_item

-- S�tun isimleri yazarsak istedi�imiz s�tunlar gelir
SELECT	order_id, item_id, product_id
FROM	sale.order_item

-- Sale order item tablosunda quantity s�tunundaki de�erleri toplad�k AS ile bir ba�l�k verdik
SELECT	SUM(quantity) AS total_quantity
FROM	sale.order_item

-- Sat�lan �r�n say�s�n� sipari�e g�re almak istersek
SELECT	order_id, SUM(quantity) AS total_quantity	-- sonu�ta iki s�tun istiyoruz order-id ye g�re quantity toplam�
FROM	sale.order_item
GROUP BY order_id									-- Bu y�zden gruplama yapmal�y�z

---COUNT(), MAX(), MIN(), AVG(), SUM()

SELECT	COUNT(DISTINCT product_id)		--order idem tablosunda ka� farkl� �r�n sat�lm��
FROM	sale.order_item					-- DISTINC bir s�tundaki farkl� �r�nleri unique de�erleri sayar


SELECT	COUNT (customer_id)
FROM	sale.customer


SELECT	COUNT (DISTINCT customer_id), COUNT (*)
FROM	sale.customer


SELECT	COUNT (phone)
FROM	sale.customer


----

-- WHERE ile istedi�imiz bir s�tundaki istedi�imiz de�eri �a��rabiliriz 
SELECT *
FROM	sale.customer
WHERE	[state] = 'TX'


SELECT *
FROM	sale.customer
WHERE	state <> 'TX'


SELECT *
FROM	sale.customer
WHERE	phone IS NULL -- IS NOT NULL

-- LIKE ile 8 ile ba�layan sonras�nda ke� de�er oldu�u bilinmeyen
SELECT *
FROM	sale.customer
WHERE	street LIKE '8%'

-- street s�tununda # den sonra iki karekter i�erenleri
SELECT *
FROM	sale.customer
WHERE	street LIKE '%#__'


-- sale.customer tablosunda city s�tununda 'Billings', 'Allen' olanlar� �a��rd�k
SELECT *
FROM	sale.customer
WHERE	city IN ('Billings', 'Allen')

-- yukar�daki il ayn� sonucu verir
SELECT *
FROM	sale.customer
WHERE	city = 'Billings' 
OR		city = 'Allen'

-- bunu and ile yazamay�z ��nk� ayn� zamanda iki de�er alamaz hata verir
SELECT *
FROM	sale.customer
WHERE	city = 'Billings' 
AND		city = 'Allen'

-- ismi D ile ba�layan city Ann Arbor olan� getir veya sadece city si Allen olan� getir
SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
AND		city = 'Ann Arbor'
OR		city = 'Allen'

-- ismi D ile ba�layan city Ann Arbor veya Allen olan� getir () �NEML� !!!!!
SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
AND		(city = 'Ann Arbor'   OR	city = 'Allen')



-------------

-- order by ie last name e g�re s�ralad�
SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
ORDER BY 
		last_name -- = last_name ASC DEFAULT 


-- �ki farkl� s�tuna g�re s�ralama yapabiliriz
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
--2 g�nden ge� kargolanan sipari�lerin bilgilerini getiriniz.

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

SELECT LEN ('Clarusway  ') -- Sonraki bo�luklar� saymaz

SELECT LEN ('  Clarusway  ') -- �nceki bo�luklar� sayar


---CHARINDEX

SELECT CHARINDEX('l', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway', 4) -- 4. karakterden itibaren ba�la ve say


SELECT CHARINDEX('ar', 'Clarusway')


SELECT CHARINDEX('as', 'Clarusway') -- birden fazla harf te arayabiliriz



--PATINDEX

SELECT PATINDEX('%la%', 'Clarusway')


SELECT PATINDEX('__a%', 'Clarusway')


SELECT	first_name, PATINDEX('%th', first_name) pattindex
FROM	sale.customer
WHERE	PATINDEX('%th', first_name)  > 0


----------------

---LEFT
--Soldan �lk 3 karakteri almam�z� sa�lar
SELECT LEFT ('Clarusway', 3) 

---RIGHT
--Sa�dan 3 karakteri almam�z� sa�lar 
SELECT RIGHT ('Clarusway', 3)

--SUBSTRING
-- 3. Karakterden ba�la 4 karakter al
SELECT SUBSTRING ('Clarusway', 3, 4)

SELECT SUBSTRING ('Clarusway', 1, 4)

SELECT SUBSTRING ('Clarusway', 4, 2)

SELECT SUBSTRING ('Clarusway', 4, LEN('Clarusway')) -- 4 ten ba�la LEN ile ucunlu�unu say yani sonuna kadar al

SELECT SUBSTRING ('Clarusway', -4, 2)

SELECT SUBSTRING ('Clarusway', -4, 6)	-- '-4-3-2-1 0 C l a r u s w a y'



SELECT	first_name, SUBSTRING(first_name, 3, LEN(first_name))
FROM	sale.customer


---------------------

---lower, upper, string_split

SELECT LOWER ('CLARUSWAY'), UPPER ('reinvent yourself'),
		LOWER ('CLARUSWAY') + UPPER (' reinvent yourself')



SELECT *
FROM	string_split ('Ali,Veli,Ahmet,Zeynep', ',')


---soru: clarusway kelimesinin ilk harfini b�y�k, di�erlerini k���k olacak �ekilde g�sterin.


SELECT UPPER(SUBSTRING('clarusway', 1, 1)) + SUBSTRING('clarusway',2,LEN('clarusway'))

SELECT UPPER(SUBSTRING('clarusway', 1, 1))

SELECT LOWER(SUBSTRING('clarusway',2,LEN('clarusway')))

SELECT UPPER(SUBSTRING('clarusway', 1, 1)) + LOWER(SUBSTRING('clarusway',2,LEN('clarusway')))


SELECT	email, UPPER(SUBSTRING(email, 1, 1)) + LOWER(SUBSTRING(email, 2, LEN(email)))
FROM	sale.customer



---TRIM, LTRIM, RTRIM


SELECT TRIM('  Clarusway   ') --Bo�luklar� siler

SELECT LTRIM('  Clarusway   ') --Soldaki bo�luklar� siler

SELECT RTRIM('  Clarusway   ') --Sa�daki bo�luklar� siler


SELECT TRIM('/* ' FROM '/*  Clarusway   /*')


-----REPLACE, STR


SELECT REPLACE ('Clarusway', 'way', 'path')


SELECT REPLACE ('Clarusway', 'way', '')

SELECT REPLACE ('Clarus-way', '-', '')



SELECT STR(1265465455.216, 14, 3)











-----CAST, CONVERT
--veri tipini d�n��t�rmemize yarar
SELECT CAST(123.25 as INT) 

SELECT CAST('2024-04-26' as DATE)


SELECT CAST('2024-04-26' as varchar(7)) -- varchar a d�n��t�r ilk 7 sini al


SELECT CONVERT(VARCHAR(7), '2024-04-26') -- cast �n tersi buna d�n��t�r bunu d�n��t�r


SELECT *,  CONVERT(VARCHAR(7), order_date)
FROM	sale.orders



SELECT *,  CONVERT(VARCHAR(50), order_date, 105)
FROM	sale.orders



SELECT *,  datepart (month, CONVERT(VARCHAR(50), order_date, 106))  -- order date s�tunun veri tipini varchar yap 106 format�ndaki tarihe d�n��t�r
FROM	sale.orders													-- datepart ile aylar� al


SELECT CONVERT(DATE, '03-01-2018') -- default date format�na d�n��t�r�r


SELECT CONVERT(DATE, '03 jan 2018')


----ROUND , ISNULL

SELECT ROUND(123456.5678, 2) -- Yuvarlama yapar virg�lden sonra 2. basama�a g�re yuvarla


SELECT ROUND(123456.5638, 2)


SELECT ROUND(123456.5678, 2, 0)--3. arg�man opsiyonel ve 0 ya da 1 de�eri alabilir.


SELECT ROUND(123456.5678, 2, 1)-- 1 a�a�� yuvarlar


SELECT ROUND(123456.5638, 2, 1)

--sale.customer tablosunda phone s�tununda Null g�rd��� yere istedi�imizi yazd�r�r�z
SELECT phone, ISNULL (phone, '+111111111')
FROM	sale.customer


----COALESCE

SELECT COALESCE(NULL, NULL, 'A')	-- NULL olmayan ilk de�eri getirir cevap A

SELECT COALESCE(NULL, 1, 'A')		-- cevap 1


-- sale.customer table da phone s�tununda NULL de�erlere kar��l�k 1 yazar
SELECT phone, COALESCE (phone, '1')
FROM	sale.customer

-- sale.customer table da phone s�tununda NULL de�erlere kar��l�k first_name s�tun de�erini getirir
SELECT phone, COALESCE (phone, first_name)
FROM	sale.customer


----NULLIF
--�ki expression u birbiriyle k�yaslar e�it ise NULL d�ner e�it de�ilse ilkini d�ner

SELECT NULLIF(10, 10)

SELECT NULLIF(10, 11)

-- state i NC olanlara NULL yaz
SELECT	STATE, NULLIF(state, 'NC')
FROM	sale.customer


---ISNUMERIC
-- Numerik ise 1 de�il ise 0 d�nd�r�r
SELECT ISNUMERIC(12354651232)

SELECT ISNUMERIC('AL�')


SELECT	zip_code, ISNUMERIC(zip_code)
FROM	sale.customer



------------//////////////////////////

-- How many customers have yahoo mail?

--yahoo mailine sahip ka� m��teri vard�r?



SELECT	COUNT(customer_id)
FROM	sale.customer
WHERE	email LIKE '%yahoo.com%'



SELECT	COUNT(customer_id)
FROM	sale.customer
WHERE	PATINDEX('%yahoo.com%', email) > 0



----/////////


--Write a query that returns the characters before the '@' character in the email column.
--E-posta s�tununda '@' karakterinden �nceki karakterleri d�nd�ren bir sorgu yaz�n

SELECT	email, CHARINDEX('@', email), LEFT(email, CHARINDEX('@', email)-1) 
FROM	sale.customer



----------
--Add a new column to the customers table that contains the customers' contact information. 
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.
--M��teriler tablosuna m��terilerin ileti�im bilgilerini i�eren yeni bir s�tun ekleyin. 
--Telefon null de�ilse, telefon bilgileri yazd�r�lacak, de�ilse e-posta bilgileri yazd�r�lacakt�r


SELECT	phone, email, COALESCE(phone, email) as contact
FROM	sale.customer

SELECT	*, COALESCE(phone, email) as contact -- tablonun tamam� gelir sonuna contact s�tunu ekler
FROM	sale.customer


---///////////////////

--Write a query that returns the name of the streets, where the third character of the streets is numeric.
--Sokaklar�n ���nc� karakterinin say�sal oldu�u sokaklar�n ad�n� d�nd�ren bir sorgu yaz�n.

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

--Split the mail addresses into two parts from �@�, and place them in separate columns.

--@ i�areti ile mail s�tununu ikiye ay�r�n. �rne�in
--ronna.butler@gmail.com	/ ronna.butler	/ gmail.com



SELECT	email, 
		SUBSTRING (email, 1, CHARINDEX('@', email)-1), 
		SUBSTRING(email, (CHARINDEX('@', email)+1), LEN(email))
FROM sale.customer





--The street column has some string characters (5C, 43E, 234F, etc.) 
--that are mistakenly added to the end of the numeric characters in the first part of the street records. Remove these typos in this column. 

--street s�tununda ba�taki rakamsal ifadenin sonuna yanl��l�kla eklenmi� string karakterleri temizleyin
--�nce bo�lu�a kadar olan k�sm� al�n�z
--sonra where ile sonunda harf olan kay�tlar� bulunuz
--bu harfi kald�r�n


SELECT street, REPLACE (street, target_chars,numerical_chars) new_street
FROM	(
			SELECT	street,
					LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
					RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars,

					LEFT (street, CHARINDEX(' ', street)-2) AS numerical_chars

			FROM	sale.customer
		) A

WHERE	ISNUMERIC (string_chars) = 0