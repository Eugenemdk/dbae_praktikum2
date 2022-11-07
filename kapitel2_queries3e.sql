--e)
CREATE OR REPLACE FUNCTION leser_buch_avail()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
DECLARE buch_zahl int;
BEGIN
	SELECT COUNT(ausleihe.leserid)
	into buch_zahl
	FROM ausleihe.ausleihe;
	IF buch_zahl<=3 THEN
		INSERT INTO ausleihe.ausleihe VALUES(OLD.isbn,OLD.explnr,OLD.datum,OLD.leserid);
	END IF;
	
RETURN NEW;
END;
$$

CREATE OR REPLACE TRIGGER trigger_on_readers
AFTER INSERT
ON ausleihe.ausleihe
FOR EACH STATEMENT
EXECUTE PROCEDURE leser_buch_avail();
--
--CHECK CORRECT EXECUTION
INSERT INTO ausleihe.ausleihe VALUES('A',3,'2022-10-24'::date,1);
SELECT * FROM ausleihe.ausleihe;

--QUERY TO OUTPUT number of books at the same time by reader
SELECT leser.lesername,COUNT(ausleihe.leserid) 
FROM ausleihe.leser
INNER JOIN ausleihe.ausleihe
ON ausleihe.leserid=leser.lid
GROUP BY lesername

SELECT COUNT(ausleihe.leserid)
FROM ausleihe.ausleihe