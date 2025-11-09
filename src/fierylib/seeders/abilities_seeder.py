"""
Ability Seeder - Import all 368 abilities from documentation into database

This module converts legacy ability data from ABILITIES_COMPLETE.md and
all_spell_implementations.json into the new Lua-based ability system.

Data flow:
1. Parse docs/ABILITIES_COMPLETE.md for ability metadata
2. Parse docs/all_spell_implementations.json for implementation details
3. Convert C++ formulas to Lua expressions
4. Create Auras for buff/debuff effects
5. Insert into Spells, SpellEffects, Auras, AuraModifiers tables
"""

import json
import re
import logging
from pathlib import Path
from typing import Any, Dict, List, Optional
from prisma import Prisma
from prisma.models import Spells, Auras, AuraModifiers

logger = logging.getLogger(__name__)


class AbilityConverter:
    """Converts legacy ability data to new Lua-based format."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self.docs_path = Path(__file__).parent.parent.parent.parent.parent / "docs"

    async def seed_all_abilities(self) -> int:
        """Import all 368 abilities from documentation."""
        logger.info("Starting ability import from documentation...")

        # Load source data
        abilities_data = self._parse_abilities_md()
        implementations = self._load_implementations_json()

        # Merge data sources
        merged = self._merge_ability_data(abilities_data, implementations)

        logger.info(f"Found {len(merged)} abilities to import")

        # Convert and insert
        imported_count = 0
        for ability_data in merged:
            try:
                await self._import_ability(ability_data)
                imported_count += 1
                if imported_count % 50 == 0:
                    logger.info(f"Imported {imported_count}/{len(merged)} abilities...")
            except Exception as e:
                logger.error(f"Failed to import {ability_data.get('name')}: {e}")
                continue

        logger.info(f"✅ Successfully imported {imported_count} abilities")
        return imported_count

    def _parse_abilities_md(self) -> List[Dict[str, Any]]:
        """Parse ABILITIES_COMPLETE.md for all ability metadata."""
        abilities_md_path = self.docs_path / "ABILITIES_COMPLETE.md"

        if not abilities_md_path.exists():
            raise FileNotFoundError(f"Documentation not found: {abilities_md_path}")

        abilities = []
        current_ability = None

        with open(abilities_md_path, 'r', encoding='utf-8') as f:
            for line in f:
                # Match ability headers: #### Spell Name (ID 123)
                header_match = re.match(r'^####\s+(.+?)\s+\(ID\s+(\d+)\)', line)
                if header_match:
                    if current_ability:
                        abilities.append(current_ability)

                    current_ability = {
                        'name': header_match.group(1),
                        'id': int(header_match.group(2)),
                        'metadata': {}
                    }
                    continue

                if not current_ability:
                    continue

                # Extract metadata fields
                if line.startswith('- **Type**:'):
                    current_ability['kind'] = line.split(':')[1].strip()
                elif line.startswith('- **Command**:'):
                    current_ability['command'] = line.split('`')[1] if '`' in line else None
                elif line.startswith('- **Target**:'):
                    current_ability['target'] = line.split(':')[1].strip()
                elif line.startswith('- **Min Level**:'):
                    level_match = re.search(r'(\d+)', line)
                    if level_match:
                        current_ability['minLevel'] = int(level_match.group(1))

        if current_ability:
            abilities.append(current_ability)

        logger.info(f"Parsed {len(abilities)} abilities from ABILITIES_COMPLETE.md")
        return abilities

    def _load_implementations_json(self) -> Dict[str, Any]:
        """Load all_spell_implementations.json."""
        impl_path = self.docs_path / "all_spell_implementations.json"

        if not impl_path.exists():
            raise FileNotFoundError(f"Implementation data not found: {impl_path}")

        with open(impl_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        logger.info(f"Loaded {len(data)} implementation entries from JSON")
        return data

    def _merge_ability_data(self, abilities: List[Dict], implementations: Dict) -> List[Dict]:
        """Merge metadata and implementation data."""
        merged = []

        for ability in abilities:
            # Try to find implementation by ID or name
            impl_key = f"SPELL_{ability['name'].upper().replace(' ', '_')}"

            if impl_key in implementations:
                ability['implementation'] = implementations[impl_key]

            merged.append(ability)

        return merged

    async def _import_ability(self, data: Dict[str, Any]) -> None:
        """Import a single ability into the database."""
        # Create game ID
        name_clean = data['name'].lower().replace(' ', '_').replace("'", '')
        game_id = f"spell.{name_clean}"

        # Check if already exists
        existing = await self.prisma.spells.find_unique(where={'gameId': game_id})
        if existing:
            # Delete old effects to re-import with enhanced params
            await self.prisma.spelleffects.delete_many(where={'spellId': existing.id})
            await self.prisma.spelltargeting.delete_many(where={'spellId': existing.id})
            await self.prisma.spellmessages.delete_many(where={'spellId': existing.id})

            spell = existing
            logger.debug(f"♻️  Updating {data['name']} with enhanced params")
        else:
            # Determine target scope
            target_scope = self._map_target_scope(data.get('target', 'SINGLE'))

            # Create spell record
            spell = await self.prisma.spells.create(
                data={
                    'gameId': game_id,
                    'name': data['name'],
                    'description': f"Imported from legacy ability ID {data['id']}",
                    'minPosition': 'STANDING',  # Default
                    'violent': 'OFFENSIVE' in data.get('target', ''),
                    'tags': self._extract_tags(data),
                }
            )

            logger.info(f"✅ Created spell: {spell.name}")

        # Determine target scope
        target_scope = self._map_target_scope(data.get('target', 'SINGLE'))

        # Create effects
        implementation = data.get('implementation', {})
        await self._create_effects(spell.id, implementation)

        # Create targeting
        await self._create_targeting(spell.id, target_scope, data)

        # Create messages
        await self._create_messages(spell.id, implementation)

    def _map_target_scope(self, target: str) -> str:
        """Map legacy target string to TargetScope enum."""
        if 'SELF' in target:
            return 'SINGLE'  # Will filter to self
        elif 'GROUP' in target:
            return 'GROUP'
        elif 'ROOM' in target or 'AREA' in target:
            return 'ROOM'
        else:
            return 'SINGLE'

    def _extract_tags(self, data: Dict) -> List[str]:
        """Extract tags from ability data."""
        tags = []

        impl = data.get('implementation', {})

        # Add damage type as tag
        if 'damageType' in impl:
            damage_type = impl['damageType'].replace('DAM_', '').lower()
            tags.append(damage_type)

        # Add category tags
        if 'OFFENSIVE' in data.get('target', ''):
            tags.append('offensive')
        if 'AREA' in data.get('target', ''):
            tags.append('aoe')

        return tags

    def _extract_base_formula(self, formula: str) -> str:
        """Extract base damage formula, removing alignment scaling."""
        # Handle formulas with ", then *= (...)" pattern
        if ', then *=' in formula:
            return formula.split(', then *=')[0].strip()
        return formula

    def _parse_alignment_restrictions(self, requirements: str) -> Dict:
        """Parse alignment restriction strings into structured data."""
        restrictions = {}

        if not requirements:
            return restrictions

        # "Fails vs good/neutral victims" -> requireEvil = true
        if 'fails vs good' in requirements.lower() or 'no damage if victim good' in requirements.lower():
            restrictions['requireEvil'] = True
            restrictions['failOnNeutral'] = True

        # "Fails vs evil/neutral victims" -> requireGood = true
        if 'fails vs evil' in requirements.lower() or 'no damage if victim evil' in requirements.lower():
            restrictions['requireGood'] = True
            restrictions['failOnNeutral'] = True

        return restrictions

    def _parse_alignment_bonuses(self, bonus_str: str) -> List[Dict]:
        """Parse alignment bonus strings into structured data.

        Example input:
        "x1.25 if PRIEST with align>=750, x1.15 if PRIEST with lower align, x1.1 if non-priest with align>=750"

        Returns:
        [
            {"class": "PRIEST", "minAlignment": 750, "multiplier": 1.25},
            {"class": "PRIEST", "minAlignment": 0, "maxAlignment": 749, "multiplier": 1.15},
            {"minAlignment": 750, "multiplier": 1.1}
        ]
        """
        bonuses = []

        if not bonus_str:
            return bonuses

        import re

        # Split on commas
        parts = bonus_str.split(',')

        for part in parts:
            part = part.strip()

            # Extract multiplier (x1.25, x1.15, etc.)
            mult_match = re.search(r'x(\d+\.?\d*)', part)
            if not mult_match:
                continue

            multiplier = float(mult_match.group(1))

            bonus = {'multiplier': multiplier}

            # Extract class
            class_match = re.search(r'\b(PRIEST|DIABOLIST|CLERIC|PALADIN)\b', part, re.IGNORECASE)
            if class_match:
                bonus['class'] = class_match.group(1).upper()

            # Check for "non-priest" pattern
            if 'non-' in part.lower():
                # This is a bonus for any class, don't set class field
                pass

            # Extract alignment threshold
            if 'align>=' in part:
                align_match = re.search(r'align>=(-?\d+)', part)
                if align_match:
                    bonus['minAlignment'] = int(align_match.group(1))
            elif 'align<=' in part:
                align_match = re.search(r'align<=(-?\d+)', part)
                if align_match:
                    bonus['maxAlignment'] = int(align_match.group(1))
            elif 'lower align' in part.lower():
                # "lower align" means below the previous threshold
                # For PRIEST, this typically means 0-749
                if 'class' in bonus and bonus['class'] == 'PRIEST':
                    bonus['minAlignment'] = 0
                    bonus['maxAlignment'] = 749

            bonuses.append(bonus)

        return bonuses

    def _parse_victim_scaling(self, formula: str) -> Dict | None:
        """Parse victim alignment scaling from formula.

        Example: "dam + ..., then *= (victim_align * -0.0007 + 0.8)"
        Returns: {"formula": "target.alignment * -0.0007 + 0.8", "penalizesEvil": true}
        """
        if ', then *=' not in formula:
            return None

        scaling_part = formula.split(', then *=')[1].strip()

        # Remove parentheses
        scaling_part = scaling_part.strip('()')

        # Convert variable names to Lua
        scaling_part = scaling_part.replace('victim_align', 'target.alignment')
        scaling_part = scaling_part.replace('caster_align', 'caster.alignment')

        # Determine if it penalizes evil (negative alignment)
        penalizes_evil = '-0.0' in scaling_part or '* -' in scaling_part

        return {
            'formula': scaling_part,
            'penalizesEvil': penalizes_evil
        }

    def _parse_caster_scaling(self, formula: str) -> Dict | None:
        """Parse caster alignment scaling from formula."""
        if ', then *=' not in formula:
            return None

        scaling_part = formula.split(', then *=')[1].strip()
        scaling_part = scaling_part.strip('()')

        # Check if it uses caster alignment
        if 'caster_align' not in scaling_part:
            return None

        scaling_part = scaling_part.replace('caster_align', 'caster.alignment')

        return {
            'formula': scaling_part
        }

    def _build_damage_params(self, damage_type: str, damage_obj: Dict) -> Dict:
        """Build structured params object for damage effects."""
        # Base damage type
        damage_type_clean = damage_type.replace('DAM_', '')
        params = {
            'damageType': damage_type_clean
        }

        # Add max damage if present
        if 'max_damage' in damage_obj:
            max_dmg_str = damage_obj['max_damage']
            # Parse "135 (from 10d5+15 online)" -> 135
            if isinstance(max_dmg_str, str):
                import re
                match = re.search(r'(\d+)', max_dmg_str)
                if match:
                    params['maxDamage'] = int(match.group(1))
            else:
                params['maxDamage'] = int(max_dmg_str)

        # Alignment-specific processing
        if damage_type_clean == 'ALIGN':
            # Parse restrictions
            if 'requirements' in damage_obj:
                restrictions = self._parse_alignment_restrictions(damage_obj['requirements'])
                if restrictions:
                    params['restrictions'] = restrictions

            # Parse alignment bonuses
            if 'bonus' in damage_obj:
                bonuses = self._parse_alignment_bonuses(damage_obj['bonus'])
                if bonuses:
                    params['alignmentBonuses'] = bonuses

            # Parse victim scaling from formula
            if 'formula' in damage_obj:
                victim_scaling = self._parse_victim_scaling(damage_obj['formula'])
                if victim_scaling and 'target.alignment' in victim_scaling.get('formula', ''):
                    params['victimScaling'] = victim_scaling

                # Parse caster scaling
                caster_scaling = self._parse_caster_scaling(damage_obj['formula'])
                if caster_scaling:
                    params['casterScaling'] = caster_scaling

        # Note: We intentionally DO NOT include 'source' or 'notes' in params
        # These are legacy reference data useful for documentation, not game mechanics
        # The game engine only needs the actual mechanics data

        return params

    async def _create_effects(self, spell_id: int, implementation: Dict) -> None:
        """Create spell effects from implementation data."""
        # Handle damage spells
        damage_formula = None
        damage_type = 'DAM_ENERGY'
        damage_obj = None

        # Check for different damage formula structures
        if 'damageFormula' in implementation:
            damage_formula = implementation['damageFormula']
            damage_type = implementation.get('damageType', 'DAM_ENERGY')
        elif 'damage' in implementation and isinstance(implementation['damage'], dict):
            damage_obj = implementation['damage']
            damage_formula = damage_obj.get('formula')
            damage_type = damage_obj.get('damage_type', 'DAM_ENERGY')

        if damage_formula:
            # Split complex formulas (remove scaling from base formula)
            base_formula = self._extract_base_formula(damage_formula)
            lua_formula = self._convert_formula_to_lua(base_formula)

            # Build params based on damage type
            params = self._build_damage_params(damage_type, damage_obj or {})

            await self.prisma.spelleffects.create(
                data={
                    'spellId': spell_id,
                    'effectType': 'DAMAGE',
                    'order': 0,
                    'luaFormula': lua_formula,
                    'params': json.dumps(params)
                }
            )

        # Handle buff/debuff spells (effects with modifiers)
        if 'effects' in implementation:
            # Get spell record to access game_id
            spell = await self.prisma.spells.find_unique(where={'id': spell_id})
            spell_name = spell.gameId.replace('spell.', '') if spell else str(spell_id)

            for idx, effect in enumerate(implementation['effects']):
                await self._create_aura_effect(spell_id, spell_name, effect, idx + 1)

    async def _create_aura_effect(self, spell_id: int, spell_name: str, effect_data: Dict, order: int) -> None:
        """Create an APPLY_AURA effect with corresponding Aura."""
        # Determine aura ID based on effect type
        # Make auras spell-specific to ensure each spell has its own modifiers
        if 'flag' in effect_data:
            # Status effect (EFF_BLESS, EFF_SANCTUARY, etc.)
            # These can be shared across spells
            aura_id = f"aura.{effect_data['flag'].lower()}"
            aura_name = effect_data['flag'].replace('EFF_', '').title()
        elif effect_data.get('type') == 'modifier' and 'formula' in effect_data:
            # Modifier effect - make spell-specific with formula in name
            apply_type = effect_data['formula'].lower()
            aura_id = f"aura.{spell_name}.{apply_type}"
            aura_name = f"{spell_name.replace('_', ' ').title()} {apply_type.title()}"
        else:
            # Unknown effect type - make spell-specific
            aura_id = f"aura.{spell_name}.effect{order}"
            aura_name = f"{spell_name.replace('_', ' ').title()} Effect {order}"

        # Always create a new aura (don't try to reuse)
        # Each spell gets its own aura instance
        aura = await self.prisma.auras.find_unique(where={'gameId': aura_id})

        if not aura:
            # Create new aura
            aura = await self.prisma.auras.create(
                data={
                    'gameId': aura_id,
                    'name': aura_name,
                    'description': effect_data.get('description', ''),
                    'dispelCategory': 'magic',
                    'stackingRule': 'REFRESH',
                }
            )

            # Create modifiers
            if 'location' in effect_data and effect_data['location'] != 'APPLY_NONE':
                location = effect_data['location']

                # Handle malformed JSON where location contains formula/expression
                # Two cases:
                # 1. "APPLY_get_vitality_hp_gain(ch, spellnum)" - function call
                # 2. "APPLY_skill / 25 + 1" - arithmetic expression
                has_formula = any(op in location for op in ['(', '/', '*', '+', '-'])

                if has_formula:
                    # Extract the formula/expression from location
                    formula_str = location.replace('APPLY_', '').strip()

                    # The actual apply type is in the 'formula' field
                    apply_type_raw = effect_data.get('formula', 'NONE')

                    # Convert C++ formula to Lua
                    modifier_formula = self._convert_formula_to_lua(formula_str)
                else:
                    # Normal case: location is the apply type, modifier/formula is the value
                    apply_type_raw = location.replace('APPLY_', '')

                    # Check if there's a modifier value or use 0
                    if 'modifier' in effect_data:
                        modifier_formula = str(effect_data['modifier'])
                    elif 'formula' in effect_data:
                        # Sometimes the value is in the formula field
                        modifier_formula = str(effect_data['formula'])
                    else:
                        modifier_formula = '0'

                # Validate ApplyType
                valid_apply_types = [
                    'AC', 'HITROLL', 'DAMROLL', 'STR', 'DEX', 'INT', 'WIS', 'CON', 'CHA',
                    'SAVING_PARA', 'SAVING_ROD', 'SAVING_PETRI', 'SAVING_BREATH', 'SAVING_SPELL',
                    'HIT_REGEN', 'MAX_HP', 'MAX_MANA', 'MAX_MOVEMENT', 'PERCEPTION', 'HIDDENNESS',
                    'SIZE', 'AGE', 'CHAR_WEIGHT', 'CHAR_HEIGHT', 'FOCUS', 'COMPOSITION', 'LEVEL', 'NONE'
                ]

                # Map common variations to valid types
                apply_type_map = {
                    'HIT': 'MAX_HP',  # HP bonus maps to MAX_HP
                    'MANA': 'MAX_MANA',
                    'MOVE': 'MAX_MOVEMENT',
                    'MOVEMENT': 'MAX_MOVEMENT',
                }

                apply_type = apply_type_map.get(apply_type_raw, apply_type_raw)

                if apply_type in valid_apply_types and apply_type != 'NONE':
                    await self.prisma.auramodifiers.create(
                        data={
                            'auraId': aura.id,
                            'applyType': apply_type,
                            'formula': modifier_formula,
                        }
                    )
                    logger.debug(f"Created modifier: {apply_type} = {modifier_formula}")
                else:
                    logger.warning(f"Skipping invalid ApplyType: {apply_type_raw} -> {apply_type}")

        # Create APPLY_AURA effect
        duration_formula = self._convert_formula_to_lua(effect_data.get('duration', '0'))

        await self.prisma.spelleffects.create(
            data={
                'spellId': spell_id,
                'effectType': 'APPLY_AURA',
                'order': order,
                'durationFormula': duration_formula,
                'params': json.dumps({
                    'auraGameId': aura_id
                })
            }
        )

    async def _create_targeting(self, spell_id: int, target_scope: str, data: Dict) -> None:
        """Create spell targeting configuration."""
        await self.prisma.spelltargeting.create(
            data={
                'spellId': spell_id,
                'targetScope': target_scope,
                'maxTargets': 1,
                'range': 'ROOM',
                'requireLos': False,
                'allowedTargetsMask': 1,  # Default
            }
        )

    async def _create_messages(self, spell_id: int, implementation: Dict) -> None:
        """Create spell messages from implementation data."""
        messages_data = implementation.get('messages', {})

        if messages_data:
            await self.prisma.spellmessages.create(
                data={
                    'spellId': spell_id,
                    'startToCaster': messages_data.get('to_char'),
                    'startToVictim': messages_data.get('to_vict'),
                    'startToRoom': messages_data.get('to_room'),
                    'wearoffToTarget': implementation.get('wearoffMessage'),
                }
            )

    def _convert_formula_to_lua(self, cpp_formula: str) -> str:
        """Convert C++ formula to Lua expression."""
        if not cpp_formula:
            return "0"

        lua = cpp_formula

        # Convert pow() to Lua power operator
        lua = re.sub(r'pow\((\w+),\s*(\d+)\)', r'(\1^\2)', lua)

        # Convert roll_dice(a, b) to roll(a, b)
        lua = lua.replace('roll_dice(', 'roll(')

        # Convert C++ variable access to Lua
        replacements = {
            'GET_LEVEL(ch)': 'caster.level',
            'GET_LEVEL(victim)': 'target.level',
            'GET_SKILL(ch,': 'skill',
            'GET_WIS(ch)': 'caster.WIS',
            'GET_INT(ch)': 'caster.INT',
            'GET_CON(ch)': 'caster.CON',
            'GET_DEX(ch)': 'caster.DEX',
        }

        for cpp, lua_expr in replacements.items():
            lua = lua.replace(cpp, lua_expr)

        # Clean up skill references (removes spell name parameter)
        lua = re.sub(r'skill\s+\w+\)', 'skill', lua)

        return lua


async def seed_abilities(prisma: Prisma) -> int:
    """Main entry point for ability seeding."""
    converter = AbilityConverter(prisma)
    return await converter.seed_all_abilities()
