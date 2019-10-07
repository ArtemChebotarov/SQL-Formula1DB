-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2019-01-22 18:23:25.367

-- tables
-- Table: Druzyna
CREATE TABLE Druzyna (
    idDruzyna integer  NOT NULL,
    NazwaDruzyny varchar2(30)  NOT NULL,
    CONSTRAINT Druzyna_pk PRIMARY KEY (idDruzyna)
) ;

-- Table: PrognozaPogody
CREATE TABLE PrognozaPogody (
    idPrognoza integer  NOT NULL,
    Temperatura integer  NOT NULL,
    Opady varchar2(100)  NOT NULL,
    PredkoscWiatru integer  NOT NULL,
    KierunekWiatru varchar2(30)  NOT NULL,
    Wilgotnosc integer  NOT NULL,
    Data date  NOT NULL,
    CONSTRAINT PrognozaPogody_pk PRIMARY KEY (idPrognoza)
) ;

-- Table: Trasa
CREATE TABLE Trasa (
    idTrasy integer  NOT NULL,
    NazwaTrasy varchar2(30)  NOT NULL,
    DlugoscTrasy number(5,2)  NOT NULL,
    Miasto varchar2(30)  NOT NULL,
    CONSTRAINT Trasa_pk PRIMARY KEY (idTrasy)
) ;

-- Table: WynikiWyscigow
CREATE TABLE WynikiWyscigow (
    Zawodnik_idZawodnika integer  NOT NULL,
    CzasNajlepszegoOkrezenia integer  NOT NULL,
    OstatnieOkrazenie integer  NOT NULL,
    Wyscigi_idWyscigi integer  NOT NULL,
    idWyniki integer  NOT NULL,
    ZajeteMiejsce integer  NOT NULL,
    CONSTRAINT WynikiWyscigow_pk PRIMARY KEY (idWyniki)
) ;

-- Table: Wyscigi
CREATE TABLE Wyscigi (
    DataPrzeprowadzania date  NOT NULL,
    idWyscigi integer  NOT NULL,
    PrognozaPogody_idPrognoza integer  NOT NULL,
    WynikiWyscigow_idWyniki integer  NULL,
    Trasa_idTrasy integer  NOT NULL,
    IloscOkrazen integer  NOT NULL,
    CONSTRAINT Wyscigi_pk PRIMARY KEY (idWyscigi)
) ;

-- Table: Zawodnik
CREATE TABLE Zawodnik (
    idZawodnika integer  NOT NULL,
    Imie varchar2(30)  NOT NULL,
    Nazwisko varchar2(40)  NOT NULL,
    DataUrodzenia date  NOT NULL,
    Druzyna_idDruzyna integer  NOT NULL,
    CONSTRAINT Zawodnik_pk PRIMARY KEY (idZawodnika)
) ;

-- foreign keys
-- Reference: WynikiWyscigow_Wyscigi (table: WynikiWyscigow)
ALTER TABLE WynikiWyscigow ADD CONSTRAINT WynikiWyscigow_Wyscigi
    FOREIGN KEY (Wyscigi_idWyscigi)
    REFERENCES Wyscigi (idWyscigi);

-- Reference: WynikiWyscigow_Zawodnik (table: WynikiWyscigow)
ALTER TABLE WynikiWyscigow ADD CONSTRAINT WynikiWyscigow_Zawodnik
    FOREIGN KEY (Zawodnik_idZawodnika)
    REFERENCES Zawodnik (idZawodnika);

-- Reference: Wyscigi_PrognozaPogody (table: Wyscigi)
ALTER TABLE Wyscigi ADD CONSTRAINT Wyscigi_PrognozaPogody
    FOREIGN KEY (PrognozaPogody_idPrognoza)
    REFERENCES PrognozaPogody (idPrognoza);

-- Reference: Wyscigi_Trasa (table: Wyscigi)
ALTER TABLE Wyscigi ADD CONSTRAINT Wyscigi_Trasa
    FOREIGN KEY (Trasa_idTrasy)
    REFERENCES Trasa (idTrasy);

-- Reference: Zawodnik_Druzyna (table: Zawodnik)
ALTER TABLE Zawodnik ADD CONSTRAINT Zawodnik_Druzyna
    FOREIGN KEY (Druzyna_idDruzyna)
    REFERENCES Druzyna (idDruzyna);

-- End of file.

