


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


--SELECT 'ALÝ' AS name, 20 AS age SQL de bu þekilde bir ifade ile bir tablo formatýnda görebiliriz


SELECT GETDATE()
-- Þu anki zamaný gösterir

INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())
-- Bir tablonun mevcut sütunlarýna deðer olarak atayabiliriz

SELECT *
FROM	t_date_time



---RETURN DATE OR TIME PARTS 

SELECT GETDATE(),
		DATENAME(DW, GETDATE()),			--tarih içindeki almak istediðin parça, hangi tarihten alacaksýn (sonuç dtype ý nvarchar)
		DATEPART(NANOSECOND, GETDATE()),	--tarih içindeki almak istediðin parça, hangi tarihten alacaksýn (sonuç dtype ý int)
		DAY(GETDATE()),						--(dtype ý int)
		MONTH(GETDATE()),					--(dtype ý int)
		YEAR(GETDATE()),					--(dtype ý int)
		DATEPART(WEEK, GETDATE())			--


---GET DIFFERENCE 

SELECT GETDATE(),
		DATEDIFF(YEAR, '06-15-1983', GETDATE()), -- Yýl cinsinden, baþlangýç tarihi þu olan, þu anda 
		DATEDIFF(DAY, '06-15-1983', GETDATE())	-- Doðalý kaç gün geçmiþ


SELECT *, DATEDIFF(DAY, order_date, required_date) AS differences	-- sale.order tablosunda ordet_date ile required_date arasýndaki gün farkýný alýp
FROM sale.orders													-- AS differences ile yeni bir sütun oluþturduk


---------DATEADD, EOMONTH


SELECT	GETDATE(),
		DATEADD(day, 5, GETDATE()),		--Þu andan 5 gün sonra
		DATEADD(day, -5, GETDATE()),	--Þu andan 5 gün önde
		DATEADD(HOUR, 5, GETDATE())		--Þu andan 5 saat sonra


SELECT GETDATE(),
		EOMONTH(GETDATE()),		-- Bulunduðun ayýn son günü
		EOMONTH(GETDATE(), 2),	-- Bu Aydan 2 ay sonraki ayýn son günü
		EOMONTH(GETDATE(), -2)	-- Bu Aydan 2 ay önceki ayýn son günü



---ISDATE

YMD

SELECT ISDATE (GETDATE())


SELECT ISDATE ('2024-04-30') -- string olmasýna raðmen tarih olarak algýlayabiliyor

SELECT	ISDATE ('24-04-2024') -- bizim formatýmýzn tam tersi ise kabul etmiyor

SELECT	ISDATE ('04-24-2024') -- MDY þeklinide kabul etti

SELECT	ISDATE ('04/24/2024')

SELECT	ISDATE ('20240424')


--------------



SELECT 'ALÝ' AS name, 20 AS age

-- SELECT * yazdýðýmýzda tüm sütunlar gelir
SELECT *
FROM	sale.order_item

-- Sütun isimleri yazarsak istediðimiz sütunlar gelir
SELECT	order_id, item_id, product_id
FROM	sale.order_item

-- Sale order item tablosunda quantity sütunundaki deðerleri topladýk AS ile bir baþlýk verdik
SELECT	SUM(quantity) AS total_quantity
FROM	sale.order_item

-- Satýlan ürün sayýsýný sipariþe göre almak istersek
SELECT	order_id, SUM(quantity) AS total_quantity	-- sonuçta iki sütun istiyoruz order-id ye göre quantity toplamý
FROM	sale.order_item
GROUP BY order_id									-- Bu yüzden gruplama yapmalýyýz

---COUNT(), MAX(), MIN(), AVG(), SUM()

SELECT	COUNT(DISTINCT product_id)		--order idem tablosunda kaç farklý ürün satýlmýþ
FROM	sale.order_item					-- DISTINC bir sütundaki farklý ürünleri unique deðerleri sayar


SELECT	COUNT (customer_id)
FROM	sale.customer


SELECT	COUNT (DISTINCT customer_id), COUNT (*)
FROM	sale.customer


