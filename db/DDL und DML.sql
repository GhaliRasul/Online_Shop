-- DDL-Anweisungen

-- Tabllen werden hier erstmal gelöscht
-- Falls sich tabllen mit gleichen Namen im DD befinden


alter table produkte drop foreign key produkte_fk1;
alter table auftragspositionsdaten drop foreign key Auftragspositionsdaten_FK1 ;
alter table auftragspositionsdaten drop foreign key Auftragspositionsdaten_FK2 ;
alter table auftrag drop foreign key Auftrag_FK1 ;
alter table lieferantenbestellungen drop foreign key Lieferantenbestellungen_FK2 ;
alter table abteilung drop foreign key Abteilung_FK1 ;
alter table mitarbeiter drop foreign key Mitarbeiter_FK1 ;
alter table bestellpositionsdaten drop foreign key Bestellpositionsdaten_FK1 ;
alter table bestellpositionsdaten drop foreign key Bestellpositionsdaten_FK2 ;
alter table Warenkorbpositionen drop foreign key Warenkorb_fk1;
alter table Warenkorbpositionen drop foreign key Warenkorb_fk2;




DROP TABLE Produkte;
DROP TABLE Kategorien;
DROP TABLE Auftragspositionsdaten;
DROP TABLE Auftrag;
DROP TABLE Lieferanten;
DROP TABLE Lieferantenbestellungen;
DROP TABLE Abteilung;
DROP TABLE Kunden;
DROP TABLE Mitarbeiter;
DROP TABLE Bestellpositionsdaten;
DROP TABLE Warenkorbpositionen;



-- Tabelle der Produkte wird erstellt
CREATE TABLE Produkte(
produktnummer INTEGER AUTO_INCREMENT,
CONSTRAINT Produkte_PK PRIMARY KEY(produktnummer),
produktname VARCHAR(45) NOT NULL,
produktbeschreibung VARCHAR (200) NOT NULL,
bild VARCHAR(500),
verkaufspreis NUMERIC(8,2) NOT NULL,
mindestbestand INTEGER NOT NULL,
best_bestand INTEGER NOT NULL,
res_bestand INTEGER NOT NULL,
phys_bestand INTEGER NOT NULL,
Kategoriennummer INTEGER NOT NULL,

CONSTRAINT Produkt_pre_CK1 CHECK (verkaufspreis >0 ),
CONSTRAINT Produkt_bestand_CK1 CHECK (best_bestand>=0 AND res_bestand >=0 ),
CONSTRAINT Produkt_bestand_CK3 CHECK (mindestbestand>=0)
);


-- Tabelle der Katagorien wird erstellt
CREATE TABLE Kategorien(
Kategoriennummer INTEGER AUTO_INCREMENT,
CONSTRAINT Kategorien_PK PRIMARY KEY(Kategoriennummer),
Kategorienname VARCHAR(45) NOT NULL,
Kategorienbeschreibung VARCHAR(100) NOT NULL,

CONSTRAINT Kategorien_U1 UNIQUE(Kategorienname)
);



-- Tabelle der Kunden wird erstellt
CREATE TABLE Kunden(
kundennummer  INTEGER AUTO_INCREMENT,
CONSTRAINT Kunden_PK PRIMARY KEY(kundennummer),
geschlecht CHAR(1) NOT NULL,
name VARCHAR(45) NOT NULL,
vorname VARCHAR(45)NOT NULL,
adresee VARCHAR(45) NOT NULL,
plz NUMERIC(6) NOT NULL,
wohnort VARCHAR(45) NOT NULL,
telefonnummer NUMERIC,
e_mail VARCHAR(75) NOT NULL,
bankkonto VARCHAR(16),
kennwort VARCHAR(16),

CONSTRAINT Kunden_U1 UNIQUE (e_mail),
CONSTRAINT Kunden_U2 CHECK ( geschlecht in ('w', 'm'))
);


CREATE TABLE Warenkorbpositionen(
position_id  INTEGER AUTO_INCREMENT,
CONSTRAINT Warenkurb_PK PRIMARY KEY(position_id),
kundennummer INTEGER NOT NULL,
produktnummer INTEGER NOT NULL,
menge  INTEGER NOT NULL
);


