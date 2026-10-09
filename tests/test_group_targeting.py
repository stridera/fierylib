"""Legacy MAG_GROUP targeting (skills.cpp) and TAR_OUTDOORS restriction (spell_parser.cpp:1559)."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-group-targeting.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}

# Every legacy MAG_GROUP spell/chant/song except WAR_CRY (see the SQL header: its row is a violent
# on-hit damage placeholder, so group targeting would hit the group). GROUP_HEAL was already area.
GROUP = [
    "INVIGORATE",
    "DIVINE_ESSENCE",
    "GROUP_ARMOR",
    "GROUP_RECALL",
    "FREEDOM_SONG",
    "HEARTHSONG",
    "HEROIC_JOURNEY",
]
# Every legacy TAR_OUTDOORS spell (skills.cpp). GAIAS_CLOAK is legacy "cloak of gaia".
OUTDOORS = [
    "CALL_LIGHTNING",
    "DETONATION",
    "EARTHQUAKE",
    "ENTANGLE",
    "GAIAS_CLOAK",
    "MOONBEAM",
    "NATURES_EMBRACE",
    "URBAN_RENEWAL",
    "WRITHING_WEEDS",
]
REFUSAL = "This area is too enclosed to cast that spell!"


def _sql_name_list(after: str) -> list[str]:
    """The plain_name IN (...) list of the first statement containing `after`."""
    block = SQL[SQL.index(after) :]
    match = re.search(r"plain_name IN \(([^)]*)\)", block)
    return re.findall(r"'([A-Z_]+)'", match.group(1))


def test_group_spells_are_room_allies_scope_like_group_heal():
    # Group Heal is the existing example: a non-violent isArea ability, which the importer
    # turns into targetScope ROOM_ALLIES (the runtime's caster-plus-group fan-out).
    assert BY_NAME["GROUP_HEAL"]["isArea"] is True
    for name in GROUP:
        ability = BY_NAME[name]
        assert ability["isArea"] is True, name
        assert not ability["violent"], name
        assert "targetScope" not in ability, name


def test_group_sql_names_match_the_json():
    assert sorted(_sql_name_list("1. Group scope")) == sorted(GROUP)


def test_every_outdoors_spell_carries_the_outdoors_rule_with_the_legacy_line():
    for name in OUTDOORS:
        requirements = BY_NAME[name]["restrictions"]["requirements"]
        assert {"type": "outdoors", "message": REFUSAL} in requirements, name


def test_outdoors_sql_names_and_rule_match_the_json():
    assert sorted(_sql_name_list("2. Outdoors restriction")) == sorted(OUTDOORS)
    pattern = r"'(\{\"type\": \"outdoors\"[^']*\})'::jsonb"
    literals = [json.loads(m) for m in re.findall(pattern, SQL)]
    assert literals
    assert all(literal == {"type": "outdoors", "message": REFUSAL} for literal in literals)


def test_natures_embrace_text_no_longer_says_outdoors_is_unenforced():
    ability = BY_NAME["NATURES_EMBRACE"]
    assert "not enforced" not in ability["description"]
    assert "not enforced" not in ability["notes"]


def test_sql_is_keyed_by_plain_name_only_and_guarded():
    assert not re.search(r"\bid\s*=\s*\d", SQL)
    assert "ability_id = " not in SQL.replace("r.ability_id = a.id", "")
    # Every statement that changes an existing row is guarded by the old shape.
    assert "AND a.target_scope = 'SINGLE'" in SQL
    assert "NOT EXISTS" in SQL
