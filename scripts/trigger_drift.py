#!/usr/bin/env python3
"""Compare the Triggers table of a database with data/triggers at git HEAD (read-only).

A DB row is "clean" when md5(commands) matches any form of its repo file that
gen_trigger_patch_sql.accepted_forms() knows (header-stripped body, whole file, either
with the final newline trimmed), the same set the md5-guarded patches accept. Reports:

  drifted    row exists on both sides but matches no form of the HEAD file
  prod_only  row in the DB with no file in data/triggers
  repo_only  file in data/triggers with no DB row, ignoring files whose zone has no row
             in the DB's "Zones" table (that zone was never imported there)

Exactly one input source:
  --dsn DSN       run psql DSN (a postgresql:// URI or conninfo string) locally
  --psql CMD      run CMD with the query on stdin; CMD is split shell-style and must
                  behave like "psql -At -F '|'" (so it may be an ssh pipeline)
  --tsv FILE|-    read a prior export (use - for stdin); see --print-query

Export format, one record per line, fields separated by "|" or TAB:
  <zone_id>|<id>|<md5 of commands>|<updated_at>|<updated_by>      a Triggers row
  zone|<zone_id>                                                  a Zones row
If the export has no zone lines, repo_only is not filtered by zone.
--print-query prints the SELECT that produces it.

Prod, without credentials on this machine (the query goes over ssh on stdin):
  poetry run python scripts/trigger_drift.py --psql \\
    "ssh fierymud 'sudo -n -u postgres psql -d fierynext -At -F \\"|\\"'"
or pipe an export:
  poetry run python scripts/trigger_drift.py --print-query |
    ssh fierymud 'sudo -n -u postgres psql -d fierynext -At -F "|"' |
    poetry run python scripts/trigger_drift.py --tsv -
Dev:
  poetry run python scripts/trigger_drift.py --dsn "postgresql://strider@localhost/fierydev"

Only SELECTs are issued. Exit status is 1 if anything drifted, else 0.
"""

from __future__ import annotations

import argparse
import importlib.util
import shlex
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# UNION ALL cannot mix int and text in column 1, so cast both sides.
QUERY = (
    "SELECT zone_id::text, id::text, md5(commands), updated_at::text, coalesce(updated_by, '<null>') "
    'FROM "Triggers" '
    "UNION ALL SELECT 'zone', id::text, '', '', '' FROM \"Zones\";"
)


def _gen():
    spec = importlib.util.spec_from_file_location("gen_trigger_patch_sql", ROOT / "scripts/gen_trigger_patch_sql.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def repo_forms(ref: str = "HEAD") -> tuple[dict, list]:
    """(zone, id) -> (path, set of md5 of accepted forms) for every .lua under data/triggers at ref."""
    gen = _gen()
    names = subprocess.run(
        ["git", "ls-tree", "-r", "--name-only", ref, "--", "data/triggers"],
        cwd=ROOT, check=True, capture_output=True, text=True,
    ).stdout.splitlines()
    repo: dict[tuple[int, int], tuple[str, set[str]]] = {}
    dups = []
    for path in sorted(n for n in names if n.endswith(".lua")):
        raw = subprocess.run(["git", "show", f"{ref}:{path}"], cwd=ROOT, check=True, capture_output=True).stdout
        text = raw.decode("utf-8")
        p = gen.parse(text, path)
        key = (p.zone_id, p.local_id)
        hashes = {gen.md5_hex(f) for f in gen.accepted_forms(text, path)}
        if key in repo:
            dups.append((key, path, repo[key][0]))
            hashes |= repo[key][1]  # either file's form counts as clean
            path = repo[key][0]
        repo[key] = (path, hashes)
    return repo, dups


def parse_export(lines) -> tuple[dict, set | None]:
    """Parse an export into ({(zone, id): (md5, updated_at, updated_by)}, zone ids or None)."""
    rows: dict[tuple[int, int], tuple[str, str, str]] = {}
    zones: set[int] = set()
    for n, line in enumerate(lines, 1):
        line = line.rstrip("\r\n")
        if not line.strip():
            continue
        f = line.split("|") if "|" in line else line.split("\t")
        if f[0] == "zone":
            zones.add(int(f[1]))
            continue
        if len(f) < 3:
            raise SystemExit(f"export line {n}: expected zone|id|md5|updated_at|updated_by, got {line!r}")
        f += [""] * (5 - len(f))
        rows[(int(f[0]), int(f[1]))] = (f[2], f[3], f[4])
    return rows, (zones or None)


def run_query(argv: list[str]) -> list[str]:
    r = subprocess.run(argv, input=QUERY + "\n", capture_output=True, text=True)
    if r.returncode != 0:
        raise SystemExit(f"query failed ({argv[0]}): {r.stderr.strip()}")
    return r.stdout.splitlines()


def compare(rows, zones, repo):
    drifted, prod_only, repo_only, clean = [], [], [], 0
    for key, (h, ts, by) in sorted(rows.items()):
        if key not in repo:
            prod_only.append((key, ts, by))
        elif h in repo[key][1]:
            clean += 1
        else:
            drifted.append((key, ts, by, repo[key][0]))
    for key in sorted(repo):
        if key in rows or (zones is not None and key[0] not in zones):
            continue
        repo_only.append((key, repo[key][0]))
    drifted.sort(key=lambda r: r[1], reverse=True)
    return drifted, prod_only, repo_only, clean


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    src = ap.add_mutually_exclusive_group()
    src.add_argument("--dsn")
    src.add_argument("--psql", metavar="CMD")
    src.add_argument("--tsv", metavar="FILE")
    ap.add_argument("--ref", default="HEAD", help="git ref holding data/triggers (default HEAD)")
    ap.add_argument("--print-query", action="store_true")
    a = ap.parse_args()
    if a.print_query:
        print(QUERY)
        return 0
    if a.dsn:
        lines = run_query(["psql", a.dsn, "-X", "-At", "-F", "|", "-v", "ON_ERROR_STOP=1"])
    elif a.psql:
        lines = run_query(shlex.split(a.psql))
    elif a.tsv:
        lines = sys.stdin.read().splitlines() if a.tsv == "-" else Path(a.tsv).read_text(encoding="utf-8").splitlines()
    else:
        ap.error("give one of --dsn, --psql, --tsv")
    rows, zones = parse_export(lines)
    if not rows:
        raise SystemExit("no Triggers rows in the input")
    repo, dups = repo_forms(a.ref)
    drifted, prod_only, repo_only, clean = compare(rows, zones, repo)
    print(f"db rows={len(rows)} repo files={len(repo)} clean={clean} dup_repo_keys={len(dups)}"
          + ("" if zones is not None else " (no zone list: repo_only unfiltered)"))
    print(f"drifted={len(drifted)} prod_only={len(prod_only)} repo_only={len(repo_only)}")
    for (z, i), ts, by, path in drifted:
        print(f"drifted\t{z}:{i}\t{ts}\t{by}\t{path}")
    for (z, i), ts, by in prod_only:
        print(f"prod_only\t{z}:{i}\t{ts}\t{by}")
    for (z, i), path in repo_only:
        print(f"repo_only\t{z}:{i}\t{path}")
    return 1 if drifted else 0


if __name__ == "__main__":
    sys.exit(main())
