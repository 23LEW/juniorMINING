-- Batch 6: 5 Success Companies (Aurelian, Lumina, Andean, Red Back, Rainy River)
-- Schema Version: v1.3
-- Date: 2026-05-17

PRAGMA foreign_keys = ON;

-- ============================================================
-- COMPANY 1: AURELIAN RESOURCES INC.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Aurelian Resources Inc.', NULL, 'Canada', 'TSX-V', 2003, 2008, 'Au', 0, 'success');

-- Aurelian Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Patrick', 'Anderson', 'B.Sc. Geology, University of Toronto', 'Canada', 0, 2001, 'Founder, President & CEO Aurelian Resources (2003-2009), Mining Person of Year 2008, discoverer Fruta del Norte');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Keith', 'Barron', 'PhD Geology, University of Western Ontario', 'Canada', 0, 2001, 'Co-Founder, VP Exploration Aurelian Resources, Mining Person of Year 2008, 30+ years Latin America exploration');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Stephen', 'Leary', 'B.Sc. First Class Honours Geology, University of Canterbury', 'New Zealand', 0, 2005, 'Exploration Manager Aurelian (2005-2008), 14+ years gold/silver exploration, Mining Person of Year 2008');

-- Aurelian Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Patrick' AND nachname='Anderson' LIMIT 1),
       (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'CEO', '2003-01-01', '2008-10-03';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Keith' AND nachname='Barron' LIMIT 1),
       (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'VP Exploration', '2002-01-01', '2008-10-03';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Stephen' AND nachname='Leary' LIMIT 1),
       (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'Chief Geologist', '2005-03-01', '2008-10-03';

-- Aurelian Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'Fruta del Norte', 'Ecuador', 'Au', 'PFS', 'Production';

-- Aurelian Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       95, 65, 70, 80, 79.5, 'M&A', 2008, 1200;

-- Aurelian Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'Discovery', '2006-04-01', 'Fruta del Norte discovery announced (early 2006 drilling, 237.3m @ 4.14 g/t Au)';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'Resource Estimate', '2007-10-31', 'Initial Mineral Resource Estimate: 13.7M oz Au, 22.4M oz Ag (58.9Mt @ 7.23 g/t Au)';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'PFS', '2008-01-15', 'Preliminary Feasibility Study 95% complete';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Aurelian Resources Inc.' LIMIT 1),
       'M&A', '2008-07-24', 'Kinross Gold announces acquisition of Aurelian for CAD 1.2B (63% VWAP premium), completion Sept 30, 2008';

-- ============================================================
-- COMPANY 2: LUMINA COPPER CORP.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Lumina Copper Corp.', NULL, 'Canada', 'TSX-V', 2003, 2014, 'Cu', 0, 'success');

-- Lumina Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Ross', 'Beaty', NULL, 'Canada', 0, 2003, 'Founder, Lumina Group (6 companies), billionaire mining entrepreneur, Taca Taca acquisition strategy');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('David', 'Strang', NULL, 'Canada', 0, 2008, 'President & CEO Lumina Copper (2008-2014), 20+ years corporate finance experience');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Andrew', 'Carstensen', 'BA & MS Geology, University of Montana', 'Canada', 1, 2008, 'VP Exploration, Qualified Person NI 43-101, 35+ years mineral exploration (majors & juniors)');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Guillermo', 'Almandoz', NULL, 'Argentina', 1, 2010, 'Project Manager Taca Taca, Rio Tinto veteran, porphyry expert');

-- Lumina Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='David' AND nachname='Strang' LIMIT 1),
       (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'CEO', '2008-01-01', '2014-08-19';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Andrew' AND nachname='Carstensen' LIMIT 1),
       (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'VP Exploration', '2008-01-01', '2014-08-19';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Guillermo' AND nachname='Almandoz' LIMIT 1),
       (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'VP Exploration', '2010-01-01', '2014-08-19';

-- Lumina Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'Taca Taca', 'Salta Province, Argentina', 'Cu', 'PEA', 'PEA';

-- Lumina Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       50, 85, 0, 65, 52.5, 'M&A', 2014, 470;

-- Lumina Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'Discovery', '2008-08-01', 'Lumina acquires Taca Taca from Corriente Resources for USD 1M');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'Resource Estimate', '2012-05-31', 'Updated Resource Estimate: 1.762 Gt @ 0.53% Cu (Indicated), 20.5 Blbs Cu');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'PEA', '2013-04-09', 'Positive Preliminary Economic Assessment: USD 2.1B NPV, 17.2% IRR, 120,000 tpd');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Lumina Copper Corp.' LIMIT 1),
       'M&A', '2014-06-17', 'First Quantum Minerals announces acquisition of Lumina for CAD 470M (34% VWAP premium), completion Aug 19, 2014';

-- ============================================================
-- COMPANY 3: ANDEAN RESOURCES LIMITED
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Andean Resources Limited', NULL, 'Canada', 'ASX/TSX', 1994, 2010, 'Au', 0, 'success');

-- Andean Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Wayne', 'Hubert', 'B.Sc. Chemical Engineering (University of Cape Town), MBA (Brigham Young)', 'Canada', 1, 2006, 'CEO Andean Resources (2006-2010), 20+ years South America mining, ex-Meridian Gold VP Development');

-- Andean Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Wayne' AND nachname='Hubert' LIMIT 1),
       (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       'CEO', '2006-01-01', '2010-12-30';

-- Andean Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       'Cerro Negro', 'Santa Cruz Province, Argentina', 'Au', 'FS', 'Production';

-- Andean Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       80, 90, 70, 80, 80.0, 'M&A', 2010, 3420;

-- Andean Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       'Discovery', '1992-01-01', 'Cerro Negro discovery by prospecteur Roberto Schupback (1992)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       'PFS', '2008-12-01', 'Pre-Feasibility Study completion (Micon International)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       'FS', '2010-07-20', 'Feasibility Study completion (Ausenco), 2.07M oz Au, 20.6M oz Ag reserves');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1),
       'M&A', '2010-09-03', 'Goldcorp announces acquisition for CAD 3.42B (56% VWAP premium), completion Dec 30, 2010');

