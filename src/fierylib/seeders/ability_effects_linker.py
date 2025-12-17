"""Link abilities to their effects based on legacy spell implementations."""

import csv
import json
import click
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from prisma import Prisma


# =============================================================================
# Legacy Effect Mappings
# =============================================================================

# Map legacy EFF_* flags to new consolidated parameterized effects
# All effects now use the 18-effect consolidated schema
EFF_FLAG_MAPPINGS: Dict[str, Tuple[str, Dict[str, Any]]] = {
    # Simple status effects (flag-only)
    "EFF_BLESS": ("status", {"flag": "bless"}),
    "EFF_CURSE": ("status", {"flag": "curse"}),
    "EFF_SANCTUARY": ("status", {"flag": "sanctuary"}),
    "EFF_HASTE": ("status", {"flag": "haste"}),
    "EFF_STONE_SKIN": ("status", {"flag": "stoneskin"}),
    "EFF_BERSERK": ("status", {"flag": "berserk"}),
    "EFF_AWARE": ("status", {"flag": "aware"}),
    "EFF_FLY": ("status", {"flag": "fly"}),
    "EFF_WATERWALK": ("status", {"flag": "waterwalk"}),
    "EFF_WATERBREATH": ("status", {"flag": "waterbreath"}),
    "EFF_FEATHER_FALL": ("status", {"flag": "featherfall"}),
    "EFF_NIMBLE": ("status", {"flag": "nimble"}),
    "EFF_LIGHT": ("status", {"flag": "glowing"}),

    # Crowd control -> status with CC flags
    "EFF_BLIND": ("status", {"flag": "blinded"}),
    "EFF_SLEEP": ("status", {"flag": "sleeping"}),
    "EFF_PARALYSIS": ("status", {"flag": "paralyzed"}),
    "EFF_MINOR_PARALYSIS": ("status", {"flag": "paralyzed", "breakOnDamage": True}),
    "EFF_MAJOR_PARALYSIS": ("status", {"flag": "paralyzed"}),
    "EFF_SILENCE": ("status", {"flag": "silenced"}),
    "EFF_FEAR": ("status", {"flag": "feared"}),
    "EFF_CONFUSION": ("status", {"flag": "confused"}),
    "EFF_CHARM": ("status", {"flag": "charmed"}),
    "EFF_MESMERIZED": ("status", {"flag": "mesmerized"}),
    "EFF_INSANITY": ("status", {"flag": "confused"}),  # Map to confused
    "EFF_WEB": ("status", {"flag": "webbed"}),
    "EFF_IMMOBILIZED": ("status", {"flag": "webbed"}),  # Map to webbed
    "EFF_SLOW": ("status", {"flag": "slowed"}),

    # DoT effects -> damage with interval/duration
    "EFF_POISON": ("damage", {"type": "poison", "amount": "2%", "interval": 1, "duration": 30}),
    "EFF_DISEASE": ("damage", {"type": "poison", "amount": "3%", "interval": 1, "duration": 30}),
    "EFF_ON_FIRE": ("damage", {"type": "fire", "amount": "5%", "interval": 1, "duration": 10}),

    # Stealth -> status with stealth flags
    "EFF_INVISIBLE": ("status", {"flag": "invisible"}),
    "EFF_CAMOUFLAGED": ("status", {"flag": "camouflaged"}),

    # Detection -> status with detect_* flags
    "EFF_DETECT_INVIS": ("status", {"flag": "detect_invisible"}),
    "EFF_DETECT_MAGIC": ("status", {"flag": "detect_magic"}),
    "EFF_DETECT_ALIGN": ("status", {"flag": "detect_align"}),
    "EFF_DETECT_POISON": ("status", {"flag": "detect_poison"}),
    "EFF_SENSE_LIFE": ("status", {"flag": "detect_life"}),
    "EFF_INFRAVISION": ("status", {"flag": "infravision"}),
    "EFF_ULTRAVISION": ("status", {"flag": "ultravision"}),
    "EFF_FARSEE": ("status", {"flag": "detect_hidden"}),

    # Protection -> status with resistance flag
    "EFF_PROT_FIRE": ("status", {"flag": "resistance", "type": "fire", "amount": 50}),
    "EFF_PROT_COLD": ("status", {"flag": "resistance", "type": "cold", "amount": 50}),
    "EFF_PROT_ACID": ("status", {"flag": "resistance", "type": "acid", "amount": 50}),
    "EFF_PROT_SHOCK": ("status", {"flag": "resistance", "type": "shock", "amount": 50}),
    "EFF_PROT_AIR": ("status", {"flag": "resistance", "type": "air", "amount": 50}),
    "EFF_PROT_EARTH": ("status", {"flag": "resistance", "type": "earth", "amount": 50}),
    "EFF_PROTECT_EVIL": ("status", {"flag": "resistance", "type": "unholy", "amount": 25}),
    "EFF_PROTECT_GOOD": ("status", {"flag": "resistance", "type": "holy", "amount": 25}),
    "EFF_NEGATE_HEAT": ("status", {"flag": "resistance", "type": "fire", "amount": 100}),
    "EFF_NEGATE_COLD": ("status", {"flag": "resistance", "type": "cold", "amount": 100}),
    "EFF_NEGATE_AIR": ("status", {"flag": "resistance", "type": "air", "amount": 100}),

    # Elemental hands -> status with elemental_hands flag
    "EFF_FIREHANDS": ("status", {"flag": "elemental_hands", "type": "fire", "amount": 25}),
    "EFF_ICEHANDS": ("status", {"flag": "elemental_hands", "type": "cold", "amount": 25}),
    "EFF_LIGHTNING_HANDS": ("status", {"flag": "elemental_hands", "type": "shock", "amount": 25}),
    "EFF_ACID_HANDS": ("status", {"flag": "elemental_hands", "type": "acid", "amount": 25}),

    # Globe effects (keep as globe)
    "EFF_MINOR_GLOBE": ("globe", {"maxCircle": 3}),
    "EFF_MAJOR_GLOBE": ("globe", {"maxCircle": 6}),

    # Shield effects -> status with reflect flag
    "EFF_FIRESHIELD": ("status", {"flag": "reflect", "type": "fire", "amount": 25}),
    "EFF_COLDSHIELD": ("status", {"flag": "reflect", "type": "cold", "amount": 25}),

    # Lifesteal -> status with lifesteal flag
    "EFF_VAMP_TOUCH": ("status", {"flag": "lifesteal", "amount": 25}),

    # Misc status effects
    "EFF_HARNESS": ("status", {"flag": "empowered", "consumeOnCast": True}),  # Empower next spell
    "EFF_TETHERED": ("status", {"flag": "taunted"}),
    "EFF_FAMILIARITY": ("status", {"flag": "detect_hidden"}),
    "EFF_RAY_OF_ENFEEB": ("modify", {"target": "str", "amount": -4}),
    "EFF_SPIRIT_WOLF": ("transform", {"form": "wolf"}),
    "EFF_SPIRIT_BEAR": ("transform", {"form": "bear"}),
    "EFF_SONG_OF_REST": ("heal", {"resource": "hp", "amount": "level"}),
    "EFF_DISPLACEMENT": ("status", {"flag": "invisible"}),  # Map to invisible
    "EFF_GREATER_DISPLACEMENT": ("status", {"flag": "invisible"}),
    "EFF_MISDIRECTION": ("status", {"flag": "camouflaged"}),
    "EFF_WRATH": ("modify", {"target": "damroll", "amount": 2}),
    "EFF_GLORY": ("status", {"flag": "sanctuary"}),
    "EFF_BLUR": ("status", {"flag": "invisible"}),
    "EFF_NOPAIN": ("status", {"flag": "berserk"}),
}

