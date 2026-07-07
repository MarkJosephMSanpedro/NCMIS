#!/usr/bin/env python3
"""Run archive-related SQL migration scripts against the configured DB.

Usage:
  python scripts/run_archive_migrations.py        # preview SQL files (no changes)
  python scripts/run_archive_migrations.py --apply  # execute statements

This script uses `get_db_connection()` from the project's `db.py` to connect
to the same database the app uses. Back up your DB before running.
"""
import sys
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SQL_FILES = [
    ROOT / 'scripts' / 'add_archive_columns_20260409.sql',
    ROOT / 'scripts' / 'add_consumables_archive_columns_20260413.sql',
]


def load_sql(path: Path) -> str:
    return path.read_text(encoding='utf-8')


def split_statements(sql: str):
    # Simple split by semicolon - good enough for these migration files.
    parts = [s.strip() for s in sql.split(';')]
    return [p for p in parts if p]


def main():
    apply_changes = '--apply' in sys.argv

    print('Migration runner')
    print('SQL files:')
    for f in SQL_FILES:
        print(' -', f)

    if not all(f.exists() for f in SQL_FILES):
        print('\nError: one or more SQL files are missing. Aborting.')
        sys.exit(1)

    if not apply_changes:
        print('\nPreview mode (no changes). To execute migrations, re-run with --apply')

    # Load SQL contents
    all_statements = []
    for f in SQL_FILES:
        sql = load_sql(f)
        stmts = split_statements(sql)
        print(f"\nLoaded {len(stmts)} statements from {f.name}")
        for s in stmts:
            print('---')
            print(s)
        all_statements.extend(stmts)

    if not apply_changes:
        print('\nPreview complete. No statements executed.')
        return

    # Execute statements using project's DB connection
    try:
        from db import get_db_connection
    except Exception as e:
        print('Failed to import get_db_connection from db.py:', e)
        sys.exit(1)

    conn = None
    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            for i, stmt in enumerate(all_statements, start=1):
                try:
                    cur.execute(stmt)
                    print(f'Executed statement {i}/{len(all_statements)}')
                except Exception as e:
                    print(f'Error executing statement #{i}: {e}')
                    conn.rollback()
                    raise
        conn.commit()
        print('\nAll migration statements executed successfully.')
    except Exception as e:
        print('\nMigration failed:', e)
    finally:
        if conn:
            conn.close()


if __name__ == '__main__':
    main()
