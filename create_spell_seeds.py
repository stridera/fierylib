#!/usr/bin/env python3
"""
Create comprehensive spell seed files combining all data sources.
"""
import json
import csv
from pathlib import Path
from typing import Dict, List, Optional

# Help text data (47 entries from previous parsing)
HELP_TEXT_DATA = {
    "SPELL_ARMOR": {
        "usage": "cast 'armor' [target]",
        "duration": "24 Hours",
        "accumulative": "No",
        "description": "The Armor spell will improve your AC by 2.\n\nSee also: AC"
    },
    "SPELL_BLESS": {
        "usage": "cast 'bless' [target]",
        "duration": "6 Hours",
        "accumulative": "No",
        "description": "This spell will make you better in melee combat, giving you a bonus of +1 on your hitroll."
    },
    "SPELL_BLINDNESS": {
        "usage": "cast 'blindness' <victim>",
        "duration": "2-4 Hours",
        "accumulative": "No",
        "description": "This spell will blind a person for 2-4 hours, making the victim unable to see, making the victim an very easy target in combat. The victim will also find it very hard to hit the victim's opponents."
    },
    "SPELL_BURNING_HANDS": {
        "usage": "cast 'burning hands' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This is a very powerful spell at low levels. It will not only damage your victim, but if you're lucky you can blind your victim for a short while.\n\nSee also: BLINDNESS"
    },
    "SPELL_CALL_LIGHTNING": {
        "usage": "cast 'call lightning' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will let you do damage to your opponent using electricity."
    },
    "SPELL_CHARM_PERSON": {
        "usage": "cast 'charm' <victim>",
        "duration": "Permanent unless saved against",
        "accumulative": "No",
        "description": "This spell will try to charm a person. A charmed person will follow you, and obey most of your orders."
    },
    "SPELL_CHILL_TOUCH": {
        "usage": "cast 'chill touch' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell is a damaging cold spell. Unlike the fire spells like 'fireball' and 'burning hands', this spell will not do damage at a distance. You must be in the same room as your opponent. You can actually kill your opponent with this spell."
    },
    "SPELL_COLOUR_SPRAY": {
        "usage": "cast 'colour spray' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will possibly blind your opponent. It does a small amount of damage to everyone in the room except the group members of the caster."
    },
    "SPELL_CONTROL_WEATHER": {
        "usage": "cast 'control weather' <'better' | 'worse'>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will change the weather in the direction you wish. You can use this spell to call lightning upon someone.\n\nSee also: CALL LIGHTNING"
    },
    "SPELL_CREATE_FOOD": {
        "usage": "cast 'create food'",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell instantly creates a magic mushroom. It's not very filling, but it will keep you alive."
    },
    "SPELL_CREATE_WATER": {
        "usage": "cast 'create water' <drink container>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "When you cast this spell at a drink container, you will fill it with water."
    },
    "SPELL_CURE_BLIND": {
        "usage": "cast 'cure blind' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will cure the effect of a 'blindness' spell cast upon you or on another character.\n\nSee also: BLINDNESS"
    },
    "SPELL_CURE_CRITIC": {
        "usage": "cast 'cure critic' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell cures 3d8+3 Hitpoints of damage.\n\nSee also: CURE LIGHT, CURE SERIOUS"
    },
    "SPELL_CURE_LIGHT": {
        "usage": "cast 'cure light' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell cures 1d8+1 Hitpoints of damage.\n\nSee also: CURE CRITIC, CURE SERIOUS"
    },
    "SPELL_CURE_SERIOUS": {
        "usage": "cast 'cure serious' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell cures 2d8+2 Hitpoints of damage.\n\nSee also: CURE LIGHT, CURE CRITIC"
    },
    "SPELL_CURSE": {
        "usage": "cast 'curse' <victim | object>",
        "duration": "7 Days",
        "accumulative": "No",
        "description": "This spell will make your victim weaker in melee combat, giving a -1 modifier on the hitroll. If you cast this spell at an object, it will prevent you from removing that object if you wear it. The only way to remove the curse from an item is by using the spell remove curse. The only way to cure a cursed person is by the spell remove curse.\n\nSee also: REMOVE CURSE"
    },
    "SPELL_DETECT_INVISIBILITY": {
        "usage": "cast 'detect invisibility'",
        "duration": "12 Hours + Level/4 Hours",
        "accumulative": "No",
        "description": "This spell enables you to see invisible objects and beings."
    },
    "SPELL_DETECT_MAGIC": {
        "usage": "cast 'detect magic'",
        "duration": "12 Hours + Level/4 Hours",
        "accumulative": "No",
        "description": "This spell enables you to see if an object or character is magical or influenced by a magical spell."
    },
    "SPELL_DETECT_POISON": {
        "usage": "cast 'detect poison' <victim | food | drink>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will tell you whether a person, a piece of food or a drink is poisoned. If cast at a person, it will only detect the spell 'poison'. It will not detect natural poisons from for instance snakes."
    },
    "SPELL_DISPEL_EVIL": {
        "usage": "cast 'dispel evil' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will cause damage to an evil creature."
    },
    "SPELL_DISPEL_GOOD": {
        "usage": "cast 'dispel good' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will cause damage to a good creature."
    },
    "SPELL_EARTHQUAKE": {
        "usage": "cast 'earthquake'",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will damage all persons in the same room except for members of the caster's group."
    },
    "SPELL_ENCHANT_WEAPON": {
        "usage": "cast 'enchant weapon' <weapon>",
        "duration": "Permanent",
        "accumulative": "-",
        "description": "This spell makes a weapon magical. When a weapon is magical, it will gain magical bonuses."
    },
    "SPELL_ENERGY_DRAIN": {
        "usage": "cast 'energy drain' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This is one of the most feared spells. By casting this spell at your opponent you will do damage and drain levels from your victim."
    },
    "SPELL_FIREBALL": {
        "usage": "cast 'fireball' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell is one of the most powerful area spells you can cast. This spell will damage your opponent and everyone in the room, except for the members of your group."
    },
    "SPELL_HARM": {
        "usage": "cast 'harm' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This is a very powerful damaging spell. It will reduce your opponent's Hitpoints to 1d4 points."
    },
    "SPELL_HEAL": {
        "usage": "cast 'heal' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This is the most powerful healing spell. It will completely cure all your Hitpoints. It will also cure the disease caused by the spell 'poison' or natural poison.\n\nSee also: POISON"
    },
    "SPELL_INVISIBILITY": {
        "usage": "cast 'invisibility' [target]",
        "duration": "24 Hours",
        "accumulative": "No",
        "description": "This spell makes you or the target invisible. If you're invisible you can't be seen by persons without the ability to sense invisible. Being invisible gives you great advantages in battle. If you attack someone or cast an offensive spell, the spell will wear off.\n\nSee also: DETECT INVISIBILITY"
    },
    "SPELL_LIGHTNING_BOLT": {
        "usage": "cast 'lightning bolt' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will do a large amount of damage to your opponent by casting lightning at your opponent. This is an electrical spell."
    },
    "SPELL_LOCATE_OBJECT": {
        "usage": "cast 'locate object' <object>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will tell you the locations of all objects with the name you specified."
    },
    "SPELL_MAGIC_MISSILE": {
        "usage": "cast 'magic missile' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will cause some damage to your opponent. It never misses its target, and it doesn't cost much mana, which makes it very popular at lower levels."
    },
    "SPELL_POISON": {
        "usage": "cast 'poison' <victim | food | drink>",
        "duration": "Variable",
        "accumulative": "No",
        "description": "This spell will poison a person, food or drink. If cast at a person, it will damage the person every 'tick' (A tick is usually between 45 and 75 seconds). When cast at food or drink, the person eating the food or drinking the drink will become poisoned."
    },
    "SPELL_PROTECTION_FROM_EVIL": {
        "usage": "cast 'protection from evil'",
        "duration": "24 Hours",
        "accumulative": "No",
        "description": "This spell will protect you from evil creatures. You will gain a +1 modifier on your saving throws when attacked by evil persons, and your AC will improve by 1 point when attacked by evil creatures."
    },
    "SPELL_REMOVE_CURSE": {
        "usage": "cast 'remove curse' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will remove a curse from a person or an object.\n\nSee also: CURSE"
    },
    "SPELL_REMOVE_POISON": {
        "usage": "cast 'remove poison' <victim | food | drink>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will remove the effects of poison from a person, food or drink.\n\nSee also: POISON"
    },
    "SPELL_SANCTUARY": {
        "usage": "cast 'sanctuary' [target]",
        "duration": "4 Hours",
        "accumulative": "No",
        "description": "This spell will decrease all the damage done to you by a factor 2."
    },
    "SPELL_SHOCKING_GRASP": {
        "usage": "cast 'shocking grasp' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will damage your opponent by use of electricity."
    },
    "SPELL_SLEEP": {
        "usage": "cast 'sleep' <victim>",
        "duration": "4+Level Hours",
        "accumulative": "Yes",
        "description": "This spell will make your victim go to sleep. When you are asleep, you will only wake up if you're attacked. You may not issue any commands while asleep. You can also 'wake' yourself or others up."
    },
    "SPELL_STRENGTH": {
        "usage": "cast 'strength' [target]",
        "duration": "Level+4 Hours",
        "accumulative": "No",
        "description": "This spell increases the strength of a character temporarily."
    },
    "SPELL_WORD_OF_RECALL": {
        "usage": "cast 'word of recall'",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will teleport you to a place of safety, as specified by your god. If you don't have a god, this spell will teleport you to the Temple of Midgaard."
    },
    "SPELL_REMOVE_PARALYSIS": {
        "usage": "cast 'remove paralysis' [target]",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This spell will remove paralysis from a person."
    },
    "SPELL_CONE_OF_COLD": {
        "usage": "cast 'cone of cold' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This is a cold spell that will damage your opponent."
    },
    "SPELL_FLAMESTRIKE": {
        "usage": "cast 'flamestrike' <victim>",
        "duration": "Instantaneous",
        "accumulative": "-",
        "description": "This is a fire spell that will damage your opponent."
    },
    "SPELL_POWER_WORD_STUN": {
        "usage": "cast 'power word stun' <victim>",
        "duration": "1 Round + 1 Round/4 Levels",
        "accumulative": "Yes",
        "description": "This spell will stun your opponent, making it impossible for the victim to do anything for a short while."
    },
    "SPELL_FIRESHIELD": {
        "usage": "cast 'fireshield'",
        "duration": "24 Hours",
        "accumulative": "No",
        "description": "When someone strikes you in combat, the attacker will receive fire damage."
    },
    "SPELL_COLDSHIELD": {
        "usage": "cast 'coldshield'",
        "duration": "24 Hours",
        "accumulative": "No",
        "description": "When someone strikes you in combat, the attacker will receive cold damage."
    }
}