-- Tabelle der Abteilung  wird erstellt
CREATE TABLE Abteilung(
abteilungsnummer INTEGER AUTO_INCREMENT,
CONSTRAINT Abteilung_PK PRIMARY KEY(abteilungsnummer),
abteilungsname VARCHAR(45) NOT NULL,
leiter_nummer INTEGER ,
beschreibung VARCHAR(100) ,

CONSTRAINT Abteilung_U1 UNIQUE (abteilungsname)
);


-- Tabelle der Mitarbeiter wird erstellt
CREATE TABLE Mitarbeiter (
mitarbeiternummer INTEGER AUTO_INCREMENT,
CONSTRAINT Mitarbeiter_PK PRIMARY KEY(mitarbeiternummer),
geschlecht  CHAR(1) NOT NULL,
name VARCHAR(45) NOT NULL,
vorname VARCHAR(45)NOT NULL,
adresee VARCHAR(45) NOT NULL,
plz NUMERIC (6) NOT NULL,
wohnort VARCHAR(45) NOT NULL,
telefonnummer NUMERIC,
e_mail VARCHAR(75) NOT NULL,
gehalt NUMERIC(8,2) NOT NULL,
abteilungsnummer integer NOT NULL,

CONSTRAINT Mitarbeiter_CK1 CHECK(gehalt>0),
CONSTRAINT Mitarbeiter_U1 UNIQUE(e_mail),
CONSTRAINT Mitarbeiter_U2 CHECK ( geschlecht in ('w', 'm'))
);


-- Tabelle der Auftraege wird erstellt
CREATE TABLE Auftrag(
auftragsnummer INTEGER AUTO_INCREMENT,
CONSTRAINT Auftrag_PK PRIMARY KEY(auftragsnummer),
auftragsdatum timestamp DEFAULT CURRENT_TIMESTAMP,
stornodatum date null,
lieferdatum date NOT NULL,
auftragsstatus VARCHAR(45) NOT NULL,
kundennummer INTEGER NOT NULL,

CONSTRAINT Auftrag_CK1 CHECK (auftragsdatum <= stornodatum)
);


-- Tabelle der Auftragspositiosdaten wird erstellt
CREATE TABLE Auftragspositionsdaten(
position_id INTEGER AUTO_INCREMENT,
CONSTRAINT Auftragspositionsdaten_PK PRIMARY KEY(position_id),
produktnummer INTEGER NOT NULL,
auftragsnummer INTEGER NOT NULL,
menge  INTEGER NOT NULL
);


-- Tabelle der Liferanten wird erstellt
CREATE TABLE Lieferanten(
lieferantennummer INTEGER AUTO_INCREMENT,
CONSTRAINT Lieferanten_PK PRIMARY KEY (lieferantennummer),
geschlecht CHAR(1) NOT NULL,
name VARCHAR(45) NOT NULL,
vorname VARCHAR(45) NOT NULL,
adresse VARCHAR(45) NOT NULL,
plz NUMERIC (6) NOT NULL,
ort VARCHAR (45) NOT NULL,
telefonnummer NUMERIC NOT NULL,
e_mail VARCHAR(45) NOT NULL,
beschreibung VARCHAR(100),

CONSTRAINT lieferanten_u1 UNIQUE (e_mail),
CONSTRAINT lieferanten_ck1 CHECK ( geschlecht in ('w', 'm'))
);


-- Tabelle der Lieferantenbestellungen wird erstellt
CREATE TABLE Lieferantenbestellungen(
Liefer_id INTEGER AUTO_INCREMENT,
CONSTRAINT Lieferantenbestellungen_PK PRIMARY KEY(Liefer_id),
auftragsdatum timestamp DEFAULT CURRENT_TIMESTAMP,
auftragsstatus VARCHAR(45) NOT NULL,
lieferantennummer  INTEGER NOT NULL
);

CREATE TABLE Bestellpositionsdaten(
    bestell_nr INTEGER AUTO_INCREMENT,
    CONSTRAINT bestellpositionsdaten_PK PRIMARY KEY(bestell_nr),
    Liefer_id INTEGER NOT NULL,
    produktnummer INTEGER NOT NULL,
    menge INTEGER NOT NULL,
    lieferstatus VARCHAR(45) NOT NULL,
    lieferdatum timestamp  NOT NULL,
    einkaufspreis NUMERIC(8,2),

    CONSTRAINT Lieferantenbestellungen_CK1 CHECK (menge >0),
    CONSTRAINT Lieferantenbestellungen_CK2 CHECK (einkaufspreis >0)
);


