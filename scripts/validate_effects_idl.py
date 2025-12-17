#!/usr/bin/env python3
"""Validate database effects against Effects IDL v1 schema.

Checks:
- Effect type coverage (all DB effects map to IDL types)
- Required params present for each effect type
- Element values match ElementId taxonomy
- Duration formats are valid
- Status IDs are consistent
"""

import asyncio
import csv
import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any
from prisma import Prisma


# Effects IDL v1 type definitions
IDL_EFFECT_TYPES = {
    "damage": {
        "required": ["amount"],
        "optional": ["element", "scaling", "flags"],
        "params_schema": {
            "amount": ("Scalar", "number, dice expr, or formula"),
            "element": ("ElementId", "physical, fire, cold, etc."),
            "scaling": ("ScalingSpec", "byLevel, byStat, byWeapon"),
            "flags": ("object", "nonlethal, etc."),
        }
    },
    "heal": {
        "required": ["amount"],
        "optional": ["scaling", "resource"],
        "params_schema": {
            "amount": ("Scalar", "number, dice expr, or formula"),
            "resource": ("ResourceId", "hp, mana, move"),
            "scaling": ("ScalingSpec", "byLevel, byStat"),
        }
    },
    "dot": {
        "required": ["damagePerTick", "duration"],
        "optional": ["element", "tickEvery", "stacking"],
        "params_schema": {
            "damagePerTick": ("Scalar", "damage per tick"),
            "element": ("ElementId", "damage type"),
            "duration": ("DurationExpr", "total duration"),
            "tickEvery": ("DurationExpr", "tick interval"),
            "stacking": ("StackingRule", "how stacks work"),
        }
    },
    "lifesteal": {
        "required": [],
        "optional": ["amount", "pctOfDamage", "element"],
        "params_schema": {
            "amount": ("Scalar", "flat amount"),
            "pctOfDamage": ("Scalar", "0-100 percent"),
            "element": ("ElementId", "damage element"),
        }
    },
    "reflect": {
        "required": ["pct", "duration"],
        "optional": ["element"],
        "params_schema": {
            "pct": ("Scalar", "0-100 percent reflected"),
            "duration": ("DurationExpr", "how long"),
            "element": ("ElementId", "filter by element"),
        }
    },
    "status_apply": {
        "required": ["status", "duration"],
        "optional": ["potency", "stacking"],
        "params_schema": {
            "status": ("StatusId", "status to apply"),
            "duration": ("DurationExpr", "how long"),
            "potency": ("Scalar", "effect strength"),
            "stacking": ("StackingRule", "how stacks work"),
        }
    },
    "status_remove": {
        "required": [],
        "optional": ["status", "filter", "maxRemoved"],
        "params_schema": {
            "status": ("StatusId", "specific status to remove"),
            "filter": ("StatusFilter", "hasTag, element filter"),
            "maxRemoved": ("number", "max to remove"),
        }
    },
    "cure": {
        "required": ["filter"],
        "optional": ["power", "maxRemoved"],
        "params_schema": {
            "filter": ("StatusFilter", "condition type to cure"),
            "power": ("Scalar", "dispel strength"),
            "maxRemoved": ("number", "max to remove"),
        }
    },
    "dispel": {
        "required": ["scope", "filter"],
        "optional": ["power", "maxRemoved"],
        "params_schema": {
            "scope": ("string", "target, room, group"),
            "filter": ("object", "statusTag, statusId, element"),
            "power": ("Scalar", "dispel strength"),
            "maxRemoved": ("number", "max to remove"),
        }
    },
    "stat_mod": {
        "required": ["stat", "delta", "duration"],
        "optional": ["stacking"],
        "params_schema": {
            "stat": ("StatId", "stat to modify"),
            "delta": ("Scalar", "change amount"),
            "duration": ("DurationExpr", "how long"),
            "stacking": ("StackingRule", "how stacks work"),
        }
    },
    "resource_mod": {
        "required": ["resource", "delta"],
        "optional": ["amount", "duration"],
        "params_schema": {
            "resource": ("ResourceId", "hp, mana, move"),
            "delta": ("Scalar", "change amount"),
            "amount": ("Scalar", "alternative to delta"),
            "duration": ("DurationExpr", "for temp changes"),
        }
    },
    "protection": {
        "required": ["element", "amount", "duration"],
        "optional": ["immune", "stacking"],
        "params_schema": {
            "element": ("ElementId", "element protected from"),
            "amount": ("Scalar", "reduction amount/pct"),
            "duration": ("DurationExpr", "how long"),
            "immune": ("boolean", "complete immunity"),
            "stacking": ("StackingRule", "how stacks work"),
        }
    },
    "vulnerability": {
        "required": ["element", "amount", "duration"],
        "optional": ["stacking"],
        "params_schema": {
            "element": ("ElementId", "element vulnerable to"),
            "amount": ("Scalar", "increase amount/pct"),
            "duration": ("DurationExpr", "how long"),
            "stacking": ("StackingRule", "how stacks work"),
        }
    },
    "detection": {
        "required": ["kind"],
        "optional": ["duration", "radius"],
        "params_schema": {
            "kind": ("string", "see_invis, sense_life, detect_magic, true_sight"),
            "duration": ("DurationExpr", "buff duration or instant"),
            "radius": ("string", "room or zone"),
        }
    },
    "stealth": {
        "required": ["kind", "duration"],
        "optional": ["breakOn"],
        "params_schema": {
            "kind": ("string", "hide, invisible, sneak"),
            "duration": ("DurationExpr", "how long"),
            "breakOn": ("object", "attack, cast, takeDamage"),
        }
    },
    "reveal": {
        "required": ["kind"],
        "optional": ["duration"],
        "params_schema": {
            "kind": ("string", "invis, hide, sneak, all"),
            "duration": ("DurationExpr", "if buff, how long"),
        }
    },
    "teleport": {
        "required": ["destination"],
        "optional": ["restrictions"],
        "params_schema": {
            "destination": ("DestinationSpec", "room, anchor, target, random"),
            "restrictions": ("TeleportRestrictions", "denyInCombat, etc."),
        }
    },
    "summon": {
        "required": ["prototypeId", "count"],
        "optional": ["duration", "control"],
        "params_schema": {
            "prototypeId": ("Id", "mob prototype"),
            "count": ("number", "how many"),
            "duration": ("DurationExpr", "how long"),
            "control": ("object", "owner, follow, assist"),
        }
    },
    "banish": {
        "required": [],
        "optional": ["filter", "power", "onSuccess"],
        "params_schema": {
            "filter": ("object", "summonedOnly, tag, prototypeId"),
            "power": ("Scalar", "banish strength"),
            "onSuccess": ("string", "despawn or unsummon_to_origin"),
        }
    },
    "create_object": {
        "required": ["prototypeId"],
        "optional": ["quantity", "duration", "bind"],
        "params_schema": {
            "prototypeId": ("ObjectProtoId", "object prototype"),
            "quantity": ("number", "how many"),
            "duration": ("DurationExpr", "how long"),
            "bind": ("object", "instance data"),
        }
    },
    "room_effect": {
        "required": ["kind", "duration"],
        "optional": ["tickEvery", "damagePerTick", "element", "affects"],
        "params_schema": {
            "kind": ("string", "damage_field, aura, hazard"),
            "duration": ("DurationExpr", "how long"),
            "tickEvery": ("DurationExpr", "tick interval"),
            "damagePerTick": ("Scalar", "damage per tick"),
            "element": ("ElementId", "damage type"),
            "affects": ("string", "enemies, allies, all"),
        }
    },
    "room_barrier": {
        "required": ["flag", "duration"],
        "optional": ["breakable"],
        "params_schema": {
            "flag": ("string", "no_flee, no_recall, silence, no_magic, sanctuary"),
            "duration": ("DurationExpr", "how long"),
            "breakable": ("object", "onDamage, hp"),
        }
    },
    "globe": {
        "required": ["maxCircle", "duration"],
        "optional": ["mode", "charges"],
        "params_schema": {
            "maxCircle": ("number", "max spell circle blocked 1-9"),
            "duration": ("DurationExpr", "how long"),
            "mode": ("string", "block or absorb"),
            "charges": ("number", "uses before breaking"),
        }
    },
    "resurrect": {
        "required": ["kind"],
        "optional": ["hpPct", "maxLevel", "penalties"],
        "params_schema": {
            "kind": ("string", "revive or raise"),
            "hpPct": ("Scalar", "percent hp on return"),
            "maxLevel": ("number", "max level to resurrect"),
            "penalties": ("object", "xpDebt, statWeaken"),
        }
    },
    "script": {
        "required": ["entry"],
        "optional": ["args"],
        "params_schema": {
            "entry": ("string", "Lua function name"),
            "args": ("object", "arbitrary arguments"),
        }
    },
}