# Implementation data (64 ASPELL implementations from previous analysis)
IMPLEMENTATION_DATA = {
    "SPELL_ARMOR": {
        "pattern": "SIMPLE_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying AC bonus, messages sent to caster/room/target, duration set"
    },
    "SPELL_BLESS": {
        "pattern": "SIMPLE_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying hit bonus, messages sent to caster/room/target, duration set"
    },
    "SPELL_BLINDNESS": {
        "pattern": "DEBUFF_WITH_CHECKS",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Checks for existing blindness, GODMODE, saving throw, sends messages, applies affect"
    },
    "SPELL_BURNING_HANDS": {
        "pattern": "DAMAGE_WITH_EFFECT",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Deals fire damage, 20% chance to blind victim on failed save"
    },
    "SPELL_CALL_LIGHTNING": {
        "pattern": "CONDITIONAL_DAMAGE",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Only works outdoors in storm conditions, damage scales with level (7d8 + level)"
    },
    "SPELL_CHARM_PERSON": {
        "pattern": "CHARM_SPELL",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Complex charm logic: checks existing charm, MOB/player restrictions, circle of death, charm limits"
    },
    "SPELL_CHILL_TOUCH": {
        "pattern": "DAMAGE_WITH_DEBUFF",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Deals cold damage, applies SPELL_CHILL_TOUCH affect (likely strength reduction)"
    },
    "SPELL_COLOUR_SPRAY": {
        "pattern": "AOE_DEBUFF",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Room-wide spell excluding group, applies blindness with saving throw"
    },
    "SPELL_CONTROL_WEATHER": {
        "pattern": "WORLD_EFFECT",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Modifies global weather state, requires outdoor location, better/worse argument parsing"
    },
    "SPELL_CREATE_FOOD": {
        "pattern": "OBJECT_CREATION",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Creates food object (ITEM_FOOD) with level-based nutrition, loads from specific vnum"
    },
    "SPELL_CREATE_WATER": {
        "pattern": "OBJECT_MODIFICATION",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Modifies drink container capacity based on level and weather, requires specific item type checks"
    },
    "SPELL_CURE_BLIND": {
        "pattern": "AFFLICTION_REMOVAL",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Simple affect removal for SPELL_BLINDNESS"
    },
    "SPELL_CURE_CRITIC": {
        "pattern": "HEALING_SPELL",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Heals 3d8+3 HP, standard healing messages"
    },
    "SPELL_CURE_LIGHT": {
        "pattern": "HEALING_SPELL",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Heals 1d8+1 HP, standard healing messages"
    },
    "SPELL_CURE_SERIOUS": {
        "pattern": "HEALING_SPELL",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Heals 2d8+2 HP, standard healing messages"
    },
    "SPELL_CURSE": {
        "pattern": "DEBUFF_WITH_CHECKS",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Can target char or object, applies NODROP to objects or hitroll penalty to chars, saving throw"
    },
    "SPELL_DETECT_INVISIBILITY": {
        "pattern": "SENSE_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying SENSE_INVIS, level-based duration (12 + level/4 hours)"
    },
    "SPELL_DETECT_MAGIC": {
        "pattern": "SENSE_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying DETECT_MAGIC, level-based duration (12 + level/4 hours)"
    },
    "SPELL_DETECT_POISON": {
        "pattern": "DETECTION_SPELL",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Checks char/object for poison, handles food/drink/fountain, SPELL_POISON affect detection"
    },
    "SPELL_DISPEL_EVIL": {
        "pattern": "ALIGNMENT_DAMAGE",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Damage based on caster/victim alignment, no damage if victim good, complex formula"
    },
    "SPELL_DISPEL_GOOD": {
        "pattern": "ALIGNMENT_DAMAGE",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Damage based on caster/victim alignment, no damage if victim evil, complex formula"
    },
    "SPELL_EARTHQUAKE": {
        "pattern": "AOE_DAMAGE",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Room-wide damage excluding group and flying victims, level-based damage (2d8 + level)"
    },
    "SPELL_ENCHANT_WEAPON": {
        "pattern": "OBJECT_ENHANCEMENT",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Complex weapon enchanting: checks weapon type, applies magical flag, modifies hitroll/damroll"
    },
    "SPELL_ENERGY_DRAIN": {
        "pattern": "LEVEL_DRAIN",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Drains levels and experience, multiple saving throws, severe penalties, complex calculations"
    },
    "SPELL_FIREBALL": {
        "pattern": "AOE_DAMAGE",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Room-wide fire damage excluding group, level-based damage (11d6 + level)"
    },
    "SPELL_HARM": {
        "pattern": "SEVERE_DAMAGE",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Reduces victim HP to 1d4, except undead (1d8 + 50 healing), unique mechanics"
    },
    "SPELL_HEAL": {
        "pattern": "FULL_HEALING",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Restores 100 + dice(4, 8) HP, cures poison and blindness, standard messages"
    },
    "SPELL_INVISIBILITY": {
        "pattern": "STEALTH_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying INVISIBLE and HIDDEN, 24 hour duration, messages sent"
    },
    "SPELL_LIGHTNING_BOLT": {
        "pattern": "SIMPLE_DAMAGE",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Deals lightning damage (7d8 + level), standard damage messages"
    },
    "SPELL_LOCATE_OBJECT": {
        "pattern": "DIVINATION",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Searches world for objects matching name, complex location logic, level limits"
    },
    "SPELL_MAGIC_MISSILE": {
        "pattern": "SIMPLE_DAMAGE",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Deals magic damage (1d6 + 1 per 2 levels, max 10), standard damage messages"
    },
    "SPELL_POISON": {
        "pattern": "AFFLICTION_APPLICATION",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Can target char or food/drink, applies poison affect or modifies object, saving throw for chars"
    },
    "SPELL_PROTECTION_FROM_EVIL": {
        "pattern": "PROTECTIVE_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying PROT_FROM_EVIL, 24 hour duration, AC and saving throw bonuses"
    },
    "SPELL_REMOVE_CURSE": {
        "pattern": "AFFLICTION_REMOVAL",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Can target char or object, removes SPELL_CURSE affect or NODROP flag from objects"
    },
    "SPELL_REMOVE_POISON": {
        "pattern": "AFFLICTION_REMOVAL",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Can target char or food/drink, removes poison affect or unpoisonous object, complex object handling"
    },
    "SPELL_SANCTUARY": {
        "pattern": "PROTECTIVE_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying SANCTUARY (halves damage), 4 hour duration, messages sent"
    },
    "SPELL_SHOCKING_GRASP": {
        "pattern": "SIMPLE_DAMAGE",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Deals electric damage (5d8 + level), standard damage messages"
    },
    "SPELL_SLEEP": {
        "pattern": "DISABLE_SPELL",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Complex sleep logic: checks existing sleep, MOB restrictions, position changes, affects attacks"
    },
    "SPELL_STRENGTH": {
        "pattern": "STAT_BUFF",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Standard buff applying STRENGTH, level-based duration (level + 4 hours), messages sent"
    },
    "SPELL_WORD_OF_RECALL": {
        "pattern": "TELEPORTATION",
        "configurability": "CUSTOM_LOGIC_REQUIRED",
        "hasCustomLogic": True,
        "notes": "Teleports to loadroom or temple, checks following, combat restrictions, complex location logic"
    },
    "SPELL_REMOVE_PARALYSIS": {
        "pattern": "AFFLICTION_REMOVAL",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Simple affect removal for paralysis"
    },
    "SPELL_CONE_OF_COLD": {
        "pattern": "SIMPLE_DAMAGE",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Deals cold damage, standard damage messages"
    },
    "SPELL_FLAMESTRIKE": {
        "pattern": "SIMPLE_DAMAGE",
        "configurability": "FULLY_CONFIGURABLE",
        "hasCustomLogic": False,
        "notes": "Deals fire damage, standard damage messages"
    },
    "SPELL_POWER_WORD_STUN": {
        "pattern": "DISABLE_SPELL",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Stuns victim, level-based duration (1 + level/4 rounds), checks position, saving throw"
    },
    "SPELL_FIRESHIELD": {
        "pattern": "REACTIVE_BUFF",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Standard buff with reactive damage component (fire damage to attackers)"
    },
    "SPELL_COLDSHIELD": {
        "pattern": "REACTIVE_BUFF",
        "configurability": "MOSTLY_CONFIGURABLE",
        "hasCustomLogic": True,
        "notes": "Standard buff with reactive damage component (cold damage to attackers)"
    }
}


