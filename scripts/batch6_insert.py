#!/usr/bin/env python3
"""
Batch 6 Database Insert Script
- Executes SQL file with proper transaction handling
- Validates integrity
"""

import sqlite3
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
DB_PATH = REPO_ROOT / "data" / "junior_mining.db"
SQL_PATH = REPO_ROOT / "sql" / "260517 Batch 6 Final.sql"

def insert_batch6():
    """Insert Batch 6 data into database"""

    print("=" * 70)
    print("BATCH 6 DATABASE INSERT")
    print("=" * 70)

    if not DB_PATH.exists():
        print(f"❌ ERROR: Database not found at {DB_PATH}")
        sys.exit(1)

    if not SQL_PATH.exists():
        print(f"❌ ERROR: SQL file not found at {SQL_PATH}")
        sys.exit(1)

    print(f"📊 Database: {DB_PATH}")
    print(f"📄 SQL File: {SQL_PATH}")

    # Connect
    try:
        conn = sqlite3.connect(str(DB_PATH))
        conn.isolation_level = None  # Autocommit mode initially
        cursor = conn.cursor()
        print("✅ Database connection successful")
    except sqlite3.Error as e:
        print(f"❌ Connection failed: {e}")
        sys.exit(1)

    # Read SQL file
    try:
        with open(SQL_PATH, 'r') as f:
            sql_content = f.read()
        print(f"✅ SQL file loaded ({len(sql_content)} bytes)")
    except Exception as e:
        print(f"❌ Error reading SQL: {e}")
        sys.exit(1)

    # Count BEFORE
    print("\n--- BEFORE INSERTION ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM company WHERE success_label='success'")
        before_c = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM person")
        before_p = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM role")
        before_r = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM project")
        before_j = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM outcome")
        before_o = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM event")
        before_e = cursor.fetchone()[0]

        print(f"Companies (success): {before_c}")
        print(f"Persons: {before_p}")
        print(f"Roles: {before_r}")
        print(f"Projects: {before_j}")
        print(f"Outcomes: {before_o}")
        print(f"Events: {before_e}")
    except sqlite3.Error as e:
        print(f"⚠️  Error counting before: {e}")
        before_c = before_p = before_r = before_j = before_o = before_e = 0

    # Execute SQL with executescript (handles transactions properly)
    print("\n--- EXECUTING SQL ---")
    try:
        cursor.executescript(sql_content)
        print("✅ SQL file executed successfully")
    except sqlite3.Error as e:
        print(f"❌ SQL Error: {e}")
        print("\nAttempting to recover...")
        conn.rollback()
        conn.close()
        sys.exit(1)

    # Commit
    try:
        conn.commit()
        print("✅ Transaction committed")
    except sqlite3.Error as e:
        print(f"❌ Commit failed: {e}")
        sys.exit(1)

    # Count AFTER
    print("\n--- AFTER INSERTION ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM company WHERE success_label='success'")
        after_c = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM person")
        after_p = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM role")
        after_r = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM project")
        after_j = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM outcome")
        after_o = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM event")
        after_e = cursor.fetchone()[0]

        print(f"Companies (success): {after_c} (+{after_c - before_c})")
        print(f"Persons: {after_p} (+{after_p - before_p})")
        print(f"Roles: {after_r} (+{after_r - before_r})")
        print(f"Projects: {after_j} (+{after_j - before_j})")
        print(f"Outcomes: {after_o} (+{after_o - before_o})")
        print(f"Events: {after_e} (+{after_e - before_e})")
    except sqlite3.Error as e:
        print(f"⚠️  Error counting after: {e}")

    # Integrity checks
    print("\n--- INTEGRITY CHECKS ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM role WHERE company_id NOT IN (SELECT id FROM company)")
        bad_roles = cursor.fetchone()[0]
        print(f"✅ Roles with valid company refs: {bad_roles == 0}")

        cursor.execute("SELECT COUNT(*) FROM role WHERE person_id NOT IN (SELECT id FROM person)")
        bad_person_refs = cursor.fetchone()[0]
        print(f"✅ Roles with valid person refs: {bad_person_refs == 0}")

        cursor.execute("SELECT COUNT(*) FROM outcome WHERE company_id NOT IN (SELECT id FROM company)")
        bad_outcomes = cursor.fetchone()[0]
        print(f"✅ Outcomes with valid company refs: {bad_outcomes == 0}")
    except sqlite3.Error as e:
        print(f"⚠️  Error checking integrity: {e}")

    # Display Batch 6 companies
    print("\n--- BATCH 6 COMPANIES ---")
    try:
        cursor.execute("""
            SELECT c.id, c.name, c.listing_year, c.delisting_year, c.primary_commodity,
                   o.exit_type, o.exit_year, o.total_score, o.peak_marketcap_cad_million
            FROM company c
            LEFT JOIN outcome o ON c.id = o.company_id
            WHERE c.name IN ('Aurelian Resources Inc.', 'Lumina Copper Corp.',
                            'Andean Resources Limited', 'Red Back Mining Inc.',
                            'Rainy River Resources Ltd.')
            ORDER BY c.name
        """)
        results = cursor.fetchall()
        for row in results:
            company_id, name, list_yr, delist_yr, commodity, exit_type, exit_yr, score, market_cap = row
            print(f"[ID {row[0]:3d}] {row[1]:<35} | {row[2]}-{row[3]} {row[4]:<4} | {row[5]:<6} {row[6]} | Score: {row[7]:.2f}")
    except sqlite3.Error as e:
        print(f"⚠️  Error displaying companies: {e}")

    print("\n" + "=" * 70)
    print("✅ INSERTION COMPLETE")
    print("=" * 70)

    conn.close()
    return 0

if __name__ == '__main__':
    sys.exit(insert_batch6())
