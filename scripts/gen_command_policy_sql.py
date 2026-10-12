#!/usr/bin/env python3
"""Generate data/sql/2026-10-12-command-policy-flags.sql from the lists in
fierylib.seeders.command_policy (the fierymud-rs per-command allow lists).

Usage:
    poetry run python scripts/gen_command_policy_sql.py [--out PATH]
"""

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

from fierylib.seeders.command_policy import FLAGS, patch_sql  # noqa: E402

DEFAULT_OUT = ROOT / "data" / "sql" / "2026-10-12-command-policy-flags.sql"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = ap.parse_args()
    args.out.write_text(patch_sql(), encoding="utf-8")
    print(f"wrote {args.out} ({', '.join(f'{c}={len(n)}' for c, n in FLAGS.items())})")


if __name__ == "__main__":
    main()
