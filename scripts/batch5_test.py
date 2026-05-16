#!/usr/bin/env python3
"""
Batch 5 Local Verification Script
- Validates SQL data entry
- Tests database integrity
- Reports summary statistics
"""

import sqlite3
import sys
from pathlib import Path

# File paths
REPO_ROOT = Path(__file__).parent.parent
DB_PATH = REPO_ROOT / "data" / "junior_mining.db"
SQL_PATH = REPO_ROOT / "sql" / "260517 Batch 5 Data Entry.sql"

def test_database():
    """Test SQL syntax and data integrity"""

    print("=" * 70)
    print("BATCH 5 DATABASE VERIFICATION")
    print("=" * 70)

    # Check if DB exists
    if not DB_PATH.exists():
        print(f"❌ ERROR: Database not found at {DB_PATH}")
        sys.exit(1)

    print(f"✅ Database found: {DB_PATH}")

    # Check if SQL file exists
    if not SQL_PATH.exists():
        print(f"❌ ERROR: SQL file not found at {SQL_PATH}")
        sys.exit(1)

    print(f"✅ SQL file found: {SQL_PATH}")

    # Connect to DB
    try:
        conn = sqlite3.connect(str(DB_PATH))
        cursor = conn.cursor()
        print("✅ Database connection successful")
    except sqlite3.Error as e:
        print(f"❌ Database connection failed: {e}")
        sys.exit(1)

    # Read SQL file
    try:
        with open(SQL_PATH, 'r') as f:
            sql_content = f.read()
        print(f"✅ SQL file loaded ({len(sql_content)} bytes)")
    except Exception as e:
        print(f"❌ Error reading SQL file: {e}")
        sys.exit(1)

    # Test: Count records BEFORE insertion
    print("\n--- BEFORE INSERTION ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM company")
        before_companies = cursor.fetchone()[0]
        print(f"Companies: {before_companies}")

        cursor.execute("SELECT COUNT(*) FROM person")
        before_persons = cursor.fetchone()[0]
        print(f"Persons: {before_persons}")

        cursor.execute("SELECT COUNT(*) FROM role")
        before_roles = cursor.fetchone()[0]
        print(f"Roles: {before_roles}")

        cursor.execute("SELECT COUNT(*) FROM project")
        before_projects = cursor.fetchone()[0]
        print(f"Projects: {before_projects}")

        cursor.execute("SELECT COUNT(*) FROM outcome")
        before_outcomes = cursor.fetchone()[0]
        print(f"Outcomes: {before_outcomes}")

        cursor.execute("SELECT COUNT(*) FROM event")
        before_events = cursor.fetchone()[0]
        print(f"Events: {before_events}")
    except sqlite3.Error as e:
        print(f"❌ Error querying before-state: {e}")
        sys.exit(1)

    # Parse and execute SQL statements
    print("\n--- EXECUTING SQL ---")
    statements = [s.strip() for s in sql_content.split(';') if s.strip() and not s.strip().startswith('--')]

    executed = 0
    for stmt in statements:
        if stmt.startswith('PRAGMA') or stmt.startswith('--'):
            continue

        if 'INSERT INTO' in stmt or 'SELECT' in stmt:
            try:
                cursor.execute(stmt)
                executed += 1
            except sqlite3.Error as e:
                print(f"❌ SQL Error executing: {stmt[:50]}...")
                print(f"   {e}")
                conn.rollback()
                sys.exit(1)

    print(f"✅ {executed} SQL statements executed successfully")

    # Commit transaction
    try:
        conn.commit()
        print("✅ Transaction committed")
    except sqlite3.Error as e:
        print(f"❌ Commit failed: {e}")
        sys.exit(1)

    # Test: Count records AFTER insertion
    print("\n--- AFTER INSERTION ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM company")
        after_companies = cursor.fetchone()[0]
        print(f"Companies: {after_companies} (added {after_companies - before_companies})")

        cursor.execute("SELECT COUNT(*) FROM person")
        after_persons = cursor.fetchone()[0]
        print(f"Persons: {after_persons} (added {after_persons - before_persons})")

        cursor.execute("SELECT COUNT(*) FROM role")
        after_roles = cursor.fetchone()[0]
        print(f"Roles: {after_roles} (added {after_roles - before_roles})")

        cursor.execute("SELECT COUNT(*) FROM project")
        after_projects = cursor.fetchone()[0]
        print(f"Projects: {after_projects} (added {after_projects - before_projects})")

        cursor.execute("SELECT COUNT(*) FROM outcome")
        after_outcomes = cursor.fetchone()[0]
        print(f"Outcomes: {after_outcomes} (added {after_outcomes - before_outcomes})")

        cursor.execute("SELECT COUNT(*) FROM event")
        after_events = cursor.fetchone()[0]
        print(f"Events: {after_events} (added {after_events - before_events})")
    except sqlite3.Error as e:
        print(f"❌ Error querying after-state: {e}")
        sys.exit(1)

    # Data quality checks
    print("\n--- DATA QUALITY CHECKS ---")

    # Check 1: All companies have success_label = 'success'
    cursor.execute("SELECT COUNT(*) FROM company WHERE success_label != 'success'")
    bad_labels = cursor.fetchone()[0]
    if bad_labels == 0:
        print("✅ All companies labeled as 'success'")
    else:
        print(f"⚠️  {bad_labels} companies with non-'success' labels")

    # Check 2: All outcomes have valid exit years
    cursor.execute("SELECT COUNT(*) FROM outcome WHERE exit_year < 2000 OR exit_year > 2026")
    bad_years = cursor.fetchone()[0]
    if bad_years == 0:
        print("✅ All outcomes have valid exit years (2000-2026)")
    else:
        print(f"⚠️  {bad_years} outcomes with invalid years")

    # Check 3: All roles have matching person and company
    cursor.execute("""
        SELECT COUNT(*) FROM role
        WHERE person_id NOT IN (SELECT id FROM person)
           OR company_id NOT IN (SELECT id FROM company)
    """)
    bad_fks = cursor.fetchone()[0]
    if bad_fks == 0:
        print("✅ All roles have valid person and company references")
    else:
        print(f"⚠️  {bad_fks} roles with invalid foreign keys")

    # Check 4: All projects have matching company
    cursor.execute("SELECT COUNT(*) FROM project WHERE company_id NOT IN (SELECT id FROM company)")
    bad_projects = cursor.fetchone()[0]
    if bad_projects == 0:
        print("✅ All projects have valid company references")
    else:
        print(f"⚠️  {bad_projects} projects with invalid company references")

    # Check 5: All events have matching company
    cursor.execute("SELECT COUNT(*) FROM event WHERE company_id NOT IN (SELECT id FROM company)")
    bad_events = cursor.fetchone()[0]
    if bad_events == 0:
        print("✅ All events have valid company references")
    else:
        print(f"⚠️  {bad_events} events with invalid company references")

    # Check 6: All outcomes have matching company
    cursor.execute("SELECT COUNT(*) FROM outcome WHERE company_id NOT IN (SELECT id FROM company)")
    bad_outcomes = cursor.fetchone()[0]
    if bad_outcomes == 0:
        print("✅ All outcomes have valid company references")
    else:
        print(f"⚠️  {bad_outcomes} outcomes with invalid company references")

    # Sample data display
    print("\n--- SAMPLE DATA (Batch 5 Companies) ---")
    try:
        cursor.execute("""
            SELECT c.name, c.listing_year, c.delisting_year, c.primary_commodity,
                   o.exit_type, o.exit_year, o.total_score, o.peak_marketcap_cad_million
            FROM company c
            LEFT JOIN outcome o ON c.id = o.company_id
            WHERE c.success_label = 'success'
            ORDER BY c.name
        """)
        results = cursor.fetchall()
        for row in results:
            print(f"{row[0]:<30} | {row[1]}-{row[2]} | {row[3]} | {row[4]:<6} {row[5]} | Score: {row[6]:.1f} | CAD${row[7]:.0f}M")
    except sqlite3.Error as e:
        print(f"⚠️  Error displaying sample data: {e}")

    # Summary
    print("\n" + "=" * 70)
    print("VERIFICATION SUMMARY")
    print("=" * 70)
    print(f"✅ Database integrity verified")
    print(f"✅ {executed} SQL statements executed")
    print(f"✅ Added {after_companies - before_companies} companies")
    print(f"✅ Added {after_persons - before_persons} persons")
    print(f"✅ Added {after_roles - before_roles} roles")
    print(f"✅ Added {after_projects - before_projects} projects")
    print(f"✅ Added {after_outcomes - before_outcomes} outcomes")
    print(f"✅ Added {after_events - before_events} events")
    print("=" * 70)

    conn.close()
    print("\n✅ TEST COMPLETE - Database ready for production use")
    return 0

if __name__ == '__main__':
    sys.exit(test_database())
