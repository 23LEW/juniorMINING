-- Junior-Mining Erfolgs-Datenbank
-- Schema-Version: 1.1
-- Erstellt: 2026-05-14 (v1.0)
-- Geaendert: 2026-05-14 (v1.1: role_type um 'Project Geologist' erweitert;
--                              Migrationsskript siehe
--                              sql/260514 Migration v1.0 zu v1.1 - role_type Project Geologist.sql)
-- Korrespondiert mit: docs/Konzeptpapier_Junior-Mining-Erfolgs-Datenbank_v0.4.docx, Abschnitt 4

PRAGMA foreign_keys = ON;

-- Tabelle 1: Unternehmen
CREATE TABLE company (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    name                 TEXT NOT NULL,
    isin                 TEXT,
    country              TEXT,
    stock_exchange       TEXT,
    listing_year         INTEGER,
    delisting_year       INTEGER,
    primary_commodity    TEXT,
    commodity_2          TEXT,
    commodity_3          TEXT,
    fraud_flag           INTEGER DEFAULT 0,
    success_label        TEXT CHECK (success_label IN ('success', 'failure', 'ambivalent', 'pending'))
);

-- Tabelle 2: Personen
CREATE TABLE person (
    id                              INTEGER PRIMARY KEY AUTOINCREMENT,
    vorname                         TEXT,
    nachname                        TEXT NOT NULL,
    birth_year                      INTEGER,
    education                       TEXT,
    country                         TEXT,
    production_ramp_up_experience   INTEGER DEFAULT 0,
    first_mention_year              INTEGER,
    first_mention_source            TEXT
);

-- Tabelle 3: Rollen (Verknuepfung Person <-> Company)
CREATE TABLE role (
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

-- Tabelle 4: Projekte
CREATE TABLE project (
    id                     INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id             INTEGER NOT NULL REFERENCES company(id),
    name                   TEXT NOT NULL,
    jurisdiction           TEXT,
    primary_commodity      TEXT,
    commodity_2            TEXT,
    commodity_3            TEXT,
    deposit_type           TEXT,
    stage_at_acquisition   TEXT CHECK (stage_at_acquisition IN (
        'Greenfield', 'Brownfield', 'Discovery', 'PEA', 'PFS', 'FS', 'Construction', 'Production'
    )),
    peak_stage             TEXT CHECK (peak_stage IN (
        'Greenfield', 'Brownfield', 'Discovery', 'PEA', 'PFS', 'FS', 'Construction', 'Production'
    ))
);

-- Tabelle 5: Erfolgsmessung
CREATE TABLE outcome (
    id                         INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id                 INTEGER NOT NULL UNIQUE REFERENCES company(id),
    discovery_score            REAL,
    reserve_conversion_score   REAL,
    exit_production_score      REAL,
    peak_marketcap_score       REAL,
    total_score                REAL,
    exit_type                  TEXT CHECK (exit_type IN (
        'M&A', 'Production', 'Insolvency', 'Delisting', 'Active'
    )),
    exit_year                  INTEGER
);

-- Tabelle 6: Ereignisse / Meilensteine
CREATE TABLE event (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id   INTEGER NOT NULL REFERENCES company(id),
    event_type   TEXT NOT NULL CHECK (event_type IN (
        'PEA', 'PFS', 'FS', 'Discovery', 'M&A', 'Delisting', 'Insolvency',
        'PDAC Award', 'IPO', 'Production Start', 'Resource Estimate'
    )),
    event_date   TEXT,
    description  TEXT
);

-- Indizes fuer haeufige Abfragen
CREATE INDEX idx_role_person     ON role(person_id);
CREATE INDEX idx_role_company    ON role(company_id);
CREATE INDEX idx_project_company ON project(company_id);
CREATE INDEX idx_event_company   ON event(company_id);
CREATE INDEX idx_company_success ON company(success_label);
