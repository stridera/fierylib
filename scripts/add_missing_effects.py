"""Add missing effects to abilities based on legacy spell analysis."""

import json
from pathlib import Path

# Effect mappings based on legacy code analysis

# Status effects (status flag)
STATUS_EFFECTS = {
    "Aware": {"flag": "aware", "duration": "level * 2"},
    "Berserk": {"flag": "berserk", "duration": "level"},
    "Bless": {"flag": "bless", "duration": "level * 2"},
    "Blur": {"flag": "blur", "duration": "level"},
    "Coldshield": {"flag": "coldshield", "duration": "level"},
    "Feather Fall": {"flag": "featherfall", "duration": "level * 2"},
    "Fireshield": {"flag": "fireshield", "duration": "level"},
    "Fly": {"flag": "fly", "duration": "level * 2"},
    "Haste": {"flag": "haste", "duration": "level"},
    "Infravision": {"flag": "infravision", "duration": "level * 2"},
    "Night Vision": {"flag": "infravision", "duration": "level * 2"},
    "Sanctuary": {"flag": "sanctuary", "duration": "level"},
    "Stone Skin": {"flag": "stoneskin", "duration": "level"},
    "Waterwalk": {"flag": "waterwalk", "duration": "level * 3"},
    "Safefall": {"flag": "featherfall", "duration": "level * 2"},
    "Nimble": {"flag": "haste", "duration": "level"},  # Similar to haste
}

# Protection effects (damage reduction)
PROTECTION_EFFECTS = {
    "Protection from Fire": {"type": "fire", "amount": 50, "duration": "level * 2"},
    "Protection from Cold": {"type": "cold", "amount": 50, "duration": "level * 2"},
    "Protection from Air": {"type": "shock", "amount": 50, "duration": "level * 2"},
    "Protection from Earth": {"type": "physical", "amount": 25, "duration": "level * 2"},
    "Protection from Evil": {"type": "evil", "amount": 50, "duration": "level * 2"},
    "Protection from Good": {"type": "good", "amount": 50, "duration": "level * 2"},
    "Negate Cold": {"type": "cold", "amount": 100, "duration": "level"},
    "Negate Heat": {"type": "fire", "amount": 100, "duration": "level"},
    "Elemental Warding": {"type": "fire", "amount": 50, "duration": "level * 2"},  # Can be any element
}

# Globe effects
GLOBE_EFFECTS = {
    "Minor Globe": {"maxCircle": 3, "duration": "level"},
    "Major Globe": {"maxCircle": 6, "duration": "level"},
}

# Detection effects
DETECTION_EFFECTS = {
    "Detect Alignment": {"type": "align", "duration": "level * 2"},
    "Detect Invisibility": {"type": "invisible", "duration": "level * 2"},
    "Detect Magic": {"type": "magic", "duration": "level * 2"},
    "Detect Poison": {"type": "poison", "duration": "level * 2"},
    "Sense Life": {"type": "life", "duration": "level * 3"},
    "Farsee": {"type": "hidden", "duration": "level * 2"},
    "Reveal Hidden": {"type": "hidden", "duration": "level"},
}

# Crowd control effects
CROWD_CONTROL_EFFECTS = {
    "Charm Person": {"type": "charm", "duration": "level / 2", "breakOnDamage": False},
    "Confusion": {"type": "confuse", "duration": "level / 2", "breakOnDamage": True},
    "Entangle": {"type": "web", "duration": "level / 2", "breakOnDamage": False},
    "Fear": {"type": "fear", "duration": "level / 4", "breakOnDamage": True},
    "Major Paralysis": {"type": "paralyze", "duration": "level / 2", "breakOnDamage": False},
    "Minor Paralysis": {"type": "paralyze", "duration": "level / 4", "breakOnDamage": True},
    "Mesmerize": {"type": "mesmerize", "duration": "level / 2", "breakOnDamage": True},
    "Sleep": {"type": "sleep", "duration": "level", "breakOnDamage": True},
    "Web": {"type": "web", "duration": "level / 2", "breakOnDamage": False},
    "Bone Cage": {"type": "paralyze", "duration": "level / 4", "breakOnDamage": False},
    "Silence": {"type": "silence", "duration": "level / 2", "breakOnDamage": False},
    "Doom": {"type": "fear", "duration": "level / 4", "breakOnDamage": True},
    "Terror": {"type": "fear", "duration": "level / 4", "breakOnDamage": True},
    "Hysteria": {"type": "fear", "duration": "level / 4", "breakOnDamage": True},
    "Crown Of Madness": {"type": "confuse", "duration": "level / 2", "breakOnDamage": True},
}

