#!/usr/bin/env python3
"""One-off: add the legacy killing-blow ("fatality") messages of the damage spells to abilities.json.

Fixes stridera/fierymud-rs #134: legacy lib/misc/messages carries, per spell, a *death* record
(attacker / victim / room) that replaces the normal hit line when the spell lands the killing blow.
The Rust runtime had nowhere to store them; AbilityMessages now has kill_to_caster / kill_to_victim /
kill_to_room.

Rewrites data/abilities.json in place (messages.killToCaster / killToVictim / killToRoom, legacy colour
codes kept - the importer converts them) and writes data/sql/2026-10-21-spell-fatality-messages.sql for
databases that were imported before the columns existed. Run it ONCE; a second run changes nothing.

Only SPELL_/CHANT_/SONG_ records are taken. Spells with several records for one number (Fracture) are
skipped: legacy picks one at random and one column cannot hold both. Skills (kick, bash, backstab) and
weapon attack types are not handled here.

Usage:
    python scripts/sync_fatality_messages.py [--legacy /home/strider/Code/mud/fierymud_legacy]
"""

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

from fierylib.converters.color_converter import convert_legacy_colors  # noqa: E402
from fierylib.parsers.legacy_spell_data import (  # noqa: E402
    convert_fight_message,
    parse_ability_numbers,
    parse_fight_messages,
    plain_name_for,
)

ABILITIES = ROOT / "data" / "abilities.json"
SQL_PATH = ROOT / "data" / "sql" / "2026-10-21-spell-fatality-messages.sql"
KEYS = ("killToCaster", "killToVictim", "killToRoom")
COLUMNS = ("kill_to_caster", "kill_to_victim", "kill_to_room")


def fatality_messages(legacy: Path) -> dict:
    """``{plain_name: (to_caster, to_victim, to_room)}`` in template syntax, legacy colours kept."""
    messages = parse_fight_messages((legacy / "lib.default/misc/messages").read_text(encoding="latin-1"))
    numbers = parse_ability_numbers((legacy / "src/defines.hpp").read_text(encoding="latin-1"))
    out = {}
    for const, number in numbers.items():
        if const.startswith("SKILL_") or number not in messages or len(messages[number]) != 1:
            continue
        die = [convert_fight_message(m) for m in messages[number][0]["die"]]
        if not any(die):
            continue
        assert not any("$" in (m or "") for m in die), (const, die)
        out[plain_name_for(const)] = tuple(die)
    return out


def q(value):
    return "NULL::text" if value is None else "'" + value.replace("'", "''") + "'"


def render_sql(rows: dict) -> str:
    values = ",\n".join(
        f"       ({q(name)}, " + ", ".join(q(convert_legacy_colors(m) if m else None) for m in msgs) + ")"
        for name, msgs in sorted(rows.items())
    )
    return f"""-- Killing-blow ("fatality") messages for damage spells (fierymud-rs #134).
--
-- Legacy lib/misc/messages carries a death record per spell (attacker / victim / room) that replaces the
-- normal hit line when the spell kills. AbilityMessages.kill_to_caster / kill_to_victim / kill_to_room
-- hold them; the runtime sends them instead of success_to_* on a killing blow.
-- Run AFTER the muditor db push that adds the three columns.
--
-- Keyed by Ability.plain_name (ids differ between dev and prod); abilities missing from the database
-- are skipped; an ability with no AbilityMessages row gets one. Idempotent: rows whose three values
-- already match are not touched, so a re-run changes 0 rows.

INSERT INTO "AbilityMessages" (ability_id, kill_to_caster, kill_to_victim, kill_to_room)
SELECT a.id, v.to_caster, v.to_victim, v.to_room
FROM (VALUES
{values}
     ) AS v(plain_name, to_caster, to_victim, to_room)
JOIN "Ability" a ON a.plain_name = v.plain_name
ON CONFLICT (ability_id) DO UPDATE
SET kill_to_caster = EXCLUDED.kill_to_caster,
    kill_to_victim = EXCLUDED.kill_to_victim,
    kill_to_room = EXCLUDED.kill_to_room
WHERE ("AbilityMessages".kill_to_caster, "AbilityMessages".kill_to_victim, "AbilityMessages".kill_to_room)
      IS DISTINCT FROM (EXCLUDED.kill_to_caster, EXCLUDED.kill_to_victim, EXCLUDED.kill_to_room);
"""


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--legacy", default="/home/strider/Code/mud/fierymud_legacy", type=Path)
    args = ap.parse_args()

    abilities = json.loads(ABILITIES.read_text(encoding="utf-8"))
    by_name = {a["plainName"]: a for a in abilities}
    rows = {n: m for n, m in fatality_messages(args.legacy).items() if n in by_name}
    for name, msgs in rows.items():
        by_name[name].setdefault("messages", {}).update({k: v for k, v in zip(KEYS, msgs) if v})
    ABILITIES.write_text(json.dumps(abilities, indent=2, ensure_ascii=True), encoding="utf-8")
    SQL_PATH.write_text(render_sql(rows), encoding="utf-8")
    print(f"fatality messages for {len(rows)} spells")


if __name__ == "__main__":
    main()
