-- ============================================================================
-- CONTINENTAL GOLD — BATCH 4 INSERT SCRIPT
-- Schema v1.3 | Workflow v0.2 + Pipeline v3
-- Created 2026-05-15
-- ============================================================================

-- ============================================================================
-- 1. INSERT COMPANY
-- ============================================================================

INSERT INTO company (
    id, name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label
) VALUES (
    (SELECT MAX(id) + 1 FROM company),
    'Continental Gold',
    'CA21146A1084',
    'Canada',
    'TSX',
    2010,
    2020,
    'Gold',
    'Silver',
    'Zinc',
    0,
    'High-Grade Gold Discovery & Mine Development Exit'
);

-- Get the newly inserted company_id for use in subsequent inserts
SET @cgl_company_id = (SELECT id FROM company WHERE name = 'Continental Gold' LIMIT 1);

-- ============================================================================
-- 2. INSERT PERSONS
-- ============================================================================

-- Ari Sussman
INSERT INTO person (
    id, vorname, nachname, birth_year, education, country,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text
) VALUES (
    (SELECT MAX(id) + 1 FROM person),
    'Ari',
    'Sussman',
    1973,
    'University of Western Ontario (1994)',
    'Canada',
    1,
    2010,
    'WEB-CNL-2026-SUSSMAN-BLOOMBERG',
    'CEO of Continental Gold 2010-2020. 30+ years mining/resources. Founder CVW Sustainable Royalties (2001), Continental Gold (2010). Previously CEO Cronus Resources (2005-2010), Chairman Cordoba Minerals, Executive Chairman Colossus Minerals (2011-2012), Director Dalradian. Currently Executive Chairman Collective Mining (2021+). Successful fundraiser ($1B+); led discovery of 11M+ oz Au at Buriticá; exited via M&A to Zijin for C$2B (2020).'
);

-- Leon Teicher
INSERT INTO person (
    id, vorname, nachname, birth_year, education, country,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text
) VALUES (
    (SELECT MAX(id) + 1 FROM person),
    'León',
    'Teicher',
    NULL,
    'MBA Stanford University; Industrial Economics (Universidad de los Andes)',
    'Colombia/Canada',
    0,
    2013,
    'WEB-CNL-2026-TEICHER-BLOOMBERG',
    'Chairman of Continental Gold 2014-2020; Executive Chairman 2015-2020. Former CEO of Cerrejón Coal Ltd. (2006-2012), Colombia largest private coal producer. VP Marketing & Sales Carbocol S.A. (Colombian state coal). General Manager Unisys Corporation (IT). Founder/CEO Xeon Technology Corp. Fulbright Scholar 1976-1978. Dual citizen Colombia/Canada. Chairman Fundación Ideas Para La Paz (2018+); Director Cementos Argos S.A.; Governor Universidad de los Andes.'
);

-- Donald Gray
INSERT INTO person (
    id, vorname, nachname, birth_year, education, country,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text
) VALUES (
    (SELECT MAX(id) + 1 FROM person),
    'Donald',
    'Gray',
    NULL,
    'BS Mining Engineering (University of Idaho); MS Civil Engineering (MIT); MBA (Auburn University)',
    'USA / Latin America',
    1,
    2015,
    'WEB-CNL-2026-GRAY-GLOBALMINING',
    'COO of Continental Gold 2015-2020. 40+ years mining engineering and operations. EVP Operations Tahoe Resources (Escobal silver mine to production). Senior mining companies: Exxon, Hecla, Newmont, Coeur d''Alene Mines (Latin America, Spain, USA). Responsible for design, financing, construction, and operation of large precious metal mines including sustainability (health, safety, environment, community, labor, security). Led successful completion of Buriticá mine development and mill construction culminating in 2020 Zijin acquisition.'
);

-- Paul Begin
INSERT INTO person (
    id, vorname, nachname, birth_year, education, country,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text
) VALUES (
    (SELECT MAX(id) + 1 FROM person),
    'Paul',
    'Begin',
    NULL,
    'CA (Chartered Accountant); MBA',
    'Canada',
    0,
    2013,
    'WEB-CNL-2013-PAULBEGIN-MARKETWIRED',
    'CFO of Continental Gold 2013-2020. 15+ years senior level financial experience. Previously CFO & Corporate Secretary at Hanfeng Evergreen Inc. (fertilizer producer, China/Southeast Asia). CFO & VP Finance at Trilliant Incorporated and OZZ Corporation (M&A lead, acquisitions/divestitures). Senior financial roles: marketing communications, secure transactions, real estate, hospitality. Public markets, international business, strategic management expertise.'
);

-- ============================================================================
-- 3. INSERT PROJECT
-- ============================================================================