# Resource modification effects (HP/mana/move)
RESOURCE_MOD_EFFECTS = {
    "Endurance": {"resource": "move", "amount": "skill / 2", "duration": "level * 2"},
    "Greater Endurance": {"resource": "move", "amount": "skill", "duration": "level * 2"},
    "Lesser Endurance": {"resource": "move", "amount": "skill / 4", "duration": "level * 2"},
    "Vitality": {"resource": "hp", "amount": "skill / 2", "duration": "level * 2"},
    "Greater Vitality": {"resource": "hp", "amount": "skill", "duration": "level * 2"},
    "Dragons Health": {"resource": "hp", "amount": "skill * 2", "duration": "level * 2"},
}

# Stat modification effects
STAT_MOD_EFFECTS = {
    "Earth Blessing": {"stat": "con", "amount": 2, "duration": "level * 2"},
    "Clarity": {"stat": "focus", "amount": "skill / 5", "duration": "level * 2"},
    "Prayer": {"stat": "hitroll", "amount": 2, "duration": "level * 2"},
    "Chant": {"stat": "hitroll", "amount": 1, "duration": "level"},
    "Quick Chant": {"stat": "hitroll", "amount": 1, "duration": "level / 2"},
}

# Cure effects
CURE_EFFECTS = {
    "Remove Curse": {"condition": "curse", "scope": "all"},
    "Remove Paralysis": {"condition": "paralysis", "scope": "all"},
}

# Heal effects (instant heal, not resource_mod)
HEAL_EFFECTS = {
    "First Aid": {"resource": "hp", "amount": "skill / 4", "scaling": "wis"},
    "Lay Hands": {"resource": "hp", "amount": "level * 2", "scaling": "cha"},
    "Bandage": {"resource": "hp", "amount": "skill / 5", "scaling": "wis"},
    "Invigorate": {"resource": "move", "amount": "skill / 2", "scaling": "wis"},
    # Note: Meditate is a toggle skill that applies 'meditating' status + focus modifier, not a heal
}

# Breath weapons (damage)
BREATH_DAMAGE = {
    "Breathe Acid": {"type": "acid", "amount": "skill + random(1, skill*2)"},
    "Breathe Fire": {"type": "fire", "amount": "skill + random(1, skill*2)"},
    "Breathe Frost": {"type": "cold", "amount": "skill + random(1, skill*2)"},
    "Breathe Gas": {"type": "poison", "amount": "skill + random(1, skill*2)"},
    "Breathe Lightning": {"type": "shock", "amount": "skill + random(1, skill*2)"},
    "Cremate": {"type": "fire", "amount": "skill * 2"},
    "Electrify": {"type": "shock", "amount": "skill"},
    "Degeneration": {"type": "unholy", "amount": "skill"},
    "Creeping Doom": {"type": "poison", "amount": "skill"},
}

# Room effects
ROOM_EFFECTS = {
    "Darkness": {"type": "darkness", "duration": "level"},
    "Illumination": {"type": "light", "duration": "level * 2"},
    "Rain": {"type": "fog", "duration": "level"},
    "Control Weather": {"type": "fog", "duration": "level"},
}

# Room barriers
ROOM_BARRIERS = {
    "Wall Of Fog": {"type": "fog", "traversalRules": "slow", "duration": "level"},
    "Wall Of Ice": {"type": "ice", "hp": 100, "traversalRules": "block", "duration": "level"},
    "Wall Of Stone": {"type": "stone", "hp": 200, "traversalRules": "block", "duration": "level"},
    "Illusory Wall": {"type": "illusion", "traversalRules": "passable", "duration": "level * 2"},
}

