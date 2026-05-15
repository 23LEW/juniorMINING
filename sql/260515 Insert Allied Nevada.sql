-- ============================================================================
-- Insert: Allied Nevada Gold Corp.
--   Sample: FAILURE
--   Methodisch: Operational/Financial Failure (Chapter 11 2015 nach Mill-
--   Expansion-Vorhaben). Spin-off von Vista Gold 2007. Robert Buchan (Kinross-
--   Gruender) als Founder — Cross-Link Erfolgsperson zu erfolglosem Vehikel.
-- ============================================================================
-- Schema-Voraussetzung: v1.3
-- Audit: docs/260515 Batch-1 Audit.md (Abschnitt 4)
-- ============================================================================

PRAGMA foreign_keys = ON;

-- 1) company
INSERT INTO company (
    name, isin, country, stock_exchange,
    listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3,
    fraud_flag, success_label
) VALUES (
    'Allied Nevada Gold Corp.', 'US0193441005', 'USA', 'TSX → NYSE-MKT',
    2007, 2015,
    'Au', 'Ag', NULL,
    0, 'failure'
);

-- 2) person (6; Initial-Direktoren Richings, Palmer, Eppler ausgeschlossen.
-- VP Exploration / Chief Geologist nicht namentlich verifizierbar — Allied
-- Nevada war operations-fokussiert.)
INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Robert', 'Buchan', 'Canada',
     'BSc Mining Engineering, Heriot-Watt University 1969; MSc Mining Engineering, Queen''s University 1972',
     1, 2007, 'WIKI-BUCHAN',
     'Schottisch-kanadischer Mining-Engineer; Founder Kinross Gold (1993); retired als Kinross-CEO Jan 2005. Founder Katanga Mining. Instrumental bei Formation von Allied Nevada Gold; Executive Chairman 2007-2015.'),

    ('Scott', 'Caldwell', 'USA', 'BSc Mining Engineering, University of Arizona',
     1, 2006, 'VISTA-2006-PROG',
     'Mining Engineer mit 30+ Jahren Operating-Erfahrung. Vorher EVP/COO Kinross Gold (8 Jahre) + Kinross-Board-Member. Fuehrte Allied Nevada durch Hycroft-Commissioning und Run-up-Phase. President & CEO 2007-2013.'),

    ('Randy', 'Buffington', 'USA',
     'MSc Civil Engineering (University of Nevada Reno / University of Colorado)',
     1, 2013, 'YAHOO-BUFF-2013',
     'Mining Executive mit 28+ Jahren Operations. Vorher SVP Operations Coeur d''Alene Mines; davor General Manager Barrick Goldstrike. Uebernahm Allied Nevada Operations Feb 2013 als COO, dann President + CEO ab Juli 2013; fuehrte durch Chapter 11.'),

    ('Stephen', 'Jones', 'USA', 'BBA Finance, Texas A&M University; CPA',
     0, 2012, 'ELKO-CFO-2012',
     'Finance Executive; vorher President/CFO EPM Mining Ventures; SVP/CFO Katanga Mining (raised ~USD 300 Mio Debt Financing); fruehere Rollen bei Freeport-McMoRan, El Paso Corp. Signed die Chapter-11-Declaration. CFO 2012-2015.'),

    ('Hal', 'Kirby', 'Canada', NULL,
     0, 2007, 'SEC-ANV-S1-2007',
     'Mining-Finance-Executive; vorher Vice President + Controller Kinross Gold Corporation vor Allied-Nevada-Beitritt. Erster VP + CFO ab Spin-off 2007. Nahm Anfang 2012 Beurlaubung; ersetzt durch Stephen Jones.'),

    ('Carl', 'Pescio', 'USA', NULL,
     0, 2006, 'SEC-ANV-S1-2007',
     'Langjaehriger unabhaengiger Nevada-Prospektor/Explorer; staked hunderte Claims quer durch Nevada (seit 1980er-1990er). Brachte mit Ehefrau Janet die Nevada-Mineralien-Assets bei Allied-Nevada-Gruendung ein; groesster Einzelaktionaer (~16.2%).');

