"""
C++ Race Parser for FieryMUD races.cpp

Parses the RaceDef structure array from races.cpp and extracts:
- Basic race information (name, display names, flags)
- Physical attributes (size, height/weight ranges)
- Stat maximums (str, dex, int, wis, con, cha)
- Combat bonuses (hitroll, damroll, focus)
- Race skill/spell assignments
- Permanent racial effects
"""

import re
from pathlib import Path
from typing import Dict, List, Optional, Any


class CppRaceParser:
    """Parser for FieryMUD races.cpp file."""

    # Race constants mapping (RACE_HUMAN = 0, RACE_ELF = 1, etc.)
    RACE_CONSTANTS = {
        'RACE_HUMAN': 0,
        'RACE_ELF': 1,
        'RACE_GNOME': 2,
        'RACE_DWARF': 3,
        'RACE_TROLL': 4,
        'RACE_DROW': 5,
        'RACE_DUERGAR': 6,
        'RACE_OGRE': 7,
        'RACE_ORC': 8,
        'RACE_HALF_ELF': 9,
        'RACE_BARBARIAN': 10,
        'RACE_HALFLING': 11,
        'RACE_PLANT': 12,
        'RACE_HUMANOID': 13,
        'RACE_ANIMAL': 14,
        'RACE_DRAGON_GENERAL': 15,
        'RACE_GIANT': 16,
        'RACE_OTHER': 17,
        'RACE_GOBLIN': 18,
        'RACE_DEMON': 19,
        'RACE_BROWNIE': 20,
        'RACE_DRAGON_FIRE': 21,
        'RACE_DRAGON_FROST': 22,
        'RACE_DRAGON_ACID': 23,
        'RACE_DRAGON_LIGHTNING': 24,
        'RACE_DRAGON_GAS': 25,
        'RACE_DRAGONBORN_FIRE': 26,
        'RACE_DRAGONBORN_FROST': 27,
        'RACE_DRAGONBORN_ACID': 28,
        'RACE_DRAGONBORN_LIGHTNING': 29,
        'RACE_DRAGONBORN_GAS': 30,
        'RACE_SVERFNEBLIN': 31,
        'RACE_FAERIE_SEELIE': 32,
        'RACE_FAERIE_UNSEELIE': 33,
        'RACE_NYMPH': 34,
        'RACE_ARBOREAN': 35,
    }

    # Size constants
    SIZE_MAP = {
        'SIZE_TINY': 'TINY',
        'SIZE_SMALL': 'SMALL',
        'SIZE_MEDIUM': 'MEDIUM',
        'SIZE_LARGE': 'LARGE',
        'SIZE_HUGE': 'HUGE',
        'SIZE_GIANT': 'GIANT',
        'SIZE_GARGANTUAN': 'GARGANTUAN',
        'SIZE_COLOSSAL': 'COLOSSAL',
        'SIZE_TITANIC': 'TITANIC',
        'SIZE_MOUNTAINOUS': 'MOUNTAINOUS',
    }

    # Lifeforce constants
    LIFEFORCE_MAP = {
        'LIFE_LIFE': 'LIFE',
        'LIFE_UNDEAD': 'UNDEAD',
        'LIFE_MAGIC': 'MAGIC',
        'LIFE_CELESTIAL': 'CELESTIAL',
        'LIFE_DEMONIC': 'DEMONIC',
        'LIFE_ELEMENTAL': 'ELEMENTAL',
    }

    # Composition constants
    COMPOSITION_MAP = {
        'COMP_FLESH': 'FLESH',
        'COMP_EARTH': 'EARTH',
        'COMP_AIR': 'AIR',
        'COMP_FIRE': 'FIRE',
        'COMP_WATER': 'WATER',
        'COMP_ICE': 'ICE',
        'COMP_MIST': 'MIST',
        'COMP_ETHER': 'ETHER',
        'COMP_METAL': 'METAL',
        'COMP_STONE': 'STONE',
        'COMP_BONE': 'BONE',
        'COMP_LAVA': 'LAVA',
        'COMP_PLANT': 'PLANT',
    }

    # Race alignment constants
    RACE_ALIGN_MAP = {
        'RACE_ALIGN_UNKNOWN': 'UNKNOWN',
        'RACE_ALIGN_GOOD': 'GOOD',
        'RACE_ALIGN_EVIL': 'EVIL',
        -1: 'UNKNOWN',
        0: 'GOOD',
        1: 'EVIL',
    }

    def __init__(self, races_cpp_path: Path):
        """Initialize parser with path to races.cpp."""
        self.races_cpp_path = races_cpp_path
        self.content = races_cpp_path.read_text()

    def parse(self) -> Dict[str, Any]:
        """Parse races.cpp and return structured race data."""
        races = self._parse_race_definitions()
        race_skills = self._parse_race_skills()
        permanent_effects = self._parse_permanent_effects()

        # Merge skill assignments and permanent effects into race data
        for race_name, skills in race_skills.items():
            # Find matching race by name
            for race in races:
                if race['name'].lower() == race_name.lower():
                    race['skills'] = skills
                    break

        for race_name, effects in permanent_effects.items():
            # Find matching race by name
            for race in races:
                if race['name'].lower() == race_name.lower():
                    race['permanentEffects'] = effects
                    break

        return {
            'races': races,
            'metadata': {
                'source_file': str(self.races_cpp_path),
                'total_races': len(races),
            }
        }

    def _parse_race_definitions(self) -> List[Dict[str, Any]]:
        """Parse the RaceDef races[] array."""
        races = []

        # Find the races[] array definition
        races_array_match = re.search(
            r'RaceDef races\[NUM_RACES\]\s*=\s*\{(.*?)\};',
            self.content,
            re.DOTALL
        )

        if not races_array_match:
            raise ValueError("Could not find RaceDef races[] array")

        races_content = races_array_match.group(1)

        # Split into individual race definitions
        # Each race ends with {0, 0}},
        race_blocks = re.findall(
            r'/\*\s*([A-Z\s_-]+)\s*\*/\s*\{(.*?)\{0,\s*0\}\}',
            races_content,
            re.DOTALL
        )

        for race_comment, race_data in race_blocks:
            race = self._parse_race_block(race_comment.strip(), race_data)
            if race:
                races.append(race)

        return races

    def _parse_race_block(self, comment: str, data: str) -> Optional[Dict[str, Any]]:
        """Parse a single race definition block."""
        # Extract all string literals and values
        lines = [line.strip() for line in data.split('\n') if line.strip() and not line.strip().startswith('/*')]

        # Remove comments from each line
        lines = [re.sub(r'/\*.*?\*/', '', line).strip() for line in lines]
        lines = [line for line in lines if line]

        if len(lines) < 20:  # Need at least 20 fields
            return None

        # Parse structured fields
        try:
            # Remove trailing commas and extract values
            values = []
            for line in lines:
                line = line.rstrip(',')

                # Handle string literals
                if line.startswith('"'):
                    match = re.match(r'"([^"]*)"', line)
                    if match:
                        values.append(match.group(1))
                    else:
                        values.append('')
                # Handle booleans
                elif line in ('true', 'false'):
                    values.append(line == 'true')
                # Handle nullptr
                elif line == 'nullptr':
                    values.append(None)
                # Handle arrays like {76, 76, 76, 76, 76, 76}
                elif line.startswith('{') and line.endswith('}'):
                    array_content = line[1:-1]
                    array_values = [int(v.strip()) for v in array_content.split(',') if v.strip()]
                    values.append(array_values)
                # Handle numeric values
                else:
                    # Try to parse as int
                    try:
                        values.append(int(line))
                    except ValueError:
                        # Keep as string (might be constant like SIZE_MEDIUM)
                        values.append(line)

            # Map values to race structure
            # Based on the comment structure from races.cpp lines 38-52
            race = {
                'name': values[0] if len(values) > 0 else '',
                'keywords': values[1] if len(values) > 1 else '',
                'displayName': self._strip_color_codes(values[2]) if len(values) > 2 else '',
                'fullName': self._strip_color_codes(values[3]) if len(values) > 3 else '',
                'plainName': values[4] if len(values) > 4 else '',
                'playable': values[5] if len(values) > 5 else False,
                'humanoid': values[6] if len(values) > 6 else False,
                'magical': values[7] if len(values) > 7 else False,
                'raceAlign': self._map_race_align(values[8]) if len(values) > 8 else 'GOOD',
                'defaultSize': self._map_size(values[9]) if len(values) > 9 else 'MEDIUM',
                'defaultAlignment': values[10] if len(values) > 10 else 0,
                'bonusDamroll': values[11] if len(values) > 11 else 0,
                'bonusHitroll': values[12] if len(values) > 12 else 0,
                'focusBonus': values[13] if len(values) > 13 else 100,
                'defaultLifeforce': self._map_lifeforce(values[14]) if len(values) > 14 else 'LIFE',
                'defaultComposition': self._map_composition(values[15]) if len(values) > 15 else 'FLESH',
                'maleWeightLow': values[16] if len(values) > 16 else 0,
                'maleWeightHigh': values[17] if len(values) > 17 else 0,
                'maleHeightLow': values[18] if len(values) > 18 else 0,
                'maleHeightHigh': values[19] if len(values) > 19 else 0,
                'femaleWeightLow': values[20] if len(values) > 20 else 0,
                'femaleWeightHigh': values[21] if len(values) > 21 else 0,
                'femaleHeightLow': values[22] if len(values) > 22 else 0,
                'femaleHeightHigh': values[23] if len(values) > 23 else 0,
                'maxStats': {
                    'str': values[24][0] if len(values) > 24 and isinstance(values[24], list) and len(values[24]) > 0 else 76,
                    'dex': values[24][1] if len(values) > 24 and isinstance(values[24], list) and len(values[24]) > 1 else 76,
                    'int': values[24][2] if len(values) > 24 and isinstance(values[24], list) and len(values[24]) > 2 else 76,
                    'wis': values[24][3] if len(values) > 24 and isinstance(values[24], list) and len(values[24]) > 3 else 76,
                    'con': values[24][4] if len(values) > 24 and isinstance(values[24], list) and len(values[24]) > 4 else 76,
                    'cha': values[24][5] if len(values) > 24 and isinstance(values[24], list) and len(values[24]) > 5 else 76,
                },
                'expFactor': values[25] if len(values) > 25 else 100,
                'hpFactor': values[26] if len(values) > 26 else 100,
                'hitDamageFactor': values[27] if len(values) > 27 else 100,
                'damageDiceFactor': values[28] if len(values) > 28 else 100,
                'copperFactor': values[29] if len(values) > 29 else 75,
                'acFactor': values[30] if len(values) > 30 else 100,
                'enterVerb': values[31] if len(values) > 31 else None,
                'leaveVerb': values[32] if len(values) > 32 else None,
            }

            return race

        except (IndexError, ValueError) as e:
            print(f"Warning: Failed to parse race {comment}: {e}")
            return None

    def _parse_race_skills(self) -> Dict[str, List[Dict[str, Any]]]:
        """Parse race skill/spell assignments from assign_race_skills()."""
        race_skills = {}

        # Find the assign_race_skills function
        func_match = re.search(
            r'void assign_race_skills\s*\(void\)\s*\{(.*?)\n\s*\}',
            self.content,
            re.DOTALL
        )

        if not func_match:
            return race_skills

        func_content = func_match.group(1)

        # Find all race_skill_assign, race_spell_assign, race_chant_assign, race_song_assign calls
        skill_assignments = re.findall(
            r'race_(?:skill|spell|chant|song)_assign\s*\(\s*([A-Z_]+)\s*,\s*RACE_([A-Z_]+)\s*,\s*(\d+|CIRCLE_\d+)\s*\)',
            func_content
        )

        for skill_name, race_name, level in skill_assignments:
            # Convert race name to readable format
            race_display = race_name.replace('_', ' ').title().replace(' ', '_')

            # Convert CIRCLE_N to actual number (CIRCLE_1 = 1, etc.)
            if level.startswith('CIRCLE_'):
                level_num = int(level.replace('CIRCLE_', ''))
            else:
                level_num = int(level)

            if race_display not in race_skills:
                race_skills[race_display] = []

            race_skills[race_display].append({
                'skillName': skill_name,
                'minLevel': level_num,
                'category': 'PRIMARY'  # Racial skills are typically primary
            })

        return race_skills

    def _strip_color_codes(self, text: str) -> str:
        """Remove MUD color codes from text."""
        return re.sub(r'&[0-9a-z&]', '', text)

    def _map_size(self, size_constant: Any) -> str:
        """Map C++ size constant to Prisma enum value."""
        if isinstance(size_constant, str):
            return self.SIZE_MAP.get(size_constant, 'MEDIUM')
        return 'MEDIUM'

    def _map_lifeforce(self, lifeforce_constant: Any) -> str:
        """Map C++ lifeforce constant to Prisma enum value."""
        if isinstance(lifeforce_constant, str):
            return self.LIFEFORCE_MAP.get(lifeforce_constant, 'LIFE')
        return 'LIFE'

    def _map_composition(self, comp_constant: Any) -> str:
        """Map C++ composition constant to Prisma enum value."""
        if isinstance(comp_constant, str):
            return self.COMPOSITION_MAP.get(comp_constant, 'FLESH')
        return 'FLESH'

    def _map_race_align(self, align_constant: Any) -> str:
        """Map C++ race align constant to RaceAlign enum value."""
        if isinstance(align_constant, str):
            return self.RACE_ALIGN_MAP.get(align_constant, 'GOOD')
        elif isinstance(align_constant, int):
            return self.RACE_ALIGN_MAP.get(align_constant, 'GOOD')
        return 'GOOD'

    def _parse_permanent_effects(self) -> Dict[str, List[str]]:
        """Parse permanent racial effects from init_races() function."""
        # Map EFF_* constants to EffectFlag enum values
        EFF_TO_EFFECT_FLAG = {
            'EFF_BLIND': 'BLIND',
            'EFF_INVISIBLE': 'INVISIBLE',
            'EFF_DETECT_ALIGN': 'DETECT_ALIGN',
            'EFF_DETECT_INVIS': 'DETECT_INVIS',
            'EFF_DETECT_MAGIC': 'DETECT_MAGIC',
            'EFF_SENSE_LIFE': 'SENSE_LIFE',
            'EFF_WATERWALK': 'WATERWALK',
            'EFF_SANCTUARY': 'SANCTUARY',
            'EFF_CONFUSION': 'CONFUSION',
            'EFF_CURSE': 'CURSE',
            'EFF_INFRAVISION': 'INFRAVISION',
            'EFF_POISON': 'POISON',
            'EFF_PROTECT_EVIL': 'PROTECT_EVIL',
            'EFF_PROTECT_GOOD': 'PROTECT_GOOD',
            'EFF_SLEEP': 'SLEEP',
            'EFF_NOTRACK': 'NO_TRACK',
            'EFF_TAMED': 'TAMED',
            'EFF_BERSERK': 'BERSERK',
            'EFF_SNEAK': 'SNEAK',
            'EFF_STEALTH': 'STEALTH',
            'EFF_FLY': 'FLY',
            'EFF_CHARM': 'CHARM',
            'EFF_STONE_SKIN': 'STONE_SKIN',
            'EFF_FARSEE': 'FARSEE',
            'EFF_HASTE': 'HASTE',
            'EFF_BLUR': 'BLUR',
            'EFF_VITALITY': 'VITALITY',
            'EFF_GLORY': 'GLORY',
            'EFF_MAJOR_PARALYSIS': 'MAJOR_PARALYSIS',
            'EFF_FAMILIARITY': 'FAMILIARITY',
            'EFF_MESMERIZED': 'MESMERIZED',
            'EFF_IMMOBILIZED': 'IMMOBILIZED',
            'EFF_LIGHT': 'LIGHT',
            'EFF_MINOR_PARALYSIS': 'MINOR_PARALYSIS',
            'EFF_HURT_THROAT': 'HURT_THROAT',
            'EFF_FEATHER_FALL': 'FEATHER_FALL',
            'EFF_WATERBREATH': 'WATERBREATH',
            'EFF_SOULSHIELD': 'SOULSHIELD',
            'EFF_SILENCE': 'SILENCE',
            'EFF_PROT_FIRE': 'PROTECT_FIRE',
            'EFF_PROT_COLD': 'PROTECT_COLD',
            'EFF_PROT_AIR': 'PROTECT_AIR',
            'EFF_PROT_EARTH': 'PROTECT_EARTH',
            'EFF_FIRESHIELD': 'FIRESHIELD',
            'EFF_COLDSHIELD': 'COLDSHIELD',
            'EFF_MINOR_GLOBE': 'MINOR_GLOBE',
            'EFF_MAJOR_GLOBE': 'MAJOR_GLOBE',
            'EFF_HARNESS': 'HARNESS',
            'EFF_ON_FIRE': 'ON_FIRE',
            'EFF_FEAR': 'FEAR',
            'EFF_TONGUES': 'TONGUES',
            'EFF_DISEASE': 'DISEASE',
            'EFF_INSANITY': 'INSANITY',
            'EFF_ULTRAVISION': 'ULTRAVISION',
            'EFF_NEGATE_HEAT': 'NEGATE_HEAT',
            'EFF_NEGATE_COLD': 'NEGATE_COLD',
            'EFF_NEGATE_AIR': 'NEGATE_AIR',
            'EFF_NEGATE_EARTH': 'NEGATE_EARTH',
            'EFF_REMOTE_AGGR': 'REMOTE_AGGRO',
            'EFF_AWARE': 'AWARE',
            'EFF_REDUCE': 'REDUCE',
            'EFF_ENLARGE': 'ENLARGE',
            'EFF_VAMP_TOUCH': 'VAMPIRIC_TOUCH',
            'EFF_RAY_OF_ENFEEB': 'RAY_OF_ENFEEBLEMENT',
            'EFF_ANIMATED': 'ANIMATED',
            'EFF_EXPOSED': 'EXPOSED',
            'EFF_SHADOWING': 'SHADOWING',
            'EFF_CAMOUFLAGED': 'CAMOUFLAGED',
            'EFF_SPIRIT_WOLF': 'SPIRIT_WOLF',
            'EFF_SPIRIT_BEAR': 'SPIRIT_BEAR',
            'EFF_WRATH': 'WRATH',
            'EFF_MISDIRECTION': 'MISDIRECTION',
            'EFF_MISDIRECTING': 'MISDIRECTING',
            'EFF_BLESS': 'BLESS',
            'EFF_DETECT_POISON': 'DETECT_POISON',
            'EFF_SONG_OF_REST': 'SONG_OF_REST',
            'EFF_DISPLACEMENT': 'DISPLACEMENT',
            'EFF_GREATER_DISPLACEMENT': 'GREATER_DISPLACEMENT',
            'EFF_FIRE_WEAPON': 'FIRE_WEAPON',
            'EFF_ICE_WEAPON': 'ICE_WEAPON',
            'EFF_POISON_WEAPON': 'POISON_WEAPON',
            'EFF_ACID_WEAPON': 'ACID_WEAPON',
            'EFF_SHOCK_WEAPON': 'SHOCK_WEAPON',
            'EFF_RADIANT_WEAPON': 'RADIANT_WEAPON',
        }

        race_effects = {}

        # Find the init_races function
        func_match = re.search(
            r'void init_races\s*\(void\)\s*\{(.*?)(?:for\s*\(race\s*=\s*0|$)',
            self.content,
            re.DOTALL
        )

        if not func_match:
            return race_effects

        func_content = func_match.group(1)

        # Find all PERM_EFF calls
        # Pattern: PERM_EFF(RACE_XXX, EFF_YYY);
        perm_eff_calls = re.findall(
            r'PERM_EFF\s*\(\s*RACE_([A-Z_]+)\s*,\s*(EFF_[A-Z_]+)\s*\)',
            func_content
        )

        for race_name, effect_name in perm_eff_calls:
            # Convert race name to readable format
            race_display = race_name.replace('_', ' ').title().replace(' ', '_')

            # Map effect to Prisma enum
            effect_flag = EFF_TO_EFFECT_FLAG.get(effect_name)
            if not effect_flag:
                print(f"Warning: Unknown effect flag {effect_name} for race {race_name}")
                continue

            if race_display not in race_effects:
                race_effects[race_display] = []

            race_effects[race_display].append(effect_flag)

        return race_effects


def parse_races_cpp(races_cpp_path: Path) -> Dict[str, Any]:
    """
    Parse races.cpp and return structured race data.

    Args:
        races_cpp_path: Path to races.cpp file

    Returns:
        Dictionary with 'races' list and metadata
    """
    parser = CppRaceParser(races_cpp_path)
    return parser.parse()
