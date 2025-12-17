#!/usr/bin/env python3
"""Generate CSV files for ability and effect mapping review.

Creates two CSV files:
1. abilities_mapping.csv - All abilities with legacy and modern effects
2. effects_reference.csv - All parameterized effects

Extracts additional data from:
- skills.cpp - cast_time, pages, quest_only, humanoid_only
- ability_messages.csv - message availability
"""

import asyncio
import csv
import json
import re
from pathlib import Path
from prisma import Prisma


def format_amount(amount) -> str:
    """Format an amount with proper sign handling."""
    amount_str = str(amount)
    # Don't add + if already has a sign or starts with a negative formula
    if amount_str.startswith("-") or amount_str.startswith("+"):
        return amount_str
    return f"+{amount_str}"


def format_modern_effect(effect_name: str, params: dict) -> str:
    """Translate modern effect with params to human-readable format.

    Uses the new combat system terminology:
    - ACC (Accuracy) - replaces THAC0/hitroll
    - EVA (Evasion) - replaces defensive AC
    - AR (Armor Rating) → DR% - from armor
    - AP (Attack Power) - replaces damroll
    - Soak - flat damage reduction
    """
    # Stat name mappings (legacy → modern combat system)
    STAT_NAMES = {
        # Combat stats (new system)
        "ac": "EVA",      # AC defense → Evasion
        "hitroll": "ACC",  # hitroll → Accuracy
        "damroll": "AP",   # damroll → Attack Power
        # Resources
        "hp": "HP",
        "mana": "Mana",
        "move": "Move",
        # Attributes
        "str": "STR",
        "dex": "DEX",
        "con": "CON",
        "int": "INT",
        "wis": "WIS",
        "cha": "CHA",
    }

    # Format based on effect type
    if effect_name == "evasion_mod":
        stat = STAT_NAMES.get(params.get("stat", ""), params.get("stat", "?"))
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"{stat} {format_amount(amount)} (dur: {duration})"
        return f"{stat} {format_amount(amount)}"

    elif effect_name == "accuracy_mod":
        stat = STAT_NAMES.get(params.get("stat", ""), params.get("stat", "?"))
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"{stat} {format_amount(amount)} (dur: {duration})"
        return f"{stat} {format_amount(amount)}"

    elif effect_name == "stat_mod":
        stat = STAT_NAMES.get(params.get("stat", ""), params.get("stat", "?"))
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"{stat} {format_amount(amount)} (dur: {duration})"
        return f"{stat} {format_amount(amount)}"

    elif effect_name == "resource_mod":
        stat = STAT_NAMES.get(params.get("stat", ""), params.get("stat", "?"))
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"{stat} {format_amount(amount)} (dur: {duration})"
        return f"{stat} {format_amount(amount)}"

    elif effect_name == "saving_mod":
        save_type = params.get("saveType", params.get("stat", params.get("type", "spell")))
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"Save vs {save_type} {format_amount(amount)} (dur: {duration})"
        return f"Save vs {save_type} {format_amount(amount)}"

    elif effect_name == "ward_mod":
        # Ward% - magical damage reduction (from Armor, Barkskin, etc.)
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"Ward% {format_amount(amount)} (dur: {duration})"
        return f"Ward% {format_amount(amount)}"

    elif effect_name == "damage":
        dmg_type = params.get("damageType", params.get("type", "physical")).upper()
        dice = params.get("dice", "")
        formula = params.get("formula", params.get("amount", ""))
        base = params.get("baseDamage", "")
        if dice:
            return f"{dmg_type} damage ({dice})"
        elif formula:
            return f"{dmg_type} damage ({formula})"
        elif base:
            return f"{dmg_type} damage (base: {base})"
        return f"{dmg_type} damage"

    elif effect_name == "heal":
        resource = params.get("resource", "HP")
        amount = params.get("amount", "?")
        formula = params.get("formula", "")
        if formula:
            return f"Heal {resource} ({formula})"
        return f"Heal {resource} +{amount}"

    elif effect_name == "dot":
        dmg_type = params.get("damageType", "poison").upper()
        tick = params.get("tickDamage", "?")
        duration = params.get("duration", "?")
        return f"{dmg_type} DoT ({tick}/tick, {duration})"

    elif effect_name == "status":
        flag = params.get("flag", params.get("status", params.get("type", "?")))
        duration = params.get("duration", "")
        if duration:
            return f"Status: {flag} (dur: {duration})"
        return f"Status: {flag}"

    elif effect_name == "crowd_control":
        cc_type = params.get("type", params.get("ccType", "?"))
        duration = params.get("duration", "")
        if duration:
            return f"CC: {cc_type} (dur: {duration})"
        return f"CC: {cc_type}"

    elif effect_name == "damage_mod":
        stat = STAT_NAMES.get(params.get("stat", ""), params.get("stat", "?"))
        amount = params.get("amount", "?")
        duration = params.get("duration", "")
        if duration:
            return f"{stat} {format_amount(amount)} (dur: {duration})"
        return f"{stat} {format_amount(amount)}"

    elif effect_name == "cure":
        cures = params.get("cures", params.get("type", "?"))
        return f"Cure: {cures}"

    elif effect_name == "dispel":
        target = params.get("target", "magic")
        return f"Dispel {target}"

    elif effect_name == "protection":
        protects = params.get("against", params.get("type", "?"))
        reduction = params.get("reduction", "")
        if reduction:
            return f"Prot vs {protects} ({reduction}%)"
        return f"Prot vs {protects}"

    elif effect_name == "vulnerability":
        vuln_to = params.get("to", params.get("type", "?"))
        increase = params.get("increase", "")
        if increase:
            return f"Vuln to {vuln_to} (+{increase}%)"
        return f"Vuln to {vuln_to}"

    elif effect_name == "stealth":
        stealth_type = params.get("type", "invisible")
        return f"Stealth: {stealth_type}"

    elif effect_name == "detection":
        detects = params.get("detects", params.get("type", "?"))
        return f"Detect: {detects}"

    elif effect_name == "movement":
        move_type = params.get("type", "?")
        return f"Movement: {move_type}"

    elif effect_name == "teleport":
        target = params.get("target", params.get("destination", "?"))
        return f"Teleport: {target}"

    elif effect_name == "summon":
        mob = params.get("mobVnum", params.get("creature", "?"))
        return f"Summon: {mob}"

    elif effect_name == "create_object":
        obj = params.get("objectVnum", params.get("item", "?"))
        return f"Create: {obj}"

    elif effect_name == "elemental_hands":
        element = params.get("element", "?")
        damage = params.get("bonusDamage", "")
        if damage:
            return f"{element} hands (+{damage} dmg)"
        return f"{element} hands"

    elif effect_name == "globe":
        blocks = params.get("blocksCircle", params.get("level", "?"))
        return f"Globe (blocks circle {blocks})"

    elif effect_name == "reflect":
        reflects = params.get("reflects", params.get("type", "?"))
        percent = params.get("percent", "")
        if percent:
            return f"Reflect {reflects} ({percent}%)"
        return f"Reflect {reflects}"

    elif effect_name == "lifesteal":
        percent = params.get("percent", "?")
        return f"Lifesteal {percent}%"

    elif effect_name == "size_mod":
        change = params.get("change", params.get("amount", "?"))
        return f"Size {change:+d}" if isinstance(change, int) else f"Size {change}"

    # Fallback: just show effect name with params
    if params:
        params_str = ", ".join(f"{k}={v}" for k, v in params.items())
        return f"{effect_name}({params_str})"
    return effect_name