def title_case_spell_name(name: str) -> str:
    """Convert spell name to proper title case."""
    # Remove SPELL_ prefix if present
    if name.startswith("SPELL_"):
        name = name[6:]

    # Special cases for abbreviations and proper nouns
    special_cases = {
        "ac": "AC",
        "hp": "HP",
        "prot": "Protection"
    }

    # Split on underscores and convert to title case
    words = name.lower().split('_')
    result = []
    for word in words:
        if word in special_cases:
            result.append(special_cases[word])
        else:
            result.append(word.capitalize())

    return ' '.join(result)


def assess_configurability(spell: Dict, impl: Optional[Dict]) -> str:
    """Assess spell configurability based on implementation and routines."""
    if impl:
        return impl.get("configurability", "PARTIALLY_CONFIGURABLE")

    # Check routines for simple patterns
    routines = spell.get("routines", [])

    # Has MAG_MANUAL - requires custom logic
    if "MAG_MANUAL" in routines:
        return "CUSTOM_LOGIC_REQUIRED"

    # Simple buff/damage spells are fully configurable
    simple_routines = {"MAG_AFFECT", "MAG_POINT", "MAG_AREA"}
    if routines and all(r in simple_routines for r in routines):
        return "FULLY_CONFIGURABLE"

    # Complex combinations need partial configuration
    if len(routines) > 1:
        return "PARTIALLY_CONFIGURABLE"

    return "PARTIALLY_CONFIGURABLE"


