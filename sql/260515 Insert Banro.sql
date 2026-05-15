-- ============================================================================
-- Insert: Banro Corporation
--   Sample: FAILURE
--   Methodisch: Jurisdiktions-Risiko-Muster (DRC eastern conflict zone).
--   CCAA Dez 2017 / Delisting Jan 2018. Stamm-Equity wiped out; Operations
--   bestehen privat fort unter Gramercy + Baiyin Ownership.
-- ============================================================================
-- Schema-Voraussetzung: v1.3
-- Audit: docs/260515 Batch-1 Audit.md (Abschnitt 5)
-- ============================================================================

PRAGMA foreign_keys = ON;

-- 1) company
-- listing_year=1996: Original-Listing als Banro Resource Corp. auf TSE.
-- Aktueller Ticker BAA wurde erst 2005 etabliert (Rename Jan 2001, AMEX-Listing
-- Maerz 2005, TSX-Listing November 2005). Im Event-Eintrag dokumentiert.
INSERT INTO company (
    name, isin, country, stock_exchange,
    listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3,
    fraud_flag, success_label
) VALUES (
    'Banro Corporation', 'CA0668001039', 'Canada', 'TSX → NYSE American',
    1996, 2018,
    'Au', NULL, NULL,
    0, 'failure'
);

-- 2) person (10; Director-only (van Rooyen post-Chairman-Periode) und Non-Exec
-- Personen (Farr als General Counsel, Gramercy + Baiyin als Corporate-Cornerstone-
-- Entities) ausgeschlossen.)
INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Arnold', 'Kondrat', 'Canada', 'University of Western Ontario',
     1, 1994, 'SEC-BAA-FORM20F-2017',
     'Founder Banro Corporation (inkorporiert 1994 als Banro International Capital Inc.). 30+ Jahre in Resource Public Markets; 27-Jahr-Historie in DRC. Auch Founder Loncor Gold (1993), BRC Diamond (1999), Gentor Resources (2005), Sterling Portfolio Securities (2000). Production-Ramp-Up-Erfahrung via Twangiza-Commercial-Production 2012.'),

    ('Bernard', 'van Rooyen', 'South Africa', NULL,
     1, 1996, 'GPC-BAA-PRIVATE-EQUITY-2011',
     'Suedafrikanischer Bergbau-Industrie-Veteran mit senior Executive-Erfahrung. Founding director Banro 1996. Chairman in der fruehen Periode (pre-2004). Verifiziert ueber externe Quellen (LinkedIn / MarketScreener).'),

    ('Peter', 'Cowley', 'United Kingdom', 'Geologist (40+ Jahre Industrie)',
     1, 2004, 'PR-BAA-PRINSLOO-2007',
     'Geologe mit 40+ Jahren Industrie-Erfahrung. Fuehrte Banro-Exploration die die Twangiza-Namoya-Au-Resourcen delineierte. Vorher Managing Director Ashanti Exploration, dort Geita-Mine-Discovery/Development (Tansania). Production-Ramp-Up via Geita.'),

    ('Mike', 'Prinsloo', 'South Africa', NULL,
     1, 2007, 'PR-BAA-PRINSLOO-2007',
     'Karriere bei AngloGold (Anglo American Gold) und Gold Fields; zuletzt CEO Gold Fields Business & Leadership Academy + Managing Director Driefontein Gold Mine 2002-2007. Banro-CEO 2007 mit Mandat Transition Explorer -> Developer. Trat 16.09.2010 zurueck.'),

    ('Simon', 'Village', 'United Kingdom', NULL,
     0, 2004, 'PR-BAA-PRINSLOO-2007',
     'Chairman Banro seit 2004. Former Managing Director World Gold Council; Founder Exchange Traded Gold (early Physical-Gold-ETF-Produkte). Interim President/CEO 2010 nach Prinsloo-Abgang; returned als President/CEO 2012-2013.'),

    ('John', 'Clarke', 'United Kingdom',
     'BSc Metallurgy, University College Cardiff; PhD Metallurgy, Cambridge University; MBA, Middlesex Polytechnic',
     1, 2013, 'BAA-MGT-CLARKE',
     'Metallurg, Karriere seit 1972; vorher CEO Nevsun Resources; Chairman/Director Great Quest Metals. Uebernahm Banro 2014 nach Village-Exit; fuehrte durch schwierige Namoya-Ramp-Up, Security-Krisen, und CCAA-Filing Dez 2017.'),

    ('Brett', 'Richards', 'Canada',
     'Mechanical Engineering, Durham College; MBA Management Engineering, Cornell University Johnson School; Mining Engineering Certificate, Queen''s University',
     1, 2018, 'PR-BAA-RICHARDS-2018',
     'Senior Mining Executive, 32+ Jahre. Mitglied des original Founding-Teams Katanga Mining; Senior-Rollen Kinross Gold, Co-Steel, Avocet, Roxgold, Octéa, African Thunder Platinum. Appointed Chairman/CEO Post-CCAA Banro 07.05.2018.'),

    ('Donat', 'Madilo', 'DRC',
     'Finance / accounting (Congolese-Canadian)',
     1, 2007, 'BAA-MGT-CLARKE',
     '17+ Jahre bei Banro; CFO ab 2007. Effektiv 01.09.2014 zugewiesen zu Senior VP Commercial & DRC Affairs (bis 2018). Major Role in Banro-Transition von Exploration zu Two-Mine-Producer.'),

    ('Dan', 'Bansah', 'Ghana',
     'M.Sc. Mineral Exploration (Distinction), University of Leicester; Chartered Professional Member AusIMM',
     1, 2007, 'BAA-MGT-BANSAH',
     '19+ Jahre Mineral Resource and Ore Reserve Estimation. VP Exploration Banro ~2007-2014, dann VP Projects & Operations 2014-2018, durch Twangiza- und Namoya-Development-Zyklen.'),

    ('Bubaka', 'Rudahya', 'DRC', NULL,
     0, 2010, 'BAA-MGT-CLARKE',
     'DRC-basierter Group Chief Geologist Banro; fuehrte lokale Exploration am Twangiza-Namoya-Gold-Belt.');

