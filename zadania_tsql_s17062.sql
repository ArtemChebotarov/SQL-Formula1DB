/* Create a procedure that returns the best average of the places occupied by all competitors. */

CREATE PROCEDURE bestAVG @najSrednia Int OUTPUT
AS
	DECLARE checkAVG CURSOR FOR 
	SELECT AVG(zajeteMiejsce), idZawodnika FROM wynikiWyscigow ww
	JOIN Zawodnik z ON ww.Zawodnik_idZawodnika = z.idZawodnika 
	GROUP BY idZawodnika;

	DECLARE @idZawodnika Int, @srednia Int;
	
	OPEN checkAVG;
	FETCH NEXT FROM checkAVG INTO @srednia, @idZawodnika;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @najSrednia IS NULL OR @srednia < @najSrednia
		BEGIN 
			SET @najSrednia = @srednia;
		END;
		FETCH NEXT FROM checkAVG INTO @srednia, @idZawodnika;
	END;
	CLOSE checkAVG;
	DEALLOCATE checkAVG;
GO;

/* Create a procedure that changes the route for given races to the route in the city specified in the procedure parameters. */

CREATE PROCEDURE changeCity @idWyscigow Int, @miasto Varchar(30)
AS
	UPDATE Wyscigi SET Trasa_idTrasy = 
	(SELECT idTrasy FROM Trasa WHERE Miasto = @miasto) 
	WHERE idWyscigi = @idWyscigow;

	PRINT 'Trasa dla wyscigow o indeksie ' + CAST(@idWyscigow AS Varchar) + ' zostala zmieniona na trase w miescie ' + @miasto;
GO;

/* Stworzyc wyzwalac, ktory nie pozwoli dodawac nowych zawodnikow do druzyny, ktora jest wypelniona do konca (maks. 3 osoby). */
CREATE TRIGGER noMore ON Zawodnik FOR INSERT
AS
BEGIN 
	DECLARE @liczbaZawodnikow Int;
	SELECT @liczbaZawodnikow = COUNT(1) 
	FROM Zawodnik 
	WHERE Druzyna_idDruzyna = (SELECT Druzyna_idDruzyna FROM inserted);

	IF @liczbaZawodnikow > 3 
	BEGIN
		ROLLBACK;
		Raiserror('Druzyna jest wypelniona', 1, 2);
	END;
END;
GO;

/* Create a trigger that when inserting into the PrognozaPogody table, new values will change given in Celsius temperature on temperature in fahrenheits. */ 

CREATE TRIGGER toFahrenheit ON PrognozaPogody FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		UPDATE PrognozaPogody SET Temperatura = 
		(SELECT Temperatura FROM inserted) * 9/5 + 32 WHERE idPrognoza = 
		(SELECT idPrognoza FROM inserted);

		PRINT 'Temperatura C -> F';
	END;
END;
GO;












