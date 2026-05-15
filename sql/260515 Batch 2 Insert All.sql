-- ============================================================================
-- Pipeline-Batch 2 (Variante A: 5 Success-Companies)
--   Companies: Fronteer Gold, Reservoir Minerals, Probe Mines, Detour Gold, Pretium Resources
--   Sample-Label alle: success
--   Schema-Voraussetzung: v1.3
--   Audit: docs/260515 Batch-2 Audit.md
-- ============================================================================
-- Reihenfolge im File: pro Company company -> person -> role -> project -> outcome -> event
-- Direktoren-only ausgeschlossen per Workflow v0.2 §3.1
-- ============================================================================

PRAGMA foreign_keys = ON;

-- ============================================================================
-- COMPANY 1: Fronteer Gold Inc.
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Fronteer Gold Inc.', NULL, 'Canada', 'TSX → NYSE-Amex', 2001, 2011,
    'Au', 'U', NULL, 0, 'success');

INSERT INTO person (vorname, nachname, birth_year, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Mark', 'O''Dea', 1967, 'Canada',
     'BSc Geological Sciences Carleton University 1989; PhD Geology (Structural Geology) Monash University 1996',
     1, 2001, 'STRATUM-OD-INT',
     'Mining-Entrepreneur, Founder Fronteer Gold 2001-2011 (transformierte ~US$2M-Startup in CAD 2.3 Mrd Newmont-M&A). Serial Founder: Aurora Energy, Pilot Gold, True Gold, Liberty Gold, Pure Gold, Discovery Silver. Chairman Pilot Gold post-Newmont 2011. Executive Chairman True Gold 2011-2016 (an Endeavour Mining verkauft).'),

    ('Sean', 'Tetzlaff', NULL, 'Canada',
     'CPA, CA (Chartered Accountant)',
     1, 2005, 'SEC-FRG-2011-EX1',
     'Finanzfachmann mit 25+ Jahren Mining. CFO, VP Finance, Corporate Secretary Fronteer Gold 2005-2011. Concurrently CFO Aurora Energy Resources 2006-2008 (IPO bis Uranium-Resource-Entwicklung).'),

    ('Scott', 'Heffernan', NULL, 'Canada',
     'M.Sc.; P.Geo (Professional Geologist)',
     1, 2008, 'SEC-FRG-2009-TR',
     'Registered Professional Geologist, 15+ Jahre Mineral Exploration. VP Exploration Fronteer Gold pre-Newmont-Akquisition. Fuehrte Long-Canyon-, Sandman-, Northumberland-Exploration in Nevada. Wechselte zu True Gold Mining post-Spin-off (Karma Burkina Faso).'),

    ('Peter', 'Carter', NULL, 'Canada',
     'Mining Engineer (25+ Jahre Operations)',
     1, 2009, 'SEC-FRG-2011-EX1',
     'Mine-Builder und Operator mit 25+ Jahren Mining-Erfahrung. COO und VP Engineering Fronteer Gold 2009-2011. Verantwortlich fuer Development-Strategie und Operational-Planning fuer Long Canyon und Portfolio.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Mark' AND nachname='O''Dea'),
     (SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Founder', '2001-05', NULL),
    ((SELECT id FROM person WHERE vorname='Mark' AND nachname='O''Dea'),
     (SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'CEO', '2001-05', '2011-04-06'),
    ((SELECT id FROM person WHERE vorname='Mark' AND nachname='O''Dea'),
     (SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'President', '2001-05', '2011-04-06'),
    ((SELECT id FROM person WHERE vorname='Sean' AND nachname='Tetzlaff'),
     (SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'CFO', '2005', '2011-04-06'),
    ((SELECT id FROM person WHERE vorname='Scott' AND nachname='Heffernan'),
     (SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'VP Exploration', '2008', '2011-04-06'),
    ((SELECT id FROM person WHERE vorname='Peter' AND nachname='Carter'),
     (SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'COO', '2009', '2011-04-06');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Long Canyon', 'USA, Nevada (Elko County, Pequop Mountains)',
     'Au', NULL, NULL,
     'Off-trend sediment-hosted (Carlin-style oxide/mixed)', 'Brownfield', 'PFS', NULL),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Michelin', 'Canada, Labrador (Central Mineral Belt)',
     'U', NULL, NULL,
     'Conventional Uranium', 'Brownfield', 'PEA', NULL),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Northumberland + Sandman (Nevada)', 'USA, Nevada',
     'Au', 'Ag', NULL,
     'Carlin-style oxide gold', 'Brownfield', 'Discovery', NULL);

-- Outcome: Discovery 1.0 (Mark-O''Dea-Team-systematische-Drillerei nach Pittston-1999-jasperoid;
-- Fronteer baute Resource von ~0 auf 2.2 Moz Au plus 84.4 Mlb U3O8; major discovery credit
-- via NI 43-101 Resource Definition 2009-2011), Reserve-Conversion 0.6 (PFS-Level pre-Newmont),
-- Exit 1.0 (Newmont M&A 37% Premium auf 20-Tage-VWAP), Peak-MarketCap 0.6 (~CAD 950 Mio
-- Standalone-Peak; CAD 2.3 Mrd M&A inkl. Pilot-Gold-Spin und Uranium-Sale an Paladin).
-- Total: 0.25*1.0 + 0.25*0.6 + 0.30*1.0 + 0.20*0.6 = 0.82
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
    1.0, 0.6, 1.0, 0.6, 0.82, 'M&A', 2011, 950.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'IPO', '2001',
     'Fronteer Development Group beginnt Handel an TSX. Mark O''Dea uebernimmt CEO-Rolle der Shell-Company; spaeter umbenannt Fronteer Gold.'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'M&A', '2007-09',
     'Fronteer erwirbt NewWest Gold (Long-Canyon-Property in Nevada).'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Resource Estimate', '2009-03',
     'Long Canyon PFS-Level Resource: M+I 4.8 Mt @ 2.35 g/t Au (363 koz); Inferred 8.8 Mt @ 1.63 g/t Au.'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'M&A', '2009-04',
     'Fronteer erwirbt 100% Aurora Energy Resources (Michelin U-Projekt Labrador) fuer ~CAD 180 Mio (final 7.9% remaining ownership).'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'PEA', '2009-09',
     'Michelin Uranium PEA: NPV USD 914M, IRR 19.4%, 4.7-year payback. M+I 84.4 Mlb U3O8 + Inferred 52.5 Mlb.'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Resource Estimate', '2011-01',
     'Long Canyon Updated Resource: 2.2 Moz Au combined (M+I+I).'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'M&A', '2011-02-03',
     'Newmont announcement: Akquisition Fronteer fuer CAD 14/share + 1 Pilot-Gold-share pro FRG-Aktie. Total CAD 2.3 Mrd, 37% Premium auf 20-Tage-VWAP.'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'M&A', '2011-02',
     'Paladin Energy erwirbt Aurora Energy / Michelin von Fronteer fuer CAD 260-261 Mio (separate Transaktion vor Newmont-Closing).'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'M&A', '2011-04-06',
     'Newmont schliesst Akquisition Fronteer ab. Pilot-Gold-Spin-off (Nevada/Turkey/Peru Exploration-Assets) zu Aktionaeren; Mark O''Dea wird Chairman Pilot Gold.'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Delisting', '2011-04-06',
     'Fronteer Gold (FRG.TO) delisted nach Newmont-Akquisitions-Closing.'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Production Start', '2016-11-08',
     'Newmont pours first gold doré at Long Canyon (post-Akquisition, ahead of schedule, under-budget USD 225M).'),
    ((SELECT id FROM company WHERE name='Fronteer Gold Inc.'),
     'Production Start', '2016-12',
     'Newmont declares commercial production Long Canyon: 100-150 koz/yr, 8-Jahr-Mine-Life, AISC USD 500-600/oz.');


-- ============================================================================
-- COMPANY 2: Reservoir Minerals Inc.
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Reservoir Minerals Inc.', NULL, 'Canada', 'TSX-V', 2011, 2016,
    'Cu', 'Au', NULL, 0, 'success');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Simon', 'Ingram', 'United Kingdom',
     'BSc (Hons) Exploration and Mining Geology Cardiff University; PhD Mineral Resource Evaluation Cardiff University 1997',
     0, 2011, 'CRUNCH-INGRAM',
     'Founder/CEO Reservoir Minerals 2011-2016, 20+ Jahre Exploration und Mining. Cukaru Peki Cu-Au Discovery in Timok-Projekt (Serbien). Thayer Lindsley Award 2016 (Best Discovery).'),

    ('David', 'Miles', 'Canada',
     'BSc Geology; CPA, CA (Chartered Professional Accountant Canada)',
     0, 2011, 'ALTUS-MILES',
     'CFO Reservoir Minerals 2011-2016, 30+ Jahre Mining/Exploration. Ehemals Cominco Ltd (Exploration Controller fuer 8 internationale Explorations-Tochtergesellschaften).'),

    ('Aleksandar', 'Obrenovic', 'Serbia',
     'Engineering & Economic Geology University of Belgrade',
     0, 2011, 'GS-RES-2014-exec',
     'VP Exploration Reservoir Minerals 2011-2014; ab Aug 2014 Country Manager Serbia fuer Timok. Spaeter Director Balkan Exploration & Mining bei Zijin Mining.'),

    ('Tim', 'Livesey', NULL, NULL,
     0, 2014, 'NSU-ACQ-2016-CLOSE',
     'COO Reservoir Minerals 2014-2016. Spaeter COO Nevsun bei Integration nach Akquisition Juni 2016.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Simon' AND nachname='Ingram'),
     (SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Founder', '2011', NULL),
    ((SELECT id FROM person WHERE vorname='Simon' AND nachname='Ingram'),
     (SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'CEO', '2011', '2016-06'),
    ((SELECT id FROM person WHERE vorname='Simon' AND nachname='Ingram'),
     (SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'President', '2011', '2016-06'),
    ((SELECT id FROM person WHERE vorname='David' AND nachname='Miles'),
     (SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'CFO', '2011', '2016-06'),
    ((SELECT id FROM person WHERE vorname='Aleksandar' AND nachname='Obrenovic'),
     (SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'VP Exploration', '2011', '2014-08'),
    ((SELECT id FROM person WHERE vorname='Tim' AND nachname='Livesey'),
     (SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'COO', '2014', '2016-06');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Timok (Cukaru Peki)', 'Serbia, Bor District (Eastern Serbia)',
     'Cu', 'Au', NULL,
     'High-sulphidation epithermal (Upper Zone) + porphyry-style (Lower Zone)',
     'Greenfield', 'PEA', NULL);

-- Outcome: Discovery 1.0 (Cukaru Peki blind discovery 2012, Thayer Lindsley Award 2016),
-- Reserve-Conversion 0.3 (PEA April 2016; PFS erst unter Nevsun 2018), Exit 1.0 (M&A 35% Premium
-- CAD 365M), Peak-MarketCap 0.6 (~CAD 450M peak Standalone).
-- Total: 0.25*1.0 + 0.25*0.3 + 0.30*1.0 + 0.20*0.6 = 0.745
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
    1.0, 0.3, 1.0, 0.6, 0.745, 'M&A', 2016, 450.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'IPO', '2011-11',
     'Reservoir Minerals Listing TSX-V (RMC) bei CAD 0.65/Aktie.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'M&A', '2012-08',
     'Freeport-McMoRan vollzieht Earn-In: 55% Timok-Projekt; JV formed; Freeport Operator.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Discovery', '2012',
     'Cukaru Peki Cu-Au Blind Discovery; 10. Bohrloch trifft hochgradige Mineralisierung unter ~400m Deckgestein.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Resource Estimate', '2014-01-27',
     'Initial NI 43-101 Resource: Cukaru Peki Upper Zone 65.3 Mt @ 2.6% Cu + 1.5 g/t Au (Inferred).'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Resource Estimate', '2015',
     'Updated Resource via Infill-Drilling: 1.7 Mt Indicated @ 13.5% Cu + 10.4 g/t Au.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'PEA', '2016-04',
     'PEA Cukaru Peki: NPV(8%) USD 1.552 Mrd, IRR 106%, CAPEX USD 213M.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'M&A', '2016-04-24',
     'Nevsun Resources Arrangement Agreement: Erwerb Reservoir fuer CAD 365 Mio (2 NSU-Aktien + CAD 0.001 cash pro RMC-Aktie). ~35% Premium.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'M&A', '2016-06',
     'Nevsun schliesst Reservoir-Akquisition ab.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Delisting', '2016-06',
     'Reservoir Minerals (RMC) delisted nach Nevsun-Akquisition.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'Industry Award', '2016',
     'Thayer Lindsley Award fuer Best Discovery (Cukaru Peki); UK Mining Journal Best Small/Mid-Cap Deal.'),
    ((SELECT id FROM company WHERE name='Reservoir Minerals Inc.'),
     'PFS', '2018-03-28',
     'PFS Timok Upper Zone unter Nevsun (NACH Reservoir-Akquisition): NAV(8%) USD 1.8 Mrd, IRR 80% @ USD 3.15/lb Cu.');


-- ============================================================================
-- COMPANY 3: Probe Mines Limited
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Probe Mines Limited', NULL, 'Canada', 'TSX-V', NULL, 2015,
    'Au', 'Cr', NULL, 0, 'success');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('David', 'Palmer', 'Canada',
     'PhD Economic Geology McGill University',
     0, 2004, 'NM-PALMER-2014',
     'President & CEO Probe Mines 2004-2015. Borden-Gold-Discovery (>4 Moz Au) + Black-Creek-Chromit-Discovery. The Northern Miner Mining Person of the Year 2014; PDAC Bill Dennis Prospector of the Year 2015. Post-Goldcorp: CEO Probe Metals (Spin-off).'),

    ('Jamie', 'Sokalsky', 'Canada', NULL,
     1, 2014, 'MIN-PMS-2014-SOKALSKY',
     'Ehemals President & CEO Barrick Gold 2012-2014, 30+ Jahre Finance/Mining-Operations. Joined Probe Mines als Chairman 2014; approved Goldcorp-Akquisition.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='David' AND nachname='Palmer'),
     (SELECT id FROM company WHERE name='Probe Mines Limited'),
     'President', '2004', '2015-03-13'),
    ((SELECT id FROM person WHERE vorname='David' AND nachname='Palmer'),
     (SELECT id FROM company WHERE name='Probe Mines Limited'),
     'CEO', '2004', '2015-03-13'),
    ((SELECT id FROM person WHERE vorname='Jamie' AND nachname='Sokalsky'),
     (SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Chairman', '2014', '2015-03-13');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Borden Lake Gold', 'Canada, Ontario (Chapleau district, 35 km E Hemlo)',
     'Au', NULL, NULL,
     'Archean mesothermal lode gold (Kapuskasing Structural Zone)',
     'Greenfield', 'Production', NULL),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Black Creek Chromite', 'Canada, Ontario (Ring of Fire)',
     'Cr', NULL, NULL,
     'Magmatic chromite (stratiform)',
     'Greenfield', 'Discovery', NULL);

-- Outcome: Discovery 1.0 (Borden Major Discovery 2010), Reserve-Conversion 0.3 (Resource
-- Estimate 2014, kein PEA vor Akquisition), Exit 1.0 (M&A 49% Premium CAD 526M),
-- Peak-MarketCap 0.6 (~CAD 525M).
-- Total: 0.25*1.0 + 0.25*0.3 + 0.30*1.0 + 0.20*0.6 = 0.745
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Probe Mines Limited'),
    1.0, 0.3, 1.0, 0.6, 0.745, 'M&A', 2015, 525.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Discovery', '2009',
     'Black Creek Chromite Deposit Discovery in Ring of Fire (Ontario).'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Discovery', '2010-04-26',
     'Borden Lake Gold Discovery angekuendigt; erste Bohrresultate zeigen Gold top-to-bottom in 8 Core-Samples.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Industry Award', '2013',
     'Ontario Prospectors Association 2013 Ontario Prospector Award an Probe fuer Borden-Discovery.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Industry Award', '2014',
     'David Palmer: Northern Miner Mining Person of the Year 2014.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Resource Estimate', '2014-06-10',
     'Erste Mineral Resource Estimate Borden: Indicated 2.3 Moz (Open Pit) + 1.6 Moz (U/G); NI 43-101 Snowden.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'M&A', '2015-01-19',
     'Goldcorp Definitive Agreement: Erwerb Probe Mines fuer CAD 526 Mio; 49% Premium auf Marktpreis.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'M&A', '2015-03-13',
     'Goldcorp schliesst Akquisition ab. Probe Metals Inc. (Ring-of-Fire-Assets) gespaltet und an TSX-V (PRB) gelistet.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Industry Award', '2015',
     'David Palmer: PDAC Bill Dennis Prospector of the Year 2015.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Delisting', '2015-03-13',
     'Probe Mines (TSX-V: PMS) delisted nach Goldcorp-Akquisition.'),
    ((SELECT id FROM company WHERE name='Probe Mines Limited'),
     'Production Start', '2019-10',
     'Newmont Goldcorp Borden Mine: commercial production (nach Newmont-Goldcorp-Merger). 2020: 104,648 oz Au.');


-- ============================================================================
-- COMPANY 4: Detour Gold Corporation
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Detour Gold Corporation', 'CA2506691088', 'Canada', 'TSX', 2007, 2020,
    'Au', NULL, NULL, 0, 'success');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Gerald', 'Panneton', 'Canada',
     'BSc Geology Universite de Montreal; MSc Geology McGill University',
     1, 2006, 'GOLDTERRA-PANNETON',
     'Geologist, 35+ Jahre Exploration & Development. 12 Jahre bei Barrick Gold 1994-2006 als Director of Advanced Projects. Founder Detour Gold 2006; trieb Detour-Lake-Restart von 1.5 Moz auf 16 Moz Reserves. Post-Detour: CEO Gold Terra Resource.'),

    ('Paul', 'Martin', 'Canada',
     'CPA, CA (Chartered Accountant)',
     1, 2008, 'BLOOMBERG-MARTIN',
     'Financial Executive, 30+ Jahre. CFO New Gold Inc. 2005-2008; CFO Gabriel Resources 2000-2005. CFO Detour 2008, transitioned CEO 2013 (interim Nov 2013, permanent Feb 2014); retired 2018.'),

    ('Michael', 'Kenyon', 'Canada', 'Geologist',
     1, 2013, 'PROACT-KENYON',
     'Mining Geologist, 40+ Jahre. Founding Director Sutton Resources (acq. Barrick), Cumberland Resources (acq. Agnico), Canico (acq. Vale). PDAC Developer of Year 2005. Chairman Detour 2013-2018, Interim CEO 2018.'),

    ('Michael', 'McMullen', NULL, NULL,
     1, 2019, 'KITCO-MCMULLEN-2019',
     'Mining Executive, 25+ Jahre internationale Erfahrung. CEO/Director Stillwater Mining 2013-2017 (acq. Sibanye Gold 2017). Appointed Detour CEO 2019-05-01 bis Akquisitions-Closing 2020-01-31.'),

    ('Bill', 'Williams', 'Canada', 'Certified Professional Geologist',
     0, 2019, 'DGC-WILLIAMS-2019',
     'Mining Geologist, 30+ Jahre. Former CEO Orvana Minerals. Appointed Interim CEO Detour Jan 2019 nach Kenyon-Resignation (Proxy Contest). Backed by Paulson & Co. activist investors.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Gerald' AND nachname='Panneton'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'Founder', '2006', NULL),
    ((SELECT id FROM person WHERE vorname='Gerald' AND nachname='Panneton'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'CEO', '2006', '2013-11'),
    ((SELECT id FROM person WHERE vorname='Paul' AND nachname='Martin'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'CFO', '2008', '2013-11'),
    ((SELECT id FROM person WHERE vorname='Paul' AND nachname='Martin'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'CEO', '2013-11', '2018-05'),
    ((SELECT id FROM person WHERE vorname='Michael' AND nachname='Kenyon'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'Chairman', '2013', '2018-12'),
    ((SELECT id FROM person WHERE vorname='Michael' AND nachname='Kenyon'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'CEO', '2018-05', '2019-01'),
    ((SELECT id FROM person WHERE vorname='Bill' AND nachname='Williams'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'CEO', '2019-01', '2019-05'),
    ((SELECT id FROM person WHERE vorname='Michael' AND nachname='McMullen'),
     (SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'CEO', '2019-05-01', '2020-01-31');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'Detour Lake', 'Canada, Ontario (NE Timmins, Abitibi Greenstone Belt)',
     'Au', NULL, NULL,
     'Greenstone-hosted gold (komatiite-chert horizon, quartz-feldspar porphyry intrusion)',
     'Brownfield', 'Production', NULL);

-- Outcome: Discovery 0.5 (Placer Dome 1983 historical discovery; Detour erweiterte Resourcen
-- von 1.5 Moz auf 20+ Moz - signifikante Erweiterung), Reserve-Conversion 1.0 (Bankable FS
-- 2010-12), Exit 1.0 (M&A CAD 4.9 Mrd, 24% Premium + 7 Jahre Production), Peak-MarketCap 1.0
-- (CAD 4.9 Mrd M&A-Wert; ~CAD 3-4 Mrd implied Peak Pre-2020).
-- Total: 0.25*0.5 + 0.25*1.0 + 0.30*1.0 + 0.20*1.0 = 0.875
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
    0.5, 1.0, 1.0, 1.0, 0.875, 'M&A', 2020, 4900.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'IPO', '2007-01-31',
     'Detour Gold IPO an TSX; ~40M Aktien @ CAD 3.00-3.50; Capital ~CAD 140 Mio fuer Detour-Lake-Restart.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'PEA', '2009-10',
     'PEA: IRR 11.3%, NPV USD 469M @ USD 775/oz, CAPEX USD 995M, 300-500 koz/yr Profile.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'FS', '2010-12',
     'Bankable Feasibility Study Detour Lake; Open Pit, CAPEX USD 1.2 Mrd, 649 koz/yr, 14.9 Moz Reserves, 21-Jahr-Mine-Life.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'Resource Estimate', '2011-12-31',
     'Year-end Resource Update: 23.3 Moz M&I (+13% YoY), 5.8 Moz Inferred; Reserves 15.6 Moz P&P.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'Production Start', '2013-Q1',
     'Erste Goldproduktion; declared commercial production Q3 2013. Ramp 260-320 koz/yr.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'M&A', '2019-11-25',
     'Kirkland Lake Gold All-Stock Akquisition Detour fuer CAD 4.9 Mrd; 0.4343 KL-shares pro DGC-share; 24% Premium.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'M&A', '2020-01-31',
     'Kirkland Lake schliesst Akquisition ab.'),
    ((SELECT id FROM company WHERE name='Detour Gold Corporation'),
     'Delisting', '2020-02-02',
     'Detour Gold delisted from TSX.');


-- ============================================================================
-- COMPANY 5: Pretium Resources Inc.
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Pretium Resources Inc.', 'CA74139C1023', 'Canada', 'TSX → NYSE',
    2011, 2022,
    'Au', 'Ag', NULL, 0, 'success');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Robert', 'Quartermain', 'Canada', NULL,
     1, 1985, 'CMHF-QUARTERMAIN',
     'Silver-Standard-CEO 1985-2010 (Aufbau von USD 2M auf USD 2.1B Market Cap). Founder Pretium 2010-10-22. CEO Pretium bis 2016-12-31; Executive Chairman 2017-2019. Pensioniert 2019-12-31. Canadian Mining Hall of Fame. Post-Pretium: Co-Chairman/CEO Dakota Gold Corp.'),

    ('Joseph', 'Ovsenek', 'Canada', NULL,
     1, 2011, 'PVG-OVSENEK-2017',
     'Joined Pretium 2011 als Chief Development Officer (CDO 2011-2015). President 2015 bis 2017-04-26. President & CEO 2017-04-27 bis 2020-04-26. 25+ Jahre Precious Metals; vorher 15 Jahre Silver Standard Resources. Post-Pretium: Board Tudor Gold; ehemals President/CEO P2 Gold.'),

    ('Jacques', 'Perron', 'Canada',
     'BSc Mining Engineering, Ecole Polytechnique de Montreal',
     1, 2020, 'JMN-PERRON-2020',
     'President + CEO Pretium 2020-04-27 bis 2022-03-09. 35+ Jahre globale Bergbau-Erfahrung mit technical/operational Expertise. Vorher President/CEO/Director Thompson Creek Metals (acq. Centerra Gold 2016) und St. Andrew Goldfields.'),

    ('Tom', 'Yip', 'Canada', NULL,
     0, 2011, 'PVG-YIP-2015',
     'CFO Pretium 2015-01-26 bis 2020-10-30. 25+ Jahre Mining Finance. Vorher CFO Silver Standard Resources (Exploration-zu-Production-Transition) und CFO International Tower Hill Mines. Board-Member Pretium ab Feb 2011, dann zu CFO 2015.'),

    ('Warwick', 'Board', 'Canada',
     'PhD; P.Geo; Pr.Sci.Nat.',
     1, 2017, 'PVG-EXEC-PROFILE',
     'VP Geology und Chief Geologist Pretium 2017-2022. Verantwortlich fuer Brucejack-Mine Resource und Exploration Drilling Operations.'),

    ('Kenneth', 'McNaughton', 'Canada',
     'M.A.Sc., P.Eng.',
     0, 2011, 'PVG-MCNAUGHTON',
     'Chief Exploration Officer Pretium 2011-2022. Verantwortlich fuer Regional-Grassroots-Exploration. Pre-Pretium bei Silver Standard Resources. Leitete spaeter Golden-Marmot-Zone-Discovery 2021.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Quartermain'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Founder', '2010-10-22', NULL),
    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Quartermain'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Chairman', '2010-10-22', '2019-12-31'),
    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Quartermain'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'CEO', '2010-10-22', '2016-12-31'),
    ((SELECT id FROM person WHERE vorname='Joseph' AND nachname='Ovsenek'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'President', '2015', '2020-04-26'),
    ((SELECT id FROM person WHERE vorname='Joseph' AND nachname='Ovsenek'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'CEO', '2017-04-27', '2020-04-26'),
    ((SELECT id FROM person WHERE vorname='Jacques' AND nachname='Perron'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'President', '2020-04-27', '2022-03-09'),
    ((SELECT id FROM person WHERE vorname='Jacques' AND nachname='Perron'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'CEO', '2020-04-27', '2022-03-09'),
    ((SELECT id FROM person WHERE vorname='Tom' AND nachname='Yip'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'CFO', '2015-01-26', '2020-10-30'),
    ((SELECT id FROM person WHERE vorname='Warwick' AND nachname='Board'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Chief Geologist', '2017', '2022-03-09'),
    ((SELECT id FROM person WHERE vorname='Kenneth' AND nachname='McNaughton'),
     (SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'VP Exploration', '2011', '2022-03-09');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Brucejack (Valley of the Kings)',
     'Canada, BC (Golden Triangle, Sulphurets Mining Camp, 65 km N Stewart)',
     'Au', 'Ag', NULL,
     'High-grade epithermal Au-Ag vein deposit',
     'Brownfield', 'Production', NULL),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Snowfield',
     'Canada, BC (Sulphurets Mining Camp)',
     'Au', NULL, NULL,
     'Bulk-tonnage gold deposit',
     'Brownfield', 'Discovery', NULL);

-- Outcome: Discovery 1.0 (Valley-of-the-Kings 2009 von Silver-Standard-Quartermain-Team; Pretium
-- wurde 2010 ge-spin-offt mit dem selben Team; per Workflow-Konsistenz mit Aurelian (Anderson-
-- Barron-Team-Discovery) zaehlt das als eigene Discovery), Reserve-Conversion 1.0 (FS 2013,
-- Production seit 2017), Exit 1.0 (M&A 23% Premium + Operating Mine), Peak-MarketCap 1.0
-- (CAD 2.27 Mrd Nov 2021, CAD 3.5 Mrd M&A-Wert).
-- Total: 0.25*1.0 + 0.25*1.0 + 0.30*1.0 + 0.20*1.0 = 1.0
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
    1.0, 1.0, 1.0, 1.0, 1.0, 'M&A', 2022, 2270.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'M&A', '2010-10-28',
     'Pretium erwirbt Brucejack + Snowfield Projects von Silver Standard Resources (Spin-off-Akquisition).'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'IPO', '2010-12-21',
     'Pretium IPO + Listing TSX als PVG; Schliessung IPO + Silver-Standard-Akquisition gleichzeitig.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'PEA', '2011-06',
     'Positive Preliminary Economic Assessment Brucejack (Wardrop/Tetra Tech); NPV USD 2.262 Mrd (pre-tax), IRR 29.8%.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'PEA', '2012-02',
     'Updated PEA confirms NPV USD 2.262 Mrd (pre-tax), 29.8% IRR; 24-Jahr-Mine-Life projected.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Exchange Upgrade', '2012',
     'Pretium Resources beginnt Handel an NYSE (PVG) zusaetzlich zu TSX-Listing.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'FS', '2013-06-26',
     'Positive Feasibility Study Brucejack (Tetra Tech); pre-tax NPV USD 2.7 Mrd @ 5% Discount; Base Case USD 1,350/oz Au.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'FS', '2014-06-20',
     'Updated Feasibility Study Brucejack; CapEx USD 746.9M; 18-Jahr-Mine-Life; 504 koz Au/yr first 8 years.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Resource Estimate', '2016-07',
     'Valley of the Kings Updated Resource: M+I 9.1 Moz Au (16.4 Mt @ 17.2 g/t). Dec 2016 Reserves P+P 8.1 Moz Au (15.6 Mt @ 16.1 g/t).'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Production Start', '2017-06-20',
     'Erster Goldguss Brucejack Mine; Mill avg 2,360 t/d during June 2017 (87.4% nameplate).'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Production Start', '2017-07-01',
     'Commercial Production declared at Brucejack Mine.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Discovery', '2021-10-25',
     'Golden Marmot Zone high-grade Discovery: 53.5m @ 72.5 g/t Au inkl. 0.5m @ 6,700 g/t Au; bestaetigt District-Scale-Potenzial Brucejack.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'M&A', '2021-11-08',
     'Newcrest Mining announces Akquisition Pretium fuer CAD 18.50/share (Cash + Shares); Total Equity ~CAD 3.5 Mrd; 29% Premium auf 20-Tage-VWAP.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'M&A', '2022-02-25',
     'Newcrest schliesst Akquisition Pretium ab; Pretium wird Newcrest-Tochter.'),
    ((SELECT id FROM company WHERE name='Pretium Resources Inc.'),
     'Delisting', '2022-03-09',
     'Pretium (PVG) delisted from TSX und NYSE nach Newcrest-Closing.');
