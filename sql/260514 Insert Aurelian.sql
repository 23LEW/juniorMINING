-- ============================================================================
-- Insert: Aurelian Resources Ltd. — Erfolgs-Sample, erstes Matched Pair
-- ============================================================================
-- Korrespondiert mit:
--   - Konzeptpapier v0.4, Abschnitt 7.2 (Erfolgs-Sample)
--   - Workflow v0.1, Abschnitt 3 (Eingabe-Reihenfolge)
--   - Workflow v0.2 Aenderungsnotizen (docs/260514 Workflow v0.2 ...md)
--   - Quellen-Log data/sources.csv (11 Quellen, IDs in den Kommentaren)
--
-- Schema-Voraussetzung: v1.1 (role_type um 'Project Geologist' erweitert)
--
-- Ausfuehrung in DB Browser for SQLite:
--   1. data/junior_mining.db oeffnen, Foreign Keys aktiv (PRAGMA pruefen)
--   2. Reiter "SQL ausfuehren" -> diese Datei laden -> Run (F5)
--   3. Bei Erfolg: "Aenderungen schreiben" / Write Changes
--   4. Verifikation am Ende dieser Datei (auskommentierte SELECTs entkommentieren)
--
-- Reihenfolge wegen Foreign-Key-Abhaengigkeiten:
--   company -> person -> role -> project -> outcome -> event
-- ============================================================================

PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- 1) company (1 Zeile)
-- Quellen: PR-KGC-2008-OFFER, PR-ARU-2008-DELIST, TNM-ARU-2006-DISC, WIKI-FDN-MINE
-- ----------------------------------------------------------------------------
INSERT INTO company (
    name, isin, country, stock_exchange,
    listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3,
    fraud_flag, success_label
) VALUES (
    'Aurelian Resources Ltd.', NULL, 'Canada', 'TSX-V → TSX',
    2003, 2008,
    'Au', 'Ag', NULL,
    0, 'success'
);

