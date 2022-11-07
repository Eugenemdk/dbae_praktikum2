--4a)
CREATE VIEW ausgeliehen AS
SELECT ausleihe.isbn,ausleihe.explnr,buchex.titel
FROM ausleihe.ausleihe
INNER JOIN ausleihe.buchex
ON ausleihe.explnr=buchex.explnr
--4b)
CREATE VIEW unausgeliehen AS
SELECT buchex.autorname,buchex.isbn
FROM ausleihe.buchex
LEFT JOIN ausleihe.ausleihe ON buchex.isbn=ausleihe.isbn
WHERE ausleihe.isbn IS NULL

--TEST data

DROP VIEW unausgeliehen
SELECT *
FROM ausleihe.ausleihe
INNER JOIN ausleihe.buchex
ON ausleihe.explnr <> buchex.explnr

SELECT * FROM ausleihe.ausleihe;
SELECT * FROM ausleihe.buchex;
SELECT * from ausleihe.leser;

INSERT INTO ausleihe.buchex VALUES('C',3,'C# crash course','Harrison Ferrone')
--4c)
CREATE VIEW ausleihanzahl AS
SELECT ausleihe.isbn,buchex.titel,buchex.autorname,COUNT(ausleihe.isbn)
FROM ausleihe.buchex
LEFT JOIN ausleihe.ausleihe ON ausleihe.isbn = buchex.isbn
GROUP BY buchex.autorname,ausleihe.isbn,buchex.titel 
DROP VIEW ausleihanzahl
--4d)
--SELECT * FROM ausleihanzahl
SELECT titel,autorname
FROM ausleihanzahl
WHERE ausleihanzahl.count=(SELECT MAX(ausleihanzahl.count) FROM ausleihanzahl)
--4e)
SELECT ausgeliehen.titel FROM ausgeliehen
GROUP BY ausgeliehen.titel
HAVING COUNT(ausgeliehen.isbn) < 2
--
SELECT * FROM ausleihanzahl
SELECT * FROM unausgeliehen
SELECT * FROM ausgeliehen
--INSERT INTO ausleihe.ausleihe VALUES('D',4,now(),1)
--INSERT INTO ausleihe.buchex VALUES('D',4,'Selenium WebDriver Practical Guide','Satya Avasarala')