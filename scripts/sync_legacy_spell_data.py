#!/usr/bin/env python3
"""One-off: bring data/abilities.json in line with the legacy spell tables and emit the SQL patches.

Fixes (stridera/fierymud-rs):
  #128  spell damage is static      -> legacy spell_dams dice on top of each damage spell's formula
  #127  teleport/gate completion text is a shared placeholder -> each spell's legacy messages
  #111  in-combat flag               -> Ability.combat_ok from legacy skills.cpp ok_fighting, every spell
  #125  quest spells (for the generated class spell lists) -> Ability.quest_only from skills.cpp

Run it ONCE against the pre-fix JSON; it rewrites data/abilities.json in place and writes
  data/sql/2026-10-12-spell-damage-dice.sql
  data/sql/2026-10-12-teleport-messages.sql
  data/sql/2026-10-12-combat-ok-from-legacy.sql
  data/sql/2026-10-12-quest-spell-flags.sql
(the SQL guards embed the *old* values, so a second run of this script on the new JSON finds nothing
to change and refuses to overwrite the committed patches).

Usage:
    python scripts/sync_legacy_spell_data.py [--legacy /home/strider/Code/mud/fierymud_legacy]
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
    dice_expression,
    parse_skill_flags,
    parse_spell_dams,
    parse_spell_numbers,
    plain_name_for,
)

ABILITIES = ROOT / "data" / "abilities.json"
SQL_DIR = ROOT / "data" / "sql"
DATE = "2026-10-12"

# --------------------------------------------------------------------------------------------------
# #128 - damage dice
# --------------------------------------------------------------------------------------------------

# Spells whose legacy mag_damage() case is `dam += <formula>` (or has no case) with spell_dams
# intern = 1, i.e. the table roll is added to the formula, and whose runtime formula has no dice.
DICE_SPELLS = [
    "CALL_LIGHTNING", "CAUSE_CRITIC", "CAUSE_LIGHT", "CAUSE_SERIOUS", "CHAIN_LIGHTNING", "CREMATE",
    "DESTROY_UNDEAD", "DISPEL_EVIL", "DISPEL_GOOD", "DIVINE_BOLT", "DIVINE_RAY", "FIRESTORM",
    "FLOOD", "FULL_HARM", "HARM", "HELL_BOLT", "HELLFIRE_BRIMSTONE", "HOLY_WORD", "ICE_SHARDS",
    "ICE_STORM", "LESSER_EXORCISM", "METEORSWARM", "STYGIAN_ERUPTION", "SUPERNOVA", "UNHOLY_WORD",
    "VAMPIRIC_BREATH", "WRITHING_WEEDS",
]  # fmt: skip

# CREMATE is a MAG_AREA spell with no case in the mag_damage switch: the table roll IS the damage.
TABLE_ONLY = {"CREMATE"}
# DEGENERATION: `dam += roll_dice(3, 40) + 300` in the switch; no spell_dams row.
FIXED_FORMULAS = {"DEGENERATION": "3d40 + 300"}


def new_amount(old: str, dice: str, table_only: bool) -> str:
    if table_only:
        return dice
    rest = old
    if rest.startswith("base_damage + "):
        # base_damage (level + 2*circle + stat bonus) was a stand-in for the online table roll.
        rest = rest[len("base_damage + "):]
    return f"{dice} + {rest}"


def sync_dice(abilities, legacy: Path):
    sd = parse_spell_dams((legacy / "lib.default/misc/spell_dams").read_text(encoding="latin-1"))
    nums = parse_spell_numbers((legacy / "src/defines.hpp").read_text(encoding="latin-1"))
    changes = []  # (plain_name, order, old, new)
    by_name = {a["plainName"]: a for a in abilities}
    targets = {n: None for n in DICE_SPELLS}
    targets.update({n: f for n, f in FIXED_FORMULAS.items()})
    for name, fixed in targets.items():
        ab = by_name[name]
        for eff in ab["effects"]:
            if eff["effect"] != "damage" or "amount" not in eff["params"]:
                continue
            old = eff["params"]["amount"]
            if fixed is not None:
                new = fixed
            else:
                dice = dice_expression(sd[nums["SPELL_" + name]])
                assert dice, name
                new = new_amount(old, dice, name in TABLE_ONLY)
            if new == old:
                continue
            eff["params"]["amount"] = new
            # The note explained the base_damage term, which the table roll replaces.
            stale_note = "base_damage" not in new and "base_damage_note" in eff["params"]
            if stale_note:
                del eff["params"]["base_damage_note"]
            changes.append((name, eff["order"], old, new, stale_note))
    return changes


def q(value):
    return "NULL" if value is None else "'" + value.replace("'", "''") + "'"


def render_dice_sql(changes):
    rows = ",\n".join(f"  ({q(n)}, {o}, {q(old)}, {q(new)})" for n, o, old, new, _ in changes)
    return f"""-- fierymud-rs #128: "Spell dams static" - Full Harm always hit for exactly 200, Chain Lightning for exactly 140.