def main():
    # Read spell metadata
    metadata_path = Path("/home/strider/Code/mud/fierymud/spell_metadata.json")
    with open(metadata_path) as f:
        metadata = json.load(f)

    # Process spells
    complete_spells = []
    csv_rows = []

    # Metadata is a dict keyed by spell ID
    for spell_id_str, spell in metadata.items():
        spell_id = int(spell_id_str)
        enum_name = spell["enumName"]
        name = spell["name"]

        # Generate display name
        display_name = title_case_spell_name(name)

        # Get help text if available (try multiple naming variations)
        help_text = HELP_TEXT_DATA.get(enum_name)
        if not help_text and not enum_name.endswith("_PERSON"):
            help_text = HELP_TEXT_DATA.get(enum_name + "_PERSON")
        if not help_text and "COLOR" in enum_name:
            help_text = HELP_TEXT_DATA.get(enum_name.replace("COLOR", "COLOUR"))

        # Get implementation data if available (try multiple naming variations)
        impl = IMPLEMENTATION_DATA.get(enum_name)
        if not impl and not enum_name.endswith("_PERSON"):
            impl = IMPLEMENTATION_DATA.get(enum_name + "_PERSON")
        if not impl and "COLOR" in enum_name:
            impl = IMPLEMENTATION_DATA.get(enum_name.replace("COLOR", "COLOUR"))

        # Build complete spell entry
        complete_spell = {
            "id": spell_id,
            "enumName": enum_name,
            "name": name,
            "displayName": display_name,
            "minPosition": spell.get("minPosition", "POS_STANDING"),
            "violent": spell.get("violent", False),
            "castTimeRounds": spell.get("castTimeRounds", 1.0),
            "castTimeSpeed": spell.get("castTimeSpeed", "CAST_SPEED1"),
            "damageType": spell.get("damageType", "DAM_UNDEFINED"),
            "sphere": spell.get("sphere", "SKILL_SPHERE_GENERIC"),
            "humanoidOnly": spell.get("humanoidOnly", False),
            "targets": spell.get("targets", []),
            "routines": spell.get("routines", []),
            "additionalMemTime": spell.get("additionalMemTime", 0),
            "pages": spell.get("pages", 1),
            "questSpell": spell.get("questSpell", False),
            "wearOffMessage": spell.get("wearOffMessage"),
            "fightingOk": spell.get("fightingOk", False),
            "helpText": help_text,
            "implementation": impl
        }

        complete_spells.append(complete_spell)

        # Build CSV row
        configurability = assess_configurability(spell, impl)
        csv_rows.append({
            "id": spell_id,
            "name": name,
            "displayName": display_name,
            "castTimeRounds": spell["castTimeRounds"],
            "violent": spell["violent"],
            "minPosition": spell["minPosition"],
            "damageType": spell["damageType"],
            "sphere": spell["sphere"],
            "configurability": configurability,
            "questSpell": spell["questSpell"]
        })

    # Write complete JSON
    output_json = Path("/home/strider/Code/mud/fierylib/seeds/spells_complete.json")
    with open(output_json, 'w') as f:
        json.dump({"spells": complete_spells}, f, indent=2)
    print(f"Created {output_json} with {len(complete_spells)} spells")

    # Write CSV
    output_csv = Path("/home/strider/Code/mud/fierylib/seeds/spells_basic.csv")
    with open(output_csv, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=[
            "id", "name", "displayName", "castTimeRounds", "violent",
            "minPosition", "damageType", "sphere", "configurability", "questSpell"
        ])
        writer.writeheader()
        writer.writerows(csv_rows)
    print(f"Created {output_csv} with {len(csv_rows)} spells")

    # Print summary statistics
    print(f"\nSummary:")
    print(f"  Total spells: {len(complete_spells)}")
    print(f"  With help text: {sum(1 for s in complete_spells if s['helpText'])}")
    print(f"  With implementation data: {sum(1 for s in complete_spells if s['implementation'])}")
    print(f"  Fully configurable: {sum(1 for r in csv_rows if r['configurability'] == 'FULLY_CONFIGURABLE')}")
    print(f"  Partially configurable: {sum(1 for r in csv_rows if r['configurability'] == 'PARTIALLY_CONFIGURABLE')}")
    print(f"  Custom logic required: {sum(1 for r in csv_rows if r['configurability'] == 'CUSTOM_LOGIC_REQUIRED')}")


if __name__ == "__main__":
    main()
