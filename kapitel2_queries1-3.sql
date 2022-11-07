
CREATE TABLE AusleihHistorie (
ISBN CHAR(10) NOT NULL,
EXPLNR INTEGER NOT NULL,
Datum DATE NOT NULL,
LeserID INTEGER NOT NULL 
)
---3
--a)
ALTER TABLE ausleihe.leser
ADD CONSTRAINT CHK_GebJahr CHECK(leser.gebjahr > 1910 AND leser.gebjahr < 2010);
--b)
ALTER TABLE ausleihe.leser 
ADD CONSTRAINT unique_lesername UNIQUE (lesername);
--c)
CREATE OR REPLACE FUNCTION trigger_delete_ausleihe() 
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS 
$$
BEGIN
	INSERT INTO ausleihe.ausleihhistorie(datum,leserid) VALUES(OLD.datum,OLD.leserid);
	RETURN NEW;
END;
$$

CREATE OR REPLACE TRIGGER on_delete_leser
BEFORE DELETE
ON ausleihe.ausleihe
FOR EACH ROW
EXECUTE PROCEDURE trigger_delete_ausleihe();

DELETE FROM ausleihe.ausleihe WHERE ausleihe.isbn = 'B';
SELECT * FROM ausleihe.ausleihe;
SELECT * FROM ausleihe.ausleihhistorie;
--d)
CREATE OR REPLACE FUNCTION authors_restriction()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS 
$$
BEGIN
	--CREATE TABLE temp_auth_leser AS(
	--SELECT leser.lesername,buchex.autorname FROM ausleihe.leser
	--INNER JOIN ausleihe.ausleihe
	--ON leser.lid  = ausleihe.leserid
	--INNER JOIN ausleihe.buchex
	--ON buchex.explnr = ausleihe.explnr);
	CREATE TABLE temp_leser
	AS (SELECT leser.lesername,buchex.autorname FROM ausleihe.leser CROSS JOIN ausleihe.buchex);
	INSERT INTO ausleihe.leser(lesername,gebjahr) 
	SELECT temp_leser.autorname,temp_leser.lesername
	FROM temp_leser
	WHERE temp_leser.autorname <> temp_leser.lesername;
	 
	
	RETURN NEW;
END;
$$

CREATE OR REPLACE TRIGGER on_add_leser
BEFORE INSERT
ON ausleihe.leser
FOR EACH ROW
EXECUTE PROCEDURE authors_restriction();


