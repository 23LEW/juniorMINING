-- ============================================================================
-- Insert: Carpathian Gold Inc.
--   Sample: FAILURE
--   Methodisch: ursprunglich als Reverse-Causation-Test fuer Dino Titaro
--   konzipiert (Allied Gold -> Carpathian). Recherche zeigt: Titaro hatte
--   KEINE Karriere beim historischen australischen Allied Gold; sein Allied-
--   Gold-Bezug ist Allied Gold Corporation (Marrone, post-Carpathian, ab 2023).
--   Daher kein gueltiger Reverse-Causation-Test. Korrektur an Konzeptpapier
--   v0.4 §8.2 in v0.5 nachzuholen. Eintragung als regulaeres Failure.
-- ============================================================================
-- Schema-Voraussetzung: v1.3
-- Audit: docs/260515 Batch-1 Audit.md (Abschnitt 3 + Cross-Cutting A)
-- ============================================================================

PRAGMA foreign_keys = ON;

-- 1) company
-- exit_type: 'Delisting' gewaehlt, weil Carpathian-Gold-Ticker (CPN) im Aug 2016
-- aufhoerte zu existieren (Rename zu Euro Sun Mining). Schema kennt keinen
-- Wert 'Rebrand'; 'Delisting' ist der naechstpassende, mit Vermerk im Event.
INSERT INTO company (
    name, isin, country, stock_exchange,
    listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3,
    fraud_flag, success_label
) VALUES (
    'Carpathian Gold Inc.', 'CA14426W1068', 'Canada', 'TSX',
    2003, 2016,
    'Au', 'Cu', NULL,
    0, 'failure'
);

-- 2) person (7; Directors-only Hick, Carvalho ausgeschlossen per Workflow §3.1.
-- Barrick Gold Corp. als Corporate Cornerstone Investor 2011-08 ist nicht
-- als person erfasst — Schema-Limitation; im Event-Eintrag dokumentiert.)
INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Dino', 'Titaro', 'Canada',
     'M.Sc. Geology, University of Western Ontario; P.Geo',
     1, 2003, 'ALLIED-Titaro-Bio',
     'Professional geologist, 35+ years international experience. Karriere: Getty Mines (1980-1986), eigene Beratungsfirma A.C.A. Howe International Limited (1986-2003), Founder Carpathian Gold 2003. WICHTIG: KEINE verifizierbare Karriere beim historischen australischen Allied Gold Ltd. — sein Allied-Gold-Bezug ist Allied Gold Corporation (Marrone, post-Carpathian, ab 2023).'),

    ('Guy', 'Charette', 'Canada',
     'Law degree (Quebec); 25+ Jahre Corporate Finance / Securities Law',
     0, 2010, 'GNW-CPN-2012-07-03-CFO',
     'Corporate-Finance/Securities-Anwalt. CEO Bay Merchant Group 1993-2000; Mitgruender Charette-Nantel Attorneys LLP. Verliess Anwaltspraxis 2010 fuer Carpathian Vollzeit. EVP/COO 2010-2014, dann Interim CEO 2014-2016.'),

    ('Rishi', 'Tibriwal', 'Canada', 'CA, MBA, CFA',
     0, 2012, 'GNW-CPN-2012-07-03-CFO',
     'Chartered Accountant und Finanzfachmann. Appointed CFO Carpathian Gold 03.07.2012, ersetzte Linda Prager.'),

    ('Linda', 'Prager', 'Canada', NULL,
     0, NULL, 'GNW-CPN-2012-07-03-CFO',
     'CFO Carpathian Gold vor Juli 2012; nach Wechsel kurzzeitig beratend taetig. Genauer Antrittstermin nicht aus oeffentlichen Quellen verifiziert.'),

    ('Randall', 'Ruff', 'Canada', NULL,
     0, 2002, 'ESM-MDA-Q3-2013',
     'Consulting Project Geologist; COO CGL (Carpathian Goldfields Ltd, Vorgaengergesellschaft) 2002; COO Carpathian Gold Corporate 2004-2010; danach Executive VP Exploration bis 2016. Reine Exploration-Fokus, keine Production-Verantwortung.'),

    ('Scott', 'Moore', 'Canada', NULL,
     0, 2016, 'GNW-CPN-2016-05-09-FM',
     'Capital-Markets-Manager; COO Forbes & Manhattan Inc. zum Zeitpunkt der Berufung. Interim CEO Carpathian Gold 19.05.2016 nach Forbes-&-Manhattan-Cornerstone-Investment. Weitergefuehrt als CEO Euro Sun Mining.'),

    ('Stan', 'Bharti', 'Canada', 'Mining Engineer (PhD)',
     1, 2016, 'GNW-CPN-2016-05-09-FM',
     'Founder/Chairman Forbes & Manhattan, Toronto Merchant Bank fuer Resource-Companies (Sulliden Gold, Avion Gold, Belo Sun Mining, Central Sun, etc.). Forbes-&-Manhattan + Sulliden Mining Capital + Black Iron zeichneten CAD 10 Mio Cornerstone Mai 2016. Production-Ramp-Up-Erfahrung ueber F&M-Portfolio.');

