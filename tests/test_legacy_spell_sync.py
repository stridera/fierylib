"""Spell data synced from the legacy tables (fierymud-rs #128, #127, #111, #125, #131).

Patches: data/sql/2026-10-12-{spell-damage-dice,teleport-messages,combat-ok-from-legacy,quest-spell-flags,
class-spell-lists,colour-codes-131}.sql. Generator: scripts/sync_legacy_spell_data.py. Tests that compare against
the legacy source skip when the legacy checkout is not next to this repo.
"""

import json
import random
import re
from pathlib import Path

import pytest

from fierylib.converters import convert_legacy_colors
from fierylib.parsers.legacy_spell_data import (
    dice_expression,
    parse_skill_flags,
    parse_spell_dams,
    parse_spell_numbers,
    plain_name_for,
)

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "data" / "sql"
ABILITIES = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}
LEGACY = Path("/home/strider/Code/mud/fierymud_legacy")
needs_legacy = pytest.mark.skipif(not (LEGACY / "src" / "skills.cpp").exists(), reason="legacy checkout not found")


def sql(name):
    return (SQL_DIR / f"2026-10-12-{name}.sql").read_text(encoding="utf-8")


def code_only(text):
    return "\n".join(line for line in text.splitlines() if not line.lstrip().startswith("--"))


def damage_amount(name):
    (eff,) = [e for e in BY_NAME[name]["effects"] if e["effect"] == "damage"]
    return eff["params"]["amount"]


# --- a tiny evaluator for the formula grammar (NdM, roll_dice, min, max, pow, + - * /) --------------------------


def evaluate(expr, skill=100, pvp=False, base_damage=0):
    def roll_dice(n, m):
        assert n > 0 and m > 0, f"roll_dice({n}, {m}) is rejected by the runtime evaluator"
        return sum(random.randint(1, m) for _ in range(n))

    py = re.sub(r"(\d+)d(\d+)", r"roll_dice(\1, \2)", expr).replace("/", "//")
    env = {
        "roll_dice": roll_dice,
        "min": min,
        "max": max,
        "pow": pow,
        "skill": skill,
        "actor_is_player": 1 if pvp else 0,
        "target_is_player": 1 if pvp else 0,
        "base_damage": base_damage,
    }
    return eval(py, {"__builtins__": {}}, env)  # noqa: S307 - test-only, input is our own JSON


# --- #128: dice -----------------------------------------------------------------------------------------------


def row(**kw):
    base = dict(spell=1, intern=1, npc_static=0, npc_dice=0, npc_faces=0, pc_static=0, pc_dice=0, pc_faces=0,
                npc_reduce=100, use_bonus=0, bonus=0, lvl_mult=0)  # fmt: skip
    base.update(kw)
    return base


def test_dice_expression_same_for_pve_and_pvp():
    assert dice_expression(row(npc_dice=8, npc_faces=6, npc_static=9, pc_dice=8, pc_faces=6, pc_static=9)) == "8d6 + 9"


def test_dice_expression_folds_pvp_columns_with_the_player_flags():
    full_harm = row(npc_dice=50, npc_faces=14, npc_static=50, pc_dice=50, pc_faces=3, pc_static=50)
    assert dice_expression(full_harm) == "roll_dice(50, 14 - 11 * actor_is_player * target_is_player) + 50"


def test_dice_expression_unused_pvp_side_falls_back_to_the_npc_roll():
    destroy_undead = row(npc_dice=18, npc_faces=5, npc_static=40)
    assert dice_expression(destroy_undead) == "18d5 + 40"


def test_dice_expression_bonus_terms():
    ray = row(npc_dice=10, npc_faces=10, pc_dice=5, pc_faces=10, bonus=75, lvl_mult=2)
    assert dice_expression(ray).endswith("+ min(75, skill * 2)")
    vamp = row(npc_dice=1, npc_faces=50, pc_dice=1, pc_faces=50, bonus=100, use_bonus=1)
    assert dice_expression(vamp) == "1d50 + min(100, skill / (2 + 2 * actor_is_player * target_is_player))"


def test_dice_expression_none_when_the_table_is_off():
    assert dice_expression(row(intern=0, npc_dice=5, npc_faces=5)) is None


