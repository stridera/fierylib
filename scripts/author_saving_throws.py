#!/usr/bin/env python3
"""Author AbilitySavingThrow rows for hostile spells/chants/songs.

Today only 2 / 408 abilities (BASH, TRIP_UP) carry an explicit
savingThrows block. The 88 violent damage spells and 36 violent
status spells land at full damage / full duration with no save check
— that's a player-counterplay gap.

This script walks `data/abilities.json` and authors a single save
per violent ability where one isn't already specified, picking the
SaveType and action from the spell's flavor:

  - Damage spells (any element):     REFLEX / WILL by damage type,
                                     onSaveAction = "NEGATE"
                                     (engine §K2 ask: HALF_DAMAGE arm)
  - Mental-flavor debuffs:           WILL, NEGATE
  - Physical-flavor debuffs (poison/
    disease/petrify/paralysis/sleep): FORTITUDE, NEGATE
  - Dodge-flavor debuffs (entangle/web): REFLEX, NEGATE
  - Long-duration status debuffs:    WILL/FORTITUDE, HALF_DURATION

DC formula is uniform `10 + skill / 5 + max(int_bonus, wis_bonus)`
— flat per-spell baseline with a +caster-stat term so a high-INT
sorcerer's spells are harder to save against.

Skill / weapon-attack abilities (the 2 already authored) are left
alone.

Idempotent — re-running won't duplicate existing entries.
"""

import json
from pathlib import Path

JSON_PATH = Path(__file__).resolve().parent.parent / "data" / "abilities.json"

DC_FORMULA = "10 + skill / 5 + max(int_bonus, wis_bonus)"

# Damage-type → save category
DAMAGE_TO_SAVE: dict[str, str] = {
    # Reflex (physical / elemental / dodge)
    "FIRE": "REFLEX",
    "COLD": "REFLEX",
    "SHOCK": "REFLEX",
    "ACID": "REFLEX",
    "EARTH": "REFLEX",
    "AIR": "REFLEX",
    "WATER": "REFLEX",
    "SONIC": "REFLEX",
    "FORCE": "REFLEX",
    # Will (divine / death / mental)
    "HOLY": "WILL",
    "UNHOLY": "WILL",
    "NECROTIC": "WILL",
    "HEAL": "WILL",
    "RADIANT": "WILL",
    "SHADOW": "WILL",
    "MENTAL": "WILL",
    "NATURE": "WILL",
    # Fortitude (physical degradation)
    "POISON": "FORTITUDE",
    "BLEED": "FORTITUDE",
    # Physical weapon types — usually skill-based, but if a spell
    # deals these, default to REFLEX (dodge).
    "PHYSICAL": "REFLEX",
    "SLASH": "REFLEX",
    "PIERCE": "REFLEX",
    "CRUSH": "REFLEX",
}

# plainName substrings that flag a non-damage status spell as
# FORTITUDE-class (biological resistance) vs the default WILL.
FORT_KEYWORDS = (
    "POISON",
    "DISEASE",
    "PARALYSIS",
    "MINOR_PARALYSIS",
    "PETRIF",
    "PETRIFY",
    "STONE",
    "SLEEP",
    "MASS_SLEEP",
    "HOLD_PERSON",
    "ROOT",
    "ENFEEB",
)

# plainName substrings that flag a non-damage status as REFLEX-class
# (dodgeable area-of-effect entanglement).
REFL_KEYWORDS = (
    "ENTANGLE",
    "WEB",
    "BIND",
    "CAGE",
    "TRAP",
    "PIT",
    "BOLA",
)

# plainName substrings that hint a status effect is long-lasting
# (curse / disease / madness) — better as HALF_DURATION on save so a
# save isn't a binary "you're fine" against a multi-day curse.
HALF_DURATION_KEYWORDS = (
    "CURSE",
    "DISEASE",
    "DOOM",
    "INSANITY",
    "MADNESS",
)


def derive_save(ability: dict) -> list[dict]:
    """Return the savingThrows list to author on this ability.

    Empty list = don't author a save (already has one, or non-violent).
    """
    if ability.get("savingThrows"):
        return ability["savingThrows"]
    if not ability.get("violent"):
        return []
    ab_type = ability.get("abilityType")
    if ab_type not in ("SPELL", "CHANT", "SONG"):
        # Skills (weapon attacks etc.) get authored per-skill — don't
        # blanket-add saves for them.
        return []

    effects = ability.get("effects", []) or []
    has_damage = any(e.get("effect") == "damage" for e in effects)
    plain = ability.get("plainName", "")

    save_type: str
    on_save: str

    if has_damage:
        # Pick by damage type, with fallback to WILL for unmarked.
        damage_type = (ability.get("damageType") or "").upper()
        save_type = DAMAGE_TO_SAVE.get(damage_type, "WILL")
        # Legacy CircleMUD divided damage by 2 on save; the runtime
        # only understands NEGATE / HALF_DURATION today. Use NEGATE
        # so the save matters; engine §K2 will rebalance to
        # HALF_DAMAGE once the arm exists.
        on_save = "NEGATE"
    else:
        # Non-damage debuff: pick by name keyword first, then default
        # WILL (mental).
        if any(kw in plain for kw in FORT_KEYWORDS):
            save_type = "FORTITUDE"
        elif any(kw in plain for kw in REFL_KEYWORDS):
            save_type = "REFLEX"
        else:
            save_type = "WILL"
        on_save = (
            "HALF_DURATION"
            if any(kw in plain for kw in HALF_DURATION_KEYWORDS)
            else "NEGATE"
        )

    return [
        {
            "saveType": save_type,
            "dcFormula": DC_FORMULA,
            "onSaveAction": on_save,
        }
    ]


def main() -> None:
    data = json.loads(JSON_PATH.read_text())

    authored = 0
    skipped_already = 0
    skipped_non_violent = 0
    skipped_skill = 0

    by_type: dict[str, int] = {}
    by_action: dict[str, int] = {}

    for ability in data:
        if ability.get("savingThrows"):
            skipped_already += 1
            continue
        if not ability.get("violent"):
            skipped_non_violent += 1
            continue
        if ability.get("abilityType") not in ("SPELL", "CHANT", "SONG"):
            skipped_skill += 1
            continue
        saves = derive_save(ability)
        if not saves:
            continue
        ability["savingThrows"] = saves
        authored += 1
        by_type[saves[0]["saveType"]] = by_type.get(saves[0]["saveType"], 0) + 1
        by_action[saves[0]["onSaveAction"]] = by_action.get(saves[0]["onSaveAction"], 0) + 1

    JSON_PATH.write_text(json.dumps(data, indent=2) + "\n")

    print(f"Authored saves on {authored} abilities.")
    print(f"  by save type: {by_type}")
    print(f"  by on-save action: {by_action}")
    print(f"  skipped (already have a save): {skipped_already}")
    print(f"  skipped (non-violent / buff): {skipped_non_violent}")
    print(f"  skipped (SKILL-type — authored per-skill): {skipped_skill}")


if __name__ == "__main__":
    main()
