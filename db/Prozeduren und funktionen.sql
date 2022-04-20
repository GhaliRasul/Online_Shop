
 USE basel;

-- Prozeduren und Funktionen


-- 5.1 Funktion: Die Funktion berechnet den verfügbaren Lagerbestand für ein eingegebenes Produkt
-- Die Funktion löschen, wenn sie existiert
DROP FUNCTION IF EXISTS verfuegbarer_Lagerbestand;
DELIMITER // -- ändert das Zeichen für das Ende eines Befehls
CREATE FUNCTION verfuegbarer_Lagerbestand ( p_produktnummer INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_best_bestand INT;
    DECLARE v_res_bestand INT;
    DECLARE v_phys_bestand INT;
    DECLARE v_ver_bestand INT;
    -- um die entsprechende Daten in Variablen zu speichern
    SELECT best_bestand, res_bestand, phys_bestand  INTO v_best_bestand, v_res_bestand, v_phys_bestand
        FROM Produkte WHERE produktnummer = p_produktnummer;

    -- Berechnung vom verfügabeen Lagerbestand
    SET v_ver_bestand = v_best_bestand + v_phys_bestand;
    RETURN (v_ver_bestand);
END //
DELIMITER ;


-- 5.2 Prozedur: Die Prozedur gibt alle vorhandenen Produkte mit deren verfügbaren Lagerbestand aus.
DROP PROCEDURE IF EXISTS Produkt_ausgeben;
DELIMITER //
CREATE PROCEDURE Produkt_ausgeben()
BEGIN
    DECLARE v_produktnummer  INT;
    DECLARE v_produktname  VARCHAR(45);
    DECLARE v_Kategoriennummer  INT;
    DECLARE v_ver_bestand INT;
    DECLARE finished INT DEFAULT 0;
    DECLARE Produkt_cursor CURSOR FOR
        SELECT produktnummer, produktname, Kategoriennummer FROM Produkte ORDER BY produktnummer;
    -- Handler um zu markieren, dass alle Zeilen abgearbeitet wurden
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET finished=1;

    OPEN Produkt_cursor;
    REPEAT
        FETCH Produkt_cursor INTO v_produktnummer, v_produktname, v_Kategoriennummer;
        IF NOT finished THEN
            -- Aufruf der Funktion verfuegbarer_Lagerbestand
			SET v_ver_bestand = verfuegbarer_Lagerbestand(v_produktnummer);

			SELECT v_produktnummer,v_produktname,v_Kategoriennummer,v_ver_bestand;
		END IF;
        UNTIL finished END REPEAT;
    CLOSE Produkt_cursor;
END //
DELIMITER ;

-- 5.3 Prozedur: Die Prozedur erstellt eine Rechnung.
DROP PROCEDURE IF EXISTS Rechnung_erstellen;
DELIMITER //
CREATE  PROCEDURE Rechnung_erstellen(IN p_auftragsnummer INT)
BEGIN
    DECLARE v_auftragsnummer  INT;
    DECLARE v_produktnummer  INT;
    DECLARE v_produktname  CHAR(27);
    DECLARE v_kundennummer  INT;
    DECLARE v_name  CHAR(45);
    DECLARE v_vorname  CHAR(45);
    DECLARE v_adresee  CHAR(45);
    DECLARE v_plz  INT;
    DECLARE v_wohnort  CHAR(40);
    DECLARE v_menge  INT;
    DECLARE v_verkaufspreis  DOUBLE;
    DECLARE v_position_id  INT;
    DECLARE v_Summe DOUBLE ;
	DECLARE finished INT DEFAULT 0;
    DECLARE  auftragposition_c CURSOR FOR SELECT position_id, menge, produktnummer FROM Auftragspositionsdaten WHERE auftragsnummer = p_auftragsnummer;
    -- Handler um zu markieren, dass alle Zeilen abgearbeitet wurden
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET finished=1;

     SELECT kundennummer INTO v_kundennummer FROM Auftrag WHERE auftragsnummer = p_auftragsnummer;
     SELECT name,vorname,adresee,plz,wohnort INTO v_name,v_vorname,v_adresee,v_plz,v_wohnort FROM Kunden WHERE kundennummer = v_kundennummer;
     -- Design von Rechnung
     SELECT '_______________________________________________________________',
			'|                           Rechnung        ',
			'|                                                      ', now(),
			'| ', v_vorname,v_name,
			'| ',v_adresee,' Auftrags-Nr.: ',p_auftragsnummer,
			'| ', v_plz, v_wohnort,' Kunden-Nr.: ', v_kundennummer
			'|  ',
			'|    ProNr.  Produkt                   Preis    Menge    Preis',
			'| -------------------------------------------------------------';
     OPEN auftragposition_c;
     REPEAT
        FETCH auftragposition_c INTO v_position_id, v_menge, v_produktnummer;
        IF NOT finished THEN
			-- um Verkaufspreis zu haben
			SELECT verkaufspreis, produktname INTO v_verkaufspreis, v_produktname FROM Produkte WHERE produktnummer = v_produktnummer;
			SET v_Summe = v_Summe + (v_menge * v_verkaufspreis);
			SELECT '| ', v_produktnummer, v_produktname, v_verkaufspreis, v_menge, v_menge * v_verkaufspreis;
        END IF;
     UNTIL finished END REPEAT;
     SELECT '|',
			'| -------------------------------------------------------------',
			'|                                      Rechnungsbetrag:  ', v_Summe,
			'|                                      MWST-Betrag:      ', (v_Summe * 0.19),
			'|                                      Nettobetrag:      ', (v_Summe - (v_Summe * 0.19) ),
			' ',
			'|                Vielen Dank für Ihren Einkauf                 ',
			'|______________________________________________________________';
     CLOSE auftragposition_c;

END //
DELIMITER ;

-- 5.4 Prozedur: Sie löscht ein bestimmtes Produkt aus System
-- Die Prozedur löschen, wenn sie existiert
DROP PROCEDURE IF EXISTS Produt_loeschen;
DELIMITER //
CREATE PROCEDURE Produt_loeschen( IN  p_produktnummer INT)
BEGIN
    DECLARE v_produktnummer  INT;

    SELECT produktnummer INTO v_produktnummer FROM Produkte WHERE produktnummer = p_produktnummer;
    DELETE FROM Produkte WHERE produktnummer = p_produktnummer;
    COMMIT;
END //
DELIMITER ;



-- 5.5 Funktion: Diese Funktion berechnet automatisch die Anzahl der Verkäufe innerhalb eines Zeitraums
DROP FUNCTION IF EXISTS anzahl_derVerkaeufe_berechnen;
DELIMITER //
CREATE FUNCTION anzahl_derVerkaeufe_berechnen ( p_produktnummer INT, StartD DATE, EndD DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_Anzahl INT;
     SET v_Anzahl = 0;
    SELECT count( a.produktnummer )  INTO v_Anzahl
    FROM Auftragspositionsdaten a
    WHERE produktnummer = p_produktnummer
        AND ((SELECT auftragsdatum FROM Auftrag WHERE auftragsnummer = a.auftragsnummer) BETWEEN StartD AND EndD);

    RETURN v_Anzahl;
END //
DELIMITER ;


-- 5.6 Prozedur: erfolg_produkt
drop procedure erfolg_produkt;

delimiter //
create procedure erfolg_produkt(IN produktsnummer_p int)
begin
    declare produktnummer_v integer default null;
    DECLARE Absatzmenge integer default 0;
    DECLARE Einkaufskosten float  default 10;
    DECLARE Fixkosten float default 0;
    DECLARE Variablekosten float default 0;
    DECLARE Erloes float default 0;
    DECLARE GuV float default 0;

    select p.produktnummer into produktnummer_v from produkte p
    where p.produktnummer=produktsnummer_p;

    SELECT SUM(a.menge) INTO Absatzmenge
    FROM Auftragspositionsdaten A
    WHERE a.produktnummer = produktsnummer_p ;
    if Absatzmenge is null then
        set absatzmenge =0;
    end if;

    SELECT p.verkaufspreis * Absatzmenge INTO Erloes
    FROM Produkte p
    WHERE p.produktnummer = produktsnummer_p;
    if Erloes is null then
        set Erloes =0;
    end if;

    SELECT (sum(b.einkaufspreis) /count(*)) * Absatzmenge INTO Einkaufskosten
    FROM Bestellpositionsdaten b
    WHERE b.produktnummer = produktsnummer_p;
    if Einkaufskosten is null then
        set Einkaufskosten =0;
    end if;

    set Fixkosten = 2.5 ;
    set Variablekosten = 0.5 * Absatzmenge ;
    set GuV = Erloes -( Variablekosten+Fixkosten + Einkaufskosten);
    if produktnummer_v is not null then
        IF GuV > 0 THEN
            SELECT'|','|Der Gewinn betragt: ', guv , ' Euro |';
        ELSeIF guv < 0 THEN
            SELECT '|','|Der Verlust betragt: ', guv , ' Euro |';
        ELSE
            SELECT '|','|weder Gewinn noch Verlust: ' ,guv, ' Euro |';
        END IF;
    else
        select ' oops aber nicht möglich';
    end if;
end //
delimiter ;



-- Trigger

-- 6.1 Trigger: Automatische Nachbestellung der Produkte
DROP TRIGGER IF EXISTS automatische_Nachbestellung_der_Produkte;
DELIMITER //
CREATE TRIGGER automatische_Nachbestellung_der_Produkte
AFTER INSERT ON  Auftragspositionsdaten
FOR EACH ROW
BEGIN
    DECLARE v_menge INT;
    DECLARE v_mindestbestand INT;
 DECLARE id INT;
    SELECT mindestbestand INTO v_mindestbestand FROM Produkte WHERE produktnummer = NEW.produktnummer;
    SET v_menge = v_mindestbestand - verfuegbarer_Lagerbestand(NEW.produktnummer);
    IF v_menge > 0 THEN
        INSERT INTO Lieferantenbestellungen VALUES
            (NULL, now(),'In Bearbeitung', 1);

        INSERT INTO Bestellpositionsdaten VALUES
            (NULL, last_insert_id() , NEW.produktnummer, v_menge, 'In Bearbeitung', now()+ INTERVAL 10 DAY , NULL);

        UPDATE Produkte SET best_bestand = best_bestand + v_menge WHERE produktnummer = NEW.produktnummer;
    END IF;
END //
delimiter ;


-- -- 6.1 Trigger: fuer Update
DROP TRIGGER IF EXISTS automatische_Nachbestellung_der_Produkte1;
DELIMITER //
CREATE TRIGGER automatische_Nachbestellung_der_Produkte1
AFTER UPDATE ON  Auftragspositionsdaten
FOR EACH ROW
BEGIN
    DECLARE v_menge INT;
    DECLARE v_mindestbestand INT;

    SELECT mindestbestand INTO v_mindestbestand FROM Produkte WHERE produktnummer = NEW.produktnummer;
    SET v_menge = v_mindestbestand - verfuegbarer_Lagerbestand(NEW.produktnummer);
    IF v_menge > 0 THEN
        INSERT INTO Lieferantenbestellungen VALUES
            (NULL, now(),'In Bearbeitung', 1);

        INSERT INTO Bestellpositionsdaten VALUES
            (NULL, last_insert_id() , NEW.produktnummer, v_menge, 'In Bearbeitung', now()+ INTERVAL 10 DAY , NULL);

        UPDATE Produkte SET best_bestand = best_bestand + v_menge WHERE produktnummer = NEW.produktnummer;
    END IF;
END //
delimiter ;



-- 6.2 Trigger BestandsKontrolle
DROP TRIGGER if exists BestandsKontrolle_u;

delimiter //
CREATE TRIGGER BestandsKontrolle_u
after  UPDATE on auftragspositionsdaten
FOR EACH ROW
BEGIN
    IF NEW.menge <> OLD.menge THEN
                UPDATE Produkte SET res_bestand = res_bestand + NEW.menge - OLD.menge
                , phys_bestand = phys_bestand - NEW.menge + OLD.menge
                WHERE produktnummer = NEW.produktnummer;
    END IF;

END //
delimiter ;


DROP TRIGGER if exists BestandsKontrolle_d;

delimiter //
CREATE  TRIGGER BestandsKontrolle_d
BEFORE DELETE ON Auftragspositionsdaten
FOR EACH ROW
BEGIN
    UPDATE Produkte SET res_bestand = res_bestand - OLD.menge , phys_bestand = phys_bestand + OLD.menge
            WHERE produktnummer = OLD.produktnummer;

END //
delimiter ;
drop trigger if exists BestandsKontrolle_i;

delimiter //
CREATE TRIGGER BestandsKontrolle_i
after INSERT ON Auftragspositionsdaten
FOR EACH ROW
BEGIN
            UPDATE Produkte SET res_bestand = res_bestand + NEW.menge , phys_bestand = phys_bestand - NEW.menge
            WHERE produktnummer = NEW.produktnummer;
END //
delimiter ;



-- 6.3 Trigger: Trigger für Sicherheitskontrolle, damit die Mitarbeiter außerhalb der Arbeitszeit die Daten nicht ändern.
DROP TRIGGER IF EXISTS abt_Check_time;
DELIMITER //
CREATE TRIGGER abt_Check_time
BEFORE INSERT ON Mitarbeiter
FOR EACH ROW
BEGIN
    IF TIME(now()) NOT BETWEEN '8:00:00' AND '18:00:00' THEN
        SIGNAL SQLSTATE '20001' SET message_text = 'Sie dürfen nur zwischen 8:00 und 20:00 arbeiten!';
    END IF;
END //
DELIMITER ;
--
DROP TRIGGER IF EXISTS abt_Check_time1;
DELIMITER //
CREATE TRIGGER abt_Check_time1
BEFORE UPDATE ON Mitarbeiter
FOR EACH ROW
BEGIN
    IF TIME(now()) NOT BETWEEN '8:00:00' AND '18:00:00' THEN
        SIGNAL SQLSTATE '20001' SET message_text = 'Sie dürfen nur zwischen 8:00 und 18:00 arbeiten!';
    END IF;
END //
DELIMITER ;
--
DROP TRIGGER IF EXISTS abt_Check_time2;
DELIMITER //
CREATE TRIGGER abt_Check_time2
BEFORE DELETE ON Mitarbeiter
FOR EACH ROW
BEGIN
    IF TIME(now()) NOT BETWEEN '8:00:00' AND '18:00:00' THEN
        SIGNAL SQLSTATE '20001' SET message_text = 'Sie dürfen nur zwischen 8:00 und 18:00 arbeiten!';
    END IF;
END //
DELIMITER ;



-- 7.1 INSTEAD-OF-Trigger
/* instead of Trigger in MYSQL nicht möglich */
CREATE OR REPLACE VIEW ausstehendeLieferantenbestellungen AS
SELECT bestell_nr, menge, lieferstatus, produktnummer, einkaufspreis, verkaufspreis, mindestbestand
FROM Bestellpositionsdaten natural JOIN Produkte
WHERE lieferstatus = 'In Bearbeitung';
