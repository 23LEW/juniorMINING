-- Migration v1.0 -> v1.1
-- Anlass: role_type erweitert um 'Project Geologist'
-- Begruendung: Workflow-Erweiterung um Kategorie
--   "Schluessel-Feldgeologen mit Discovery-Beitrag"
--   (Anlassfall: Julio Soto bei Aurelian Resources / Fruta del Norte 2006)
-- Datum: 2026-05-14
-- Anwendung in DB Browser for SQLite:
--   File -> Open Database -> data/junior_mining.db
--   Reiter "SQL ausfuehren" / "Execute SQL"
--   Inhalt dieser Datei einfuegen oder oeffnen
--   "SQL ausfuehren" Button (oder F5)
--   Bei Erfolg: "Aenderungen schreiben" / "Write Changes" druecken
--
-- Hinweis: DB Browser umschliesst die SQL-Ausfuehrung selbst mit einer Transaktion.
-- Deshalb hier KEIN explizites BEGIN TRANSACTION / COMMIT.

PRAGMA foreign_keys = OFF;

-- Neue role-Tabelle mit erweiterter CHECK-Constraint
CREATE TABLE role_new (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    person_id   INTEGER NOT NULL REFERENCES person(id),
    company_id  INTEGER NOT NULL REFERENCES company(id),
    role_type   TEXT NOT NULL CHECK (role_type IN (
        'CEO', 'Chairman', 'CFO', 'COO', 'President',
        'VP Exploration', 'Chief Geologist', 'Project Geologist',
        'Cornerstone Investor', 'Founder'
    )),
    start_date  TEXT,
    end_date    TEXT
);

-- Bestehende Daten uebernehmen (zum Migrationszeitpunkt: keine Zeilen)
INSERT INTO role_new (id, person_id, company_id, role_type, start_date, end_date)
    SELECT id, person_id, company_id, role_type, start_date, end_date FROM role;

-- Alte Tabelle entfernen und neue umbenennen
DROP TABLE role;
ALTER TABLE role_new RENAME TO role;

-- Indizes wiederherstellen (DROP TABLE entfernt sie mit)
CREATE INDEX idx_role_person  ON role(person_id);
CREATE INDEX idx_role_company ON role(company_id);

PRAGMA foreign_keys = ON;