DICE_SPELLS = [
    "CALL_LIGHTNING", "CAUSE_CRITIC", "CAUSE_LIGHT", "CAUSE_SERIOUS", "CHAIN_LIGHTNING", "CREMATE",
    "DESTROY_UNDEAD", "DISPEL_EVIL", "DISPEL_GOOD", "DIVINE_BOLT", "DIVINE_RAY", "FIRESTORM",
    "FLOOD", "FULL_HARM", "HARM", "HELL_BOLT", "HELLFIRE_BRIMSTONE", "HOLY_WORD", "ICE_SHARDS",
    "ICE_STORM", "LESSER_EXORCISM", "METEORSWARM", "STYGIAN_ERUPTION", "SUPERNOVA", "UNHOLY_WORD",
    "VAMPIRIC_BREATH", "WRITHING_WEEDS", "DEGENERATION",
]  # fmt: skip


def test_full_harm_and_chain_lightning_roll_dice_on_top_of_the_skill_term():
    assert damage_amount("FULL_HARM") == "roll_dice(50, 14 - 11 * actor_is_player * target_is_player) + 50 + (pow(skill,2)*1)/50"
    assert damage_amount("CHAIN_LIGHTNING") == (
        "12d5 + (26 - 26 * actor_is_player * target_is_player) + (pow(skill,2)*7)/500"
    )


@pytest.mark.parametrize("name", DICE_SPELLS)
def test_damage_formula_is_no_longer_static(name):
    amount = damage_amount(name)
    assert "base_damage" not in amount  # the stand-in for the table roll is replaced by the roll
    assert re.search(r"\d+d\d+|roll_dice\(", amount), amount
    for pvp in (False, True):
        values = {evaluate(amount, pvp=pvp) for _ in range(60)}
        assert len(values) > 1, f"{name} pvp={pvp} always rolls {values}"
        assert min(values) > 0


@pytest.mark.parametrize("name", DICE_SPELLS)
def test_stale_base_damage_note_is_dropped(name):
    (eff,) = [e for e in BY_NAME[name]["effects"] if e["effect"] == "damage"]
    assert "base_damage_note" not in eff["params"]


def test_full_harm_range_matches_the_legacy_table():
    # skill 100: 100 * 100 / 50 = 200 from the skill term; PvE 50d14+50 (100..750), PvP 50d3+50 (100..200).
    pve = [evaluate(damage_amount("FULL_HARM"), pvp=False) for _ in range(400)]
    pvp = [evaluate(damage_amount("FULL_HARM"), pvp=True) for _ in range(400)]
    assert 300 <= min(pve) and max(pve) <= 950
    assert 300 <= min(pvp) and max(pvp) <= 400


@needs_legacy
@pytest.mark.parametrize("name", [n for n in DICE_SPELLS if n != "DEGENERATION"])
def test_dice_match_the_legacy_spell_dams_table(name):
    rows = parse_spell_dams((LEGACY / "lib.default/misc/spell_dams").read_text(encoding="latin-1"))
    nums = parse_spell_numbers((LEGACY / "src/defines.hpp").read_text(encoding="latin-1"))
    dice = dice_expression(rows[nums["SPELL_" + name]])
    assert dice and damage_amount(name).startswith(dice), (name, dice, damage_amount(name))


def test_degeneration_is_the_legacy_switch_roll():
    assert damage_amount("DEGENERATION") == "3d40 + 300"


def test_dice_sql_is_keyed_by_plain_name_and_guarded_on_the_old_formula():
    text = sql("spell-damage-dice")
    body = code_only(text)
    assert "ae.override_params->>'amount' = v.old_amount" in body
    assert "a.plain_name = v.plain_name" in body
    assert not re.search(r"\bid\s*=\s*\d", body)
    rows = re.findall(r"^\s+\('([A-Z_]+)', (\d+), '((?:[^']|'')*)', '((?:[^']|'')*)'\),?$", body, re.M)
    assert {r[0] for r in rows} == set(DICE_SPELLS)
    for name, _order, old, new in rows:
        assert new == damage_amount(name), name
        assert old != new


# --- #127: teleport / gate completion text ---------------------------------------------------------------------