SELECT	COUNT (phone)
FROM	sale.customer


----

-- WHERE ile istediðimiz bir sütundaki istediðimiz deðeri çaðýrabiliriz 
SELECT *
FROM	sale.customer
WHERE	[state] = 'TX'


SELECT *
FROM	sale.customer
WHERE	state <> 'TX'


SELECT *
FROM	sale.customer
WHERE	phone IS NULL -- IS NOT NULL

-- LIKE ile 8 ile baþlayan sonrasýnda keç deðer olduðu bilinmeyen
SELECT *
FROM	sale.customer
WHERE	street LIKE '8%'

-- street sütununda # den sonra iki karekter içerenleri
SELECT *
FROM	sale.customer
WHERE	street LIKE '%#__'


-- sale.customer tablosunda city sütununda 'Billings', 'Allen' olanlarý çaðýrdýk
SELECT *
FROM	sale.customer
WHERE	city IN ('Billings', 'Allen')

-- yukarýdaki il ayný sonucu verir
SELECT *
FROM	sale.customer
WHERE	city = 'Billings' 
OR		city = 'Allen'

-- bunu and ile yazamayýz çünkü ayný zamanda iki deðer alamaz hata verir
SELECT *
FROM	sale.customer
WHERE	city = 'Billings' 
AND		city = 'Allen'

-- ismi D ile baþlayan city Ann Arbor olaný getir veya sadece city si Allen olaný getir
SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
AND		city = 'Ann Arbor'
OR		city = 'Allen'

-- ismi D ile baþlayan city Ann Arbor veya Allen olaný getir () ÖNEMLÝ !!!!!
SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
AND		(city = 'Ann Arbor'   OR	city = 'Allen')



-------------

-- order by ie last name e göre sýraladý
SELECT *
FROM	sale.customer
WHERE	first_name LIKE 'D%'
ORDER BY 
		last_name -- = last_name ASC DEFAULT 


-- Ýki farklý sütuna göre sýralama yapabiliriz
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

SELECT LEN ('Clarusway  ') -- Sonraki boþluklarý saymaz

SELECT LEN ('  Clarusway  ') -- Önceki boþluklarý sayar


---CHARINDEX