-- 3) role (11)
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Dino' AND nachname='Titaro'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Founder', '2003', NULL),

    ((SELECT id FROM person WHERE vorname='Dino' AND nachname='Titaro'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'President', '2003-01', '2014-01'),

    ((SELECT id FROM person WHERE vorname='Dino' AND nachname='Titaro'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'CEO', '2003-01', '2014-01'),

    ((SELECT id FROM person WHERE vorname='Guy' AND nachname='Charette'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'COO', '2010', '2014-01'),

    ((SELECT id FROM person WHERE vorname='Guy' AND nachname='Charette'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'CEO', '2014-01', '2016-05'),

    ((SELECT id FROM person WHERE vorname='Rishi' AND nachname='Tibriwal'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'CFO', '2012-07', '2016'),

    ((SELECT id FROM person WHERE vorname='Linda' AND nachname='Prager'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'CFO', NULL, '2012-07'),

    ((SELECT id FROM person WHERE vorname='Randall' AND nachname='Ruff'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'COO', '2004', '2010'),

    ((SELECT id FROM person WHERE vorname='Randall' AND nachname='Ruff'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'VP Exploration', '2010', '2016'),

    ((SELECT id FROM person WHERE vorname='Scott' AND nachname='Moore'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'CEO', '2016-05', '2016-08'),

    ((SELECT id FROM person WHERE vorname='Stan' AND nachname='Bharti'),
     (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Cornerstone Investor', '2016-05', NULL);

-- 4) project (2 Hauptprojekte; Rovina Valley umfasst 3 Sub-Deposits Rovina,
-- Colnic, Ciresata — fuer Phase 2 als zusammengefasstes Project gefuehrt,
-- Sub-Deposit-Hierarchie via parent_project_id in spaeterer Enrichment-Phase.)
INSERT INTO project (
    company_id, name, jurisdiction,
    primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage,
    parent_project_id
) VALUES
    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Rovina Valley',
     'Romania, Hunedoara County (Golden Quadrilateral)',
     'Au', 'Cu', NULL,
     'Porphyry Au-Cu (3 proximale Porphyry-Deposits: Rovina, Colnic, Ciresata)',
     'Greenfield', 'PEA',
     NULL),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Riacho dos Machados (RDM)',
     'Brazil, Minas Gerais State',
     'Au', NULL, NULL,
     'Orogenic / shear-hosted gold (open pit)',
     'Brownfield', 'Production',
     NULL);

-- 5) outcome
-- Discovery 0.5: Rovina-Porphyry-Trio durch Carpathian delineated (Greenfield-
--   bis-Resource-Discovery, aber kein kommerzielles Ergebnis unter Carpathian).
--   RDM war Re-Development eines Vale-Legacy-Deposits — kein Discovery-Credit.
-- Reserve-Conversion 1.0: RDM erreichte FS (April 2011) + Production. Best-of-
--   Portfolio-Bewertung.
-- Exit-Production 0.4: RDM produzierte kommerziell ab Q4 2014, ging aber
--   binnen 18 Monaten an Lender Macquarie/Brio durch Default verloren.
--   Restrukturierung mit Fortbestand des Vehikels (Rename Euro Sun) -> 0.4.
-- Peak-MarketCap 0.3: ~220-280 Mio CAD in 2011, knapp unter 250-Mio-Schwelle.
--   Bei genauerem Share-Count koennte 0.6 zutreffen; konservativ 0.3.
-- Total: 0.25*0.5 + 0.25*1.0 + 0.30*0.4 + 0.20*0.3 = 0.555
INSERT INTO outcome (
    company_id,
    discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score,
    total_score, exit_type, exit_year,
    peak_marketcap_cad_million
) VALUES (
    (SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
    0.5, 1.0, 0.4, 0.3,
    0.555, 'Delisting', 2016,
    250.0
);

-- 6) event
INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'IPO', '2003',
     'TSX-Listing als Carpathian Gold Inc. Exaktes IPO-Datum nicht aus oeffentlichen Quellen verifiziert.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Discovery', '2007',
     'Rovina-Valley-Discovery: Delineation der 3 Porphyry-Au-Cu-Deposits (Rovina, Colnic, Ciresata) durch Carpathian-Exploration in Rumaenien.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'M&A', '2008-10-30',
     'Erwerb 100% Riacho dos Machados (RDM) Gold Project, Brasilien, durch Buyout von Melbourne Ventures Fund LLC.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'PEA', '2009-08-12',
     'NI 43-101 Preliminary Economic Assessment fuer RDM (Brasilien) veroeffentlicht.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'PEA', '2010-03-23',
     'NI 43-101 Preliminary Economic Assessment fuer Rovina Valley (Rumaenien): ~6.22 Moz Au-eq, 19-Jahr-Mine-Life, ~200 koz/yr Au + ~325 koz/yr Au-eq.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'FS', '2011-04-06',
     'NI 43-101 Feasibility Study fuer RDM Open Pit angekuendigt; Construction Decision. Anmerkung: am 12.08.2011 schloss Barrick Gold ein strategisches Placement von CAD 20 Mio (38,461,538 Aktien @ CAD 0.52, ~9% mit Anti-Dilution-Rechten bis 8.5%) — Corporate Cornerstone Investment ohne passenden event_type in Schema v1.3.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Resource Estimate', '2012-08-31',
     'NI 43-101 Technical Report Rovina Valley: M+I 7.19 Moz Au + 1.42 Blb Cu.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Production Start', '2013-12-24',
     'Erster Goldguss bei RDM, Brasilien. Beginn der operativen Phase.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Production Start', '2014-10',
     'Commercial Production declared bei RDM (full ramp-up Q4 2014). Production lief allerdings nur ~86% des Plans Okt 2014.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'M&A', '2016-04-29',
     'Forced Asset Transfer: Carpathian gibt 100% RDM an Brio Gold (Yamana-Tochter) ab unter Restrukturierungs-Vereinbarung; Lender Macquarie/Brio hatte ~USD 213 Mio Loan-Facility gezogen.'),

    ((SELECT id FROM company WHERE name='Carpathian Gold Inc.'),
     'Delisting', '2016-08-18',
     'Carpathian Gold Inc. umbenannt zu Euro Sun Mining Inc. (TSX: ESM). Der Ticker CPN hoert auf zu existieren — kein Delisting im engeren Sinn, sondern Rebrand. Schema kennt keinen Wert "Rebrand"; als Delisting kategorisiert mangels Alternative.');