-- 3) role (10)
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Buchan'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Founder', '2007', NULL),

    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Buchan'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Chairman', '2007-05-10', '2015'),

    ((SELECT id FROM person WHERE vorname='Scott' AND nachname='Caldwell'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'President', '2007-05-10', '2013-07'),

    ((SELECT id FROM person WHERE vorname='Scott' AND nachname='Caldwell'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'CEO', '2007-05-10', '2013-07'),

    ((SELECT id FROM person WHERE vorname='Randy' AND nachname='Buffington'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'COO', '2013-02-04', '2013-07'),

    ((SELECT id FROM person WHERE vorname='Randy' AND nachname='Buffington'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'President', '2013-07', '2015'),

    ((SELECT id FROM person WHERE vorname='Randy' AND nachname='Buffington'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'CEO', '2013-07', '2015'),

    ((SELECT id FROM person WHERE vorname='Stephen' AND nachname='Jones'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'CFO', '2012-03', '2015'),

    ((SELECT id FROM person WHERE vorname='Hal' AND nachname='Kirby'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'CFO', '2007-05', '2012-03'),

    ((SELECT id FROM person WHERE vorname='Carl' AND nachname='Pescio'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Founder', '2007', NULL),

    ((SELECT id FROM person WHERE vorname='Carl' AND nachname='Pescio'),
     (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Cornerstone Investor', '2007-05-10', '2015');

-- 4) project (Hycroft als Haupt-Operations-Asset; Sekundaer-Properties
-- Hasbrouck Mountain, Mountain View, Wildcat, Three Hills, Maverick Springs
-- waren Exploration-Stage und nicht material fuer Outcome — in description
-- erwaehnt aber nicht separat erfasst.)
INSERT INTO project (
    company_id, name, jurisdiction,
    primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage,
    parent_project_id
) VALUES (
    (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
    'Hycroft Mine',
    'USA, Nevada (Sulphur Mining District; Humboldt + Pershing Counties)',
    'Au', 'Ag', NULL,
    'Epithermal Au-Ag (hot-spring style, Sulphur district)',
    'Brownfield',
    'Production',
    NULL
);

-- 5) outcome
-- Discovery 0.0: Hycroft = existierender Past-Producer-Asset (stillgelegt 1998),
--   bei Spin-off 2007 von Vista Gold uebertragen. Sekundaer-Properties alle
--   known historic prospects, keine Greenfield-Discoveries.
-- Reserve-Conversion 1.0: Hycroft mit PFS (2011) + FS (2011/2012) Mill-
--   Expansion + aktive Heap-Leach-Produktion seit 2008.
-- Exit 0.0: Chapter 11 Maerz 2015, Pre-Petition-Equity wiped out.
-- Peak-MarketCap 1.0: USD ~3.3 Mrd Mai 2011 (89.65M Aktien × ~USD 37);
--   USD-CAD-Konversion 2011 nahe Paritaet -> ~CAD 3.3 Mrd, weit > 1 Mrd.
-- Total: 0.25*0 + 0.25*1.0 + 0.30*0 + 0.20*1.0 = 0.45
INSERT INTO outcome (
    company_id,
    discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score,
    total_score, exit_type, exit_year,
    peak_marketcap_cad_million
) VALUES (
    (SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
    0.0, 1.0, 0.0, 1.0,
    0.45, 'Insolvency', 2015,
    3300.0
);

-- 6) event
INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'IPO', '2007-05-10',
     'Spin-off von Vista Gold Corp.: Allied Nevada Gold Corp. shares beginnen Handel an TSX und NYSE-AMEX (Symbol ANV). Vista-Aktionaere erhielten 70% des neuen Vehikels.'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Resource Estimate', '2008',
     'Initial NI 43-101 Resource Estimates fuer Hycroft-Restart sowie fuer Hasbrouck Mountain, Mountain View, Maverick Springs.'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Production Start', '2008-12',
     'Erster Goldguss bei restartetem Hycroft-Heap-Leach (~1,000 oz Au + 3,000 oz Ag). On schedule fuer Q4 2008.'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'PFS', '2011',
     'Hycroft Mill-Expansion Pre-Feasibility Study veroeffentlicht — NPV USD 1.7 Mrd @ 26.5% IRR, initial CAPEX ~USD 894 Mio fuer 120,000 st/d Mill.'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'FS', '2011-09',
     'Positive Feasibility Study fuer Hycroft Mill-Expansion veroeffentlicht (M3 mit SRK-Resource-Modelling).'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'FS', '2012',
     'Updated Hycroft Mill FS: 19-Jahr-Mine-Life, 582 koz Au + 29.1 Moz Ag avg annual (Y1-10), initial CAPEX USD 1.2 Mrd, NPV USD 1.6 Mrd @ 6%, IRR 37%. Mill nie gebaut.'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Insolvency', '2015-03-10',
     'Allied Nevada Gold Corp. + 13 Affiliated Debtors filing Chapter 11 Petition im US Bankruptcy Court District of Delaware (Case 15-10503). Listed USD 664 Mio Debt vs USD 941 Mio Assets.'),

    ((SELECT id FROM company WHERE name='Allied Nevada Gold Corp.'),
     'Delisting', '2015-03',
     'Trading suspendiert auf NYSE-MKT und TSX nach Chapter 11; Aktien zu OTC als ANVGQ. Pre-petition Common Equity (ANV) im Reorganization Plan extinguished; emergierte Okt 2015 als private Hycroft Mining Corporation.');
