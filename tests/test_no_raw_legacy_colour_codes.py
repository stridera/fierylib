"""Legacy `&` colour codes must never reach the Rust server raw.

The server has no `&` layer; every legacy-to-modern conversion happens in fierylib.
  * data/triggers/*.lua ship to the DB verbatim, so no non-comment string may hold a code.
  * data/abilities.json is import *source*: magic_system_importer runs every message through
    convert_legacy_colors, so the invariant is that this conversion leaves no `&` residue.
"""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from fierylib.converters.color_converter import convert_legacy_colors  # noqa: E402

CODE_RE = re.compile(r"&[0-9a-zA-Z_]")
STRING_RE = re.compile(r"\"(?:[^\"\\]|\\.)*\"|'(?:[^'\\]|\\.)*'")


def test_no_legacy_codes_in_trigger_strings():
    bad = []
    for path in sorted((ROOT / "data" / "triggers").rglob("*.lua")):
        for n, line in enumerate(path.read_text().split("\n"), 1):
            if line.lstrip().startswith("--") or "&" not in line:
                continue
            for m in STRING_RE.finditer(line):
                if CODE_RE.search(m.group(0)):
                    bad.append(f"{path.relative_to(ROOT)}:{n}: {m.group(0)[:80]}")
    assert not bad, "legacy colour codes in trigger strings:\n" + "\n".join(bad)


def test_ability_messages_convert_without_residue():
    abilities = json.loads((ROOT / "data" / "abilities.json").read_text())
    bad = []
    for ab in abilities:
        for key, value in (ab.get("messages") or {}).items():
            if not isinstance(value, str):
                continue
            out = convert_legacy_colors(value)
            if CODE_RE.search(out):
                bad.append(f"{ab.get('name') or ab.get('plainName')}.{key}: {out[:80]}")
    assert not bad, "importer leaves legacy codes in ability messages:\n" + "\n".join(bad)
