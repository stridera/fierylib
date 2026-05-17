#!/usr/bin/env python3
"""One-shot merge of stub + modern duplicate abilities in abilities.json.

The skill_seeder (legacy CPP path) creates Ability rows with the legacy
plain_name (e.g. INN_ASCEN, RAY_OF_ENFEEB) but no AbilityEffect rows.
abilities.json was later authored with renamed entries
(INNATE_ASCEN, RAY_OF_ENFEEBLEMENT) that DO carry effects, producing a
parallel set of rows with no class/character refs.

Class + character imports point at the legacy plain_name, so they
silently load a zero-effect spell — the cast emits a success line and
does nothing.

This script:
  1. For each (stub, modern) pair, copies the modern entry's effects,
     messages, notes, and sphere into the stub entry, keeping the
     legacy plain_name as canonical.
  2. Deletes the modern duplicate from JSON.
  3. Adds first-class effect blocks to the four MONK_* spells (modern
     damage spells with no legacy precedent), PEACE (chant_peace =
     stop_combat manual), and GAIAS_CLOAK (legacy: APPLY_AC +15-21
     for 5-12 hours).

After this runs, `poetry run fierylib seed magic-system` is required
to push the rewritten effects into the DB. The now-orphan modern
rows in the DB (INNATE_ASCEN etc.) have 0 class/char refs; cleanup
them via SQL.
"""

import json
from pathlib import Path

JSON_PATH = Path(__file__).resolve().parent.parent / "data" / "abilities.json"

# (legacy_stub, modern_with_effects) pairs to collapse.
DUPLICATE_PAIRS = [
    ("INN_ASCEN", "INNATE_ASCEN"),
    ("INN_BRILL", "INNATE_BRILL"),
    ("INN_STRENGTH", "INNATE_CHAZ"),  # legacy "innate chaz" = strength
    ("INN_SYLL", "INNATE_SYLL"),
    ("INN_TASS", "INNATE_TASS"),
    ("INN_TREN", "INNATE_TREN"),
    ("RAY_OF_ENFEEB", "RAY_OF_ENFEEBLEMENT"),
]

# Fields to overwrite on the stub from the modern entry.
COPY_FIELDS = ("effects", "messages", "notes", "sphere", "pages", "description", "name",
               "violent", "castTimeRounds", "cooldownMs", "inCombatOnly",
               "isArea", "minPosition", "damageType")


def author_monk_strike(plain: str, element: str, damage_type: str, sphere: str) -> dict:
    """Modern monk elemental ki-strike — no legacy precedent.

    Mid-tier damage spell shaped like circle 4-6 mage spells. Monk
    chants/spells use SP_INVOCATION mechanics (no slot system, cooldown-
    or ki-bound) so we don't tier them in the spell-slot ladder.
    """
    flavor = {
        "FIRE": ("blazing", "incinerate", "Searing flame coats your strike."),
        "COLD": ("frozen", "shatter", "Cold ki coats your strike, frosting the air."),
        "ACID": ("acidic", "corrode", "Caustic ki coats your strike, sizzling the air."),
        "SHOCK": ("crackling", "electrify", "Crackling ki coats your strike."),
    }[element]
    return {
        "name": f"Monk {element.title()} Strike",
        "plainName": plain,
        "abilityType": "SPELL",
        "description": f"A monk's {flavor[0]} ki-strike. Channels elemental {damage_type.lower()} damage through a touch attack.",
        "minPosition": "STANDING",
        "violent": True,
        "castTimeRounds": 1,
        "cooldownMs": 0,
        "inCombatOnly": False,
        "isArea": False,
        "notes": f"Modern monk {damage_type.lower()} ki-strike. No legacy precedent; tier-balanced as a low-mid damage spell ~circle 3-4.",
        "effects": [
            {
                "effect": "damage",
                "order": 0,
                "params": {
                    "type": damage_type.lower(),
                    "amount": "4d19 + pow(skill, 1.25)",
                },
                "trigger": "on_cast",
            }
        ],
        "messages": {
            "successToCaster": f"You strike {{target.name}} with a {flavor[0]} ki-fist!",
            "successToVictim": f"{{actor.name}}'s ki-fist crackles with {damage_type.lower()} energy as it lands!",
            "successToRoom": f"{{actor.name}}'s ki-fist hits {{target.name}} in a flash of {damage_type.lower()}!",
            "failToCaster": flavor[2] + " The blow misses.",
            "failToVictim": f"{{actor.name}}'s {flavor[0]} strike misses you.",
            "failToRoom": f"{{actor.name}}'s {flavor[0]} strike misses {{target.name}}.",
        },
        "sphere": sphere,
        "damageType": damage_type,
    }