-- The damage formulas only had the skill term; legacy mag_damage() (magic.cpp) first rolls the dice from the
-- online damage table (lib/misc/spell_dams) and every `dam += <formula>` case adds its formula on top of that
-- roll. The dice are now part of each formula (data/abilities.json is the source for reimports):
--   NdM + static [+ bonus] + <old skill term>          PvE / mob casters (the npc_* columns)
-- A player casting at a player rolls the pc_* columns; the two are folded into one expression with the
-- `actor_is_player * target_is_player` product Sunray already uses. Spells that used `base_damage` (a stand-in
-- for the table roll) lose that term and its base_damage_note. Cremate has no case in the switch, so the table
-- roll is its whole damage; Degeneration's switch case is `roll_dice(3, 40) + 300`.
-- Keyed by Ability.plain_name; each row only matches while the amount is still the old formula, so a second run
-- changes 0 rows and a builder-edited formula is never overwritten.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{{amount}}', to_jsonb(v.new_amount::text)) - 'base_damage_note'
FROM (VALUES
{rows}
) AS v(plain_name, ord, old_amount, new_amount),
     "Ability" a,
     "Effect" e
WHERE a.plain_name = v.plain_name
  AND ae.ability_id = a.id
  AND ae."order" = v.ord
  AND e.id = ae.effect_id
  AND e.name = 'damage'
  AND ae.override_params->>'amount' = v.old_amount;