# Teleport effects
TELEPORT_EFFECTS = {
    "Banish": "banish",  # Already has its own effect type
    "Group Retreat": {"destination": "recall", "restrictions": []},
    "Retreat": {"destination": "recall", "restrictions": ["not_in_combat"]},
    "Wandering Woods": {"destination": "random", "restrictions": []},
}

# Stealth effects
STEALTH_EFFECTS = {
    "Hide": {"type": "hide", "level": "skill"},
    "Sneak": {"type": "camouflage", "level": "skill"},
    "Concealment": {"type": "camouflage", "level": "skill"},
    "Conceal": {"type": "hide", "level": "skill"},
    "Shadow": {"type": "hide", "level": "skill"},
    "Stealth": {"type": "camouflage", "level": "skill"},
    "Misdirection": {"type": "camouflage", "level": "skill"},
}

# Resurrect effect
RESURRECT_EFFECTS = {
    "Resurrect": {"expPenalty": 0.1, "equipTransfer": True, "hpPercent": 0.5},
}

# Displacement (stat_mod for evasion)
DISPLACEMENT_EFFECTS = {
    "Displacement": {"stat": "eva", "amount": 10, "duration": "level"},
    "Greater Displacement": {"stat": "eva", "amount": 20, "duration": "level"},
    "Phantasm": {"stat": "eva", "amount": 5, "duration": "level"},
}

# Summon effects
SUMMON_EFFECTS = {
    "Mount": {"mobType": "mount", "duration": "level * 10", "maxCount": 1},
    "Summon Mount": {"mobType": "mount", "duration": "level * 10", "maxCount": 1},
}

# Reveal effects (like identify)
REVEAL_EFFECTS = {
    "Identify": {"type": "object", "depth": "room"},
    "Locate Object": {"type": "object", "depth": "world"},
    "Wizard Eye": {"type": "hidden", "depth": "zone"},
    "Know Spell": {"type": "magic", "depth": "room"},
}

# DOT effects
DOT_EFFECTS = {
    "On Fire": {"type": "fire", "amount": "5%", "duration": 10, "interval": 1},
    "Regeneration": {"type": "heal", "amount": "2%", "duration": "level", "interval": 1},
}

# Dispel effects
DISPEL_EFFECTS = {
    "Extinguish": {"filter": "buff", "scope": "first", "power": "level"},
    "Douse": {"filter": "buff", "scope": "first", "power": "level"},
    "Enrapture": {"filter": "debuff", "scope": "all", "power": "level"},
    "Peace": {"filter": "all", "scope": "all", "power": "level"},
}

# Combat skills - these get a special "skill" effect placeholder
COMBAT_SKILLS = [
    "Backstab", "Bash", "Bodyslam", "Cartwheel", "Circle", "Claw",
    "Corner", "Disarm", "Disarm Dropped Weapon", "Disarm Fumbling Weapon",
    "Dodge", "Double Attack", "Double Backstab", "Eye Gouge",
    "Ground Shaker", "Guard", "Hit All", "Kick", "Lure", "Maul",
    "Missile", "Parry", "Peck", "Punch", "Rend", "Rescue",
    "Riposte", "Roar", "Roundhouse", "Sneak Attack", "Springleap",
    "Sweep", "Switch", "Tantrum", "Throatcut", "War Cry",
]

# Passive/weapon skills - proficiency, no direct effect
PASSIVE_SKILLS = [
    "Barehand", "Bludgeoning Weapons", "Dual Wield", "Piercing Weapons",
    "Riding", "Slashing Weapons", "Two-Hand Bludgeoning", "Two-Hand Piercing",
    "Two-Hand Slashing", "Scribe", "Pick Lock", "Track", "Hunt", "Tame",
    "Perform", "Steal", "Harness",
]