-- Fremdschlüssel hinzufügen
ALTER TABLE Produkte
ADD CONSTRAINT Produkte_FK1 FOREIGN KEY(Kategoriennummer) REFERENCES Kategorien(Kategoriennummer) ON DELETE CASCADE;

ALTER TABLE Abteilung
ADD CONSTRAINT Abteilung_FK1 FOREIGN KEY(leiter_nummer) REFERENCES Mitarbeiter(mitarbeiternummer) ON DELETE SET NULL ;

ALTER TABLE Mitarbeiter
ADD CONSTRAINT  Mitarbeiter_FK1 FOREIGN KEY (abteilungsnummer) REFERENCES Abteilung(abteilungsnummer) ON DELETE CASCADE ;

ALTER TABLE Auftrag
ADD CONSTRAINT Auftrag_FK1 FOREIGN KEY (kundennummer) REFERENCES Kunden(kundennummer) ON DELETE CASCADE;

ALTER TABLE Auftragspositionsdaten
ADD CONSTRAINT Auftragspositionsdaten_FK1  FOREIGN KEY (produktnummer) REFERENCES Produkte(produktnummer) ON DELETE CASCADE;
ALTER TABLE Auftragspositionsdaten
ADD CONSTRAINT Auftragspositionsdaten_FK2 FOREIGN KEY(auftragsnummer)REFERENCES Auftrag(auftragsnummer) ON DELETE CASCADE;

ALTER TABLE Lieferantenbestellungen
ADD CONSTRAINT Lieferantenbestellungen_FK2 FOREIGN KEY(lieferantennummer)REFERENCES Lieferanten(lieferantennummer)ON DELETE CASCADE ;

ALTER TABLE Bestellpositionsdaten
ADD CONSTRAINT Bestellpositionsdaten_FK1 FOREIGN KEY (produktnummer) REFERENCES Produkte(produktnummer);
ALTER TABLE Bestellpositionsdaten
ADD CONSTRAINT Bestellpositionsdaten_FK2 FOREIGN KEY (Liefer_id) REFERENCES Lieferantenbestellungen(Liefer_id);


ALTER TABLE Warenkorbpositionen
ADD CONSTRAINT Warenkorb_fk1 FOREIGN KEY (kundennummer) REFERENCES Kunden(kundennummer) ON DELETE CASCADE;
ALTER TABLE Warenkorbpositionen
ADD CONSTRAINT Warenkorb_fk2  FOREIGN KEY (produktnummer) REFERENCES Produkte(produktnummer) ON DELETE CASCADE;

-- DML-Anweisungen


-- Einfuegen von Kategorien
INSERT INTO Kategorien VALUES (NULL, 'Damen', 'Turnschuhe, Sportschuhe,  Laufschuhe');
INSERT INTO Kategorien VALUES (NULL, 'Kinder', 'Turnschuhe, Sportschuhe,  Laufschuhe');
INSERT INTO Kategorien VALUES (NULL, 'Herren', 'Turnschuhe, Sportschuhe,  Laufschuhe');
COMMIT;

-- Einfuegen von Produkte
INSERT INTO Produkte VALUES (NULL, 'Turnschuhe', 'Größe: 39, 40, 41,42,43,44. Farben: Weiß, Schwarz, Rot.  Kategorie:Sportschuhe für Frauen. Zustand: neu.',
                            'https://picture.yatego.com/images/5d70b00bece764.8/big_e4f02fb0ef4d96ece3bf97b11a9a48ad-qmh/art-330-neon-luftpolster-turnschuhe-schuhe-sneaker-sportschuhe-neu-damen.png'
                            , 30, 10, 0, 20,  20, 1);
INSERT INTO Produkte VALUES (NULL, 'Hausschuhe', 'Größe: 40, 41,42,43,44. Farben: Weiß, Schwarz. Kategorie:Sportschuhe für Frauen. Zustand: neu.',
                            'https://images-na.ssl-images-amazon.com/images/I/81OallZGGIL._AC_UX500_.jpg' , 15, 10, 20,  30,  10, 1);
INSERT INTO Produkte VALUES (NULL, 'Sportschuhe', 'Größe: 40, 41,42,43,44. Farben: Weiß, Schwarz, Rot. Kategorie:Sportschuhe für Frauen. Zustand: neu.',
                            'https://i.pinimg.com/originals/b7/0b/29/b70b29a71aefdbac93d580210a19d734.jpg'
                            , 30, 10, 0,  20,  20, 1);
