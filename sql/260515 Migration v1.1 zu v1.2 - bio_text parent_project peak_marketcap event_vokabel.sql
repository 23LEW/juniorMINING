-- Migration v1.1 -> v1.2
-- Anlass: Workflow v0.2 fuehrt mehrere methodische Erweiterungen ein,
--         die schema-seitig abgebildet werden muessen.
--
-- Aenderungen:
--   (a) person.bio_text TEXT
--       Kurzbio (max ~500 Zeichen) aus Appointment-PR / AIF zur
--       Personen-Disambiguierung (Workflow v0.2 §4.1).
--
--   (b) project.parent_project_id INTEGER REFERENCES project(id)
--       Self-Reference fuer die Hierarchie Konzession -> Deposit
--       (Workflow v0.2 §10).
--
--   (c) outcome.peak_marketcap_cad_million REAL
--       Exakter Peak-MarketCap-Wert in Mio CAD, zusaetzlich zur
--       Bucket-Klassifikation peak_marketcap_score. Ermoeglicht
--       empirische Bucket-Kalibrierung in Phase 3 (Workflow v0.2 §7.4).
--
--   (d) event.event_type Vokabel erweitert:
--       - Neuer Wert 'Exchange Upgrade' (TSX-V -> TSX, ASX Junior -> ASX Main).
--       - 'PDAC Award' umbenannt zu 'Industry Award' (generischer Bucket;
--         konkrete Award-Bezeichnung in description, siehe Workflow v0.2 §12).
--       Bestehende Zeilen mit event_type='PDAC Award' werden bei der
--       Migration automatisch auf 'Industry Award' gesetzt.
--
-- Datum: 2026-05-15
--
-- Anwendung in DB Browser for SQLite:
--   File -> Open Database -> data/junior_mining.db
--   Reiter "SQL ausfuehren" / "Execute SQL"
--   Inhalt dieser Datei laden -> "SQL ausfuehren" (F5)
--   Bei Erfolg: "Aenderungen schreiben" / "Write Changes"
--
-- Hinweis: DB Browser umschliesst die SQL-Ausfuehrung selbst mit einer Transaktion.
-- Deshalb KEIN explizites BEGIN TRANSACTION / COMMIT in dieser Datei.

PRAGMA foreign_keys = OFF;

-- ----------------------------------------------------------------------------
-- (a) person.bio_text
-- ----------------------------------------------------------------------------
ALTER TABLE person ADD COLUMN bio_text TEXT;

-- ----------------------------------------------------------------------------
-- (b) project.parent_project_id (Self-Reference)
-- ----------------------------------------------------------------------------
ALTER TABLE project ADD COLUMN parent_project_id INTEGER REFERENCES project(id);

-- ----------------------------------------------------------------------------
-- (c) outcome.peak_marketcap_cad_million
-- ----------------------------------------------------------------------------
ALTER TABLE outcome ADD COLUMN peak_marketcap_cad_million REAL;

-- ----------------------------------------------------------------------------
-- (d) event.event_type Vokabel erweitern + bestehende Daten migrieren
-- ----------------------------------------------------------------------------
-- SQLite kann CHECK-Constraints nicht direkt aendern -> Tabellen-Recreate.

CREATE TABLE event_new (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id   INTEGER NOT NULL REFERENCES company(id),
    event_type   TEXT NOT NULL CHECK (event_type IN (
        'PEA', 'PFS', 'FS', 'Discovery', 'M&A', 'Delisting', 'Insolvency',
        'Industry Award', 'IPO', 'Production Start', 'Resource Estimate',
        'Exchange Upgrade'
    )),
    event_date   TEXT,
    description  TEXT
);

-- Bestehende Daten uebernehmen; PDAC Award -> Industry Award
INSERT INTO event_new (id, company_id, event_type, event_date, description)
    SELECT id, company_id,
           CASE WHEN event_type = 'PDAC Award' THEN 'Industry Award'
                ELSE event_type END,
           event_date, description
    FROM event;

DROP TABLE event;
ALTER TABLE event_new RENAME TO event;

-- Index wiederherstellen (DROP TABLE entfernt ihn mit)
CREATE INDEX idx_event_company ON event(company_id);

PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- Verifikation (nach Ausfuehrung; bei Bedarf einzeln entkommentieren)
-- ----------------------------------------------------------------------------
-- SELECT name FROM pragma_table_info('person') WHERE name='bio_text';
-- SELECT name FROM pragma_table_info('project') WHERE name='parent_project_id';
-- SELECT name FROM pragma_table_info('outcome') WHERE name='peak_marketcap_cad_million';
-- SELECT sql FROM sqlite_master WHERE type='table' AND name='event';
-- SELECT event_type, COUNT(*) FROM event GROUP BY event_type ORDER BY event_type;
