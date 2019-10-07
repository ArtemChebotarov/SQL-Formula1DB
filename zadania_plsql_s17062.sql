/* Create a trigger that will check the weather forecast before inserting new races
on the day of the race. If the wind speed is higher than 30 m / s - insert new ones
the races are ignored and an error will be raised. */

CREATE OR REPLACE TRIGGER NoInsertWyscigi 
BEFORE INSERT ON Wyscigi
FOR EACH ROW
DECLARE
v_predkosc Number;
BEGIN 
    SELECT predkoscWiatru INTO v_predkosc FROM PROGNOZAPOGODY
    WHERE idPrognoza = :new.prognozapogody_idprognoza;
    
    IF v_predkosc > 30 THEN
        Raise_application_error(-20100, 'Prognoza pogody dla tych wyscig?w jest nie zadowolajaca');
    END IF;
END;

/* Create a trigger that before inserting or editing a row in the Player table
will check player's age. If age is less than 18 - insert or edit
will be ignoring. */

CREATE OR REPLACE TRIGGER SoYoung
BEFORE INSERT OR UPDATE 
ON Zawodnik
FOR EACH ROW
DECLARE
v_wiek Number;
BEGIN
    v_wiek := TRUNC(MONTHS_BETWEEN(sysdate, :new.dataUrodzenia) / 12);
    IF UPDATING THEN
        IF v_wiek < 18 THEN
            :new.dataUrodzenia := :old.dataUrodzenia;
            dbms_output.put_line('Zawodnik jest zbyt mlody, data nie zostala zmieniona');
        END IF;
    END IF;
    IF INSERTING THEN
        IF v_wiek < 18 THEN
            Raise_application_error(-20101, 'Zawodnik jest zbyt mlody dla ucz?stnictwa w wy?cigach');
        END IF;
    END IF;
END;

/* Create a procedure that will review all existing routes and delete those routes
the length will be greater than the length procedure specified in the parameter. */

CREATE OR REPLACE PROCEDURE deleteTrack (v_zadanaDlugosc trasa.dlugoscTrasy%type)
AS
    CURSOR tracks IS SELECT dlugoscTrasy FROM Trasa;
    v_dlugosc trasa.dlugoscTrasy%type;
BEGIN
    OPEN tracks;
    LOOP 
        FETCH tracks INTO v_dlugosc;
        EXIT WHEN tracks%NOTFOUND;
        IF v_dlugosc > v_zadanaDlugosc THEN
            DELETE FROM Trasa WHERE dlugoscTrasy = v_dlugosc;
        END IF;
    END LOOP;
    CLOSE tracks;
        
END;

/* Create a procedure that displays the average of the space given in the player's parameters. In case of if the requested player does not exist in bd - pick up an exception that will alert the user with the indicated number of a non-existent player.*/

CREATE OR REPLACE PROCEDURE getAvgPlace (v_zawodnik zawodnik.idZawodnika%type)
AS 
    v_srednia int DEFAULT 0;
    zawodnikNieIstnieje EXCEPTION;
    v_info Varchar2(100);
BEGIN
    SELECT AVG(zajeteMiejsce) INTO v_srednia 
    FROM wynikiWyscigow ww
    JOIN zawodnik z ON ww.zawodnik_idZawodnika = z.idZawodnika
    WHERE idZawodnika = v_zawodnik;
    IF v_srednia IS NOT NULL THEN
        dbms_output.put_line('Srednia zawodnika o indeksie ' || v_zawodnik || ' wynosi ' || v_srednia);
    ELSE 
        RAISE zawodnikNieIstnieje;
    END IF;
    
    dbms_output.put_line(v_info);
    
    EXCEPTION 
        WHEN zawodnikNieIstnieje THEN
            dbms_output.put_line('Zawodnik o zadanym numerze nie istnieje');      
END;