# Map damage types to damage effect parameters
DAMAGE_TYPE_MAPPINGS: Dict[str, str] = {
    "DAM_FIRE": "fire",
    "DAM_COLD": "cold",
    "DAM_ACID": "acid",
    "DAM_SHOCK": "shock",
    "DAM_POISON": "poison",
    "DAM_ALIGN": "holy",  # alignment damage
    "DAM_CRUSH": "physical",
    "DAM_SLASH": "physical",
    "DAM_PIERCE": "physical",
    "DAM_MAGIC": "magic",
    "DAM_WATER": "cold",  # water damage mapped to cold
    "DAM_ROT": "poison",  # decay/rot mapped to poison
}

# Spells where APPLY_AC should use ward stat instead of eva
# These are magical armor spells that provide Ward% (magical damage reduction)
# rather than EVA (evasion/dodge) - see COMBAT_CLARIFICATIONS.md Q9
WARD_MOD_SPELLS = {
    "SPELL_ARMOR",
    "SPELL_BARKSKIN",
    "SPELL_BONE_ARMOR",
    "SPELL_CLOAK_OF_GAIA",
    "SPELL_DEMONSKIN",
    "SPELL_ICE_ARMOR",
}

# Map APPLY_* types to the consolidated 'modify' effect
# All modifiers now use 'modify' with a 'target' parameter
APPLY_MAPPINGS: Dict[str, Tuple[str, str]] = {
    # Combat modifiers (all use modify)
    "APPLY_HITROLL": ("modify", "hitroll"),
    "APPLY_AC": ("modify", "eva"),  # Default is evasion; ward override in map_legacy_effect
    "APPLY_DAMROLL": ("modify", "damroll"),

    # Stats
    "APPLY_STR": ("modify", "str"),
    "APPLY_DEX": ("modify", "dex"),
    "APPLY_CON": ("modify", "con"),
    "APPLY_INT": ("modify", "int"),
    "APPLY_WIS": ("modify", "wis"),
    "APPLY_CHA": ("modify", "cha"),

    # Resources (max values)
    "APPLY_HIT": ("modify", "max_hp"),
    "APPLY_MAX_HIT": ("modify", "max_hp"),
    "APPLY_MANA": ("modify", "max_mana"),
    "APPLY_MAX_MANA": ("modify", "max_mana"),
    "APPLY_MOVE": ("modify", "max_move"),
    "APPLY_MAX_MOVE": ("modify", "max_move"),

    # Saving throws
    "APPLY_SAVING_PARA": ("modify", "save_para"),
    "APPLY_SAVING_ROD": ("modify", "save_rod"),
    "APPLY_SAVING_PETRI": ("modify", "save_petri"),
    "APPLY_SAVING_BREATH": ("modify", "save_breath"),
    "APPLY_SAVING_SPELL": ("modify", "save_spell"),

    # Size
    "APPLY_SIZE": ("modify", "size"),
}