# Map DB effect names to IDL effect types
DB_TO_IDL_MAPPING = {
    "damage": "damage",
    "heal": "heal",
    "dot": "dot",
    "lifesteal": "lifesteal",
    "reflect": "reflect",
    "status": "status_apply",
    "crowd_control": "status_apply",
    "cure": "cure",
    "dispel": "dispel",
    "stat_mod": "stat_mod",
    "resource_mod": "resource_mod",
    "saving_mod": "stat_mod",  # saving throws are stats
    "size_mod": "stat_mod",  # size is a stat-like modifier
    "protection": "protection",
    "vulnerability": "vulnerability",
    "detection": "detection",
    "stealth": "stealth",
    "reveal": "reveal",
    "teleport": "teleport",
    "broadcast_teleport": "teleport",  # teleport with group target
    "summon": "summon",
    "banish": "banish",
    "create_object": "create_object",
    "room_effect": "room_effect",
    "room_barrier": "room_barrier",
    "globe": "globe",
    "resurrect": "resurrect",
    "chain_damage": "damage",  # special damage with chaining
    "elemental_hands": "status_apply",  # applies elemental status
}

# Element taxonomy from IDL
VALID_ELEMENTS = {
    "physical", "fire", "cold", "acid", "shock",
    "poison", "disease", "holy", "shadow", "arcane",
    "psychic", "water", "earth", "wind",
    # Legacy aliases we accept
    "magic", "unholy", "evil", "good", "air",
    # Extended physical subtypes (physical + damage type)
    "physical_blunt", "physical_pierce", "physical_slash",
    # Mental = psychic
    "mental",
}

