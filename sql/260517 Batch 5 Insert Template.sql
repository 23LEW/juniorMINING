-- Batch 5: 5 Diverse Success-Companies
-- Template for data entry (Structure ready, data TBD)
-- Schema Version: v1.3
-- Date: 2026-05-17

PRAGMA foreign_keys = ON;

-- ============================================================
-- COMPANY 1: [COMPANY_NAME_1]
-- ============================================================
-- Commodity: [Au/Au+Ag]
-- Exit Type: [M&A/Production/Active]
-- Exit Year: [YYYY]
-- Exit Value: [Currency Amount]

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('[COMPANY_1]', NULL, '[COUNTRY]', '[EXCHANGE]', [YEAR], [YEAR], '[Au/Ag]', 0, 'success');

-- [COMPANY_1] Persons
-- INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
-- VALUES ('[FIRSTNAME]', '[LASTNAME]', '[EDUCATION]', '[COUNTRY]', [0/1], [YEAR], '[BIO]');

-- [COMPANY_1] Roles
-- INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
-- SELECT (SELECT id FROM person WHERE vorname='[FN]' AND nachname='[LN]' LIMIT 1),
--        (SELECT id FROM company WHERE name='[COMPANY_1]' LIMIT 1),
--        '[CEO/Chairman/CFO/VP Exploration]', '[YYYY-MM-DD]', '[YYYY-MM-DD]';

-- [COMPANY_1] Project
-- INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
-- SELECT (SELECT id FROM company WHERE name='[COMPANY_1]' LIMIT 1),
--        '[PROJECT_NAME]', '[JURISDICTION]', '[COMMODITY]', '[STAGE]', '[STAGE]';

-- [COMPANY_1] Outcome
-- Score: 0.25*[disc] + 0.25*[rc] + 0.30*[ep] + 0.20*[pmc] = [TOTAL]
-- discovery_score=[X] (...)
-- reserve_conversion_score=[X] (...)
-- exit_production_score=[X] (...)
-- peak_marketcap_score=[X] (...)
-- INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
-- SELECT (SELECT id FROM company WHERE name='[COMPANY_1]' LIMIT 1),
--        [disc], [rc], [ep], [pmc], [total], '[M&A/Production/Active]', [YEAR], [CAD_AMOUNT];

-- [COMPANY_1] Events
-- INSERT INTO event (company_id, event_type, event_date, description)
-- SELECT (SELECT id FROM company WHERE name='[COMPANY_1]' LIMIT 1),
--        '[Discovery/PEA/PFS/FS/M&A/Production Start]', '[YYYY-MM-DD]', '[DESCRIPTION]';

-- ============================================================
-- COMPANY 2: [COMPANY_NAME_2]
-- ============================================================
-- [Same structure as Company 1]

-- ============================================================
-- COMPANY 3: [COMPANY_NAME_3]
-- ============================================================
-- [Same structure as Company 1]

-- ============================================================
-- COMPANY 4: [COMPANY_NAME_4]
-- ============================================================
-- [Same structure as Company 1]

-- ============================================================
-- COMPANY 5: [COMPANY_NAME_5]
-- ============================================================
-- [Same structure as Company 1]

-- ============================================================
-- END OF BATCH 5 SQL TEMPLATE
-- ============================================================
-- Instructions:
-- 1. Replace [PLACEHOLDERS] with actual data from research
-- 2. Uncomment lines as you complete each section
-- 3. Test locally: python3 batch5_test.py (verify data before insert)
-- 4. Execute in DB after verification
-- 5. Run verification queries (see audit file)
