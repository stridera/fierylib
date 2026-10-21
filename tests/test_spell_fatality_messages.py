"""Killing-blow ("fatality") messages: legacy lib/misc/messages die records -> AbilityMessages.kill_to_*."""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from fierylib.parsers.legacy_spell_data import convert_fight_message, parse_fight_messages  # noqa: E402

DATA = ROOT / "data"
SQL = (DATA / "sql" / "2026-10-21-spell-fatality-messages.sql").read_text(encoding="utf-8")
ABILITIES = {a["plainName"]: a for a in json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))}

SAMPLE = """* Freeze
M
 175
&6&b$N&6&b is encased in a massive block of ice, permanently.&0
&6&bYou are encased in a massive block of ice, permanently.&0
#
Your spell seems to have missed!
$n's spell missed you!
$n's spell missed $N!
hit a
hit b
hit c
god a
god b
god c
#
#
#

* Next
M
 6
d1
d2
d3
m1
m2
m3
h1
h2
h3
g1
g2
g3
#
#
#
"""


def test_parse_fight_messages_reads_die_records_and_hash_slots():
    recs = parse_fight_messages(SAMPLE)
    assert sorted(recs) == [6, 175]
    (freeze,) = recs[175]
    assert freeze["die"][0] == "&6&b$N&6&b is encased in a massive block of ice, permanently.&0"
    assert freeze["die"][2] is None
    assert freeze["hit"] == ["hit a", "hit b", "hit c"]
    assert recs[6][0]["die"] == ["d1", "d2", "d3"]


def test_convert_fight_message_maps_attacker_and_victim_codes():
    assert convert_fight_message("$n burns $N, $E dies; $S $s $M $m $e") == (
        "{actor.name} burns {target.name}, {target.he} dies; "
        "{target.his} {actor.his} {target.him} {actor.him} {actor.he}"
    )
    assert convert_fight_message(None) is None


def test_freeze_fireball_and_magic_missile_carry_fatality_lines():
    for name in ("FREEZE", "FIREBALL", "MAGIC_MISSILE"):
        msgs = ABILITIES[name]["messages"]
        assert msgs["killToCaster"] and msgs["killToVictim"] and msgs["killToRoom"], name
        assert msgs["killToCaster"] != msgs["successToCaster"], name
        assert "$" not in msgs["killToCaster"] + msgs["killToVictim"] + msgs["killToRoom"], name
    assert "permanently" in ABILITIES["FREEZE"]["messages"]["killToCaster"]


def test_sql_patch_is_idempotent_and_keyed_by_plain_name():
    assert "ON CONFLICT (ability_id) DO UPDATE" in SQL
    assert "IS DISTINCT FROM" in SQL
    assert "a.plain_name = v.plain_name" in SQL
    keys = set(re.findall(r"^\s+\('([A-Z_]+)', ", SQL, re.M))
    with_kill = {n for n, a in ABILITIES.items() if a.get("messages", {}).get("killToCaster")
                 or a.get("messages", {}).get("killToVictim") or a.get("messages", {}).get("killToRoom")}
    assert keys == with_kill
    assert "FREEZE" in keys and len(keys) > 70
    # colours are converted in the patch (the importer converts them for abilities.json)
    assert not re.search(r"&[0-9a-zA-Z]", SQL)


def test_importer_passes_the_kill_columns_through():
    src = (ROOT / "src" / "fierylib" / "importers" / "magic_system_importer.py").read_text(encoding="utf-8")
    for key in ("killToCaster", "killToVictim", "killToRoom"):
        assert f'"{key}": _color("{key}")' in src