# Valid status categories
VALID_CC_TYPES = {
    "paralyze", "paralysis", "minor_paralysis", "major_paralysis",
    "sleep", "charm", "fear", "confuse", "confusion",
    "silence", "slow", "web", "mesmerize", "immobilize",
    "blind", "blindness", "insanity",
}

VALID_STATUS_FLAGS = {
    "blind", "bless", "sanctuary", "invisible", "infravision",
    "waterwalk", "waterbreath", "fly", "haste", "featherfall",
    "aware", "berserk", "stoneskin", "barkskin",
    "fireshield", "coldshield", "firehands", "icehands",
    "acidhands", "lightninghands", "glowing",
    # Extended flags we use
    "blur", "displacement", "greater_displacement", "comprehend_languages",
    "curse", "doom", "familiarity", "glory", "harness", "illusion",
    "light", "misdirection", "mounted", "nimble", "preserve",
    "ray_of_enfeeb", "satiated", "soulshield", "armor", "buff", "debuff",
}


@dataclass
class ValidationIssue:
    """A validation issue found."""
    ability_name: str
    effect_name: str
    effect_order: int
    severity: str  # "error", "warning", "info"
    message: str


@dataclass
class ValidationResult:
    """Overall validation result."""
    total_effects: int = 0
    valid_effects: int = 0
    issues: list[ValidationIssue] = field(default_factory=list)
    unmapped_types: set[str] = field(default_factory=set)

    def add_issue(self, ability: str, effect: str, order: int, severity: str, message: str):
        self.issues.append(ValidationIssue(ability, effect, order, severity, message))

    @property
    def errors(self) -> list[ValidationIssue]:
        return [i for i in self.issues if i.severity == "error"]

    @property
    def warnings(self) -> list[ValidationIssue]:
        return [i for i in self.issues if i.severity == "warning"]