TELEPORT_SPELLS = [
    "DIMENSION_DOOR", "GROUP_RECALL", "HEAVENS_GATE", "HELLS_GATE", "MOONWELL", "PLANE_SHIFT", "RECALL",
    "RELOCATE", "SHIFT_CORPSE", "SUMMON", "SUMMON_CORPSE", "TELEPORT", "WORD_OF_RECALL", "WORLD_TELEPORT",
]  # fmt: skip


def test_no_ability_still_uses_the_vanish_placeholder():
    for a in ABILITIES:
        text = json.dumps(a.get("messages") or {})
        assert "vanish in a flash of light" not in text, a["plainName"]


def test_teleport_spells_have_their_own_completion_text():
    casters = []
    for name in TELEPORT_SPELLS:
        m = BY_NAME[name]["messages"]
        assert m.get("successToRoom"), name
        casters.append(m.get("successToCaster"))
    assert len([c for c in casters if c]) >= 11
    assert len({c for c in casters if c}) >= 10  # not one shared line any more


def test_gates_tell_the_far_end_and_name_the_spell_in_the_text():
    assert "moonwell" in BY_NAME["MOONWELL"]["messages"]["successToVictim"]
    assert "tunnel of" in BY_NAME["HEAVENS_GATE"]["messages"]["successToCaster"]
    assert "hell" in BY_NAME["HELLS_GATE"]["messages"]["successToRoom"]
    assert "{actor.pos} deity" in BY_NAME["HEAVENS_GATE"]["messages"]["successToRoom"]


def test_recall_has_no_caster_line_as_in_legacy():
    for name in ("RECALL", "WORD_OF_RECALL", "GROUP_RECALL"):
        assert "successToCaster" not in BY_NAME[name]["messages"]
        assert "utters a single word" in BY_NAME[name]["messages"]["successToRoom"]


def test_teleport_sql_is_keyed_by_plain_name_and_guarded_on_the_old_text():
    text = sql("teleport-messages")
    body = code_only(text)
    stmts = [s for s in body.split(";") if "UPDATE" in s]
    assert len(stmts) == len(TELEPORT_SPELLS)
    assert {m for s in stmts for m in re.findall(r"a\.plain_name = '([A-Z_]+)'", s)} == set(TELEPORT_SPELLS)
    for s in stmts:
        assert "AND am.success_to_caster = " in s and "AND am.success_to_room = " in s
        assert not re.search(r"\bid\s*=\s*\d", s)
    assert not re.search(r"&[0-9a-zA-Z]", body)  # stored as modern markup, not legacy codes
    assert "<b:black>" in body


# --- #111: combat_ok from legacy skills.cpp ---------------------------------------------------------------------


def test_the_reported_spells_cannot_be_cast_in_combat():
    for name in ("COLDSHIELD", "ICE_ARMOR", "INVISIBLE", "MAJOR_GLOBE", "MINOR_GLOBE"):
        assert BY_NAME[name]["combatOk"] is False, name


def test_every_spell_chant_and_song_carries_an_explicit_combat_flag():
    typed = [a for a in ABILITIES if a["abilityType"] in ("SPELL", "CHANT", "SONG")]
    explicit = [a for a in typed if isinstance(a.get("combatOk"), bool)]
    # the handful the legacy skills.cpp does not define (Monk elemental strikes, Pyre Recoil...) keep the default
    assert len(explicit) >= len(typed) - 12, len(typed) - len(explicit)


@needs_legacy
def test_combat_flags_match_skills_cpp_for_every_legacy_spell():
    flags = parse_skill_flags((LEGACY / "src/skills.cpp").read_text(encoding="latin-1"))
    kind_type = {"spello": "SPELL", "chanto": "CHANT", "songo": "SONG"}
    checked = 0
    for const, f in flags.items():
        ab = BY_NAME.get(plain_name_for(const))
        if ab is None or ab["abilityType"] != kind_type[f["kind"]]:
            continue
        checked += 1
        assert ab["combatOk"] is f["fighting_ok"], const
        assert bool(ab.get("questOnly", False)) is f["quest"], const
    assert checked > 280


