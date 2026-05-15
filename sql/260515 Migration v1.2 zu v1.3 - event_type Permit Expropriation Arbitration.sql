-- Migration v1.2 -> v1.3
-- Anlass: Pipeline-Batch 1 (Crystallex) hat 4 zentrale Events, die im Schema
--         v1.2 fehlen. Diese Events sind nicht peripher, sondern bilden
--         die Failure-Story einer politisch zerstoerten Junior ab.
--
-- Aenderungen:
--   event.event_type Vokabel erweitert um:
--     - 'Permit Granted'      (Umwelt-/Bergbau-Genehmigung gewaehrt)
--     - 'Permit Denied'       (Umwelt-/Bergbau-Genehmigung verweigert)
--     - 'Expropriation'       (staatliche Enteignung / Vertragskuendigung)
--     - 'Arbitration Award'   (Schiedsgerichts-Entscheidung, z.B. ICSID)
--
-- Konvention: konkrete Bezeichnung des Awards / der Behoerde / des Tribunals
-- wird in der description-Spalte genannt (analog zur Industry-Award-Konvention
-- aus Workflow v0.2 §12).
--
-- Datum: 2026-05-15
--
-- Anwendung in DB Browser for SQLite:
--   File -> Open Database -> data/junior_mining.db
--   Reiter "Execute SQL"
--   Inhalt dieser Datei laden -> Play (oder Cmd+R)
--   Bei Erfolg: "Write Changes" (Cmd+S)
--
-- KEIN explizites BEGIN TRANSACTION / COMMIT (DB Browser wraps selbst).

PRAGMA foreign_keys = OFF;

-- ----------------------------------------------------------------------------
-- event.event_type Vokabel erweitern: Tabellen-Recreate (SQLite kann CHECK
-- nicht direkt aendern).
-- ----------------------------------------------------------------------------
CREATE TABLE event_new (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id   INTEGER NOT NULL REFERENCES company(id),
    event_type   TEXT NOT NULL CHECK (event_type IN (
        'PEA', 'PFS', 'FS', 'Discovery', 'M&A', 'Delisting', 'Insolvency',
        'Industry Award', 'IPO', 'Production Start', 'Resource Estimate',
        'Exchange Upgrade',
        'Permit Granted', 'Permit Denied', 'Expropriation', 'Arbitration Award'
    )),
    event_date   TEXT,
    description  TEXT
);

INSERT INTO event_new (id, company_id, event_type, event_date, description)
    SELECT id, company_id, event_type, event_date, description FROM event;

DROP TABLE event;
ALTER TABLE event_new RENAME TO event;

CREATE INDEX idx_event_company ON event(company_id);

PRAGMA foreign_keys = ON;

-- Verifikation:
-- SELECT sql FROM sqlite_master WHERE type='table' AND name='event';
