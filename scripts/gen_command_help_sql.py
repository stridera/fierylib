#!/usr/bin/env python3
"""Generate data/sql/2026-10-12-command-help-text.sql from data/command_help.json.

data/command_help.json is a dump of the fierymud-rs command REGISTRY (one row per command:
name, aliases, category label, min_role, usage, summary, long). Refresh it with:

    cd <fierymud-rs checkout>
    HELP_DUMP_PATH=/tmp/command-help.json \
        cargo test -p mud-server dump_command_help -- --ignored
    python3 -I -c "import json;r=json.load(open('/tmp/command-help.json'));\
json.dump(r,open('<fierylib>/data/command_help.json','w'),indent=1,ensure_ascii=False,sort_keys=True)"

The SQL fills "Command".help_summary / help_text (what `help <command>` shows) and adds a
"Command" row for every game command the older Muditor catalog lacks. Existing rows only get
the help columns filled while NULL or empty, so builder edits survive. The statement logic
lives in fierylib.seeders.command_help (CommandSeeder runs the same one).

Usage:
    poetry run python scripts/gen_command_help_sql.py [--out PATH]
"""

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

from fierylib.seeders.command_help import DATA_PATH, load_rows, patch_sql  # noqa: E402

DEFAULT_OUT = ROOT / "data" / "sql" / "2026-10-12-command-help-text.sql"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", type=Path, default=DATA_PATH)
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = ap.parse_args()
    rows = load_rows(args.src)
    args.out.write_text(patch_sql(rows), encoding="utf-8")
    print(f"wrote {args.out} ({len(rows)} commands)")


if __name__ == "__main__":
    main()