INSERT INTO Produkte VALUES (NULL, 'Turnschuhe', 'Größe: 20, 25, 28,30,33,35. Farben: Weiß, Schwarz, Rot. Kategorie:Turnschuhe für Kinder. Zustand: neu.',
                            'https://mirapodo.scene7.com/is/image/mirapodo/ext/5024070-01.jpg' , 20, 10, 15,  25,  10, 2);
INSERT INTO Produkte VALUES (NULL, 'Turnschuhe', 'Größe: 40, 41,42,43,44. Farben: Weiß, Schwarz, Rot. Kategorie:Turnschuhe für Männer. Zustand: neu.',
                            'https://cdn1.outlet46.de/item/images/117140/full/7681-1-NIKE-Sneaker-moderne-Herren-Schuhe-MD-Runner-2-19-Grau-117140.jpg' , 15, 10, 20,  30,  10, 3);
INSERT INTO Produkte VALUES (NULL, 'Sportschuhe', 'Größe: 40, 41,42,43,44. Farben: Weiß, Schwarz, Rot. Kategorie:Sportschuhe für Männer. Zustand: neu.',
                            'https://www.fusskleidung.de/media/image/39/be/5d/US8104-Black-PaarFront-S_600x600.jpg' , 30, 10, 0,  20,  20, 3);
COMMIT;


-- Einfuegen von Abteilungen
INSERT INTO Abteilung VALUES (NULL, 'Logistik', NULL, 'Logistikabteilung mit 50 Mitarbeiter');
INSERT INTO Abteilung VALUES (NULL, 'Personal', NULL, 'Personalabteilung mit 5 Mitarbeiter');
INSERT INTO Abteilung VALUES (NULL, 'Kundenservice', NULL, 'Kundenserviceabteilung mit 3 Mitarbeiter');
COMMIT;


-- Tabelle der Mitarbeiter wird erstellt
INSERT INTO Mitarbeiter VALUES (NULL, 'm', 'Meier', 'Marcos', 'Hauptstr. 50', 51034, 'köln', 0170000001, 'marcos.meier@gmail.com', 3000, 1);
INSERT INTO Mitarbeiter VALUES (NULL, 'm', 'Müller', 'Paul', 'Berlinestr. 5', 51034, 'köln',NULL, 'Paul.Müller@gmail.com', 3500, 2);
INSERT INTO Mitarbeiter VALUES (NULL, 'w', 'Peter', 'Marie', 'An der wende 6', 51634, 'Gummersbach', 0170000333, 'Peter.Marie@gmail.com', 2500, 1);
INSERT INTO Mitarbeiter VALUES (NULL, 'm', 'Thomas', 'Peter', 'Schulestr. 20', 51634, 'Gummersbach',NULL, 'Peter.Thomas@gmail.com', 2500, 1);
INSERT INTO Mitarbeiter VALUES (NULL, 'w', 'Westenberg', 'Lena', 'Grenzweg 6', 51634, 'Gummersbach', 0170002341, 'Lena.Westenberg@gmail.com', 2400, 2);
COMMIT;

UPDATE Abteilung SET leiter_nummer = 1 WHERE abteilungsnummer = 1;
UPDATE Abteilung SET leiter_nummer = 2 WHERE abteilungsnummer = 2;
COMMIT;





-- Einfuegen von Lieferanten
INSERT INTO Lieferanten VALUES (NULL, 'm', 'Zimmermann', 'Hans', 'Hochstr. 1', 51634, 'Gummersbach', 017001234, 'Hans.Zimmermann@gmail.com','von der Firma XXX');
INSERT INTO Lieferanten VALUES (NULL, 'm', 'Meier', 'Paul', 'Hohler str. 5', 51634, 'Gummersbach',017021236, 'Paul.Meier@gmail.com','von der Firma YYY');
INSERT INTO Lieferanten VALUES (NULL, 'm', 'Freiberg', 'Jan', 'Schulestr. 20', 51634, 'Gummersbach',017001235, 'Jan.Freiberg@gmail.com','von der Firma YYY');
INSERT INTO Lieferanten VALUES (NULL, 'm', 'Ali', 'Mustafa', 'Katzeweg 6', 51634, 'Gummersbach', 0170002341, 'Mustafa.Ali@gmail.com','von der Firma YYY');
COMMIT;