def test_combat_sql_lists_exactly_the_not_castable_abilities():
    body = code_only(sql("combat-ok-from-legacy"))
    assert "combat_ok = false" in body and "WHERE combat_ok" in body  # idempotent: only rows still castable
    listed = set(re.findall(r"'([A-Z_]+)'", body.split("plain_name IN")[1])) - {"SPELL", "CHANT", "SONG"}
    expected = {a["plainName"] for a in ABILITIES
                if a["abilityType"] in ("SPELL", "CHANT", "SONG") and a.get("combatOk") is False}  # fmt: skip
    # Disguise (#143) has no legacy spello(); its disguise-spell.sql INSERT sets combat_ok = false itself.
    assert listed == expected - {"DISGUISE"}
    assert not re.search(r"\bid\s*=\s*\d", body)


def test_importer_still_writes_the_json_flag():
    importer = (ROOT / "src/fierylib/importers/magic_system_importer.py").read_text(encoding="utf-8")
    assert 'ability.get("combatOk", True)' in importer
    assert 'ability.get("questOnly", False)' in importer


# --- #125: quest markers + generated class spell lists ----------------------------------------------------------


def test_quest_flags_in_json_and_sql_agree():
    body = code_only(sql("quest-spell-flags"))
    listed = set(re.findall(r"'([A-Z_]+)'", body))
    expected = {a["plainName"] for a in ABILITIES if a.get("questOnly")}
    assert listed == expected
    assert {"FLOOD", "WALL_OF_ICE", "MAJOR_GLOBE", "RELOCATE", "WATERFORM", "ICE_SHARDS"} <= expected
    assert "WHERE NOT quest_only" in body


def test_class_spell_list_sql_is_generated_from_the_class_tables_and_idempotent():
    body = code_only(sql("class-spell-lists"))
    assert 'FROM "ClassAbilities" ca' in body and "a.quest_only" in body
    assert "content IS DISTINCT FROM body" in body  # a second run rewrites nothing
    assert "'spell_' || c.key" in body
    assert "skill_" not in body  # skill lists keep the universal skills the tables do not hold
    assert not re.search(r"\bid\s*=\s*\d", body)  # no hard-coded ids


def test_class_spell_list_sql_sets_the_quest_flags_itself():
    """Prod applied class-spell-lists before quest-spell-flags (alphabetical), so no list got its `*`."""
    body = code_only(sql("class-spell-lists"))
    block = body.split("plain_name IN (")[1].split(");")[0]
    expected = {a["plainName"] for a in ABILITIES if a.get("questOnly")}
    assert set(re.findall(r"'([A-Z_]+)'", block)) == expected
    # the flag update runs before the lists are built
    assert body.index("SET quest_only = true") < body.index('FROM "ClassAbilities" ca')


def test_help_import_regenerates_the_spell_lists_after_the_legacy_import():
    src = (ROOT / "src/fierylib/importers/help_importer.py").read_text(encoding="utf-8")
    assert "2026-10-12-class-spell-lists.sql" in src
    assert src.index("import_help_files(help_dir, verbose, clear_existing)") < src.index(
        "await regenerate_class_spell_lists(prisma)"
    )
    assert (SQL_DIR / "2026-10-12-class-spell-lists.sql").exists()


# --- #131: colour codes -----------------------------------------------------------------------------------------


def test_colour_chart_patch_is_keyed_by_zone_and_id_and_guarded():
    text = sql("colour-codes-131")
    body = code_only(text)
    assert "WHERE zone_id = 10 AND id = 98" in body
    assert "AND examine_description = $q$" in body
    new = body.split("SET examine_description = $q$")[1].split("$q$")[0]
    assert new.startswith("<red>&1 </>") and "&<" not in new
    legacy = "&1&&1 &b&&1&&b &0&2&&2 &b&&2&&b &0"  # start of lib/world/obj/10.obj #1098's extra description
    assert new.startswith(convert_legacy_colors(legacy).replace("</>", "</>", 1)[:60])


def test_player_importer_stores_modern_markup_for_item_names():
    src = (ROOT / "src/fierylib/importers/player_importer.py").read_text(encoding="utf-8")
    assert 'item_data["customName"] = convert_legacy_colors(short_desc)' in src