def author_peace() -> dict:
    return {
        "name": "Peace",
        "plainName": "PEACE",
        "abilityType": "CHANT",
        "description": "A serene chant that washes peace into the room, immediately stopping all combat.",
        "minPosition": "STANDING",
        "violent": False,
        "castTimeRounds": 2,
        "cooldownMs": 0,
        "inCombatOnly": False,
        "isArea": True,
        "notes": "Legacy CHANT_PEACE — MAG_MANUAL, room-wide. Stops all in-progress fighting on success.",
        "effects": [
            {
                "effect": "stop_combat",
                "order": 0,
                "params": {"scope": "room"},
                "trigger": "on_cast",
            }
        ],
        "messages": {
            "successToCaster": "Your chant of peace settles over the room. Combat dies down.",
            "successToRoom": "{actor.name}'s chant of peace settles over the room, and combat dies down.",
            "failToCaster": "Your chant falters and the violence continues.",
            "failToRoom": "{actor.name}'s chant of peace falters.",
        },
    }


def author_gaias_cloak() -> dict:
    return {
        "name": "Gaia's Cloak",
        "plainName": "GAIAS_CLOAK",
        "abilityType": "SPELL",
        "description": "Wraps the target in a protective shroud of living earth, hardening their hide.",
        "minPosition": "STANDING",
        "violent": False,
        "castTimeRounds": 2,
        "cooldownMs": 0,
        "inCombatOnly": False,
        "isArea": False,
        "notes": "Legacy: APPLY_AC bonus +15 + (skill/16), duration 5 + (skill/14) hours. Mutually exclusive with other armor spells (Bone Armor / Ice Armor / Stone Skin / Coldshield) — that gate is runtime-enforced, not authored here.",
        "effects": [
            {
                "effect": "modify",
                "order": 0,
                "params": {
                    "target": "armor",
                    "amount": "15 + (skill / 16)",
                    "duration": "5 + (skill / 14)",
                    "durationUnit": "hours",
                },
                "trigger": "on_cast",
            }
        ],
        "messages": {
            "successToCaster": "A protective cloak of living earth wraps around {target.name}.",
            "successToVictim": "You feel the earth itself shield your body.",
            "successToSelf": "You wrap yourself in a cloak of living earth.",
            "successToRoom": "{target.name} is wrapped in a protective cloak of living earth.",
            "successSelfRoom": "{actor.name} is wrapped in a protective cloak of living earth.",
            "wearoffToTarget": "The protective cloak of earth fades from your body.",
            "failToCaster": "Your spell fails to take hold on {target.name}.",
        },
        "sphere": "EARTH",
        "pages": 15,
    }


def main() -> None:
    data = json.loads(JSON_PATH.read_text())
    by_plain = {a.get("plainName"): a for a in data}

    # 1. Merge duplicates — copy modern's effect/messages into stub, drop modern.
    merged = 0
    dropped_modern: list[str] = []
    for stub_name, modern_name in DUPLICATE_PAIRS:
        stub = by_plain.get(stub_name)
        modern = by_plain.get(modern_name)
        if stub is None or modern is None:
            print(f"  skip pair ({stub_name}, {modern_name}): one side missing")
            continue
        for field in COPY_FIELDS:
            if field in modern:
                stub[field] = modern[field]
        # Keep the legacy plainName — it's referenced by class + character rows.
        stub["plainName"] = stub_name
        merged += 1
        dropped_modern.append(modern_name)

    # 2. Author MONK_* / PEACE / GAIAS_CLOAK from scratch.
    authored: list[dict] = []
    monk_specs = [
        ("MONK_ACID", "ACID", "ACID", "EARTH"),
        ("MONK_COLD", "COLD", "COLD", "WATER"),
        ("MONK_FIRE", "FIRE", "FIRE", "FIRE"),
        ("MONK_SHOCK", "SHOCK", "SHOCK", "AIR"),
    ]
    for plain, element, damage_type, sphere in monk_specs:
        if by_plain.get(plain) is None:
            continue
        authored.append((plain, author_monk_strike(plain, element, damage_type, sphere)))
    if by_plain.get("PEACE") is not None:
        authored.append(("PEACE", author_peace()))
    if by_plain.get("GAIAS_CLOAK") is not None:
        authored.append(("GAIAS_CLOAK", author_gaias_cloak()))

    for plain, new_body in authored:
        # Replace the stub's content with the authored body, keeping
        # the position in the list so diffs are minimal.
        for i, a in enumerate(data):
            if a.get("plainName") == plain:
                data[i] = new_body
                break

    # 3. Drop the modern duplicates (now redundant).
    data = [a for a in data if a.get("plainName") not in dropped_modern]

    JSON_PATH.write_text(json.dumps(data, indent=2) + "\n")
    print(f"Merged {merged} duplicate pairs, authored {len(authored)} new spell bodies, dropped {len(dropped_modern)} modern duplicates.")
    print(f"Dropped: {dropped_modern}")
    print(f"Authored: {[p for p, _ in authored]}")


if __name__ == "__main__":
    main()