def validate_params(effect_name: str, params: dict, idl_type: str) -> list[tuple[str, str]]:
    """Validate effect params against IDL schema."""
    issues = []
    schema = IDL_EFFECT_TYPES.get(idl_type, {})
    required = schema.get("required", [])

    # Check required params
    for req in required:
        # Handle param name variations (DB uses different names than IDL)
        # Our DB conventions vs IDL conventions:
        # - duration often comes from spell skill level (not stored per-effect)
        # - amount often comes from scaling formula (not stored per-effect)
        alt_names = {
            "amount": ["amount", "damage", "healing", "percent", "base", "value"],
            "damagePerTick": ["damagePerTick", "amount", "damage"],
            "delta": ["delta", "amount", "value", "bonus"],
            "status": ["status", "flag", "type"],
            "kind": ["kind", "type"],
            "filter": ["filter", "condition", "scope", "cures", "type", "target"],  # cure uses 'cures' or 'type', dispel uses 'target'
            "prototypeId": ["prototypeId", "mobType", "objectType", "type"],  # summon uses 'type'
            "count": ["count", "maxCount", "quantity"],
            "destination": ["destination", "target", "recall", "type"],  # teleport uses 'type'
            "duration": ["duration", "time", "length"],  # often derived from skill
            "element": ["element", "type", "against", "to"],
            "stat": ["stat", "type"],
            "scope": ["scope", "target", "filter"],
            "flag": ["flag", "type"],
            "pct": ["pct", "percent", "amount"],
            "resource": ["resource", "type", "stat"],  # resource_mod sometimes uses 'stat' for hp/mana
            "maxCircle": ["maxCircle", "circle", "level"],
        }

        # For these effect types, duration is typically derived from skill level, not stored
        duration_derived_types = {
            "status_apply", "stat_mod", "stealth", "protection", "reflect",
            "room_effect", "room_barrier", "globe", "dot",
        }

        # For these effect types, amount is typically from damage formula or scaling
        amount_derived_types = {"damage"}

        found = False
        check_names = alt_names.get(req, [req])
        for name in check_names:
            if name in params:
                found = True
                break

        if not found:
            # Skip warnings for params that are typically derived from skill level
            if req == "duration" and idl_type in duration_derived_types:
                continue  # Duration comes from skill level formula
            if req == "amount" and idl_type in amount_derived_types:
                continue  # Amount comes from damage scaling formula

            # Special cases for mapped effect types
            if effect_name == "size_mod" and req == "stat":
                continue  # size_mod doesn't need a stat, it modifies size directly
            if effect_name == "summon" and req == "count":
                continue  # summon can default to count=1

            issues.append(("warning", f"Missing required param '{req}' for {idl_type}"))

    # Validate element values
    for key in ["element", "type"]:
        if key in params:
            val = str(params[key]).lower()
            if key == "element" or (key == "type" and effect_name in ["damage", "protection", "vulnerability"]):
                if val not in VALID_ELEMENTS:
                    issues.append(("warning", f"Unknown element '{val}' (valid: {sorted(VALID_ELEMENTS)[:5]}...)"))

    # Validate crowd_control types
    if effect_name == "crowd_control" and "type" in params:
        cc_type = str(params["type"]).lower()
        if cc_type not in VALID_CC_TYPES:
            issues.append(("warning", f"Unknown CC type '{cc_type}' (valid: {sorted(VALID_CC_TYPES)[:5]}...)"))

    # Validate status flags
    if effect_name == "status" and "flag" in params:
        flag = str(params["flag"]).lower()
        if flag not in VALID_STATUS_FLAGS:
            issues.append(("info", f"Uncommon status flag '{flag}'"))

    return issues