-- ============================================================
-- COMPANY 4: RED BACK MINING INC.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Red Back Mining Inc.', NULL, 'Canada', 'TSX', 2004, 2010, 'Au', 0, 'success');

-- Red Back Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Richard', 'Clark', NULL, 'Canada', 1, 2000, 'President, CEO Red Back Mining (2000-2010), led company to 500,000 oz/year gold producer, post-exit Montage Gold founder');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Lukas', 'Lundin', NULL, 'Canada', 1, 2003, 'Chairman Red Back Mining, visionaire mining investor, founder Lundin Mining');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Hugh', 'Stuart', 'BSc, MSc Geology, Chartered Geologist', 'Canada', 1, 2003, 'VP Exploration Red Back Mining, 30+ years international gold exploration, fellow GSL');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Simon', 'Jackson', NULL, 'Canada', 0, 2003, 'VP Corporate Development & CFO Red Back Mining, mining dealmaker, financing expert');

-- Red Back Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Richard' AND nachname='Clark' LIMIT 1),
       (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'CEO', '2000-01-01', '2010-09-17';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Lukas' AND nachname='Lundin' LIMIT 1),
       (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'Chairman', '2003-01-01', '2010-09-17';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Hugh' AND nachname='Stuart' LIMIT 1),
       (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'VP Exploration', '2003-01-01', '2010-09-17';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Simon' AND nachname='Jackson' LIMIT 1),
       (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'CFO', '2003-01-01', '2010-09-17';

-- Red Back Projects
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'Chirano', 'Ghana', 'Au', 'Production', 'Production';

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'Tasiast', 'Mauritania', 'Au', 'Production', 'Production';

-- Red Back Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       75, 85, 90, 80, 82.5, 'M&A', 2010, 7200;

-- Red Back Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'Production Start', '2005-10-15', 'Chirano Gold Mine achieves commercial production');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'Discovery', '2007-08-22', 'Red Back acquires Tasiast from Lundin Mining for USD 225M');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'Production Start', '2008-01-15', 'Tasiast Mine achieves commercial production');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1),
       'M&A', '2010-08-03', 'Kinross Gold announces acquisition for USD 7.1-7.3B (21% VWAP premium), completion Sept 17, 2010';

-- ============================================================
-- COMPANY 5: RAINY RIVER RESOURCES LTD.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Rainy River Resources Ltd.', NULL, 'Canada', 'TSX', 2005, 2013, 'Au', 0, 'success');

-- Rainy River Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Raymond', 'Threlkeld', 'B.Sc. Geology, University of Nevada', 'Canada', 1, 2005, 'President & CEO Rainy River Resources (2005-2013), 40+ years exploration/operations, managed $1B+ asset acquisitions');

-- Rainy River Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Raymond' AND nachname='Threlkeld' LIMIT 1),
       (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'CEO', '2005-06-01', '2013-10-16';

-- Rainy River Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'Rainy River Gold', 'Ontario, Canada', 'Au', 'FS', 'Production';

-- Rainy River Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       80, 75, 80, 70, 76.0, 'M&A', 2013, 310;

-- Rainy River Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'Discovery', '1994-01-01', 'Rainy River Gold discovery (17 Zone, 4 g/t Au bedrock)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'Resource Estimate', '2011-06-29', 'Mineral Resource Estimate: 6.2M oz Au (Measured & Indicated)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'PEA', '2011-11-30', 'Preliminary Economic Assessment positive');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'FS', '2013-04-10', 'Feasibility Study completion (4.0M oz Proven & Probable Reserves, 21,000 tpd)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1),
       'M&A', '2013-05-31', 'New Gold announces acquisition for CAD 310M (67% VWAP premium), completion Oct 16, 2013';