def load_extraction_data() -> dict:
    """Load ability metadata from the extraction CSV as fallback data source.

    Keys are normalized to match DB format: "animate dead" -> "animate_dead"
    """
    extraction_path = Path(__file__).parent.parent / "docs/extraction-reports/abilities.csv"

    if not extraction_path.exists():
        print(f"  Warning: Extraction data not found: {extraction_path}")
        return {}

    data = {}
    with open(extraction_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Key by lowercase name with underscores (matching DB plainName format)
            name_key = row.get('name', '').lower().replace(' ', '_').replace("'", '')
            if name_key:
                data[name_key] = {
                    'damageType': row.get('damageType', ''),
                    'minPosition': row.get('minPosition', 'STANDING'),
                    'violent': row.get('violent', 'false').lower() == 'true',
                    'combatOk': row.get('canUseInCombat', 'true').lower() == 'true',
                    'targetType': row.get('targetType', ''),
                    'targetScope': row.get('targetScope', ''),
                }
    return data


def extract_skill_params_from_source() -> dict:
    """Extract cast_time, pages, quest_only, humanoid_only from skills.cpp.

    Returns dict keyed by lowercase ability name with:
    - cast_time: int (from CAST_SPEEDn)
    - pages: int
    - quest_only: bool
    - humanoid_only: bool
    """
    skills_cpp = Path("/home/strider/Code/mud/fierymud/legacy/src/skills.cpp")
    if not skills_cpp.exists():
        print(f"  Warning: skills.cpp not found: {skills_cpp}")
        return {}

    content = skills_cpp.read_text()
    data = {}

    # Pattern for spello() calls - extract name, cast_time, pages, quest
    # spello(ID, "name", ..., CAST_SPEEDn, ..., SPHERE, pages, quest, wearoff)
    spello_pattern = re.compile(
        r'spello\s*\(\s*'
        r'(?:SPELL_\w+|SKILL_\w+|SONG_\w+|CHANT_\w+)\s*,\s*'
        r'"([^"]+)"',  # name
        re.MULTILINE
    )

    for match in spello_pattern.finditer(content):
        # Normalize to underscore format to match DB plainName
        name = match.group(1).lower().replace(' ', '_')

        # Find the complete call
        start = match.start()
        paren_count = 0
        end = start

        for i, char in enumerate(content[start:], start):
            if char == '(':
                paren_count += 1
            elif char == ')':
                paren_count -= 1
                if paren_count == 0:
                    end = i + 1
                    break

        full_call = content[start:end]

        # Extract cast_time (CAST_SPEEDn)
        cast_match = re.search(r'CAST_SPEED(\d+)', full_call)
        cast_time = int(cast_match.group(1)) if cast_match else 1

        # Extract pages and quest from pattern: SKILL_SPHERE_*, pages, quest, wearoff
        pages_match = re.search(r'SKILL_SPHERE_\w+\s*,\s*(\d+)\s*,\s*(true|false)', full_call)
        pages = int(pages_match.group(1)) if pages_match else 0
        quest_only = pages_match.group(2) == 'true' if pages_match else False

        data[name] = {
            'cast_time': cast_time,
            'pages': pages,
            'quest_only': quest_only,
            'humanoid_only': False,  # spello always passes false for humanoid
        }

    # Pattern for skillo() calls - extract name, humanoid
    # skillo(SKILL_*, "name", humanoid, targets, wearoff)
    skillo_pattern = re.compile(
        r'skillo\s*\(\s*'
        r'SKILL_\w+\s*,\s*'
        r'"([^"]+)"\s*,\s*'  # name
        r'(true|false)',  # humanoid
        re.MULTILINE
    )

    for match in skillo_pattern.finditer(content):
        # Normalize to underscore format to match DB plainName
        name = match.group(1).lower().replace(' ', '_')
        humanoid_only = match.group(2) == 'true'

        if name not in data:
            data[name] = {
                'cast_time': 1,
                'pages': 0,
                'quest_only': False,
                'humanoid_only': humanoid_only,
            }
        else:
            data[name]['humanoid_only'] = humanoid_only

    return data


def load_ability_messages() -> set:
    """Load ability names that have messages from ability_messages.csv.

    Returns set of lowercase ability names (with underscores) that have at least one message.
    Keys are normalized to match DB format: "animate dead" -> "animate_dead"
    """
    messages_path = Path(__file__).parent.parent / "docs/extraction-reports/ability_messages.csv"

    if not messages_path.exists():
        print(f"  Warning: ability_messages.csv not found: {messages_path}")
        return set()

    abilities_with_messages = set()
    with open(messages_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Normalize to underscore format to match DB plainName
            name = row.get('ability_name', '').lower().replace(' ', '_')
            # Check if any message column has content
            has_msg = any([
                row.get('wearoff_to_target', ''),
                row.get('success_to_caster', ''),
                row.get('success_to_victim', ''),
                row.get('success_to_room', ''),
            ])
            if has_msg:
                abilities_with_messages.add(name)

    return abilities_with_messages


def get_extraction_info(extraction_data: dict, plain_name: str) -> dict:
    """Look up extraction data for an ability by its plain name."""
    name_lower = plain_name.lower()
    keys_to_try = [
        name_lower,
        name_lower.replace('_', ' '),
    ]
    for key in keys_to_try:
        if key in extraction_data:
            return extraction_data[key]
    return {}


def map_damage_type_to_display(damage_type: str) -> str:
    """Map Prisma ElementType enum to display string."""
    if not damage_type:
        return ""
    # Map from Prisma enum to extraction format for consistency
    mapping = {
        "FIRE": "FIRE",
        "COLD": "COLD",
        "ACID": "ACID",
        "LIGHTNING": "SHOCK",
        "POISON": "POISON",
        "PSYCHIC": "MENTAL",
        "DIVINE": "ALIGN",
        "BLUDGEONING": "PHYSICAL_BLUNT",
        "PIERCING": "PHYSICAL_PIERCE",
        "SLASHING": "PHYSICAL_SLASH",
    }
    return mapping.get(damage_type, damage_type)


async def main():
    """Generate CSV mapping files."""
    prisma = Prisma()
    await prisma.connect()

    # Load extraction data from abilities.csv (authoritative source)
    extraction_data = load_extraction_data()
    print(f"Loaded {len(extraction_data)} abilities from extraction data")

    # Extract skill params from skills.cpp (cast_time, pages, quest_only, humanoid_only)
    skill_params = extract_skill_params_from_source()
    print(f"Extracted {len(skill_params)} skill parameters from skills.cpp")

    # Load ability messages to check which abilities have messages
    abilities_with_messages = load_ability_messages()
    print(f"Found {len(abilities_with_messages)} abilities with messages")

    print("Generating ability mapping CSV...")

    # Get all abilities with their effects, targeting, and messages
    abilities = await prisma.ability.find_many(
        include={
            "effects": {"include": {"effect": True}},
            "targeting": True,
            "messages": True,
        },
        order={"name": "asc"}
    )

    # Get all effects for reference
    effects = await prisma.effect.find_many(order={"name": "asc"})

    # Create output directory
    output_dir = Path(__file__).parent.parent / "docs/mapping"
    output_dir.mkdir(parents=True, exist_ok=True)

    # =========================================================================
    # Generate abilities_mapping.csv
    # =========================================================================
    abilities_csv = output_dir / "abilities_mapping.csv"

    with open(abilities_csv, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Name",
            "Type",
            "Description",
            "Damage_Type",
            "Min_Position",
            "Violent",
            "Combat_Ok",
            "Cast_Time",
            "Pages",
            "Restrictions",
            "Effects",
            "Effect_Count",
            "Has_Targeting",
            "Has_Messages"
        ])

        for ability in abilities:
            # Format modern effects with human-readable translation
            modern_effects = []
            for ae in ability.effects:
                effect = ae.effect
                # Handle params - could be dict or JSON string
                if ae.overrideParams:
                    if isinstance(ae.overrideParams, str):
                        params = json.loads(ae.overrideParams)
                    else:
                        params = ae.overrideParams
                else:
                    params = {}

                # Translate to human-readable format
                effect_str = format_modern_effect(effect.name, params)
                modern_effects.append(effect_str)

            modern_effects_str = "; ".join(modern_effects) if modern_effects else ""

            # Get description, truncate if too long
            description = ability.description or f"{ability.abilityType.title()}: {ability.plainName}"
            if len(description) > 100:
                description = description[:97] + "..."

            # Get extraction data as fallback for fields that may not be in DB
            extraction_info = get_extraction_info(extraction_data, ability.plainName)

            # Use DB value if set, otherwise fall back to extraction data
            # Violent: Use extraction data if DB has default (false)
            if extraction_info and not ability.violent and extraction_info.get('violent'):
                violent = "Yes"
            else:
                violent = "Yes" if ability.violent else "No"

            # Combat_Ok: DB default is true, so use extraction if it says false
            if extraction_info and ability.combatOk and not extraction_info.get('combatOk', True):
                combat_ok = "No"
            else:
                combat_ok = "Yes" if ability.combatOk else "No"

            # Build consolidated Restrictions column from skill_params extraction
            skill_name_key = ability.plainName.lower()
            params = skill_params.get(skill_name_key, {})
            restrictions = []
            if params.get('quest_only', False) or ability.questOnly:
                restrictions.append("Quest")
            if params.get('humanoid_only', False) or ability.humanoidOnly:
                restrictions.append("Humanoid")
            restrictions_str = ", ".join(restrictions) if restrictions else ""

            # Check Has_Targeting from extraction data (targetType/targetScope)
            has_targeting = "No"
            if extraction_info:
                target_type = extraction_info.get('targetType', '')
                target_scope = extraction_info.get('targetScope', '')
                if target_type or target_scope:
                    has_targeting = "Yes"
            elif ability.targeting:
                has_targeting = "Yes"

            # Check Has_Messages from ability_messages.csv extraction
            has_messages = "Yes" if skill_name_key in abilities_with_messages else "No"

            # Format damage type - use DB if set, otherwise extraction
            if ability.damageType:
                damage_type = map_damage_type_to_display(ability.damageType)
            elif extraction_info:
                damage_type = extraction_info.get('damageType', '')
                if damage_type == 'NONE':
                    damage_type = ''
            else:
                damage_type = ""

            # Min position - use extraction if DB has default
            if extraction_info and ability.minPosition == "STANDING":
                min_position = extraction_info.get('minPosition', 'STANDING')
            else:
                min_position = ability.minPosition

            # Get cast_time and pages from skill_params (extracted from skills.cpp)
            # Fall back to database if not in extraction
            cast_time = params.get('cast_time', ability.castTimeRounds or 1)
            pages = params.get('pages', ability.pages or 0)
            pages_str = str(pages) if pages else ""

            writer.writerow([
                ability.name,
                ability.abilityType,
                description,
                damage_type,
                min_position,
                violent,
                combat_ok,
                cast_time,
                pages_str,
                restrictions_str,
                modern_effects_str,
                len(ability.effects),
                has_targeting,
                has_messages
            ])

    print(f"  Created: {abilities_csv}")
    print(f"  Total abilities: {len(abilities)}")

    # =========================================================================
    # Generate effects_reference.csv
    # =========================================================================
    effects_csv = output_dir / "effects_reference.csv"

    # Track usage and abilities for each effect
    effect_usage = {}
    effect_abilities = {}  # effect_id -> list of ability names
    for ability in abilities:
        for ae in ability.effects:
            effect_id = ae.effect.id
            if effect_id not in effect_usage:
                effect_usage[effect_id] = 0
                effect_abilities[effect_id] = []
            effect_usage[effect_id] += 1
            effect_abilities[effect_id].append(ability.name)

    with open(effects_csv, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "ID",
            "Name",
            "Effect_Type",
            "Tags",
            "Default_Params",
            "Param_Schema",
            "Usage_Count",
            "Category",
            "Abilities_Using"
        ])

        for effect in effects:
            # Determine category based on name
            name = effect.name
            if name.startswith("apply_"):
                category = "LEGACY_APPLY"
            elif name.startswith("damage_"):
                category = "LEGACY_DAMAGE"
            elif name in ("damage", "heal", "dot", "chain_damage", "lifesteal", "reflect", "damage_mod"):
                category = "COMBAT"
            elif name in ("accuracy_mod", "evasion_mod", "protection", "vulnerability"):
                category = "DEFENSE"
            elif name in ("stat_mod", "resource_mod", "saving_mod", "size_mod"):
                category = "STATS"
            elif name in ("status", "crowd_control", "cure"):
                category = "STATUS"
            elif name in ("stealth", "detection", "movement", "elemental_hands", "globe"):
                category = "UTILITY"
            elif name in ("dispel", "reveal"):
                category = "MAGIC"
            elif name in ("teleport", "banish", "broadcast_teleport"):
                category = "TELEPORT"
            elif name in ("summon", "create_object", "resurrect"):
                category = "CREATION"
            elif name in ("room_effect", "room_barrier"):
                category = "ROOM"
            else:
                category = "OTHER"

            # Parse default params
            default_params = ""
            if effect.defaultParams:
                try:
                    params = json.loads(effect.defaultParams) if isinstance(effect.defaultParams, str) else effect.defaultParams
                    default_params = json.dumps(params) if params else ""
                except:
                    default_params = str(effect.defaultParams)

            # Parse tags
            tags = ""
            if effect.tags:
                tags = ", ".join(effect.tags)

            # Get list of abilities using this effect
            abilities_list = effect_abilities.get(effect.id, [])
            # Limit to first 10 for readability, add "..." if more
            if len(abilities_list) > 10:
                abilities_str = "; ".join(abilities_list[:10]) + f"; ... (+{len(abilities_list) - 10} more)"
            else:
                abilities_str = "; ".join(abilities_list)

            writer.writerow([
                effect.id,
                effect.name,
                effect.effectType or "",
                tags,
                default_params,
                effect.paramSchema or "",
                effect_usage.get(effect.id, 0),
                category,
                abilities_str
            ])

    print(f"  Created: {effects_csv}")
    print(f"  Total effects: {len(effects)}")

    # =========================================================================
    # Summary statistics
    # =========================================================================
    print("\n" + "=" * 60)
    print("Summary Statistics")
    print("=" * 60)

    linked = sum(1 for a in abilities if a.effects)
    # Check against extraction data (abilities.csv) instead of deleted JSON
    needs_mapping = sum(1 for a in abilities if not a.effects and a.name.lower() in extraction_data)
    no_data = len(abilities) - linked - needs_mapping

    print(f"  Abilities linked:     {linked} ({100*linked//len(abilities)}%)")
    print(f"  Needs mapping:        {needs_mapping}")
    print(f"  No legacy data:       {no_data}")
    print(f"  Total effects in DB:  {len(effects)}")
    print(f"  Parameterized (new):  {sum(1 for e in effects if not e.name.startswith(('apply_', 'damage_')))}")
    print(f"  Legacy (old):         {sum(1 for e in effects if e.name.startswith(('apply_', 'damage_')))}")

    await prisma.disconnect()

    print(f"\nFiles created in: {output_dir}")


if __name__ == "__main__":
    asyncio.run(main())
