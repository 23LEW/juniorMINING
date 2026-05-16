-- Batch 6: 3 NEW Success Companies (Andean, Red Back, Rainy River)
-- Aurelian & Lumina already exist in DB
-- Date: 2026-05-17

PRAGMA foreign_keys = ON;

-- COMPANY 1: ANDEAN RESOURCES LIMITED
INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label) VALUES ('Andean Resources Limited', NULL, 'Canada', 'ASX/TSX', 1994, 2010, 'Au', 0, 'success');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Wayne', 'Hubert', 'B.Sc. Chemical Engineering, MBA', 'Canada', 1, 2006, 'CEO Andean Resources');
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Wayne' AND nachname='Hubert' LIMIT 1), (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 'CEO', '2006-01-01', '2010-12-30';
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage) SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 'Cerro Negro', 'Santa Cruz Province, Argentina', 'Au', 'FS', 'Production';
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million) SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 80, 90, 70, 80, 80.0, 'M&A', 2010, 3420;
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 'Discovery', '1992-01-01', 'Cerro Negro discovery 1992';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 'PFS', '2008-12-01', 'Pre-Feasibility Study complete';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 'FS', '2010-07-20', 'Feasibility Study complete';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Andean Resources Limited' LIMIT 1), 'M&A', '2010-09-03', 'Goldcorp acquires for CAD 3.42B';

-- COMPANY 2: RED BACK MINING INC.
INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label) VALUES ('Red Back Mining Inc.', NULL, 'Canada', 'TSX', 2004, 2010, 'Au', 0, 'success');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Richard', 'Clark', NULL, 'Canada', 1, 2000, 'CEO Red Back Mining');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Hugh', 'Stuart', 'BSc, MSc Geology', 'Canada', 1, 2003, 'VP Exploration Red Back');
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Richard' AND nachname='Clark' LIMIT 1), (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'CEO', '2000-01-01', '2010-09-17';
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Hugh' AND nachname='Stuart' LIMIT 1), (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'VP Exploration', '2003-01-01', '2010-09-17';
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'Chirano', 'Ghana', 'Au', 'Production', 'Production';
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'Tasiast', 'Mauritania', 'Au', 'Production', 'Production';
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 75, 85, 90, 80, 82.5, 'M&A', 2010, 7200;
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'Production Start', '2005-10-15', 'Chirano production starts';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'Discovery', '2007-08-22', 'Acquires Tasiast for USD 225M';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'Production Start', '2008-01-15', 'Tasiast production starts';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Red Back Mining Inc.' LIMIT 1), 'M&A', '2010-08-03', 'Kinross acquires for USD 7.1-7.3B';

-- COMPANY 3: RAINY RIVER RESOURCES LTD.
INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label) VALUES ('Rainy River Resources Ltd.', NULL, 'Canada', 'TSX', 2005, 2013, 'Au', 0, 'success');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Raymond', 'Threlkeld', 'B.Sc. Geology, University of Nevada', 'Canada', 1, 2005, 'CEO Rainy River Resources');
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Raymond' AND nachname='Threlkeld' LIMIT 1), (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'CEO', '2005-06-01', '2013-10-16';
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'Rainy River Gold', 'Ontario, Canada', 'Au', 'FS', 'Production';
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 80, 75, 80, 70, 76.0, 'M&A', 2013, 310;
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'Discovery', '1994-01-01', 'Rainy River Gold discovery 1994';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'Resource Estimate', '2011-06-29', 'Resource: 6.2M oz Au';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'PEA', '2011-11-30', 'PEA announced';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'FS', '2013-04-10', 'Feasibility Study complete';
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Rainy River Resources Ltd.' LIMIT 1), 'M&A', '2013-05-31', 'New Gold acquires for CAD 310M';