"""


# --------------------------------------------------------------------------------------------------
# #127 - teleport / gate completion messages (legacy spells.cpp, converted to template syntax)
# --------------------------------------------------------------------------------------------------

PLACEHOLDER_CASTER = "You vanish in a flash of light!"
PLACEHOLDER_ROOM = "{actor.name} vanishes in a flash of light!"

# Legacy colour codes are kept (the importer converts them). `$n` -> {actor.name}, `$N` -> {target.name}.
# The legacy act() calls that go to the destination room have no slot in AbilityMessages and are not
# ported; neither are the multi-line pairs, which are joined on one line (no message here has a newline).
TELEPORT_MESSAGES = {
    # spell_dimension_door: perform_teleport(ch, ch, victim->in_room, ...)
    "DIMENSION_DOOR": {
        "successToCaster": "&9&bYou quickly enter the black rift that tears open at your command...&0",
        "successToRoom": "&9&bA black rift in space tears open and {actor.name}&9&b steps inside.&0",
    },
    # spell_relocate
    "RELOCATE": {
        "successToCaster": "&7&bYour body begins to fade from existence, &9then you black out...&0",
        "successToRoom": "&7&b{actor.name}&7&b's molecules loosen and eventually dissipate into thin air.&0",
    },
    # spell_plane_shift
    "PLANE_SHIFT": {
        "successToCaster": "You begin to fade, then reappear.",
        "successToRoom": "{actor.name} begins to fade, then reappears.",
    },
    # spell_teleport / spell_world_teleport -> perform_teleport_spell (success and failed-roll text)
    "TELEPORT": {
        "successToCaster": "&9&bYou feel your body being pulled in all directions, then find yourself elsewhere.&0",
        "successToRoom": "&9&b{actor.name} &9&bslowly fades out of existence and is gone.&0",
        "failToCaster": "&7The spell swirls about and dies away.&0",
        "failToRoom": "&7{actor.name} tries to teleport {actor.ref}, but fails.&0",
    },
    "WORLD_TELEPORT": {
        "successToCaster": "&9&bYou feel your body being pulled in all directions, then find yourself elsewhere.&0",
        "successToRoom": "&9&b{actor.name} &9&bslowly fades out of existence and is gone.&0",
        "failToCaster": "&7The spell swirls about and dies away.&0",
        "failToRoom": "&7{actor.name} tries to teleport {actor.ref}, but fails.&0",
    },
    # spell_recall: act("$n utters a single word...") then perform_teleport(victim, victim, ..., nullptr, leave, arrive);
    # there is no message to the traveller themselves (they simply see the new room).
    "RECALL": {
        "successToCaster": None,
        "successToRoom": "{actor.name} utters a single word... &7&b{actor.name}&7&b disappears in a bright flash of light!&0",
    },
    "WORD_OF_RECALL": {
        "successToCaster": None,
        "successToRoom": "{actor.name} utters a single word... &7&b{actor.name}&7&b disappears in a bright flash of light!&0",
    },
    # GROUP_RECALL runs spell_recall once per group member (victim = member).
    "GROUP_RECALL": {
        "successToCaster": None,
        "successToRoom": "{actor.name} utters a single word... &7&b{target.name}&7&b disappears in a bright flash of light!&0",
    },
    # spell_summon: perform_teleport(ch, victim, ch->in_room, "$n has summoned you!", leave, "$n arrives suddenly.")
    "SUMMON": {
        "successToCaster": "{target.name} arrives suddenly.",
        "successToVictim": "{actor.name} has summoned you!",
        "successToRoom": "{target.name} arrives suddenly.",
    },
    # spell_summon_corpse (arrival at the caster's room) / spell_shift_corpse
    "SUMMON_CORPSE": {
        "successToCaster": "From within a cloud of &9&bdarkness&0, a corpse materializes.",
        "successToRoom": "From within a cloud of &9&bdarkness&0, a corpse materializes.",
    },
    "SHIFT_CORPSE": {
        "successToCaster": "The hand of &9&bdeath&0 delivers the corpse to your feet.",
        "successToRoom": "The hand of &9&bdeath&0 delivers the corpse to {actor.name}'s feet.",
    },
    # spell_moonwell / spell_heavens_gate / spell_hells_gate: caster, room, and the far-end target
    "MOONWELL": {
        "successToCaster": "&5In a gust of wind a&0 &7moonwell&0 &5appears at your feet.&0",
        "successToVictim": "&5In a gust of wind a&0 &7moonwell&0 &5appears at your feet.&0",
        "successToRoom": "&5In a gust of wind a&0 &7moonwell&0 &5appears.&0",
        "failToCaster": "A &5moonwell&0 &7appears briefly, then dissolves.&0",
        "failToRoom": "A &5moonwell&0 &7appears briefly, then dissolves.&0",
    },
    "HEAVENS_GATE": {
        "successToCaster": "&7&bYou call upon your deity...&0 &6A soft &btunnel of &7light &6opens up near you, beckoning you to enter.&0",
        "successToVictim": "&6A soft &btunnel of &7light &6opens up near you, beckoning you to enter.&0",
        "successToRoom": "&7&b{actor.name}&7&b calls upon {actor.pos} deity...&0 &6A soft &btunnel of &7light&6 opens up near you, beckoning you to enter.&0",
        "failToCaster": "&7A &6&btunnel of &7light&0 &7appears briefly, then vanishes.&0",
        "failToRoom": "&7A &6&btunnel of &7light&0 &7appears briefly, then vanishes.&0",
    },
    "HELLS_GATE": {
        "successToCaster": "&1A &9&bdark hole in the &0&3earth&1 opens up to &bhell.&0",
        "successToVictim": "&1A &9&bdark hole in the &0&3earth&1 opens up to &bhell.&0",
        "successToRoom": "&1A &9&bdark hole in the &0&3earth&1 opens up to &bhell.&0",
        "failToCaster": "&9&bThe ground begins to quake and open up, briefly revealing &1hell&9, then closes.&0",
        "failToRoom": "&9&bThe ground begins to quake and open up, briefly revealing &1hell&9, then closes.&0",
    },
}  # fmt: skip

_FIELD_COLUMNS = {
    "successToCaster": "success_to_caster",
    "successToVictim": "success_to_victim",
    "successToRoom": "success_to_room",
    "failToCaster": "fail_to_caster",
    "failToRoom": "fail_to_room",
}


def sync_messages(abilities):
    by_name = {a["plainName"]: a for a in abilities}
    changes = []  # (plain_name, old_msgs, new_fields)
    for name, fields in TELEPORT_MESSAGES.items():
        msgs = by_name[name]["messages"]
        old = dict(msgs)
        assert old.get("successToCaster") == PLACEHOLDER_CASTER, (name, old)
        for key, value in fields.items():
            if value is None:
                msgs.pop(key, None)
            else:
                msgs[key] = value
        # canonical key order
        ordered = {k: msgs[k] for k in _FIELD_COLUMNS if k in msgs}
        ordered.update({k: v for k, v in msgs.items() if k not in ordered})
        by_name[name]["messages"] = ordered
        changes.append((name, old, fields))
    return changes


def render_message_sql(changes):
    out = [
        '-- fierymud-rs #127: "Spell completion text incorrect" - 14 teleport / gate / summon spells shared the',
        '-- placeholder "You vanish in a flash of light!". Each spell now carries its own legacy completion text',
        "-- (spells.cpp spell_dimension_door / relocate / plane_shift / teleport / recall / summon / moonwell /",
        "-- heavens_gate / hells_gate / summon_corpse / shift_corpse, converted to template syntax and to the",
        "-- modern colour markup). Recall, Word of Recall and Group Recall had no caster line in legacy (the",
        "-- traveller just sees the new room), so success_to_caster is cleared for them.",
        "-- Keyed by Ability.plain_name; a row is only rewritten while BOTH of its success lines are still the old",
        "-- placeholder text, so a second run changes 0 rows and builder-edited messages are never overwritten.",
        "",
    ]
    for name, old, fields in changes:
        sets = []
        for key, col in _FIELD_COLUMNS.items():
            if key in fields:
                value = fields[key]
                sets.append(f"{col} = {q(convert_legacy_colors(value) if value else None)}")
        out.append(f"-- {name}")
        out.append(
            'UPDATE "AbilityMessages" am\nSET ' + ",\n    ".join(sets) + "\n"
            'FROM "Ability" a\n'
            "WHERE am.ability_id = a.id\n"
            f"  AND a.plain_name = {q(name)}\n"
            f"  AND am.success_to_caster = {q(old['successToCaster'])}\n"
            f"  AND am.success_to_room = {q(old['successToRoom'])};\n"
        )
    return "\n".join(out)


# --------------------------------------------------------------------------------------------------
# #111 / #125 - combat_ok and quest_only from legacy skills.cpp
# --------------------------------------------------------------------------------------------------

KIND_TO_TYPE = {"spello": "SPELL", "chanto": "CHANT", "songo": "SONG"}


def sync_flags(abilities, legacy: Path):
    flags = parse_skill_flags((legacy / "src/skills.cpp").read_text(encoding="latin-1"))
    by_name = {a["plainName"]: a for a in abilities}
    combat_false, combat_total, quest_names = [], 0, []
    for const, f in flags.items():
        name = plain_name_for(const)
        ab = by_name.get(name)
        if ab is None or ab["abilityType"] != KIND_TO_TYPE[f["kind"]]:
            continue
        combat_total += 1
        _set_after(ab, "combatOk", f["fighting_ok"], after="inCombatOnly")
        if not f["fighting_ok"]:
            combat_false.append(name)
        if f["quest"]:
            _set_after(ab, "questOnly", True, after="combatOk")
            quest_names.append(name)
    return sorted(combat_false), combat_total, sorted(quest_names)


def _set_after(ab, key, value, after):
    if key in ab:
        ab[key] = value
        return
    items = list(ab.items())
    out = {}
    placed = False
    for k, v in items:
        out[k] = v
        if k == after:
            out[key] = value
            placed = True
    if not placed:
        out[key] = value
    ab.clear()
    ab.update(out)


def name_list(names):
    return ",\n".join("  " + ", ".join(q(n) for n in names[i:i + 4]) for i in range(0, len(names), 4))


def render_combat_sql(false_names):
    return f"""-- fierymud-rs #111: "Major Globe can be cast in combat" - Coldshield, Ice Armor, Invisibility (and ~130 more)