class AbilityEffectsLinker:
    """Links abilities to their effects based on legacy spell implementations."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self.spell_data: Dict[str, Any] = {}
        self.effect_cache: Dict[str, int] = {}  # name -> id
        self.ability_cache: Dict[str, int] = {}  # name -> id
        self.extraction_data: Dict[str, Dict] = {}  # From abilities.csv (authoritative source)
        self.stats = {
            "total_abilities": 0,
            "linked": 0,
            "no_effects": 0,
            "not_found": 0,
            "errors": 0,
            "effects_created": 0,
        }
        self.unlinked: List[Dict[str, Any]] = []

    async def load_spell_implementations(self, json_path: Path) -> None:
        """Load spell implementations from JSON file."""
        with open(json_path) as f:
            self.spell_data = json.load(f)
        click.echo(f"  Loaded {len(self.spell_data)} spell implementations")

    def load_extraction_data(self) -> None:
        """Load ability metadata from abilities.csv (authoritative source from skills.cpp).

        The abilities.csv is extracted from the actual spello() calls in skills.cpp,
        making it the authoritative source for damage types, minPosition, violent, etc.
        The all_spell_implementations.json has errors in some damage types.
        """
        extraction_path = Path(__file__).parent.parent.parent.parent / "docs/extraction-reports/abilities.csv"

        if not extraction_path.exists():
            click.echo(f"  Warning: Extraction data not found: {extraction_path}")
            return

        with open(extraction_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                # Key by lowercase name with underscores (matches spell names)
                name = row.get('name', '').lower()
                if name:
                    self.extraction_data[name] = {
                        'damageType': row.get('damageType', ''),
                        'minPosition': row.get('minPosition', 'STANDING'),
                        'violent': row.get('violent', 'false').lower() == 'true',
                        'combatOk': row.get('canUseInCombat', 'true').lower() == 'true',
                    }
        click.echo(f"  Loaded {len(self.extraction_data)} abilities from extraction CSV (authoritative)")

    async def load_effects_cache(self) -> None:
        """Load all effects into cache for fast lookup."""
        effects = await self.prisma.effect.find_many()
        for effect in effects:
            self.effect_cache[effect.name] = effect.id
        click.echo(f"  Loaded {len(self.effect_cache)} effects into cache")

    async def load_abilities_cache(self) -> None:
        """Load all abilities into cache for fast lookup by plainName."""
        abilities = await self.prisma.ability.find_many()
        for ability in abilities:
            # Use plainName (CODE_STYLE) as key for matching with JSON
            self.ability_cache[ability.plainName] = ability.id
        click.echo(f"  Loaded {len(self.ability_cache)} abilities into cache")

    def normalize_spell_name(self, name: str) -> List[str]:
        """Normalize ability name to match JSON keys. Returns list of possible keys to try."""
        # Database has names like:
        # 1. CODE style: "ARMOR", "BLESS", "ACID_BREATH"
        # 2. Display style: "Armor", "Bless", "Acid Breath"
        # JSON has names like "SPELL_ARMOR", "SPELL_BLESS", "CHANT_*"

        keys_to_try = []

        # If already uppercase with underscores, use directly
        if name.isupper() or "_" in name:
            code_name = name.upper()
        else:
            # Convert display name like "Acid Breath" to "ACID_BREATH"
            code_name = name.upper().replace(" ", "_")

        # Add primary key variations
        keys_to_try.append(f"SPELL_{code_name}")
        keys_to_try.append(f"CHANT_{code_name}")
        keys_to_try.append(f"SKILL_{code_name}")
        keys_to_try.append(f"SONG_{code_name}")
        keys_to_try.append(code_name)

        return keys_to_try

    def get_effect_id(self, effect_name: str) -> Optional[int]:
        """Get effect ID from cache."""
        return self.effect_cache.get(effect_name)

    def map_legacy_effect(
        self, effect_data: Dict[str, Any], spell_key: Optional[str] = None
    ) -> Optional[Tuple[str, Dict[str, Any]]]:
        """Map a legacy effect to new parameterized effect.

        Args:
            effect_data: The legacy effect data to map
            spell_key: The spell key (e.g., "SPELL_ARMOR") for special handling
        """
        effect_type = effect_data.get("type", "")

        if effect_type == "effect_flag":
            flag = effect_data.get("flag", "")
            if flag in EFF_FLAG_MAPPINGS:
                return EFF_FLAG_MAPPINGS[flag]
            return None

        elif effect_type == "modifier":
            location = effect_data.get("location", "")
            modifier = effect_data.get("modifier", "")
            duration = effect_data.get("duration", "")

            # Match APPLY_ type from location
            for apply_type, (effect_name, target_type) in APPLY_MAPPINGS.items():
                if apply_type == location:
                    # Special case: APPLY_AC on magical armor spells uses "ward" target
                    # instead of "eva" target (see COMBAT_CLARIFICATIONS.md Q9)
                    if apply_type == "APPLY_AC" and spell_key in WARD_MOD_SPELLS:
                        target_type = "ward"
                    params = {"target": target_type, "amount": modifier}
                    if duration:
                        params["duration"] = duration
                    return (effect_name, params)

            return None

        return None

    def map_spell_type(self, spell_data: Dict[str, Any]) -> List[Tuple[str, Dict[str, Any], str]]:
        """Map spells based on their 'type' field.

        Uses consolidated 18-effect schema:
        - crowd_control → status with CC flags
        - create_object → create
        - cure → cleanse
        - dot → damage with interval/duration
        - room_barrier/room_effect → room with subtype
        - stat_mod → modify
        - lifesteal → status with lifesteal flag or damage with type=lifesteal
        - banish → extract
        """
        spell_type = spell_data.get("type", "")
        mechanics = spell_data.get("mechanics", {})
        effects = []

        if spell_type == "teleport":
            effects.append(("teleport", {"scope": "self"}, "on_cast"))
        elif spell_type == "group_teleport":
            effects.append(("teleport", {"scope": "group"}, "on_cast"))
        elif spell_type == "summon":
            effects.append(("summon", {"mobType": "creature"}, "on_cast"))
        elif spell_type == "mind_control":
            # crowd_control → status with charmed flag
            effects.append(("status", {"flag": "charmed"}, "on_cast"))
        elif spell_type == "level_drain":
            effects.append(("damage", {"type": "necrotic", "amount": "level_drain"}, "on_cast"))
        elif spell_type == "item_enhancement":
            # stat_mod → enchant (applies effect to item)
            effects.append(("enchant", {"effect": "modify", "target": "item_bonus", "amount": "skill/10"}, "on_cast"))
        elif spell_type == "damage_status":
            # Combo damage + status (like Color Spray)
            dmg = mechanics.get("damage", "1d6")
            effects.append(("damage", {"type": "magic", "amount": dmg}, "on_cast"))
            if "blind" in mechanics.get("description", "").lower():
                # crowd_control → status with blinded flag
                effects.append(("status", {"flag": "blinded"}, "on_cast"))
        elif spell_type == "damage_multihit":
            # Multiple hit damage (Magic Missile)
            dmg = mechanics.get("damage_per_missile", "4d21")
            effects.append(("damage", {"type": "magic", "amount": dmg, "multihit": True}, "on_cast"))
        elif spell_type == "area_damage_dot":
            # Area damage over time (Creeping Doom) - dot → damage with interval/duration
            effects.append(("damage", {"type": "physical", "amount": "2d6", "interval": 1, "duration": 10, "area": True}, "on_cast"))
        elif spell_type == "group_healing":
            formula = mechanics.get("formula", "1d8")
            effects.append(("heal", {"resource": "hp", "amount": formula, "area": True}, "on_cast"))
        elif spell_type == "group_buff":
            # Generic group buff - map to status
            effects.append(("status", {"flag": "armor", "area": True}, "on_cast"))
        elif spell_type == "creation":
            # Create object spells (food, water, etc.) - create_object → create
            effects.append(("create", {"objectType": mechanics.get("creates", "item")}, "on_cast"))
        elif spell_type == "dispel":
            # cure → cleanse (remove curses etc.)
            effects.append(("cleanse", {"condition": "curse"}, "on_cast"))
        elif spell_type == "curse":
            effects.append(("status", {"flag": "curse"}, "on_cast"))
        elif spell_type == "barrier":
            # Room barriers (walls) - room_barrier → room with subtype: barrier
            desc = mechanics.get("description", "")
            if "fog" in desc.lower():
                effects.append(("room", {"subtype": "barrier", "type": "fog"}, "on_cast"))
            elif "stone" in desc.lower():
                effects.append(("room", {"subtype": "barrier", "type": "stone"}, "on_cast"))
            elif "ice" in desc.lower():
                effects.append(("room", {"subtype": "barrier", "type": "ice"}, "on_cast"))
            else:
                effects.append(("room", {"subtype": "barrier", "type": "generic"}, "on_cast"))
        elif spell_type == "utility":
            # Various utility spells - try to categorize
            desc = mechanics.get("description", "").lower()
            if "locate" in desc or "find" in desc:
                effects.append(("reveal", {"type": "object"}, "on_cast"))
            elif "weather" in desc:
                # room_effect → room with subtype: effect
                effects.append(("room", {"subtype": "effect", "type": "weather"}, "on_cast"))
            elif "heal" in desc or "moonwell" in desc:
                effects.append(("heal", {"resource": "hp", "amount": "regen"}, "on_cast"))
            elif "reveal" in desc or "hidden" in desc or "invisible" in desc:
                effects.append(("reveal", {"type": "hidden"}, "on_cast"))
            elif "language" in desc or "tongue" in desc:
                effects.append(("status", {"flag": "comprehend_languages"}, "on_cast"))
            elif "preserve" in desc:
                effects.append(("status", {"flag": "preserve"}, "on_cast"))
            # Other utility spells don't map well to effects
        elif spell_type == "room_effect":
            # room_effect → room with subtype: effect
            desc = mechanics.get("description", "").lower()
            if "darkness" in desc or "dark" in desc:
                effects.append(("room", {"subtype": "effect", "type": "darkness"}, "on_cast"))
            elif "light" in desc or "illumin" in desc:
                effects.append(("room", {"subtype": "effect", "type": "light"}, "on_cast"))
            else:
                effects.append(("room", {"subtype": "effect", "type": "generic"}, "on_cast"))
        elif spell_type == "crowd_control":
            # crowd_control → status with CC flags
            desc = mechanics.get("description", "").lower()
            if "paralyz" in desc:
                effects.append(("status", {"flag": "paralyzed"}, "on_cast"))
            elif "stun" in desc:
                effects.append(("status", {"flag": "stunned"}, "on_cast"))
            elif "sleep" in desc:
                effects.append(("status", {"flag": "sleeping"}, "on_cast"))
            else:
                effects.append(("status", {"flag": "confused"}, "on_cast"))
        elif spell_type == "resurrection":
            effects.append(("resurrect", {"hpPercent": 0.1}, "on_cast"))
        elif spell_type == "area_damage":
            desc = mechanics.get("description", "").lower()
            if "fire" in desc or "burn" in desc:
                effects.append(("damage", {"type": "fire", "area": True}, "on_cast"))
            elif "cold" in desc or "ice" in desc:
                effects.append(("damage", {"type": "cold", "area": True}, "on_cast"))
            else:
                effects.append(("damage", {"type": "magic", "area": True}, "on_cast"))
        elif spell_type == "damage_dot":
            # dot → damage with interval/duration
            dmg = mechanics.get("damage", "1d6")
            effects.append(("damage", {"type": "magic", "amount": dmg, "interval": 1, "duration": 10}, "on_cast"))
        elif spell_type in ("buff", "chant_buff", "song_buff"):
            # Generic buff - try to categorize
            desc = mechanics.get("description", "").lower()
            effects.append(("status", {"flag": "buff", "description": desc}, "on_cast"))
        elif spell_type == "debuff":
            desc = mechanics.get("description", "").lower()
            effects.append(("status", {"flag": "debuff", "description": desc}, "on_cast"))
        elif spell_type in ("breath_skill", "breath_weapon"):
            # Breath attacks - damage with element
            dmg_type = mechanics.get("damage_type", "fire").lower()
            if "fire" in dmg_type:
                effects.append(("damage", {"type": "fire", "amount": "breath_formula"}, "on_cast"))
            elif "cold" in dmg_type or "frost" in dmg_type:
                effects.append(("damage", {"type": "cold", "amount": "breath_formula"}, "on_cast"))
            elif "acid" in dmg_type:
                effects.append(("damage", {"type": "acid", "amount": "breath_formula"}, "on_cast"))
            elif "shock" in dmg_type or "lightning" in dmg_type:
                effects.append(("damage", {"type": "shock", "amount": "breath_formula"}, "on_cast"))
            elif "gas" in dmg_type or "poison" in dmg_type:
                # Poison breath - damage with interval/duration
                effects.append(("damage", {"type": "poison", "amount": "breath_formula", "interval": 1, "duration": 5}, "on_cast"))
            else:
                effects.append(("damage", {"type": "physical", "amount": "breath_formula"}, "on_cast"))
        elif spell_type == "illusion":
            effects.append(("status", {"flag": "illusion"}, "on_cast"))
        elif spell_type == "item_creation":
            # create_object → create
            effects.append(("create", {"objectType": "magical_item"}, "on_cast"))
        elif spell_type == "planar_summon":
            effects.append(("summon", {"mobType": "planar"}, "on_cast"))
        elif spell_type in ("song_utility", "chant_utility"):
            effects.append(("status", {"flag": "song_effect"}, "on_cast"))
        elif spell_type == "vampiric":
            # lifesteal → damage with type=lifesteal (instant drain)
            effects.append(("damage", {"type": "lifesteal", "amount": "skill"}, "on_cast"))
        elif spell_type == "vampiric_dot":
            # Vampiric DoT - damage + lifesteal status
            effects.append(("status", {"flag": "lifesteal", "amount": 25}, "on_cast"))
            effects.append(("damage", {"type": "magic", "amount": "1d6", "interval": 1, "duration": 10}, "on_cast"))
        elif spell_type == "teleport_offensive":
            # banish → extract (remove mob from game)
            effects.append(("extract", {"target": "mob"}, "on_cast"))
        elif spell_type == "teleport_defensive":
            effects.append(("teleport", {"scope": "self", "destination": "escape"}, "on_cast"))
        elif spell_type == "damage_creation":
            # Damage that creates something (like corpse explosion)
            effects.append(("damage", {"type": "magic", "creates": True}, "on_cast"))

        return effects

    def get_authoritative_damage_type(self, spell_name: str) -> Optional[str]:
        """Get the authoritative damage type from abilities.csv extraction data.

        The extraction CSV is sourced directly from spello() calls in skills.cpp,
        making it more reliable than the JSON implementations which have errors.
        """
        # Try different name formats
        name_lower = spell_name.lower()
        keys_to_try = [
            name_lower,
            name_lower.replace('_', ' '),
            name_lower.replace(' ', '_'),
        ]

        for key in keys_to_try:
            if key in self.extraction_data:
                damage_type = self.extraction_data[key].get('damageType', '')
                if damage_type and damage_type != 'NONE':
                    # Map from CSV format (ACID, FIRE, etc.) to effect param format
                    return DAMAGE_TYPE_MAPPINGS.get(f"DAM_{damage_type}", damage_type.lower())

        return None

    def map_damage_spell(self, spell_data: Dict[str, Any], spell_name: str = "") -> Optional[Tuple[str, Dict[str, Any]]]:
        """Map a damage spell to damage effect.

        Prefers authoritative damage type from abilities.csv over JSON data.
        """
        damage_info = spell_data.get("damage", {})
        formula = damage_info.get("formula", "1d6")

        # First, try to get authoritative damage type from extraction CSV
        mapped_type = self.get_authoritative_damage_type(spell_name)

        # Fall back to JSON if not found in extraction data
        if not mapped_type:
            damage_type = damage_info.get("damage_type", "DAM_MAGIC")
            mapped_type = DAMAGE_TYPE_MAPPINGS.get(damage_type, "magic")

        return ("damage", {
            "type": mapped_type,
            "amount": formula,
        })

    def map_healing_spell(self, spell_data: Dict[str, Any]) -> Optional[Tuple[str, Dict[str, Any]]]:
        """Map a healing spell to heal effect."""
        healing_info = spell_data.get("healing", {})
        formula = healing_info.get("formula", "1d8")
        restores = healing_info.get("restores", "HP").lower()

        # Determine resource type
        if "movement" in restores or "move" in restores:
            resource = "move"
        elif "mana" in restores:
            resource = "mana"
        else:
            resource = "hp"

        return ("heal", {
            "resource": resource,
            "amount": formula,
        })

    async def link_ability(self, ability_name: str, ability_id: int, verbose: bool = False) -> bool:
        """Link an ability to its effects based on legacy data."""
        keys_to_try = self.normalize_spell_name(ability_name)

        # Try different name patterns
        spell_info = None
        matched_key = None

        for key in keys_to_try:
            if key in self.spell_data:
                spell_info = self.spell_data[key]
                matched_key = key
                break

        if not spell_info:
            self.stats["not_found"] += 1
            self.unlinked.append({
                "ability": ability_name,
                "reason": "No spell implementation found",
                "tried_keys": keys_to_try,
            })
            return False

        # Collect all effects for this spell
        effects_to_link: List[Tuple[str, Dict[str, Any], str]] = []  # (effect_name, params, trigger)

        spell_type = spell_info.get("type", "")

        # Handle damage spells
        if spell_type == "damage":
            mapping = self.map_damage_spell(spell_info, ability_name)
            if mapping:
                effects_to_link.append((mapping[0], mapping[1], "on_cast"))

        # Handle healing spells
        elif spell_type == "healing":
            mapping = self.map_healing_spell(spell_info)
            if mapping:
                effects_to_link.append((mapping[0], mapping[1], "on_cast"))

        # Handle other spell types (teleport, summon, mind_control, etc.)
        elif spell_type in (
            # Teleportation
            "teleport", "group_teleport", "teleport_offensive", "teleport_defensive",
            # Summoning
            "summon", "planar_summon",
            # Mind/Control
            "mind_control", "crowd_control",
            # Damage variants
            "level_drain", "damage_status", "damage_multihit", "damage_dot",
            "area_damage", "area_damage_dot", "damage_creation",
            # Breath attacks
            "breath_skill", "breath_weapon",
            # Healing
            "group_healing",
            # Buffs/Debuffs
            "buff", "chant_buff", "song_buff", "debuff", "group_buff",
            # Creation/Items
            "creation", "item_creation", "item_enhancement",
            # Utility
            "utility", "song_utility", "chant_utility", "dispel", "curse",
            "barrier", "room_effect", "illusion",
            # Combat
            "vampiric", "vampiric_dot",
            # Resurrection
            "resurrection",
        ):
            type_effects = self.map_spell_type(spell_info)
            effects_to_link.extend(type_effects)

        # Handle effect-based spells (with effects array)
        legacy_effects = spell_info.get("effects", [])
        for effect_data in legacy_effects:
            mapping = self.map_legacy_effect(effect_data, spell_key=matched_key)
            if mapping:
                effects_to_link.append((mapping[0], mapping[1], "on_cast"))

        if not effects_to_link:
            self.stats["no_effects"] += 1
            self.unlinked.append({
                "ability": ability_name,
                "reason": "Could not map any effects",
                "spell_info": spell_info.get("name", keys_to_try[0]),
            })
            return False

        # Delete existing AbilityEffects for this ability before creating new ones
        # This is simpler than trying to update with the new composite key (abilityId, effectId, order)
        try:
            await self.prisma.abilityeffect.delete_many(
                where={"abilityId": ability_id}
            )
        except Exception:
            pass  # Ignore if no existing records

        # Create AbilityEffect records
        order = 0
        for effect_name, params, trigger in effects_to_link:
            effect_id = self.get_effect_id(effect_name)
            if not effect_id:
                self.unlinked.append({
                    "ability": ability_name,
                    "reason": f"Effect '{effect_name}' not found in database",
                })
                continue

            try:
                # Create new link with composite key (abilityId, effectId, order)
                await self.prisma.abilityeffect.create(
                    data={
                        "abilityId": ability_id,
                        "effectId": effect_id,
                        "overrideParams": json.dumps(params),
                        "trigger": trigger,
                        "order": order,
                    }
                )
                if verbose:
                    click.echo(f"    + Linked {ability_name} -> {effect_name}")
                self.stats["effects_created"] += 1
                order += 1

            except Exception as e:
                self.stats["errors"] += 1
                self.unlinked.append({
                    "ability": ability_name,
                    "reason": f"Database error: {str(e)[:100]}",
                    "effect": effect_name,
                })

        self.stats["linked"] += 1
        return True

    async def link_all(
        self,
        json_path: Path,
        dry_run: bool = False,
        verbose: bool = False,
    ) -> Dict[str, Any]:
        """Link all abilities to their effects."""
        click.echo("\nLoading data...")
        await self.load_spell_implementations(json_path)
        self.load_extraction_data()  # Load authoritative damage types from abilities.csv
        await self.load_effects_cache()
        await self.load_abilities_cache()

        click.echo("\nLinking abilities to effects...")

        # Get all spell-type abilities
        abilities = await self.prisma.ability.find_many(
            where={"abilityType": "SPELL"},
            order={"id": "asc"}
        )

        self.stats["total_abilities"] = len(abilities)
        click.echo(f"  Found {len(abilities)} spell abilities")

        for ability in abilities:
            # Use plainName (CODE_STYLE) for JSON key lookup
            if dry_run:
                keys_to_try = self.normalize_spell_name(ability.plainName)
                found = any(key in self.spell_data for key in keys_to_try)
                if found:
                    click.echo(f"  [DRY] Would link: {ability.plainName}")
                    self.stats["linked"] += 1
                else:
                    self.stats["not_found"] += 1
            else:
                await self.link_ability(ability.plainName, ability.id, verbose)

        return {
            "stats": self.stats,
            "unlinked": self.unlinked,
        }


async def link_ability_effects(
    prisma: Prisma,
    dry_run: bool = False,
    verbose: bool = False,
) -> Dict[str, Any]:
    """Main entry point for linking abilities to effects.

    Note: The all_spell_implementations.json file was removed because it contained
    incorrect damage type mappings. The authoritative source is now abilities.csv
    (extracted from skills.cpp spello() calls).

    If the JSON file doesn't exist, this function checks if abilities are already
    linked and returns early if so.
    """
    json_path = Path(__file__).parent.parent.parent.parent / "docs/extraction-reports/all_spell_implementations.json"

    if not json_path.exists():
        # Check if abilities are already linked
        existing_links = await prisma.abilityeffect.count()
        if existing_links > 0:
            click.echo(f"\n⚠️  Spell implementations JSON not found, but {existing_links} ability effects already exist.")
            click.echo("   The JSON file was removed because it contained incorrect damage types.")
            click.echo("   Ability effects are already linked from a previous run.")
            click.echo("   To re-link, restore the JSON file or use the database directly.\n")
            return {
                "stats": {
                    "total_abilities": 0,
                    "linked": 0,
                    "no_effects": 0,
                    "not_found": 0,
                    "errors": 0,
                    "effects_created": 0,
                    "existing_links": existing_links,
                },
                "unlinked": [],
                "skipped": True,
            }
        else:
            raise FileNotFoundError(
                f"Spell implementations file not found: {json_path}\n"
                "This file was removed because it contained incorrect damage types.\n"
                "The authoritative source is now abilities.csv from skills.cpp."
            )

    linker = AbilityEffectsLinker(prisma)
    return await linker.link_all(json_path, dry_run, verbose)