-- 3) role (16)
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Arnold' AND nachname='Kondrat'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'Founder', '1994', NULL),

    ((SELECT id FROM person WHERE vorname='Bernard' AND nachname='van Rooyen'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'Chairman', '1996', '2004'),

    ((SELECT id FROM person WHERE vorname='Peter' AND nachname='Cowley'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'President', '2004', '2008'),

    ((SELECT id FROM person WHERE vorname='Peter' AND nachname='Cowley'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CEO', '2004', '2008'),

    ((SELECT id FROM person WHERE vorname='Mike' AND nachname='Prinsloo'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'President', '2007', '2010-09-16'),

    ((SELECT id FROM person WHERE vorname='Mike' AND nachname='Prinsloo'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CEO', '2007', '2010-09-16'),

    ((SELECT id FROM person WHERE vorname='Simon' AND nachname='Village'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'Chairman', '2004', '2018'),

    ((SELECT id FROM person WHERE vorname='Simon' AND nachname='Village'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CEO', '2010-09-16', '2010-12'),

    ((SELECT id FROM person WHERE vorname='Simon' AND nachname='Village'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CEO', '2012', '2013'),

    ((SELECT id FROM person WHERE vorname='John' AND nachname='Clarke'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'President', '2014', '2018'),

    ((SELECT id FROM person WHERE vorname='John' AND nachname='Clarke'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CEO', '2014', '2018'),

    ((SELECT id FROM person WHERE vorname='Brett' AND nachname='Richards'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'Chairman', '2018-05-07', NULL),

    ((SELECT id FROM person WHERE vorname='Brett' AND nachname='Richards'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CEO', '2018-05-07', NULL),

    ((SELECT id FROM person WHERE vorname='Donat' AND nachname='Madilo'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'CFO', '2007', '2014-09-01'),

    ((SELECT id FROM person WHERE vorname='Dan' AND nachname='Bansah'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'VP Exploration', '2007', '2014'),

    ((SELECT id FROM person WHERE vorname='Bubaka' AND nachname='Rudahya'),
     (SELECT id FROM company WHERE name='Banro Corporation'),
     'Chief Geologist', '2010', '2018');

-- 4) project (4 Properties am Twangiza-Namoya-Gold-Belt, alle DRC South-Kivu/
-- Maniema. Belt-Hierarchie via parent_project_id nicht eingefuehrt, weil
-- "Belt" geologische Beschreibung ist, nicht Konzession.)
INSERT INTO project (
    company_id, name, jurisdiction,
    primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage,
    parent_project_id
) VALUES
    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Twangiza',
     'DRC, South Kivu Province',
     'Au', NULL, NULL,
     'Orogenic gold (Neoproterozoic, low greenschist facies; Kibaran Mobile Belt western margin)',
     'Brownfield', 'Production', NULL),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Namoya',
     'DRC, Maniema Province',
     'Au', NULL, NULL,
     'Orogenic gold (Twangiza-Namoya belt; Mount Mwendamboko, Muviringu, Kakula, Namoya Summit pits)',
     'Brownfield', 'Production', NULL),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Lugushwa',
     'DRC, South Kivu Province',
     'Au', NULL, NULL,
     'Orogenic gold (Twangiza-Namoya belt)',
     'Brownfield', 'Discovery', NULL),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Kamituga',
     'DRC, South Kivu Province',
     'Au', NULL, NULL,
     'Orogenic gold (mesothermal vein system unter historischer Mobale-Tagebau)',
     'Brownfield', 'Discovery', NULL);

-- 5) outcome
-- Discovery 0.5: SOMINKI-legacy-Properties (historisch bekannt), Banros
--   eigene NI-43-101-Arbeit definierte moderne Resourcen am Twangiza-Namoya-Belt.
-- Reserve-Conversion 1.0: FS sowohl Twangiza (2011) als auch Namoya (2013-12-31).
-- Exit 0.0: CCAA-Debt-for-Equity-Swap; Public-Equity extinguished;
--   Common-Aktionaere erhielten nichts. Operations bestehen privat fort.
-- Peak-MarketCap 0.6: USD ~900 Mio (Sept 2011) bis ~USD 1 Mrd (2012)
--   ~CAD 1.0 Mrd; borderline 0.6/1.0, konservativ unterer Bucket.
-- Total: 0.25*0.5 + 0.25*1.0 + 0.30*0 + 0.20*0.6 = 0.495
INSERT INTO outcome (
    company_id,
    discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score,
    total_score, exit_type, exit_year,
    peak_marketcap_cad_million
) VALUES (
    (SELECT id FROM company WHERE name='Banro Corporation'),
    0.5, 1.0, 0.0, 0.6,
    0.495, 'Delisting', 2018,
    1000.0
);

-- 6) event (12 Hauptevents; Security-Incidents 2017 narrative im Insolvency-
-- Event-Description, da Schema keinen passenden event_type kennt.)
INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'IPO', '1996',
     'TSX-Listing der Vorgaengergesellschaft Banro Resource Corp.; C$19.5 Mio Capital Raise zur Finanzierung der SOMINKI-Akquisition. Aktueller Ticker BAA erst 2005 etabliert (Rename Jan 2001, AMEX/TSX-Re-Listing 2005).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'M&A', '1996',
     'Banro erwirbt 72% von SOMINKI von der Regierung Zaires; Erwerb der Properties Twangiza, Namoya, Lugushwa, Kamituga (alle DRC).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Resource Estimate', '2005-02',
     'SRK NI 43-101 Technical Reports filed fuer Kamituga und Twangiza Properties.'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Exchange Upgrade', '2005-03-28',
     'Stammaktien beginnen Handel an American Stock Exchange (AMEX, spaeter NYSE-American) als Banro Corporation.'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Exchange Upgrade', '2005-11-10',
     'Stammaktien beginnen Handel an TSX als Banro Corporation (Symbol BAA).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'PEA', '2011-03-09',
     'NI 43-101 Economic Assessment Technical Report Twangiza Phase 1 (revised 2011-03-24).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Production Start', '2011-Q4',
     'Twangiza poured first gold (oxide circuit).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Production Start', '2012-09-01',
     'Banro declares commercial production at Twangiza Gold Mine.'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'FS', '2014-05-13',
     'Namoya NI 43-101 Feasibility Study Technical Report filed (Venmyn Deloitte; effective date 2013-12-31).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Production Start', '2016-01',
     'Banro declares commercial production at Namoya Gold Mine. Ramp-up troubled; spaeter suspendiert wegen Mai-Mai-Yakutumba-Militia-Attacken.'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Insolvency', '2017-12-22',
     'Banro commences CCAA restructuring proceedings (Ontario Superior Court of Justice); Support Agreement mit 74%+ Stakeholders fuer Recapitalization Plan; USD 20 Mio Interim DIP Financing approved. Trigger: Cash-Flow-Kollaps nach DRC-Security-Vorfaellen (Maerz 2017 Kidnapping 5 Mitarbeiter; Juli 2017 Mai-Mai-Yakutumba-Militia-Konflikt mit Supply-Road-Cutoff; 23 Contractor-Trucks gefangen).'),

    ((SELECT id FROM company WHERE name='Banro Corporation'),
     'Delisting', '2018-01-22',
     'TSX und NYSE American delisten Banro Stammaktien zum Handelsschluss. Restrukturierungs-Abschluss 04.05.2018: Banro emergiert als private Entitaet kontrolliert von Gramercy Funds Management + Baiyin International Investment; old Equity extinguished. Brett Richards als Chairman+CEO der privaten Nachfolgegesellschaft (07.05.2018).');