-- could still be cast mid-fight. Legacy skills.cpp passes ok_fighting as the seventh spello() argument (enforced in
-- spell_parser.cpp: `!SINFO.fighting_ok && GET_STANCE(ch) == STANCE_FIGHTING` -> "Impossible! You can't
-- concentrate enough!"), and the import never wrote it: Ability.combat_ok kept its column default (true) for
-- everything except the globe pair patched in 2026-10-10-spell-fixes.sql.
-- This clears combat_ok for every spell / chant / song that legacy marks ok_fighting = false (data/abilities.json
-- now carries `combatOk` for all of them; src/fierylib/parsers/legacy_spell_data.py reads skills.cpp).
-- Only the safe direction is patched: a row legacy marks castable in combat that someone cleared later keeps
-- the builder's choice. Keyed by Ability.plain_name; matches only rows still castable, so a second run changes 0 rows.
UPDATE "Ability"
SET combat_ok = false
WHERE combat_ok
  AND "abilityType" IN ('SPELL', 'CHANT', 'SONG')
  AND plain_name IN (
{name_list(false_names)}
  );
"""


def render_quest_sql(quest_names):
    return f"""-- fierymud-rs #125 (class spell lists): the `*` quest-spell marker in `help spell_<class>` comes from
-- Ability.quest_only, which the import never wrote (every row was false). Legacy skills.cpp marks quest spells with the
-- `quest` argument of spello()/chanto()/songo() ({len(quest_names)} abilities); data/abilities.json now carries `questOnly`
-- for them. quest_only is informational (nothing in the runtime reads it), so this does not change who can learn what.
-- Keyed by Ability.plain_name; matches only rows still false, so a second run changes 0 rows.
UPDATE "Ability"
SET quest_only = true
WHERE NOT quest_only
  AND plain_name IN (
{name_list(quest_names)}
  );
"""


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--legacy", default="/home/strider/Code/mud/fierymud_legacy", type=Path)
    args = ap.parse_args()

    raw = ABILITIES.read_text(encoding="utf-8")
    abilities = json.loads(raw)

    dice = sync_dice(abilities, args.legacy)
    msgs = sync_messages(abilities)
    combat_false, combat_total, quest = sync_flags(abilities, args.legacy)

    ABILITIES.write_text(json.dumps(abilities, indent=2, ensure_ascii=True), encoding="utf-8")
    (SQL_DIR / f"{DATE}-spell-damage-dice.sql").write_text(render_dice_sql(dice), encoding="utf-8")
    (SQL_DIR / f"{DATE}-teleport-messages.sql").write_text(render_message_sql(msgs), encoding="utf-8")
    (SQL_DIR / f"{DATE}-combat-ok-from-legacy.sql").write_text(render_combat_sql(combat_false), encoding="utf-8")
    (SQL_DIR / f"{DATE}-quest-spell-flags.sql").write_text(render_quest_sql(quest), encoding="utf-8")
    print(f"dice formulas: {len(dice)}; message sets: {len(msgs)}; "
          f"combatOk set on {combat_total} (false: {len(combat_false)}); questOnly: {len(quest)}")


if __name__ == "__main__":
    main()
