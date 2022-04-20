

-- Teste fuer Funktionen und Prozeduren

-- Test fuer 5.1 Funktion verfuegbarer_Lagerbestand
-- Kontrollanfrage
SELECT produktnummer, best_bestand, phys_bestand, res_bestand FROM Produkte;
-- Test mit korrektem Fall
SELECT VERFUEGBARER_LAGERBESTAND(1) FROM DUAL;
-- Test mit Fehlerhaftem Fall
SELECT VERFUEGBARER_LAGERBESTAND(20) FROM DUAL;


-- Test fuer 5.2 Prozedur Produkt_ausgeben
call basel.Produkt_ausgeben();


-- Test fuer 5.3 Prozedur Rechnung_erstellen;
-- Test mit korrektem Fall
call basel.Rechnung_erstellen(1);
-- Test mit Fehlerhaftem Fall
call basel.Rechnung_erstellen(9);


-- Test fuer 5.4 Prozedur Produt_loeschen;
-- Kontrollanfrage
SELECT * FROM produkte;
-- Test mit korrektem Fall
CALL Produt_loeschen(2);
-- Test mit Fehlerhaftem Fall
CALL Produt_loeschen(10);
-- Kontrollanfrage
SELECT * FROM produkte;



-- Test fuer 5.5 Funktion anzahl_derVerkaeufe_berechnen
-- Kontrollanfrage
SELECT produktnummer FROM Auftragspositionsdaten ;
-- Test mit korrektem Fall
 SELECT anzahl_derVerkaeufe_berechnen(1, now() - INTERVAL 10 DAY, now()) FROM DUAL;
-- Test mit Fehlerhaftem Fall
 SELECT anzahl_derVerkaeufe_berechnen(6, now() - INTERVAL 10 DAY, now() - 10) FROM DUAL;


-- Test fuer 5.6 Prozedur: Die Prozedur berechnet den Gewinn oder Verlust ein eingegebenes Produkt. Und stellt das Ergebnis aus.
-- Test mit korrektem Fall.User soll ProduktNummer eingeben.
call  erfolg_produkt(1); -- Produkt_Nummer : 1 Der Gewinn betragt 86 Euro
call erfolg_produkt(2);-- Produkt_Nummer : 2 Der Gewinn betragt 2.005 Euro
/*Test mit fehlerhaftem Fall.*/
call erfolg_produkt(10);-- Produkt_Nummer : 10 keine Daten zurückgeliefert!
call erfolg_produkt(0);-- Produkt_Nummer : 0 keine Daten zurückgeliefert!


-- Teste fuer Trigger


-- Test fuer 6.1  Trigger automatische_Nachbestellung_der_Produkte
-- Kontrollanfrage
SELECT * FROM   Lieferantenbestellungen;
SELECT * FROM   Bestellpositionsdaten;
SELECT produktnummer, mindestbestand, res_bestand, phys_bestand , best_bestand, verfuegbarer_Lagerbestand(produktnummer) FROM PRODUKTE;
-- Testfall mit INSERTT
INSERT INTO Auftragspositionsdaten VALUES (NULL, 1, 3, 1);
INSERT INTO Auftragspositionsdaten VALUES (NULL, 3, 3, 11);
-- Kontrollanfrage
SELECT * FROM   Lieferantenbestellungen;
SELECT * FROM   Bestellpositionsdaten;
SELECT produktnummer, mindestbestand, res_bestand, phys_bestand , best_bestand, verfuegbarer_Lagerbestand(produktnummer) FROM PRODUKTE;
-- Testfall mit INSERTT
UPDATE Auftragspositionsdaten SET menge = 2 WHERE position_id = 1;
-- Kontrollanfrage
SELECT * FROM   Lieferantenbestellungen;
SELECT * FROM   Bestellpositionsdaten;
SELECT produktnummer, mindestbestand, res_bestand, phys_bestand , best_bestand, verfuegbarer_Lagerbestand(produktnummer) FROM PRODUKTE;
ROLLBACK;



-- TEST fuer  6.2  TRigger ->Bestandkontrolle
  /* Insert Testing */
select *from produkte ;
INSERT INTO Auftragspositionsdaten VALUES (null, 4, 3, 3);
INSERT INTO Auftragspositionsdaten VALUES (null, 1, 3, 5);
select *from PRODUKTE;
/* Delete Testing */
select * from PRODUKTE;
delete from AUFTRAGSPOSITIONSDATEN where POSITION_ID = 8;
delete from AUFTRAGSPOSITIONSDATEN where POSITION_ID = 7;
select * from PRODUKTE;
/* Update Testing */
select * from PRODUKTE;
update AUFTRAGSPOSITIONSDATEN set MENGE =2 where POSITION_ID=1;
update AUFTRAGSPOSITIONSDATEN set menge = 3 where POSITION_ID =2;
select *from produkte ;
commit;


-- TEST fuer 6.3 Trigger abt_Check_time
-- Kontrollanfrage
SELECT mitarbeiternummer, Gehalt  FROM Mitarbeiter;
-- Test mit korrektem Fall
INSERT INTO Mitarbeiter VALUES (NULL, 'm', 'Basel', 'Hussein', 'Hauptstr. 50', 51034, 'köln', 0170000001, 'Basel1@gmail.com', 3000, 1);
-- Test mit korrektem Fall
UPDATE Mitarbeiter SET Gehalt = 2501 WHERE mitarbeiternummer = 1;
-- Test mit korrektem Fall
DELETE FROM Mitarbeiter WHERE mitarbeiternummer = 1;
-- Kontrollanfrage
SELECT mitarbeiternummer, Gehalt  FROM Mitarbeiter;