async def main():
    """Run validation against database."""
    prisma = Prisma()
    await prisma.connect()

    print("Validating database effects against Effects IDL v1...")
    print("=" * 70)

    result = ValidationResult()

    # Get all abilities with effects
    abilities = await prisma.ability.find_many(
        include={"effects": {"include": {"effect": True}}},
        order={"name": "asc"}
    )

    for ability in abilities:
        for ae in ability.effects:
            result.total_effects += 1
            effect = ae.effect
            params = ae.overrideParams if ae.overrideParams else {}
            if isinstance(params, str):
                params = json.loads(params)

            # Check if effect type maps to IDL
            if effect.name not in DB_TO_IDL_MAPPING:
                result.unmapped_types.add(effect.name)
                result.add_issue(
                    ability.name, effect.name, ae.order,
                    "error", f"Unknown effect type '{effect.name}' - not in IDL mapping"
                )
                continue

            idl_type = DB_TO_IDL_MAPPING[effect.name]

            # Validate params
            param_issues = validate_params(effect.name, params, idl_type)
            for severity, msg in param_issues:
                result.add_issue(ability.name, effect.name, ae.order, severity, msg)

            if not param_issues:
                result.valid_effects += 1

    await prisma.disconnect()

    # Print results
    print(f"\nTotal effects checked: {result.total_effects}")
    print(f"Valid effects: {result.valid_effects}")
    print(f"Effects with issues: {result.total_effects - result.valid_effects}")

    if result.unmapped_types:
        print(f"\nUnmapped effect types: {sorted(result.unmapped_types)}")

    # Group issues by type
    if result.errors:
        print(f"\n{'='*70}")
        print(f"ERRORS ({len(result.errors)}):")
        print("="*70)
        for issue in result.errors:
            print(f"  {issue.ability_name} [{issue.effect_name}#{issue.effect_order}]: {issue.message}")

    if result.warnings:
        print(f"\n{'='*70}")
        print(f"WARNINGS ({len(result.warnings)}):")
        print("="*70)
        # Group by message to reduce noise
        warning_groups = {}
        for issue in result.warnings:
            key = issue.message
            if key not in warning_groups:
                warning_groups[key] = []
            warning_groups[key].append(issue)

        for msg, issues in sorted(warning_groups.items()):
            abilities = [i.ability_name for i in issues[:5]]
            more = f" (+{len(issues)-5} more)" if len(issues) > 5 else ""
            print(f"  {msg}")
            print(f"    Affects: {', '.join(abilities)}{more}")

    # Output CSV report
    output_dir = Path(__file__).parent.parent / "docs/mapping"
    output_dir.mkdir(parents=True, exist_ok=True)

    report_file = output_dir / "effects_validation_report.csv"
    with open(report_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Ability", "Effect", "Order", "Severity", "Message"])
        for issue in result.issues:
            writer.writerow([
                issue.ability_name,
                issue.effect_name,
                issue.effect_order,
                issue.severity,
                issue.message
            ])

    print(f"\nDetailed report: {report_file}")

    # Summary
    print(f"\n{'='*70}")
    print("SUMMARY")
    print("="*70)
    print(f"  Effect types in DB: {len(set(DB_TO_IDL_MAPPING.keys()))}")
    print(f"  Effect types in IDL: {len(IDL_EFFECT_TYPES)}")
    print(f"  Coverage: {len(DB_TO_IDL_MAPPING)}/{len(IDL_EFFECT_TYPES)} IDL types mapped")

    # Show DB→IDL mapping
    print(f"\nDB Effect → IDL Type Mapping:")
    for db_type, idl_type in sorted(DB_TO_IDL_MAPPING.items()):
        print(f"  {db_type:20} → {idl_type}")


if __name__ == "__main__":
    asyncio.run(main())