# Bard songs - group buffs, typically stat_mod or status
BARD_SONGS = {
    "Apocalyptic Anthem": {"stat": "damroll", "amount": 2, "duration": "skill / 4"},
    "Aria Of Dissonance": {"stat": "hitroll", "amount": -2, "duration": "skill / 4"},  # Debuff
    "Ballad Of Tears": {"stat": "damroll", "amount": -2, "duration": "skill / 4"},  # Debuff
    "Battle Howl": {"stat": "hitroll", "amount": 2, "duration": "skill / 4"},
    "Battle Hymn": {"stat": "hitroll", "amount": 2, "duration": "skill / 4"},
    "Blizzards Of Saint Augustine": {"stat": "damroll", "amount": 3, "duration": "skill / 4"},
    "Fires Of Saint Augustine": {"stat": "damroll", "amount": 3, "duration": "skill / 4"},
    "Freedom Song": {"stat": "eva", "amount": 5, "duration": "skill / 4"},
    "Hearthsong": {"stat": "focus", "amount": 5, "duration": "skill / 4"},
    "Heroic Journey": {"stat": "hitroll", "amount": 3, "duration": "skill / 4"},
    "Hymn Of Saint Augustine": {"stat": "damroll", "amount": 2, "duration": "skill / 4"},
    "Inspiration": {"stat": "hitroll", "amount": 2, "duration": "skill / 4"},
    "Interminable Wrath": {"stat": "damroll", "amount": 3, "duration": "skill / 4"},
    "Ivory Symphony": {"stat": "focus", "amount": 10, "duration": "skill / 4"},
    "Joyful Noise": {"stat": "cha", "amount": 2, "duration": "skill / 4"},
    "Shadows Sorrow Song": {"stat": "hitroll", "amount": -3, "duration": "skill / 4"},  # Debuff
    "Song Of Rest": {"stat": "focus", "amount": 5, "duration": "skill / 4"},
    "Sonata Of Malaise": {"stat": "con", "amount": -2, "duration": "skill / 4"},  # Debuff
    "Tempest Of Saint Augustine": {"stat": "damroll", "amount": 4, "duration": "skill / 4"},
    "Tremors Of Saint Augustine": {"stat": "damroll", "amount": 3, "duration": "skill / 4"},
    "Spinechiller": {"stat": "eva", "amount": -5, "duration": "skill / 4"},  # Debuff
}