SELECT CHARINDEX('l', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway', 4) -- 4. karakterden itibaren baþla ve say


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
--Soldan Ýlk 3 karakteri almamýzý saðlar
SELECT LEFT ('Clarusway', 3) 

---RIGHT
--Saðdan 3 karakteri almamýzý saðlar 
SELECT RIGHT ('Clarusway', 3)

--SUBSTRING
-- 3. Karakterden baþla 4 karakter al
SELECT SUBSTRING ('Clarusway', 3, 4)

SELECT SUBSTRING ('Clarusway', 1, 4)

SELECT SUBSTRING ('Clarusway', 4, 2)

SELECT SUBSTRING ('Clarusway', 4, LEN('Clarusway')) -- 4 ten baþla LEN ile ucunluðunu say yani sonuna kadar al

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


---soru: clarusway kelimesinin ilk harfini büyük, diðerlerini küçük olacak þekilde gösterin.


SELECT UPPER(SUBSTRING('clarusway', 1, 1)) + SUBSTRING('clarusway',2,LEN('clarusway'))

SELECT UPPER(SUBSTRING('clarusway', 1, 1))

SELECT LOWER(SUBSTRING('clarusway',2,LEN('clarusway')))

SELECT UPPER(SUBSTRING('clarusway', 1, 1)) + LOWER(SUBSTRING('clarusway',2,LEN('clarusway')))


SELECT	email, UPPER(SUBSTRING(email, 1, 1)) + LOWER(SUBSTRING(email, 2, LEN(email)))
FROM	sale.customer



---TRIM, LTRIM, RTRIM


SELECT TRIM('  Clarusway   ') --Boþluklarý siler

SELECT LTRIM('  Clarusway   ') --Soldaki boþluklarý siler

SELECT RTRIM('  Clarusway   ') --Saðdaki boþluklarý siler


SELECT TRIM('/* ' FROM '/*  Clarusway   /*')


-----REPLACE, STR


SELECT REPLACE ('Clarusway', 'way', 'path')


SELECT REPLACE ('Clarusway', 'way', '')

SELECT REPLACE ('Clarus-way', '-', '')



SELECT STR(1265465455.216, 14, 3)











-----CAST, CONVERT
--veri tipini dönüþtürmemize yarar
SELECT CAST(123.25 as INT) 

SELECT CAST('2024-04-26' as DATE)


SELECT CAST('2024-04-26' as varchar(7)) -- varchar a dönüþtür ilk 7 sini al


SELECT CONVERT(VARCHAR(7), '2024-04-26') -- cast ýn tersi buna dönüþtür bunu dönüþtür


SELECT *,  CONVERT(VARCHAR(7), order_date)
FROM	sale.orders



SELECT *,  CONVERT(VARCHAR(50), order_date, 105)
FROM	sale.orders



SELECT *,  datepart (month, CONVERT(VARCHAR(50), order_date, 106))  -- order date sütunun veri tipini varchar yap 106 formatýndaki tarihe dönüþtür
FROM	sale.orders													-- datepart ile aylarý al


SELECT CONVERT(DATE, '03-01-2018') -- default date formatýna dönüþtürür


SELECT CONVERT(DATE, '03 jan 2018')


----ROUND , ISNULL

SELECT ROUND(123456.5678, 2) -- Yuvarlama yapar virgülden sonra 2. basamaða göre yuvarla


SELECT ROUND(123456.5638, 2)


SELECT ROUND(123456.5678, 2, 0)--3. argüman opsiyonel ve 0 ya da 1 deðeri alabilir.


SELECT ROUND(123456.5678, 2, 1)-- 1 aþaðý yuvarlar


SELECT ROUND(123456.5638, 2, 1)

--sale.customer tablosunda phone sütununda Null gördüðü yere istediðimizi yazdýrýrýz
SELECT phone, ISNULL (phone, '+111111111')
FROM	sale.customer


----COALESCE

SELECT COALESCE(NULL, NULL, 'A')	-- NULL olmayan ilk deðeri getirir cevap A

SELECT COALESCE(NULL, 1, 'A')		-- cevap 1


-- sale.customer table da phone sütununda NULL deðerlere karþýlýk 1 yazar
SELECT phone, COALESCE (phone, '1')
FROM	sale.customer

-- sale.customer table da phone sütununda NULL deðerlere karþýlýk first_name sütun deðerini getirir
SELECT phone, COALESCE (phone, first_name)
FROM	sale.customer


----NULLIF
--Ýki expression u birbiriyle kýyaslar eþit ise NULL döner eþit deðilse ilkini döner

SELECT NULLIF(10, 10)

SELECT NULLIF(10, 11)

-- state i NC olanlara NULL yaz
SELECT	STATE, NULLIF(state, 'NC')
FROM	sale.customer


---ISNUMERIC
-- Numerik ise 1 deðil ise 0 döndürür
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
--E-posta sütununda '@' karakterinden önceki karakterleri döndüren bir sorgu yazýn

SELECT	email, CHARINDEX('@', email), LEFT(email, CHARINDEX('@', email)-1) 
FROM	sale.customer



----------
--Add a new column to the customers table that contains the customers' contact information. 
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.
--Müþteriler tablosuna müþterilerin iletiþim bilgilerini içeren yeni bir sütun ekleyin. 
--Telefon null deðilse, telefon bilgileri yazdýrýlacak, deðilse e-posta bilgileri yazdýrýlacaktýr


SELECT	phone, email, COALESCE(phone, email) as contact
FROM	sale.customer

SELECT	*, COALESCE(phone, email) as contact -- tablonun tamamý gelir sonuna contact sütunu ekler
FROM	sale.customer


---///////////////////

--Write a query that returns the name of the streets, where the third character of the streets is numeric.
--Sokaklarýn üçüncü karakterinin sayýsal olduðu sokaklarýn adýný döndüren bir sorgu yazýn.

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