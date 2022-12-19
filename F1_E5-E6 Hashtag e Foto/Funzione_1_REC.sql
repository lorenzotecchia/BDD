--DROP TABLE f.temp;
CREATE OR REPLACE PROCEDURE f.riempitable(padre f.album.codA%TYPE) AS
$$
DECLARE
    valore_da_inserire f.album.codA%TYPE;
    count INTEGER:=(SELECT count(*) FROM f.album WHERE inalbum=padre);
    cursore CURSOR FOR (SELECT coda FROM f.album WHERE inalbum=padre);
BEGIN
    FOR valore_da_inserire IN (SELECT coda FROM f.album WHERE inalbum=padre) LOOP
        INSERT INTO f.temp(codA) values (valore_da_inserire);
        IF((SELECT count(*) FROM f.album WHERE inalbum=valore_da_inserire)<>0) THEN
            CALL f.riempitable(valore_da_inserire);
        end if;
        end loop;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION f.ritornatag(padre f.album.codA%TYPE)
    RETURNS VARCHAR(500) AS
$$
DECLARE
    output VARCHAR(500);
    cursore CURSOR FOR (SELECT DISTINCT parola
                        FROM f.tagalbum NATURAL JOIN f.temp);
    count INTEGER;
    parolav f.tagalbum.parola%TYPE;
BEGIN
    CREATE TABLE f.temp(CodA INTEGER);
    INSERT INTO f.temp(coda) values(padre);
    CALL f.riempitable(padre);
    count=(SELECT count(*)
           FROM (SELECT DISTINCT parola
                 FROM f.tagalbum NATURAL JOIN f.temp)
               AS Q);
    OPEN cursore;
    FOR i IN 1..count LOOP
        FETCH cursore INTO parolav;
        IF i=1 THEN output=parolav;
            ELSE
            output=output || ', ' || parolav;
            END IF;
        end loop;
    CLOSE cursore;
    DROP TABLE f.temp;
    RETURN output;
END;
$$
LANGUAGE plpgsql;


SELECT f.ritornatag(1);