# Special cases
SPECIAL_EFFECTS = {
    "Dark Feast": [{"effect": "heal", "params": {"resource": "hp", "amount": "skill / 2"}}],
    "Dark Presence": [{"effect": "status", "params": {"flag": "bless", "duration": "level * 2"}}],  # Evil bless
    "Divine Essence": [{"effect": "status", "params": {"flag": "sanctuary", "duration": "level"}}],
    "Natures Embrace": [{"effect": "heal", "params": {"resource": "hp", "amount": "skill"}}],
    "Comprehend Lang": [{"effect": "detection", "params": {"type": "hidden", "duration": "level * 2"}}],
    "Speak In Tongues": [{"effect": "detection", "params": {"type": "hidden", "duration": "level * 2"}}],
    "Familiarity": [{"effect": "detection", "params": {"type": "life", "duration": "level * 2"}}],
    "Group Armor": [{"effect": "stat_mod", "params": {"stat": "ward", "amount": 10, "duration": "level * 2"}}],
    "Shapechange": [{"effect": "size_mod", "params": {"amount": 1, "duration": "level"}}],
    "Statue": [{"effect": "crowd_control", "params": {"type": "paralyze", "duration": "level", "breakOnDamage": False}}],
    "Vaporform": [{"effect": "status", "params": {"flag": "invisible", "duration": "level"}}],
    "Waterform": [{"effect": "status", "params": {"flag": "waterbreath", "duration": "level"}}],
    "Soul Tap": [{"effect": "lifesteal", "params": {"percent": 25, "duration": "level"}}],
    "Soulshield": [{"effect": "protection", "params": {"type": "magic", "amount": 25, "duration": "level * 2"}}],
    "Seed Of Destruction": [{"effect": "dot", "params": {"type": "unholy", "amount": "5%", "duration": 10, "interval": 1}}],
    "Vampiric Touch": [{"effect": "lifesteal", "params": {"percent": 50, "duration": 1}}],
    "Spirit of the Bear": [{"effect": "stat_mod", "params": {"stat": "con", "amount": 4, "duration": "level * 2"}}],
    "Spirit of the Wolf": [{"effect": "stat_mod", "params": {"stat": "dex", "amount": 4, "duration": "level * 2"}}],
    "Word Of Command": [{"effect": "crowd_control", "params": {"type": "charm", "duration": "level / 4", "breakOnDamage": False}}],
    "Natures Guidance": [{"effect": "stat_mod", "params": {"stat": "hitroll", "amount": 3, "duration": "level * 2"}}],
    "Wings Of Heaven": [{"effect": "status", "params": {"flag": "fly", "duration": "level * 2"}}],
    "Wings Of Hell": [{"effect": "status", "params": {"flag": "fly", "duration": "level * 2"}}],
    "Instant Kill": [{"effect": "damage", "params": {"type": "physical", "amount": "9999"}}],
    "Preserve": [{"effect": "status", "params": {"flag": "sanctuary", "duration": "level"}}],
    "Enlightenment": [{"effect": "stat_mod", "params": {"stat": "wis", "amount": 4, "duration": "level * 2"}}],
    "Magic Torch": [{"effect": "room_effect", "params": {"type": "light", "duration": "level * 4"}}],
    "Sphere of Air": [{"effect": "protection", "params": {"type": "shock", "amount": 25, "duration": "level"}}],
    "Sphere of Death": [{"effect": "protection", "params": {"type": "unholy", "amount": 25, "duration": "level"}}],
    "Sphere of Divination": [{"effect": "detection", "params": {"type": "magic", "duration": "level"}}],
    "Sphere of Earth": [{"effect": "protection", "params": {"type": "physical", "amount": 25, "duration": "level"}}],
    "Sphere of Enchantment": [{"effect": "saving_mod", "params": {"type": "spell", "amount": -2, "duration": "level"}}],
    "Sphere of Fire": [{"effect": "protection", "params": {"type": "fire", "amount": 25, "duration": "level"}}],
    "Sphere of Generic": [{"effect": "protection", "params": {"type": "magic", "amount": 10, "duration": "level"}}],
    "Sphere of Healing": [{"effect": "heal", "params": {"resource": "hp", "amount": "level", "scaling": "wis"}}],
    "Sphere of Protection": [{"effect": "stat_mod", "params": {"stat": "ward", "amount": 10, "duration": "level"}}],
    "Sphere of Summoning": [{"effect": "summon", "params": {"mobType": "elemental", "duration": "level * 5", "maxCount": 1}}],
    "Sphere of Water": [{"effect": "protection", "params": {"type": "cold", "amount": 25, "duration": "level"}}],
    "Shift Corpse": [{"effect": "teleport", "params": {"destination": "target"}}],
    "Summon Corpse": [{"effect": "teleport", "params": {"destination": "target"}}],
    "Bind": [{"effect": "crowd_control", "params": {"type": "web", "duration": "level / 2", "breakOnDamage": False}}],
    "Circle Of Light": [{"effect": "status", "params": {"flag": "glowing", "duration": "level * 2"}}],
    "Doorbash": [{"effect": "damage", "params": {"type": "physical", "amount": "skill", "scaling": "str"}, "notes": "Breaks down doors"}],
    "Ventriloquate": [{"effect": "stealth", "params": {"type": "camouflage", "level": "skill"}, "notes": "Illusion/distraction"}],
}


def create_effect(effect_type: str, params: dict, order: int = 0) -> dict:
    """Create an effect entry."""
    return {
        "effect": effect_type,
        "order": order,
        "params": params,
        "trigger": "on_cast",
    }