INSERT INTO project (
    id, company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id
) VALUES (
    (SELECT MAX(id) + 1 FROM project),
    @cgl_company_id,
    'Buriticá',
    'Antioquia, Colombia',
    'Gold',
    'Silver',
    'Zinc',
    'Underground High-Grade Narrow-Vein',
    'Advanced Development (47% complete Dec 2018)',
    'Production (First Gold Pour H1 2020)',
    NULL
);

-- ============================================================================
-- 4. INSERT ROLES
-- ============================================================================

-- Ari Sussman → CEO
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES (
    (SELECT id FROM person WHERE vorname = 'Ari' AND nachname = 'Sussman'),
    @cgl_company_id,
    'CEO',
    '2010-06-01',
    '2020-03-05'
);

-- León Teicher → Chairman / Executive Chairman
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES (
    (SELECT id FROM person WHERE vorname = 'León' AND nachname = 'Teicher'),
    @cgl_company_id,
    'Chairman',
    '2014-04-01',
    '2020-03-05'
);

-- Donald Gray → COO
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES (
    (SELECT id FROM person WHERE vorname = 'Donald' AND nachname = 'Gray'),
    @cgl_company_id,
    'COO',
    '2015-01-01',
    '2020-03-05'
);

-- Paul Begin → CFO
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES (
    (SELECT id FROM person WHERE vorname = 'Paul' AND nachname = 'Begin'),
    @cgl_company_id,
    'CFO',
    '2013-01-01',
    '2020-03-05'
);

-- ============================================================================
-- 5. INSERT OUTCOME
-- ============================================================================

INSERT INTO outcome (
    company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score,
    exit_type, exit_year, peak_marketcap_cad_million
) VALUES (
    @cgl_company_id,
    0.85,
    0.90,
    1.0,
    0.95,
    0.9075,
    'M&A',
    2020,
    1400
);

-- ============================================================================
-- 6. INSERT EVENTS
-- ============================================================================

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    (@cgl_company_id, 'Listing', '2010-06-01', 'IPO on TSX under CEO Ari Sussman; raised ~$1B during tenure'),
    (@cgl_company_id, 'Board Appointment', '2013-04-01', 'León Teicher joins Board of Directors'),
    (@cgl_company_id, 'Board Appointment', '2014-04-01', 'León Teicher becomes non-executive Chairman'),
    (@cgl_company_id, 'Executive Appointment', '2015-03-31', 'León Teicher appointed Executive Chairman'),
    (@cgl_company_id, 'Executive Appointment', '2015-01-01', 'Donald Gray joins as Chief Operating Officer'),
    (@cgl_company_id, 'Construction Progress', '2018-05-01', 'Buriticá project 30% complete; ~50% of total project cost committed'),
    (@cgl_company_id, 'Construction Progress', '2018-11-30', 'Buriticá project 44% complete; Mill/surface infrastructure 93% procurement complete'),
    (@cgl_company_id, 'Resource Update', '2019-01-01', 'Updated NI 43-101 resource estimate for Yaraguá and Veta Sur vein systems'),
    (@cgl_company_id, 'Construction Progress', '2019-03-31', 'Buriticá project 56% complete; >10km underground development completed; 74% of pre-production plan done'),
    (@cgl_company_id, 'Construction Progress', '2019-10-31', 'Mill facilities construction 88% complete; Q1 2020 mechanical completion on schedule'),
    (@cgl_company_id, 'Construction Progress', '2020-01-31', 'Buriticá construction virtually complete; mechanical completion Q1 2020 on schedule'),
    (@cgl_company_id, 'Acquisition Announced', '2019-12-02', 'Zijin Mining announces all-cash offer: C$1.4B ($5.50/share), 29% premium over 20-day VWAP'),
    (@cgl_company_id, 'First Production', '2020-06-30', 'Buriticá first gold pour achieved (H1 2020 per schedule)'),
    (@cgl_company_id, 'Acquisition Closed', '2020-03-05', 'Zijin Mining completes acquisition; Continental Gold delisted from TSX'),
    (@cgl_company_id, 'Production Start', '2021-05-01', 'STRACON contractor begins Zijin Continental Gold underground mining operations at Buriticá');

-- ============================================================================
-- VALIDATION QUERIES (Optional: comment out for production)
-- ============================================================================

-- SELECT 'COMPANY CHECK' as check_type, COUNT(*) as count FROM company WHERE name = 'Continental Gold';
-- SELECT 'PERSONS CHECK' as check_type, COUNT(*) as count FROM person WHERE vorname IN ('Ari', 'León', 'Donald', 'Paul');
-- SELECT 'ROLES CHECK' as check_type, COUNT(*) as count FROM role WHERE company_id = @cgl_company_id;
-- SELECT 'OUTCOME CHECK' as check_type, COUNT(*) as count FROM outcome WHERE company_id = @cgl_company_id;
-- SELECT 'EVENTS CHECK' as check_type, COUNT(*) as count FROM event WHERE company_id = @cgl_company_id;

COMMIT;

-- ============================================================================
-- END INSERT SCRIPT
-- ============================================================================