-- ----------------------------------------------------------------------------
-- 2) person (4 Zeilen)
-- Anderson, Barron, Leary nach Workflow v0.1 Scope.
-- Soto: Erweiterung um "Schluessel-Feldgeologen mit Discovery-Beitrag"
-- (siehe Workflow v0.2 Notizen #1).
-- Quellen: TNM-PERSON-2008-MOTY, ACAD-FDN-2016-DISC, AURANIA-ABOUT-BARRON
-- ----------------------------------------------------------------------------
INSERT INTO person (
    vorname, nachname, birth_year, education, country,
    production_ramp_up_experience, first_mention_year, first_mention_source
) VALUES
    ('Patrick', 'Anderson', NULL,
     'BSc Geology, University of Toronto',
     'Canada', 0, 2001, 'TNM-PERSON-2008-MOTY'),

    ('Keith', 'Barron', NULL,
     'PhD Geology, University of Western Ontario; BSc Geology, University of Toronto',
     'Canada', 0, 2001, 'TNM-PERSON-2008-MOTY'),

    ('Stephen', 'Leary', NULL,
     'BSc Geology, University of Canterbury (NZ) 1993; MAusIMM',
     'New Zealand', 0, 2005, 'TNM-PERSON-2008-MOTY'),

    ('Julio', 'Soto', NULL,
     NULL,
     'Ecuador', 0, 2006, 'ACAD-FDN-2016-DISC');

-- ----------------------------------------------------------------------------
-- 3) role (7 Zeilen) — pragmatisches Mehrfach-Rollen-Modell (Variante beta)
-- Workflow v0.1 §3 Ergaenzung "alle quellenfest belegten Rollen" -> v0.2 #3.
-- Subquery-Lookups statt harter IDs fuer Robustheit.
-- ----------------------------------------------------------------------------
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Patrick' AND nachname='Anderson'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'CEO', '2003', '2009'),

    ((SELECT id FROM person WHERE vorname='Patrick' AND nachname='Anderson'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Founder', '2001', '2008'),

    ((SELECT id FROM person WHERE vorname='Keith' AND nachname='Barron'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Founder', '2001', '2008'),

    ((SELECT id FROM person WHERE vorname='Keith' AND nachname='Barron'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'VP Exploration', '2002', '2005'),

    ((SELECT id FROM person WHERE vorname='Keith' AND nachname='Barron'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Cornerstone Investor', '2001', '2003-06'),

    ((SELECT id FROM person WHERE vorname='Stephen' AND nachname='Leary'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'VP Exploration', '2005-03', '2009'),

    ((SELECT id FROM person WHERE vorname='Julio' AND nachname='Soto'),
     (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Project Geologist', '2006', NULL);

-- ----------------------------------------------------------------------------
-- 4) project (1 Zeile)
-- Fruta del Norte (innerhalb Condor-Konzession); Zwei-Ebenen-Hierarchie
-- siehe Workflow v0.2 Notizen #2.
-- Quellen: TR-ARU-2007-NI43101, TNM-ARU-2008-RESOURCE, WIKI-FDN-MINE
-- ----------------------------------------------------------------------------
INSERT INTO project (
    company_id, name, jurisdiction,
    primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage
) VALUES (
    (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
    'Fruta del Norte',
    'Ecuador, Zamora-Chinchipe',
    'Au', 'Ag', NULL,
    'Epithermal Au-Ag',
    'Greenfield',
    'Discovery'
);

-- ----------------------------------------------------------------------------
-- 5) outcome (1 Zeile)
-- Score-Komponenten nach Workflow v0.1 §7:
--   Discovery 1.0 (eigene NI 43-101)
--   Reserve-Conversion 0.0 (nur Inferred unter Aurelian; PEA/PFS/FS erst Kinross)
--   Exit-Production 1.0 (Akquisition Kinross 2008, Premium 63% > 30%)
--   Peak-MarketCap 1.0 (Verkaufswert 1.2 Mrd CAD; Peak deutlich darueber)
-- Gewichtete Summe: 0.25 + 0 + 0.30 + 0.20 = 0.75
-- ----------------------------------------------------------------------------
INSERT INTO outcome (
    company_id,
    discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score,
    total_score, exit_type, exit_year
) VALUES (
    (SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
    1.0, 0.0, 1.0, 1.0,
    0.75, 'M&A', 2008
);

-- ----------------------------------------------------------------------------
-- 6) event (8 Zeilen)
-- Anmerkungen zu Schema-Limitationen in den description-Feldern.
-- TSX-V -> TSX Graduierung nicht abbildbar (Workflow v0.2 #7a).
-- TNM "Mining Persons of the Year" als PDAC Award gemappt (Workflow v0.2 #7b).
-- ----------------------------------------------------------------------------
INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'IPO', '2003',
     'TSX-V Initial Listing. TSX-Graduierung waehrend Aurelian-Laufzeit nicht als event_type abbildbar (Schema v1.1); vermerkt in Workflow v0.2 Notizen #7a.'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Discovery', '2006',
     'Fruta del Norte Entdeckung; drittes Bohrloch eines 3-Loch-Programms trifft 237.3 m mit 4.14 g/t Au + 8.5 g/t Ag. Discovery durch Pull-apart-Basin-Konzept von S. Leary plus Beobachtung Silifizierung in Basin-Sedimenten durch J. Soto.'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Resource Estimate', '2007-11-15',
     'Erste NI 43-101 Inferred Mineral Resource: 58.9 Mt @ 7.23 g/t Au + 11.8 g/t Ag = 13.7 Moz Au + 22.4 Moz Ag. Technical Report Hennessey/Puritch/Gowans/Leary 2007, amendiert 2008-10-21. Quelle: TR-ARU-2007-NI43101.'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'PDAC Award', '2008-03',
     'PDAC Thayer Lindsley International Discovery Award fuer Keith Barron (Fruta del Norte).'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'M&A', '2008-07-24',
     'Kinross-Aurelian Friendly Combination angekuendigt. 8.20 CAD pro Aurelian-Aktie, 63 Prozent Premium ueber 20-Tage-VWAP, Gesamtwert 1.2 Mrd CAD. Angebot: 0.317 Kinross-Aktien + 0.1429 Warrant pro Aurelian-Aktie. Quelle: PR-KGC-2008-OFFER.'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'M&A', '2008-09-30',
     'Kinross schliesst Akquisition ab; haelt 90.7 Prozent der ausstehenden Aurelian-Aktien; spaeter ueber 94 Prozent. Quelle: PR-ARU-2008-DELIST.'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'Delisting', '2008-10-03',
     'Delisting von Toronto Stock Exchange (TSX), effective close of business 2008-10-03.'),

    ((SELECT id FROM company WHERE name='Aurelian Resources Ltd.'),
     'PDAC Award', '2008-12-30',
     'The Northern Miner "Mining Persons of the Year 2008" fuer Anderson, Barron, Leary. KEIN PDAC-Award im engeren Sinn; eingetragen unter event_type=PDAC Award wegen Schema-Limitation v1.1. Siehe Workflow v0.2 Notizen #7b. Quelle: TNM-PERSON-2008-MOTY.');

-- ============================================================================
-- Verifikation (nach Ausfuehrung der Inserts; bei Bedarf einzeln entkommentieren)
-- ============================================================================
-- SELECT * FROM company WHERE name='Aurelian Resources Ltd.';
-- SELECT vorname, nachname, country FROM person ORDER BY id;
-- SELECT p.vorname, p.nachname, r.role_type, r.start_date, r.end_date
--   FROM role r JOIN person p ON p.id=r.person_id
--   WHERE r.company_id=(SELECT id FROM company WHERE name='Aurelian Resources Ltd.')
--   ORDER BY p.nachname, r.start_date;
-- SELECT name, jurisdiction, stage_at_acquisition, peak_stage FROM project;
-- SELECT discovery_score, reserve_conversion_score, exit_production_score,
--        peak_marketcap_score, total_score, exit_type, exit_year FROM outcome;
-- SELECT event_type, event_date, substr(description,1,80) AS desc_preview FROM event ORDER BY event_date;