def get_effects_for_ability(name: str) -> list:
    """Determine the appropriate effects for an ability."""

    # Check special effects first
    if name in SPECIAL_EFFECTS:
        effects = SPECIAL_EFFECTS[name]
        for i, e in enumerate(effects):
            e["order"] = i
            if "trigger" not in e:
                e["trigger"] = "on_cast"
        return effects

    # Status effects
    if name in STATUS_EFFECTS:
        return [create_effect("status", STATUS_EFFECTS[name])]

    # Protection effects
    if name in PROTECTION_EFFECTS:
        return [create_effect("protection", PROTECTION_EFFECTS[name])]

    # Globe effects
    if name in GLOBE_EFFECTS:
        return [create_effect("globe", GLOBE_EFFECTS[name])]

    # Detection effects
    if name in DETECTION_EFFECTS:
        return [create_effect("detection", DETECTION_EFFECTS[name])]

    # Crowd control effects
    if name in CROWD_CONTROL_EFFECTS:
        return [create_effect("crowd_control", CROWD_CONTROL_EFFECTS[name])]

    # Resource mod effects
    if name in RESOURCE_MOD_EFFECTS:
        return [create_effect("resource_mod", RESOURCE_MOD_EFFECTS[name])]

    # Stat mod effects
    if name in STAT_MOD_EFFECTS:
        return [create_effect("stat_mod", STAT_MOD_EFFECTS[name])]

    # Cure effects
    if name in CURE_EFFECTS:
        return [create_effect("cure", CURE_EFFECTS[name])]

    # Heal effects
    if name in HEAL_EFFECTS:
        return [create_effect("heal", HEAL_EFFECTS[name])]

    # Breath damage
    if name in BREATH_DAMAGE:
        return [create_effect("damage", BREATH_DAMAGE[name])]

    # Room effects
    if name in ROOM_EFFECTS:
        return [create_effect("room_effect", ROOM_EFFECTS[name])]

    # Room barriers
    if name in ROOM_BARRIERS:
        return [create_effect("room_barrier", ROOM_BARRIERS[name])]

    # Teleport effects
    if name in TELEPORT_EFFECTS:
        if name == "Banish":
            return [create_effect("banish", {"successTiers": [50, 100], "extractCondition": "npc"})]
        return [create_effect("teleport", TELEPORT_EFFECTS[name])]

    # Stealth effects
    if name in STEALTH_EFFECTS:
        return [create_effect("stealth", STEALTH_EFFECTS[name])]

    # Resurrect effects
    if name in RESURRECT_EFFECTS:
        return [create_effect("resurrect", RESURRECT_EFFECTS[name])]

    # Displacement effects
    if name in DISPLACEMENT_EFFECTS:
        return [create_effect("stat_mod", DISPLACEMENT_EFFECTS[name])]

    # Summon effects
    if name in SUMMON_EFFECTS:
        return [create_effect("summon", SUMMON_EFFECTS[name])]

    # Reveal effects
    if name in REVEAL_EFFECTS:
        return [create_effect("reveal", REVEAL_EFFECTS[name])]

    # DOT effects
    if name in DOT_EFFECTS:
        return [create_effect("dot", DOT_EFFECTS[name])]

    # Dispel effects
    if name in DISPEL_EFFECTS:
        return [create_effect("dispel", DISPEL_EFFECTS[name])]

    # Bard songs
    if name in BARD_SONGS:
        return [create_effect("stat_mod", BARD_SONGS[name])]

    # Combat skills - placeholder
    if name in COMBAT_SKILLS:
        return [{"effect": "damage", "order": 0, "params": {"type": "physical", "amount": "skill", "scaling": "level"}, "trigger": "on_hit", "notes": f"Combat skill: {name}"}]

    # Passive skills - no effect needed, they modify other abilities
    if name in PASSIVE_SKILLS:
        return []  # Passive skills don't have direct effects

    # Unknown - return empty (will be logged)
    return None


def main():
    data_dir = Path(__file__).parent.parent / "data"
    abilities_path = data_dir / "abilities.json"

    with open(abilities_path) as f:
        abilities = json.load(f)

    updated = 0
    skipped = 0
    unknown = []
    passive = []

    for ability in abilities:
        name = ability["name"]
        existing_effects = ability.get("effects", [])

        # Skip if already has effects
        if existing_effects:
            skipped += 1
            continue

        # Get effects for this ability
        new_effects = get_effects_for_ability(name)

        if new_effects is None:
            unknown.append(name)
            continue

        if not new_effects:
            passive.append(name)
            continue

        ability["effects"] = new_effects
        updated += 1

    # Save updated abilities
    with open(abilities_path, "w") as f:
        json.dump(abilities, f, indent=2)

    print(f"Updated {updated} abilities with effects")
    print(f"Skipped {skipped} abilities (already have effects)")
    print(f"Passive skills (no effects): {len(passive)}")
    if passive:
        for name in sorted(passive):
            print(f"  - {name}")

    if unknown:
        print(f"\nUnknown abilities ({len(unknown)}):")
        for name in sorted(unknown):
            print(f"  - {name}")


if __name__ == "__main__":
    main()
