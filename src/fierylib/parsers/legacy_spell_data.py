"""Readers for the legacy spell tables that drive abilities.json.

Three legacy sources feed the spell data fierylib ships:

* ``lib/misc/spell_dams`` - the online spell damage table (``spell_dam_info``). ``mag_damage()``
  (magic.cpp) rolls the dice from it *before* the per-spell switch, and every ``dam += ...`` case
  adds its formula on top of the roll. This is what ``dice_expression`` turns into a formula term.
* ``src/skills.cpp`` - one ``spello()`` / ``chanto()`` / ``songo()`` call per spell. The seventh
  ``spello`` argument is ``ok_fighting`` (castable while fighting) and the second-to-last is
  ``quest`` (quest spell, marked ``*`` in the class spell lists).
* ``src/defines.hpp`` - ``#define SPELL_X <number>``; the damage table is indexed by number.

Everything here is a pure function over file text so tests can run it without a database.
"""

from __future__ import annotations

import re
from typing import Dict, List, Optional

# One row of lib/misc/spell_dams, in the order boot_spell_dams() sscanf's them
# (the file's own header comment lists pc_no_face before pc_no_dice; the sscanf wins).
_SD_FIELDS = (
    "spell intern npc_static npc_dice npc_faces pc_static pc_dice pc_faces "
    "npc_reduce use_bonus bonus lvl_mult"
).split()

_PVP = "actor_is_player * target_is_player"


def parse_spell_numbers(defines_text: str) -> Dict[str, int]:
    """``#define SPELL_FULL_HARM 54`` -> ``{"FULL_HARM": 54}`` (also CHANT_ and SONG_ prefixes)."""
    out: Dict[str, int] = {}
    for m in re.finditer(r"^#define\s+((?:SPELL|CHANT|SONG)_\w+)\s+(\d+)\b", defines_text, re.M):
        out[m.group(1)] = int(m.group(2))
    return out


def parse_spell_dams(text: str) -> Dict[int, Dict[str, int]]:
    """Parse ``lib/misc/spell_dams`` into ``{spell_number: row}``.

    A record is a line of twelve integers, two more numeric lines, then a free-text note closed by
    ``~`` (notes can span lines, so the record is read until the ``~``).
    """
    lines = text.replace("\r", "").split("\n")[3:]  # three header lines
    rows: Dict[int, Dict[str, int]] = {}
    i = 0
    while i < len(lines):
        m = re.fullmatch(r"\s*(-?\d+(?: +-?\d+){11})\s*", lines[i])
        if not m:
            i += 1
            continue
        row = dict(zip(_SD_FIELDS, map(int, m.group(1).split())))
        j = i + 1
        while j < len(lines) and not lines[j].rstrip().endswith("~"):
            j += 1
        if row["npc_reduce"] == 0:
            row["npc_reduce"] = 100  # boot_spell_dams()
        rows[row["spell"]] = row
        i = j + 1
    return rows


def _term(npc: int, pc: int) -> str:
    """``npc`` normally, ``pc`` when both caster and target are players."""
    if npc == pc:
        return str(npc)
    if pc > npc:
        return f"{npc} + {pc - npc} * {_PVP}" if npc else f"{pc} * {_PVP}"
    return f"{npc} - {npc - pc} * {_PVP}"


def dice_expression(row: Dict[str, int]) -> Optional[str]:
    """The formula term for what ``mag_damage()`` rolls from a spell_dams row, or None.

    magic.cpp: a PC casting at a PC (or a charmed caster) rolls ``pc_dice``d``pc_faces`` +
    ``pc_static``; everyone else (PC vs mob, mob vs anything) rolls the ``npc_*`` side. The runtime
    formula language has no branch, so the two sides are folded together with the same
    ``actor_is_player * target_is_player`` product the Sunray formula already uses. Both dice
    arguments must stay positive (``roll_dice`` rejects zero), so a PvP side with no dice (e.g.
    Destroy Undead) falls back to the NPC dice.

    The bonus term is ``min(bonus, skill / 4)`` (PvP) or ``skill / 2`` (otherwise) when
    ``use_bonus`` is set, else ``min(bonus, skill * lvl_mult)``.
    """
    if not row.get("intern"):
        return None
    nd, nf, pd, pf = row["npc_dice"], row["npc_faces"], row["pc_dice"], row["pc_faces"]
    if nd <= 0 or nf <= 0:
        return None
    ns, ps = row["npc_static"], row["pc_static"]
    if pd <= 0 or pf <= 0:
        pd, pf, ps = nd, nf, ns  # the PvP side is unused (zeroed row): same roll for everyone
    if (nd, nf) == (pd, pf):
        dice = f"{nd}d{nf}"
    else:
        dice = f"roll_dice({_term(nd, pd)}, {_term(nf, pf)})"

    parts: List[str] = [dice]
    if ns == ps:
        if ns:
            parts.append(str(ns))
    else:
        parts.append(f"({_term(ns, ps)})")

    bonus = row["bonus"]
    if bonus:
        if row["use_bonus"]:
            parts.append(f"min({bonus}, skill / (2 + 2 * {_PVP}))")
        elif row["lvl_mult"]:
            parts.append(f"min({bonus}, skill * {row['lvl_mult']})")
    return " + ".join(parts)


def parse_skill_flags(skills_cpp_text: str) -> Dict[str, Dict[str, object]]:
    """Per-spell flags from the ``spello``/``chanto``/``songo`` calls of skills.cpp.

    Returns ``{"SPELL_MAJOR_GLOBE": {"kind": "spello", "name": "major globe",
    "fighting_ok": False, "quest": True}, ...}``.

    spello(spl, name, max_mana, min_mana, mana_change, minpos, ok_fighting, targets, violent,
           routines, addl_mem_time, cast_time, damage_type, sphere, pages, quest, wearoff)
    chanto/songo(id, name, minpos, ok_fighting, targets, violent, routines, damage, quest, wearoff)
    """
    out: Dict[str, Dict[str, object]] = {}
    pattern = re.compile(r'\b(spello|chanto|songo)\(\s*(\w+)\s*,\s*"([^"]*)"\s*,([^;]*?)\)\s*;', re.S)
    for m in pattern.finditer(skills_cpp_text):
        kind, const, name, rest = m.groups()
        # Split on top-level commas only (routines use `A | B`, wearoff strings can hold commas).
        args = [a.strip() for a in re.split(r",(?![^()]*\))", rest)]
        if kind == "spello":
            fighting, quest = args[4], args[13]
        else:
            fighting, quest = args[1], args[6]
        out[const] = {
            "kind": kind,
            "name": name,
            "fighting_ok": fighting == "true",
            "quest": quest == "true",
        }
    return out


def plain_name_for(const: str) -> str:
    """``SPELL_MAJOR_GLOBE`` -> ``MAJOR_GLOBE`` (Ability.plain_name)."""
    return re.sub(r"^(SPELL|CHANT|SONG)_", "", const)
