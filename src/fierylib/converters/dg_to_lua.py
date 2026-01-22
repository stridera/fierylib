"""
DG Script to Lua Converter

Converts legacy CircleMUD DG Scripts to modern Lua triggers for FieryMUD.

Handles:
- Variable substitution (%actor%, %self%, etc.)
- Color code conversion (&1 -> <red>)
- Control flow (if/else/switch/case)
- Communication commands (say, emote, msend, mecho)
- Combat commands (mdamage, kill)
- Spawn commands (mload)
- And more...
"""

import re
from dataclasses import dataclass, field
from typing import Optional

from fierylib.parsers.trigger_parser import DGTrigger


# Color code conversions (DG/CircleMUD to FieryMUD markup)
COLOR_CODES = {
    '&0': '</>', '&n': '</>', '&N': '</>',
    '&1': '<red>', '&2': '<green>', '&3': '<yellow>', '&4': '<blue>',
    '&5': '<magenta>', '&6': '<cyan>', '&7': '<white>', '&8': '<black>',
    '&r': '<red>', '&R': '<b:red>',
    '&g': '<green>', '&G': '<b:green>',
    '&y': '<yellow>', '&Y': '<b:yellow>',
    '&b': '<blue>', '&B': '<b:blue>',
    '&m': '<magenta>', '&M': '<b:magenta>',
    '&c': '<cyan>', '&C': '<b:cyan>',
    '&w': '<white>', '&W': '<b:white>',
    '&k': '<black>', '&K': '<gray>',
    '&d': '</>', '&D': '</>',
    '@n': '</>', '@r': '<red>', '@g': '<green>', '@y': '<yellow>',
    '@b': '<blue>', '@m': '<magenta>', '@c': '<cyan>', '@w': '<white>',
    '@R': '<b:red>', '@G': '<b:green>', '@Y': '<b:yellow>',
    '@B': '<b:blue>', '@M': '<b:magenta>', '@C': '<b:cyan>', '@W': '<b:white>',
}


@dataclass
class LuaTrigger:
    """Converted Lua trigger ready for database import"""
    vnum: int
    name: str
    attach_type: str  # 'MOB', 'OBJECT', 'WORLD'
    flags: list[str]  # TriggerFlag enum values
    commands: str  # Lua script code
    numeric_arg: int = 0
    arg_list: list[str] = field(default_factory=list)
    original_dg: str = ""  # Original DG Script for reference

    @property
    def zone_id(self) -> int:
        return self.vnum // 100

    @property
    def local_id(self) -> int:
        return self.vnum % 100


def convert_colors(text: str) -> str:
    """Convert DG Script color codes to FieryMUD markup."""
    result = text

    # Handle bold combinations like &6&b (bold cyan)
    result = re.sub(r'&([1-7])&b', lambda m: f'<b:{_color_name(m.group(1))}>', result)
    result = re.sub(r'&b&([1-7])', lambda m: f'<b:{_color_name(m.group(1))}>', result)

    # Convert individual color codes (longer codes first)
    for code, markup in sorted(COLOR_CODES.items(), key=lambda x: -len(x[0])):
        result = result.replace(code, markup)

    # Clean up any remaining & followed by non-letter (like &&)
    result = re.sub(r'&([^a-zA-Z0-9])', r'\1', result)

    return result


def _color_name(num: str) -> str:
    """Map color number to name."""
    colors = {'1': 'red', '2': 'green', '3': 'yellow', '4': 'blue',
              '5': 'magenta', '6': 'cyan', '7': 'white', '8': 'black'}
    return colors.get(num, 'white')


def _vnum_to_composite(vnum: str) -> str:
    """
    Convert legacy vnum to composite ID format for Lua.

    Args:
        vnum: Legacy vnum as string (e.g., "3045")

    Returns:
        Lua expression with zone_id, local_id (e.g., "30, 45")
    """
    try:
        vnum_int = int(vnum)
        zone_id = vnum_int // 100
        local_id = vnum_int % 100
        # Zone 0 maps to zone 1000
        if zone_id == 0:
            zone_id = 1000
        return f'{zone_id}, {local_id}'
    except ValueError:
        # If not a valid number, return as-is (might be a variable)
        return vnum


def _get_room_call(vnum_or_var: str, is_variable: bool = False) -> str:
    """
    Generate a get_room() call with proper composite ID format.

    Args:
        vnum_or_var: Either a literal vnum string or a Lua variable expression
        is_variable: True if vnum_or_var is already a Lua variable expression

    Returns:
        Lua get_room() call with composite IDs
    """
    if is_variable:
        # Variable - use vnum_to_zone/vnum_to_local helpers
        return f'get_room(vnum_to_zone({vnum_or_var}), vnum_to_local({vnum_or_var}))'
    else:
        # Literal vnum - convert to composite format
        composite = _vnum_to_composite(vnum_or_var)
        return f'get_room({composite})'


def _convert_mload_for_actor(action: str, target: str, indent: str) -> Optional[str]:
    """
    Check if action is an mload obj command and convert it to actor:spawn_object().

    When an actor is forced to 'mload obj <vnum>', the object should go into
    their inventory, not the room. This function handles that conversion.

    Args:
        action: The inner action being forced (e.g., "mload obj 1012")
        target: The Lua expression for the target actor
        indent: Indentation string

    Returns:
        Converted Lua code if action is mload obj, None otherwise
    """
    # mload obj with literal vnum
    match = re.match(r'^mload\s+obj\s+(\d+)$', action, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{indent}{target}:spawn_object({composite})'

    # mload obj with variable vnum
    match = re.match(r'^mload\s+obj\s+%([^%]+)%$', action, re.IGNORECASE)
    if match:
        vnum = convert_variable_expr(match.group(1))
        return f'{indent}{target}:spawn_object(vnum_to_zone({vnum}), vnum_to_local({vnum}))'

    # wload/oload obj (alternate syntax)
    match = re.match(r'^[wo]load\s+obj\s+(\d+)$', action, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{indent}{target}:spawn_object({composite})'

    match = re.match(r'^[wo]load\s+o\s+(\d+)$', action, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{indent}{target}:spawn_object({composite})'

    return None


def convert_variable_expr(var: str) -> str:
    """
    Convert a DG Script %variable% to Lua expression.

    Args:
        var: Variable name without % delimiters

    Returns:
        Lua expression string
    """
    var = var.strip('%')

    # Simple variables
    simple_vars = {
        'actor': 'actor', 'self': 'self', 'speech': 'speech',
        'cmd': 'cmd', 'arg': 'arg', 'object': 'object',
        'direction': 'direction', 'amount': 'amount', 'damdone': 'damage_dealt',
    }
    if var in simple_vars:
        return simple_vars[var]

    # Random number: %random.N%
    random_match = re.match(r'random\.(\d+)', var)
    if random_match:
        return f'random(1, {random_match.group(1)})'

    if var == 'random.char':
        return 'room.actors[random(1, #room.actors)]'

    # Global get functions: %get.func[arg]%
    get_match = re.match(r'get\.(\w+)\[([^\]]+)\]', var)
    if get_match:
        func = get_match.group(1)
        arg = get_match.group(2)
        # If arg contains %, it's a variable reference - extract it
        if arg.startswith('%') and arg.endswith('%'):
            arg = convert_variable_expr(arg)
            is_var = True
        else:
            is_var = False

        # Convert to modern API patterns
        if func == 'mob_shortdesc':
            # get_mob_shortdesc(vnum) -> mobiles.template(zone, local).name
            if is_var:
                return f'mobiles.template(vnum_to_zone({arg}), vnum_to_local({arg})).name'
            else:
                composite = _vnum_to_composite(arg)
                return f'mobiles.template({composite}).name'
        elif func == 'obj_shortdesc':
            # get_obj_shortdesc(vnum) -> objects.template(zone, local).name
            if is_var:
                return f'objects.template(vnum_to_zone({arg}), vnum_to_local({arg})).name'
            else:
                composite = _vnum_to_composite(arg)
                return f'objects.template({composite}).name'
        elif func == 'mob_count':
            # get_mob_count(keyword) -> world.count_mobiles(keyword)
            # Note: DG Script's get.mob_count is a global count across the world
            if is_var:
                return f'world.count_mobiles({arg})'
            else:
                return f'world.count_mobiles("{arg}")'
        elif func == 'obj_count':
            # get_obj_count(keyword) -> world.count_objects(keyword)
            # Note: DG Script's get.obj_count is a global count across the world
            if is_var:
                return f'world.count_objects({arg})'
            else:
                return f'world.count_objects("{arg}")'

        # Default: keep legacy pattern (will show as UNCONVERTED if not implemented)
        if is_var:
            return f'get_{func}({arg})'
        return f'get_{func}("{arg}")'

    # Property access
    if '.' in var:
        parts = var.split('.', 1)
        obj = simple_vars.get(parts[0], parts[0])
        prop = parts[1]

        # Property mappings
        prop_map = {
            'name': 'name', 'level': 'level', 'class': 'class',
            'vnum': 'id', 'room': 'room', 'hp': 'hp', 'maxhp': 'max_hp',
            'mana': 'mana', 'maxmana': 'max_mana', 'move': 'move',
            'maxmove': 'max_move', 'gold': 'wealth', 'align': 'alignment',
            'alignment': 'alignment', 'sex': 'gender', 'size': 'size',
            'is_npc': 'is_npc', 'is_pc': 'is_player', 'fighting': 'is_fighting',
            'pos': 'position', 'position': 'position',
        }

        # Pronoun handling - use actor properties
        if prop == 'p':  # possessive (his/her/its)
            return f'{obj}.possessive'
        elif prop == 'n':  # name
            return f'{obj}.name'
        elif prop == 's':  # subject pronoun (he/she/it)
            return f'{obj}.subject'
        elif prop == 'o':  # object pronoun (him/her/it)
            return f'{obj}.object'

        # Quest stage check: actor.quest_stage[quest_name]
        quest_stage_match = re.match(r'quest_stage\[([^\]]+)\]', prop)
        if quest_stage_match:
            quest_name = quest_stage_match.group(1)
            return f'{obj}:get_quest_stage("{quest_name}")'

        # Quest variable check: actor.quest_variable[quest:var]
        quest_var_match = re.match(r'quest_variable\[([^\]]+)\]', prop)
        if quest_var_match:
            quest_var = quest_var_match.group(1)
            return f'{obj}:get_quest_var("{quest_var}")'

        # Variable exists check: actor.varexists[varname]
        varexists_match = re.match(r'varexists\[([^\]]+)\]', prop)
        if varexists_match:
            var_name = varexists_match.group(1)
            return f'{obj}:has_var("{var_name}")'

        # Skill check
        skill_match = re.match(r'skill\[([^\]]+)\]', prop)
        if skill_match:
            return f'{obj}:has_skill("{skill_match.group(1)}")'

        # Inventory check
        inv_match = re.match(r'inventory\[([^\]]+)\]', prop)
        if inv_match:
            return f'{obj}:has_item("{inv_match.group(1)}")'

        # Wearing check
        wear_match = re.match(r'wearing\[([^\]]+)\]', prop)
        if wear_match:
            return f'{obj}:has_equipped("{wear_match.group(1)}")'

        # Affect flag check: actor.aff_flagged[FLAG] -> actor:has_effect(Effect.Name)
        # Maps legacy DG Script affect flags to modern effect names
        # Note: DG Scripts use square brackets: %actor.aff_flagged[FLAG]%
        aff_match = re.match(r'aff_flagged\[([^\]]+)\]', prop)
        if aff_match:
            flag_name = aff_match.group(1).strip()
            negated = flag_name.startswith('!')
            if negated:
                flag_name = flag_name[1:]

            # Map legacy flag names to modern effect names (PascalCase)
            effect_map = {
                'BLIND': 'Blind',
                'INVISIBLE': 'Invisible',
                'INVIS': 'Invisible',
                'DET-MAGIC': 'DetectMagic',
                'DETECT_MAGIC': 'DetectMagic',
                'DET-INVIS': 'DetectInvis',
                'DETECT_INVIS': 'DetectInvis',
                'DET-ALIGN': 'DetectAlign',
                'DETECT_ALIGN': 'DetectAlign',
                'SENSE-LIFE': 'SenseLife',
                'SENSE_LIFE': 'SenseLife',
                'SANCTUARY': 'Sanctuary',
                'SANCT': 'Sanctuary',
                'POISON': 'Poison',
                'INFRAVISION': 'Infravision',
                'INFRA': 'Infravision',
                'FLY': 'Flying',
                'FLYING': 'Flying',
                'SNEAK': 'Sneak',
                'SNEAKING': 'Sneak',
                'HIDE': 'Hide',
                'HIDDEN': 'Hide',
                'CHARM': 'Charm',
                'CHARMED': 'Charm',
                'HASTE': 'Haste',
                'SLOW': 'Slow',
                'BERSERK': 'Berserk',
                'PARALYZED': 'Paralyzed',
                'WATERWALK': 'Waterwalk',
                'WATERBREATH': 'WaterBreathing',
                'UNDERWATER_BREATHING': 'WaterBreathing',
                'BLESS': 'Bless',
                'ARMOR': 'Armor',
                'SHIELD': 'Shield',
                'STONESKIN': 'Stoneskin',
                'HEAT': 'HeatResistance',  # For !HEAT checks
            }

            # Normalize to uppercase for lookup
            effect_name = effect_map.get(flag_name.upper(), flag_name.title())

            # Use Effect table for typo safety
            expr = f'{obj}:has_effect(Effect.{effect_name})'
            if negated:
                expr = f'not {expr}'
            return expr

        # People count
        if prop == 'people[count]':
            return f'{obj}.actor_count'

        # Generic array access: obj.prop[key] - convert to method call
        generic_array_match = re.match(r'(\w+)\[([^\]]+)\]', prop)
        if generic_array_match:
            prop_name = generic_array_match.group(1)
            key = generic_array_match.group(2)
            return f'{obj}:get_{prop_name}("{key}")'

        if prop in prop_map:
            return f'{obj}.{prop_map[prop]}'

        return f'{obj}.{prop}'

    return var


def convert_text_with_vars(text: str) -> str:
    """
    Convert text containing %variables% to a complete Lua string expression.

    Returns a complete Lua expression that evaluates to a string, with proper
    concatenation of literals and variable references.
    """
    # First convert colors
    text = convert_colors(text)

    # If no variables, just return quoted string
    if '%' not in text:
        text = text.replace('\\', '\\\\').replace('"', '\\"')
        return f'"{text}"'

    # Split text by variables and build concatenation
    # Handle nested variables like %get.func[%inner%]%
    parts = []
    i = 0
    length = len(text)

    while i < length:
        # Find next %
        start = text.find('%', i)
        if start == -1:
            # No more variables, add remaining text
            remaining = text[i:]
            if remaining:
                remaining = remaining.replace('\\', '\\\\').replace('"', '\\"')
                parts.append(f'"{remaining}"')
            break

        # Add text before the variable
        before = text[i:start]
        if before:
            before = before.replace('\\', '\\\\').replace('"', '\\"')
            parts.append(f'"{before}"')

        # Find the matching closing % (handling nested %)
        depth = 1
        j = start + 1
        while j < length and depth > 0:
            if text[j] == '%':
                # Check if this is a nested start or the end
                if j + 1 < length and text[j + 1] != '%':
                    # Could be nested start or end
                    # Look ahead to see if there's content before next %
                    next_pct = text.find('%', j + 1)
                    if next_pct != -1 and '[' in text[start:j]:
                        # This might be a nested variable like %outer[%inner%]%
                        # Find the inner % pair first
                        depth += 1
                        j += 1
                        continue
                depth -= 1
            j += 1

        if depth == 0:
            # Found matching %
            var = text[start + 1:j - 1]
            # Handle nested variables: extract inner %var% and convert
            if '%' in var:
                # Replace inner %var% with converted expressions
                var = re.sub(r'%([^%\[\]]+)%', lambda m: convert_variable_expr(m.group(1)), var)
            expr = convert_variable_expr(var)
            if expr.startswith('get_'):
                parts.append(expr)
            else:
                parts.append(f'tostring({expr})')
            i = j
        else:
            # No matching %, treat as literal
            remaining = text[start:]
            remaining = remaining.replace('\\', '\\\\').replace('"', '\\"')
            parts.append(f'"{remaining}"')
            break

    # Join with concatenation operator
    if len(parts) == 0:
        return '""'
    if len(parts) == 1:
        return parts[0]
    return ' .. '.join(parts)


def convert_condition(cond: str) -> str:
    """Convert a DG Script condition to Lua."""
    result = cond.strip()

    # Remove surrounding parentheses if balanced
    while result.startswith('(') and result.endswith(')'):
        depth = 0
        balanced = True
        for i, c in enumerate(result):
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
            if depth == 0 and i < len(result) - 1:
                balanced = False
                break
        if balanced:
            result = result[1:-1].strip()
        else:
            break

    # Convert variables first
    result = re.sub(r'%([^%]+)%', lambda m: convert_variable_expr(m.group(1)), result)

    # String contains/equals: /= (use word boundaries to avoid capturing parens)
    result = re.sub(r'([\w.]+)\s+/=\s+([\w.]+)',
                    lambda m: f'string.find({m.group(1)}, "{m.group(2)}")', result)

    # Operators - order matters!
    result = result.replace('!=', ' ~= ')  # Not equal BEFORE negation
    result = result.replace('&&', ' and ')
    result = result.replace('||', ' or ')
    # Single | is also OR in DG Script (be careful not to replace || which is already handled)
    result = re.sub(r'(?<!\|)\|(?!\|)', ' or ', result)

    # Negation - comprehensive conversion
    result = re.sub(r'!\s*\(', 'not (', result)  # !(expr)
    result = re.sub(r'!\s*(\w[\w.:]*)', r'not \1', result)  # !variable or !obj.prop

    # Quote unquoted string comparisons (word == word or word ~= word)
    # Handle multi-word string values like "bludgeoning weapons"
    # Match: == or ~= followed by words (with optional missing space) up to 'then', 'and', 'or', ')', end
    def quote_comparison_value(match):
        op = match.group(1)
        value = match.group(2).strip()
        # Don't quote if it's a number, already quoted, or a variable reference
        if value.isdigit() or value.startswith('"') or '.' in value or ':' in value:
            return f'{op} {value}'
        return f'{op} "{value}"'

    # Handle both ==word and == word patterns
    result = re.sub(
        r'(==|~=)\s*([a-zA-Z_][a-zA-Z0-9_ ?!-]*?)(?=\s+(?:then|and|or)\b|\s*\)|\s*$)',
        quote_comparison_value,
        result
    )

    # Clean up multiple spaces
    result = re.sub(r'\s+', ' ', result)

    return result


def convert_command(cmd: str, indent: int = 0) -> Optional[str]:
    """Convert a single DG Script command to Lua."""
    cmd = cmd.strip()
    if not cmd:
        return None

    ind = '    ' * indent

    # Comments
    if cmd.startswith('*'):
        return f'{ind}-- {cmd[1:].strip()}'

    # === Pre-processing: Fix common typos ===

    # Double command prefix typos: msend msend -> msend
    cmd = re.sub(r'^(msend|wsend|osend)\s+\1\s+', r'\1 ', cmd, flags=re.IGNORECASE)

    # wati -> wait (typo)
    cmd = re.sub(r'^wati\s+', 'wait ', cmd, flags=re.IGNORECASE)

    # way Ns -> wait Ns (typo)
    cmd = re.sub(r'^way\s+(\d+s?)$', r'wait \1', cmd, flags=re.IGNORECASE)

    # wait2 -> wait 2 (missing space)
    cmd = re.sub(r'^wait(\d+)$', r'wait \1', cmd, flags=re.IGNORECASE)

    # wait 5ss -> wait 5s (double s)
    cmd = re.sub(r'^wait\s+(\d+)ss$', r'wait \1s', cmd, flags=re.IGNORECASE)

    # cas -> cast (typo)
    cmd = re.sub(r'^cas\s+', 'cast ', cmd, flags=re.IGNORECASE)

    # set %var% value -> set var value (remove percent signs from variable name)
    cmd = re.sub(r'^set\s+%(\w+)%\s+', r'set \1 ', cmd, flags=re.IGNORECASE)

    # eval %var% expr -> eval var expr (remove percent signs from variable name)
    cmd = re.sub(r'^eval\s+%(\w+)%\s+', r'eval \1 ', cmd, flags=re.IGNORECASE)

    # set varvalue -> set var value (missing space before numeric value)
    # e.g., set vnum_destroyed_gloves55331 -> set vnum_destroyed_gloves 55331
    cmd = re.sub(r'^set\s+([a-zA-Z_][a-zA-Z0-9_]*)(\d{4,})$', r'set \1 \2', cmd, flags=re.IGNORECASE)

    # return O -> return 0 (typo: O instead of 0)
    cmd = re.sub(r'^return\s+O$', 'return 0', cmd, flags=re.IGNORECASE)

    cmd_lower = cmd.lower()

    # Control flow (handled separately)
    if cmd_lower.startswith(('if ', 'elseif ', 'else', 'end', 'switch ', 'case ', 'default', 'done')):
        return None

    # === Communication Commands ===

    # say (with content or empty)
    match = re.match(r'^say\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self:say({text})'

    if cmd_lower == 'say':
        return f'{ind}-- (empty say)'

    # sat (typo for say)
    match = re.match(r'^sat\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self:say({text})  -- typo: sat'

    # sa (abbreviation for say)
    match = re.match(r'^sa\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self:say({text})'

    # whisper
    match = re.match(r'^whisper\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}self:whisper({target}, {text})'

    match = re.match(r'^whisper\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = match.group(1)
        text = convert_text_with_vars(match.group(2))
        return f'{ind}self:whisper(self.room:find_actor("{target}"), {text})'

    # emote/em/emotes
    match = re.match(r'^(?:emote|em|emot|emotes)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self:emote({text})'

    # : action (colon prefix for emote)
    match = re.match(r'^:\s*(.+)$', cmd)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self:emote({text})'

    # msend/wsend/osend (send to specific actor)
    match = re.match(r'^[mwo]send\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}{target}:send({text})'

    # msend/osend with no space after target variable
    # e.g., msend %actor%%self.name% text -> actor:send(self.name .. " text")
    match = re.match(r'^[mwo]send\s+%([^%]+)%(%[^%]+%|\S)(.*)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        rest_start = match.group(2)
        rest_text = match.group(3)
        if rest_start.startswith('%') and rest_start.endswith('%'):
            # Another variable immediately after: %actor%%self.name%
            var2 = convert_variable_expr(rest_start[1:-1])
            if rest_text:
                text = convert_text_with_vars(rest_text)
                return f'{ind}{target}:send({var2} .. {text})'
            else:
                return f'{ind}{target}:send({var2})'
        else:
            # Non-space character immediately after: %actor%- or %actor%&0
            full_text = rest_start + rest_text
            text = convert_text_with_vars(full_text)
            return f'{ind}{target}:send({text})'

    # osend/msend with space inside variable (typo): osend %actor %text
    match = re.match(r'^[mwo]send\s+%(\w+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}{target}:send({text})  -- fixed: space in var name'

    # osent/msent (typos for osend/msend)
    match = re.match(r'^[mo]sent\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}{target}:send({text})  -- typo: sent'

    # mecho/wecho/oecho (send to room)
    match = re.match(r'^[mwo]echo\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self.room:send({text})'

    # mpecho (MPROG echo - convert to room echo)
    match = re.match(r'^mpecho\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self.room:send({text})  -- from MPROG'

    # === MPROG legacy commands (use $n, $I, $o variables) ===
    # mpechoaround $n message - echo to room except target
    match = re.match(r'^mpechoaround\s+\$[nN]\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = match.group(1)
        # Convert $I to self, $n to actor, $o to object
        text = re.sub(r'\$[iI]', 'self.name', text)
        text = re.sub(r'\$[nN]', 'actor.name', text)
        text = re.sub(r'\$[oO]', 'object.shortdesc', text)
        return f'{ind}self.room:send_except(actor, "{text}")  -- from MPROG'

    # mpechoat $n message - echo to specific target
    match = re.match(r'^mpechoat\s+\$[nN]\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = match.group(1)
        text = re.sub(r'\$[iI]', 'self.name', text)
        text = re.sub(r'\$[nN]', 'actor.name', text)
        text = re.sub(r'\$[oO]', 'object.shortdesc', text)
        return f'{ind}actor:send("{text}")  -- from MPROG'

    # MPTRANSFER $n room - teleport target
    match = re.match(r'^mptransfer\s+\$[nN]\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        return f'{ind}actor:teleport({room_call})  -- from MPROG'

    # mpjunk $o - destroy object
    match = re.match(r'^mpjunk\s+\$[oO]$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}world.destroy(object)  -- from MPROG'

    # Standalone mecho/wecho/oecho (no message - likely incomplete trigger)
    if cmd_lower in ('mecho', 'wecho', 'oecho'):
        return f'{ind}-- (empty room echo)'

    # msend/wsend/osend without message (incomplete trigger)
    match = re.match(r'^[mwo]send\s+%([^%]+)%\s*$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}-- (empty send to {match.group(1)})'

    # mechoaround/wechoaround/oechoaround (also handle mechoabout typo)
    match = re.match(r'^[mwo]echo(?:around|about)\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}self.room:send_except({target}, {text})'

    # wzoneecho (zone-wide echo)
    match = re.match(r'^wzoneecho\s+(\d+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        zone = match.group(1)
        text = convert_text_with_vars(match.group(2))
        return f'{ind}zone.echo({zone}, {text})'

    # wzoneecho without zone number (current zone)
    match = re.match(r'^wzoneecho\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}zone.echo(self.room.zone_id, {text})'

    # wechoaround by name (not variable)
    match = re.match(r'^wechoaround\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        text = convert_text_with_vars(match.group(2))
        if not target_name.startswith('%'):
            return f'{ind}self.room:send_except(self.room:find_actor("{target_name}"), {text})'

    # oforce (object force - make actor do something)
    # Try to convert the inner action to proper Lua API call
    match = re.match(r'^oforce\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        action = match.group(2)
        # Check for mload obj - should spawn into actor's inventory
        mload_result = _convert_mload_for_actor(action, target, ind)
        if mload_result:
            return mload_result
        inner_cmd = convert_command(action, 0).strip()
        # If inner command was converted successfully, replace self: with target
        if 'UNCONVERTED' not in inner_cmd and inner_cmd.startswith('self:'):
            return f'{ind}{inner_cmd.replace("self:", f"{target}:", 1)}'
        # Otherwise use command() for runtime execution
        return f'{ind}{target}:command("{action}")'

    match = re.match(r'^oforce\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        action = match.group(2)
        target = f'self.room:find_actor("{target_name}")'
        # Check for mload obj - should spawn into actor's inventory
        mload_result = _convert_mload_for_actor(action, target, ind)
        if mload_result:
            return mload_result
        inner_cmd = convert_command(action, 0).strip()
        if 'UNCONVERTED' not in inner_cmd and inner_cmd.startswith('self:'):
            return f'{ind}{inner_cmd.replace("self:", f"{target}:", 1)}'
        return f'{ind}{target}:command("{action}")'

    # tell
    match = re.match(r'^tell\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}{target}:send(self.name .. " tells you, \'" .. {text} .. "\'")'

    # t (shorthand for tell)
    match = re.match(r'^t\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}{target}:send(self.name .. " tells you, \'" .. {text} .. "\'")'

    # shout
    match = re.match(r'^shout\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self:shout({text})'

    # masound (area sound - message to adjacent rooms)
    match = re.match(r'^masound\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}self.room:send_to_adjacent({text})'

    # === Timing ===

    # wait N or wait N s
    match = re.match(r'^wait\s+(\d+)\s*s?$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}wait({match.group(1)})'

    # wait N seconds (spelled out)
    match = re.match(r'^wait\s+(\d+)\s+seconds?$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}wait({match.group(1)})'

    # wait %var%s or wait %var% s (variable seconds)
    match = re.match(r'^wait\s+%([^%]+)%\s*s?$', cmd, re.IGNORECASE)
    if match:
        delay = convert_variable_expr(match.group(1))
        return f'{ind}wait({delay})'

    # wait until HH:MM (time-based wait)
    match = re.match(r'^wait\s+until\s+(\d{1,2}):(\d{2})$', cmd, re.IGNORECASE)
    if match:
        hour = match.group(1)
        minute = match.group(2)
        return f'{ind}wait_until({hour}, {minute})'

    # wait N t (ticks)
    match = re.match(r'^wait\s+(\d+)\s*t$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}wait_ticks({match.group(1)})'

    # === Flow Control ===
    # In DG Script: return 0/1 sets return value but does NOT stop execution
    # Only 'halt' actually stops execution
    # We use a _return_value variable to track this

    if cmd_lower == 'halt':
        return f'{ind}return _return_value'

    if cmd_lower == 'return 0':
        return f'{ind}_return_value = false'

    if cmd_lower == 'return 1':
        return f'{ind}_return_value = true'

    # === Spawning ===
    # Modern API uses composite IDs: self.room:spawn_mobile(zone_id, local_id)
    # Using self.room instead of room so mforce can replace self with target

    # mload mob - literal or variable
    match = re.match(r'^mload\s+mob\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{ind}self.room:spawn_mobile({composite})'

    match = re.match(r'^mload\s+mob\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        vnum = convert_variable_expr(match.group(1))
        return f'{ind}self.room:spawn_mobile(vnum_to_zone({vnum}), vnum_to_local({vnum}))'

    # mload obj - literal or variable
    match = re.match(r'^mload\s+obj\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{ind}self.room:spawn_object({composite})'

    match = re.match(r'^mload\s+obj\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        vnum = convert_variable_expr(match.group(1))
        return f'{ind}self.room:spawn_object(vnum_to_zone({vnum}), vnum_to_local({vnum}))'

    # wload/oload mob/obj - world/object load
    match = re.match(r'^[wo]load\s+mob\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{ind}self.room:spawn_mobile({composite})'

    match = re.match(r'^[wo]load\s+obj\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{ind}self.room:spawn_object({composite})'

    match = re.match(r'^[wo]load\s+mob\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        vnum = convert_variable_expr(match.group(1))
        return f'{ind}self.room:spawn_mobile(vnum_to_zone({vnum}), vnum_to_local({vnum}))'

    match = re.match(r'^[wo]load\s+obj\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        vnum = convert_variable_expr(match.group(1))
        return f'{ind}self.room:spawn_object(vnum_to_zone({vnum}), vnum_to_local({vnum}))'

    # mload m / wload o (abbreviated form)
    match = re.match(r'^mload\s+m\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{ind}self.room:spawn_mobile({composite})'

    match = re.match(r'^[wo]load\s+o\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        composite = _vnum_to_composite(match.group(1))
        return f'{ind}self.room:spawn_object({composite})'

    # === Mob Management Commands ===

    # mjunk/ojunk (destroy an object)
    match = re.match(r'^[mo]junk\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        obj = convert_variable_expr(match.group(1))
        return f'{ind}world.destroy({obj})'

    match = re.match(r'^[mo]junk\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}self:destroy_item("{match.group(1)}")'

    # mexp/wexp (give experience to player)
    match = re.match(r'^[mw]exp\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        exp = convert_variable_expr(match.group(2))
        return f'{ind}{target}:award_exp({exp})'

    match = re.match(r'^[mw]exp\s+%([^%]+)%\s+(-?\d+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}{target}:award_exp({match.group(2)})'

    # wexp with actor.name (name lookup)
    match = re.match(r'^wexp\s+(\S+)\s+(-?\d+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}self.room:find_actor("{match.group(1)}"):award_exp({match.group(2)})'

    # msave (save player data)
    match = re.match(r'^msave\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}{target}:save()'

    # === Quest Commands ===

    # quest variable <quest_name> <player> <var_name> <value>
    match = re.match(r'^quest\s+variable\s+(\S+)\s+%([^%]+)%\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        var_name = match.group(3)
        value = match.group(4)
        # Handle variable values
        if value.startswith('%') and value.endswith('%'):
            value = convert_variable_expr(value)
        else:
            value = f'"{value}"' if not value.isdigit() else value
        return f'{ind}{player}:set_quest_var("{quest}", "{var_name}", {value})'

    # quest advance <quest_name> <player>
    match = re.match(r'^quest\s+advance\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        return f'{ind}{player}:advance_quest("{quest}")'

    # quest complete <quest_name> <player>
    match = re.match(r'^quest\s+complete\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        return f'{ind}{player}:complete_quest("{quest}")'

    # quest start <quest_name> <player>
    match = re.match(r'^quest\s+start\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        return f'{ind}{player}:start_quest("{quest}")'

    # quest erase <quest_name> <player>
    match = re.match(r'^quest\s+erase\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        return f'{ind}{player}:erase_quest("{quest}")'

    # quest fail <quest_name> <player>
    match = re.match(r'^quest\s+fail\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        return f'{ind}{player}:fail_quest("{quest}")'

    # quest restart <quest_name> <player_name>
    match = re.match(r'^quest\s+restart\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        return f'{ind}{player}:restart_quest("{quest}")'

    match = re.match(r'^quest\s+restart\s+(\S+)\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player_name = match.group(2)
        return f'{ind}find_player("{player_name}"):restart_quest("{quest}")'

    # quest start with extra argument (subclass name etc)
    match = re.match(r'^quest\s+start\s+(\S+)\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        arg = convert_variable_expr(match.group(3))
        return f'{ind}{player}:start_quest("{quest}", {arg})'

    match = re.match(r'^quest\s+start\s+(\S+)\s+%([^%]+)%\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        quest = match.group(1)
        player = convert_variable_expr(match.group(2))
        arg = match.group(3)
        return f'{ind}{player}:start_quest("{quest}", "{arg}")'

    # === Movement Commands ===

    # Basic directional movement (including single-letter abbreviations)
    directions = ['north', 'south', 'east', 'west', 'up', 'down', 'ne', 'nw', 'se', 'sw',
                  'northeast', 'northwest', 'southeast', 'southwest',
                  'n', 's', 'e', 'w', 'u', 'd']
    if cmd_lower in directions:
        return f'{ind}self:move("{cmd_lower}")'

    # mgoto (mob goto room)
    match = re.match(r'^mgoto\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        return f'{ind}self:teleport({room_call})'

    match = re.match(r'^mgoto\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        return f'{ind}self:teleport({room_call})'

    # mat (mob at room - execute command at another room) - use room:at()
    # Recursively convert the inner command
    match = re.match(r'^mat\s+(\d+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        inner_cmd = convert_command(match.group(2), 0).strip()
        if 'UNCONVERTED' in inner_cmd:
            inner_cmd = f'-- {match.group(2)}'
        return f'{ind}{room_call}:at(function()\n{ind}    {inner_cmd}\n{ind}end)'

    match = re.match(r'^mat\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        inner_cmd = convert_command(match.group(2), 0).strip()
        if 'UNCONVERTED' in inner_cmd:
            inner_cmd = f'-- {match.group(2)}'
        return f'{ind}{room_call}:at(function()\n{ind}    {inner_cmd}\n{ind}end)'

    # mat by mob name (find mob's room and execute there)
    # Use nil-safe pattern since mob may not exist
    match = re.match(r'^mat\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        mob_name = match.group(1)
        action = match.group(2)
        if not mob_name.startswith('%') and not mob_name.isdigit():
            inner_cmd = convert_command(action, 0).strip()
            if 'UNCONVERTED' in inner_cmd:
                inner_cmd = f'-- {action}'
            # Generate nil-safe code with local variable
            return (f'{ind}do\n'
                    f'{ind}    local _mob = world.find_mobile("{mob_name}")\n'
                    f'{ind}    if _mob then\n'
                    f'{ind}        _mob.room:at(function()\n'
                    f'{ind}            {inner_cmd}\n'
                    f'{ind}        end)\n'
                    f'{ind}    end\n'
                    f'{ind}end')

    # === Combat/Damage ===

    match = re.match(r'^[mwo]damage\s+%([^%]+)%\s+%([^%]+)%(?:\s+(\w+))?$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        damage = convert_variable_expr(match.group(2))
        dtype = match.group(3) or 'physical'
        return f'{ind}local damage_dealt = {target}:damage({damage})  -- type: {dtype}'

    # wdamage with literal damage value
    match = re.match(r'^[mwo]damage\s+%([^%]+)%\s+(\d+)(?:\s+(\w+))?$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        damage = match.group(2)
        dtype = match.group(3) or 'physical'
        return f'{ind}{target}:damage({damage})  -- type: {dtype}'

    # wdamage silent (damage without message)
    match = re.match(r'^wdamage\s+silent\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        damage = match.group(1)
        return f'{ind}actor:damage({damage}, true)  -- silent damage'

    # wdamage negative (healing)
    match = re.match(r'^wdamage\s+%([^%]+)%\s+(-\d+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        heal_amount = match.group(2)[1:]  # Remove the minus sign
        return f'{ind}{target}:heal({heal_amount})'

    # mdamage by name (not variable)
    match = re.match(r'^mdamage\s+(\S+)\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        damage = match.group(2)
        if not target_name.startswith('%'):
            return f'{ind}self.room:find_actor("{target_name}"):damage({damage})'

    # odamage/oheal with variable arg (single arg that is the amount)
    match = re.match(r'^odamage\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        amount = convert_variable_expr(match.group(1))
        return f'{ind}actor:damage({amount})'

    match = re.match(r'^oheal\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        amount = convert_variable_expr(match.group(1))
        return f'{ind}actor:heal({amount})'

    # mcast (mob cast spell)
    match = re.match(r'^mcast\s+(\S+)\s+%([^%]+)%(?:\s+(\d+))?$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = match.group(3) or 'self.level'
        return f'{ind}spells.cast(self, "{spell}", {target}, {level})'

    # mcast with quoted spell name
    match = re.match(r'^mcast\s+[\'"]([^\'"]+)[\'"]\s+%([^%]+)%(?:\s+(\d+))?$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = match.group(3) or 'self.level'
        return f'{ind}spells.cast(self, "{spell}", {target}, {level})'

    # mcast with variable level
    match = re.match(r'^mcast\s+(\S+)\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = convert_variable_expr(match.group(3))
        return f'{ind}spells.cast(self, "{spell}", {target}, {level})'

    # cast (self or target) - various formats
    # cast '<spell>' (self-targeting)
    match = re.match(r'^cast\s+[\'"]([^\'"]+)[\'"]$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        return f'{ind}spells.cast(self, "{spell}")'

    # cast 'spell'%target% (no space before variable - typo)
    match = re.match(r'^cast\s+[\'"]([^\'"]+)[\'"]%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        return f'{ind}spells.cast(self, "{spell}", {target})  -- typo: no space'

    # cast '<spell>' <target>
    match = re.match(r'^cast\s+[\'"]([^\'"]+)[\'"]\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        return f'{ind}spells.cast(self, "{spell}", {target})'

    match = re.match(r'^cast\s+[\'"]([^\'"]+)[\'"]\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = match.group(2)
        return f'{ind}spells.cast(self, "{spell}", self.room:find_actor("{target}"))'

    # c '<spell>' (shorthand for cast)
    match = re.match(r'^c\s+[\'"]([^\'"]+)[\'"]$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        return f'{ind}spells.cast(self, "{spell}")'

    match = re.match(r'^c\s+[\'"]([^\'"]+)[\'"]\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        return f'{ind}spells.cast(self, "{spell}", {target})'

    match = re.match(r'^c\s+[\'"]([^\'"]+)[\'"]\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = match.group(2)
        return f'{ind}spells.cast(self, "{spell}", self.room:find_actor("{target}"))'

    # ocast (object cast spell)
    match = re.match(r'^ocast\s+[\'"]?([^\'"]+)[\'"]?\s+%([^%]+)%(?:\s+(\d+))?$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = match.group(3) or 'self.level'
        return f'{ind}spells.cast(self, "{spell}", {target}, {level})'

    match = re.match(r'^ocast\s+[\'"]?([^\'"]+)[\'"]?\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        spell = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = convert_variable_expr(match.group(3))
        return f'{ind}spells.cast(self, "{spell}", {target}, {level})'

    # wheal/oheal/mheal (heal target)
    match = re.match(r'^[wom]heal\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        amount = convert_variable_expr(match.group(2))
        return f'{ind}{target}:heal({amount})'

    # heal with literal amount
    match = re.match(r'^[wom]heal\s+%([^%]+)%\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}{target}:heal({match.group(2)})'

    # heal by name
    match = re.match(r'^[wom]heal\s+(\S+)\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target = match.group(1)
        return f'{ind}self.room:find_actor("{target}"):heal({match.group(2)})'

    # heal by name with variable amount
    match = re.match(r'^[wom]heal\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = match.group(1)
        amount = convert_variable_expr(match.group(2))
        if not target.startswith('%'):
            return f'{ind}self.room:find_actor("{target}"):heal({amount})'

    # oexp (object give experience)
    match = re.match(r'^oexp\s+%([^%]+)%\s+(-?\d+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}{target}:award_exp({match.group(2)})'

    match = re.match(r'^oexp\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        exp = convert_variable_expr(match.group(2))
        return f'{ind}{target}:award_exp({exp})'

    # oexp by name
    match = re.match(r'^oexp\s+(\S+)\s+(-?\d+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}self.room:find_actor("{match.group(1)}"):award_exp({match.group(2)})'

    # Combat skill commands (backstab, bash, kick as combat abilities)
    match = re.match(r'^(backstab|bash)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        skill = match.group(1)
        target = convert_variable_expr(match.group(2))
        return f'{ind}skills.execute(self, "{skill}", {target})'

    match = re.match(r'^(backstab|bash)\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        skill = match.group(1)
        target = match.group(2)
        return f'{ind}skills.execute(self, "{skill}", self.room:find_actor("{target}"))'

    # Standalone combat skills (attack current target)
    if cmd_lower in ('backstab', 'bash', 'kick'):
        return f'{ind}skills.execute(self, "{cmd_lower}", self.fighting)'

    # odamage (object damage)
    match = re.match(r'^odamage\s+%([^%]+)%\s+(\d+)(?:\s+(\w+))?$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        damage = match.group(2)
        dtype = match.group(3) or 'physical'
        return f'{ind}{target}:damage({damage})  -- type: {dtype}'

    # Breath weapon attacks
    match = re.match(r'^breath\s+(\w+)(?:\s+%([^%]+)%)?$', cmd, re.IGNORECASE)
    if match:
        element = match.group(1)
        target = convert_variable_expr(match.group(2)) if match.group(2) else 'nil'
        return f'{ind}self:breath_attack("{element}", {target})'

    # mperform (mob perform skill/song)
    match = re.match(r'^mperform\s+[\'"]?([^\'"]+)[\'"]?\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        skill = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = convert_variable_expr(match.group(3))
        return f'{ind}self:perform("{skill}", {target}, {level})'

    match = re.match(r'^mperform\s+[\'"]?([^\'"]+)[\'"]?\s+%([^%]+)%(?:\s+(\d+))?$', cmd, re.IGNORECASE)
    if match:
        skill = match.group(1)
        target = convert_variable_expr(match.group(2))
        level = match.group(3) or 'self.level'
        return f'{ind}self:perform("{skill}", {target}, {level})'

    # chant (bard chant)
    match = re.match(r'^chant\s+[\'"]([^\'"]+)[\'"]$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}self:chant("{match.group(1)}")'

    match = re.match(r'^chant\s+[\'"]([^\'"]+)[\'"]\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        skill = match.group(1)
        target = convert_variable_expr(match.group(2))
        return f'{ind}self:chant("{skill}", {target})'

    # rescue (by name or variable)
    match = re.match(r'^rescue\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}combat.rescue(self, {target})'

    match = re.match(r'^rescue\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}combat.rescue(self, self.room:find_actor("{match.group(1)}"))'

    # log (log message for debugging)
    match = re.match(r'^log\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}trigger_log({text})'

    match = re.match(r'^[m]?kill\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}combat.engage(self, {target})'

    match = re.match(r'^[m]?kill\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}combat.engage(self, self.room:find_actor("{match.group(1)}"))'

    # hitall (attack all enemies)
    if cmd_lower == 'hitall':
        return f'{ind}self:attack_all()'

    # skillset (teach skill)
    match = re.match(r'^skillset\s+(\S+)\s+[\'"]?([^\'"]+)[\'"]?\s+(\w+)$', cmd, re.IGNORECASE)
    if match:
        target = match.group(1)
        skill = match.group(2)
        level = match.group(3)
        if target.startswith('%'):
            target = convert_variable_expr(target.strip('%'))
        else:
            target = f'self.room:find_actor("{target}")'
        return f'{ind}{target}:set_skill("{skill}", {level})'

    # follow command
    match = re.match(r'^(?:fol|follow)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}self:follow({target})'

    match = re.match(r'^(?:fol|follow)\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}self:follow(self.room:find_actor("{match.group(1)}"))'

    # === Movement/Teleport ===

    # teleport all in room
    match = re.match(r'^[wmo]teleport\s+all\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        return f'{ind}self.room:teleport_all({room_call})'

    match = re.match(r'^[mwo]teleport\s+%([^%]+)%\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        room_call = _get_room_call(match.group(2))
        return f'{ind}{target}:teleport({room_call})'

    # oteleport with variable room
    match = re.match(r'^[mwo]teleport\s+%([^%]+)%\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        room = convert_variable_expr(match.group(2))
        room_call = _get_room_call(room, is_variable=True)
        return f'{ind}{target}:teleport({room_call})'

    # oteleport with literal 0 (home room)
    match = re.match(r'^[mwo]teleport\s+%([^%]+)%\s+0$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}{target}:teleport_home()'

    # mteleport by name (not variable) to literal room
    match = re.match(r'^mteleport\s+(\S+)\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        if not target_name.startswith('%'):
            room_call = _get_room_call(match.group(2))
            return f'{ind}self.room:find_actor("{target_name}"):teleport({room_call})'

    # mteleport by name to named location
    match = re.match(r'^mteleport\s+(\S+)\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        location = match.group(2)
        if not target_name.startswith('%') and not location.isdigit():
            return f'{ind}self.room:find_actor("{target_name}"):teleport(find_room_by_name("{location}"))'

    # oteleport by name (not variable) to literal room
    match = re.match(r'^oteleport\s+(\S+)\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        room_call = _get_room_call(match.group(2))
        if not target_name.startswith('%'):
            return f'{ind}find_player("{target_name}"):teleport({room_call})'

    # mforce/wforce - try to convert inner action to proper Lua API call
    match = re.match(r'^[mw]force\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        action = match.group(2)
        if action.lower() == 'look':
            return f'{ind}-- {target} looks around'
        # Check for mload obj - should spawn into actor's inventory
        mload_result = _convert_mload_for_actor(action, target, ind)
        if mload_result:
            return mload_result
        # Try to convert the inner action
        inner_cmd = convert_command(action, 0).strip()
        if 'UNCONVERTED' not in inner_cmd and inner_cmd.startswith('self:'):
            return f'{ind}{inner_cmd.replace("self:", f"{target}:", 1)}'
        # Fall back to command() for runtime execution
        return f'{ind}{target}:command("{action}")'

    # === Door Manipulation ===
    # wdoor room direction action [target_room]
    # Common actions: open, close, lock, unlock, toggle

    # wdoor with room, direction, action
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+(\w+)(?:\s+(\d+))?$', cmd, re.IGNORECASE)
    if match:
        room_num = match.group(1)
        direction = match.group(2).lower()
        action = match.group(3).lower()
        target_room = match.group(4)  # Optional

        # Map action to doors namespace function
        room_call = _get_room_call(room_num)
        if action in ('open', 'close', 'lock', 'unlock'):
            return f'{ind}doors.{action}({room_call}, "{direction}")'
        else:
            # Complex action, use set_state
            return f'{ind}doors.set_state({room_call}, "{direction}", {{action = "{action}"}})'

    # wdoor with variable room
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+(\w+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        direction = match.group(2).lower()
        action = match.group(3).lower()
        room_call = _get_room_call(room, is_variable=True)
        if action in ('open', 'close', 'lock', 'unlock'):
            return f'{ind}doors.{action}({room_call}, "{direction}")'
        else:
            return f'{ind}doors.set_state({room_call}, "{direction}", {{action = "{action}"}})'

    # wdoor with flags: wdoor ROOM DIR flags FLAGS
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+flags\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        flags = match.group(3)
        return f'{ind}doors.set_flags({room_call}, "{direction}", "{flags}")'

    # wdoor with flags and variable room
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+flags\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        direction = match.group(2).lower()
        flags = match.group(3)
        return f'{ind}doors.set_flags({room_call}, "{direction}", "{flags}")'

    # wdoor with name: wdoor ROOM DIR name TEXT
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+name\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        name = match.group(3).strip()
        return f'{ind}doors.set_name({room_call}, "{direction}", "{name}")'

    # wdoor with name and variable room
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+name\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        direction = match.group(2).lower()
        name = match.group(3).strip()
        return f'{ind}doors.set_name({room_call}, "{direction}", "{name}")'

    # wdoor with key: wdoor ROOM DIR key NUM
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+key\s+(-?\d+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        key = match.group(3)
        return f'{ind}doors.set_key({room_call}, "{direction}", {key})'

    # wdoor with key and variable room
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+key\s+(-?\d+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        direction = match.group(2).lower()
        key = match.group(3)
        return f'{ind}doors.set_key({room_call}, "{direction}", {key})'

    # wdoor with key variable: wdoor ROOM DIR key %VAR%
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+key\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        key = convert_variable_expr(match.group(3))
        return f'{ind}doors.set_key({room_call}, "{direction}", {key})'

    # wdoor with description: wdoor ROOM DIR description TEXT
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+description\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        desc = match.group(3).strip()
        return f'{ind}doors.set_description({room_call}, "{direction}", "{desc}")'

    # wdoor with description and variable room
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+description\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        direction = match.group(2).lower()
        desc = match.group(3).strip()
        return f'{ind}doors.set_description({room_call}, "{direction}", "{desc}")'

    # wdoor with room target: wdoor %VAR% DIR room %VAR%
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+room\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        direction = match.group(2).lower()
        target_room = convert_variable_expr(match.group(3))
        return f'{ind}doors.set_exit({room_call}, "{direction}", {target_room})'

    # wdoor with room target (literal room): wdoor ROOM DIR room NUM
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+room\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        target_room_call = _get_room_call(match.group(3))
        return f'{ind}doors.set_exit({room_call}, "{direction}", {target_room_call})'

    # wdoor with room target (literal room, variable target): wdoor ROOM DIR room %VAR%
    match = re.match(r'^wdoor\s+(\d+)\s+(\w+)\s+room\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        direction = match.group(2).lower()
        target_room = convert_variable_expr(match.group(3))
        return f'{ind}doors.set_exit({room_call}, "{direction}", {target_room})'

    # wdoor with room target (variable room, literal target): wdoor %VAR% DIR room NUM
    match = re.match(r'^wdoor\s+%([^%]+)%\s+(\w+)\s+room\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        direction = match.group(2).lower()
        target_room_call = _get_room_call(match.group(3))
        return f'{ind}doors.set_exit({room_call}, "{direction}", {target_room_call})'

    # Generic wdoor fallback (unparseable format)
    match = re.match(r'^wdoor\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}-- UNCONVERTED wdoor: {match.group(1)}'

    # mdoor (mob door manipulation)
    match = re.match(r'^mdoor\s+(\d+)\s+(\w+)\s+(\w+)(?:\s+(\d+))?$', cmd, re.IGNORECASE)
    if match:
        room_num = match.group(1)
        direction = match.group(2).lower()
        action = match.group(3).lower()
        room_call = _get_room_call(room_num)

        if action in ('open', 'close', 'lock', 'unlock'):
            return f'{ind}doors.{action}({room_call}, "{direction}")'
        else:
            return f'{ind}doors.set_state({room_call}, "{direction}", {{action = "{action}"}})'

    # Generic mdoor fallback
    match = re.match(r'^mdoor\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}-- UNCONVERTED mdoor: {match.group(1)}'

    # === Skills ===
    # Use skills.set_level(actor, skill_name, level) - setting to 100 = learned

    match = re.match(r'^mskillset\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        skill = match.group(2)
        return f'{ind}skills.set_level({target}, "{skill}", 100)'

    # oskillset (object teach skill)
    match = re.match(r'^oskillset\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        skill = match.group(2)
        return f'{ind}skills.set_level({target}, "{skill}", 100)'

    match = re.match(r'^oskillset\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        skill = match.group(2)
        return f'{ind}skills.set_level(world.find_player("{target_name}"), "{skill}", 100)'

    # === Variables ===

    # Dynamic variable names: set varname%index% value
    # e.g., set card%card% %plyr% -> card[card] = plyr
    match = re.match(r'^set\s+(\w+)%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        var_base = match.group(1)
        index = convert_variable_expr(match.group(2))
        value = match.group(3).strip()
        if value.startswith('%') and value.endswith('%'):
            value = convert_variable_expr(value[1:-1])
        elif value.isdigit() or (value.startswith('-') and value[1:].isdigit()):
            pass  # Keep numeric value
        else:
            value = f'"{value}"'
        return f'{ind}{var_base}[{index}] = {value}'

    match = re.match(r'^set\s+(\w+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        var_name = match.group(1)
        value = convert_variable_expr(match.group(2))
        return f'{ind}local {var_name} = {value}'

    match = re.match(r'^set\s+(\w+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        var_name = match.group(1)
        value = match.group(2).strip()
        # If value contains variables or operators, it's an expression
        if '%' in value or '==' in value or '(' in value:
            value = re.sub(r'%([^%]+)%', lambda m: convert_variable_expr(m.group(1)), value)
            # Convert operators in complex expressions
            value = value.replace('||', ' or ')
            value = value.replace('&&', ' and ')
            value = value.replace('!=', ' ~= ')
            value = re.sub(r'(?<!\|)\|(?!\|)', ' or ', value)
            # Quote unquoted string comparisons
            value = re.sub(
                r'(==|~=)\s*([a-zA-Z_][a-zA-Z0-9_]*)\b(?!\s*[.(\[])',
                lambda m: f'{m.group(1)} "{m.group(2)}"',
                value
            )
        # If value is a number, leave it as-is
        elif re.match(r'^-?\d+\.?\d*$', value):
            pass  # Keep numeric value
        # Otherwise, quote it as a string
        else:
            value = value.replace('\\', '\\\\').replace('"', '\\"')
            value = f'"{value}"'
        return f'{ind}local {var_name} = {value}'

    # eval with dynamic variable name: eval varname%index% expr
    match = re.match(r'^eval\s+(\w+)%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        var_base = match.group(1)
        index = convert_variable_expr(match.group(2))
        expr = match.group(3).strip()
        expr = re.sub(r'%([^%]+)%', lambda m: convert_variable_expr(m.group(1)), expr)
        expr = expr.replace('!=', ' ~= ')
        expr = expr.replace('&&', ' and ')
        expr = expr.replace('||', ' or ')
        return f'{ind}{var_base}[{index}] = {expr}'

    match = re.match(r'^eval\s+(\w+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        var_name = match.group(1)
        expr = match.group(2).strip()
        # Convert variables in expression
        expr = re.sub(r'%([^%]+)%', lambda m: convert_variable_expr(m.group(1)), expr)
        # Convert operators
        expr = expr.replace('!=', ' ~= ')
        expr = expr.replace('&&', ' and ')
        expr = expr.replace('||', ' or ')
        expr = re.sub(r'(?<!\|)\|(?!\|)', ' or ', expr)
        return f'{ind}local {var_name} = {expr}'

    # === Misc ===

    # unset (clear a variable)
    match = re.match(r'^unset\s+(\w+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}{match.group(1)} = nil'

    # unset with dynamic index: unset varname%index%
    match = re.match(r'^unset\s+(\w+)%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        var_base = match.group(1)
        index = convert_variable_expr(match.group(2))
        return f'{ind}{var_base}[{index}] = nil'

    # unset with extra value (likely a bug, but handle gracefully)
    match = re.match(r'^unset\s+(\w+)\s+\d+$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}{match.group(1)} = nil  -- extra value ignored'

    # wat (world at) - execute command at specified room - use room:at()
    match = re.match(r'^wat\s+(\d+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room_call = _get_room_call(match.group(1))
        action = match.group(2)
        # Recursively convert the inner command
        inner_cmd = convert_command(action, 0).strip()
        if 'UNCONVERTED' in inner_cmd:
            inner_cmd = f'-- {action}'
        return f'{ind}{room_call}:at(function()\n{ind}    {inner_cmd}\n{ind}end)'

    # wat with variable room - use room:at()
    match = re.match(r'^wat\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        room = convert_variable_expr(match.group(1))
        room_call = _get_room_call(room, is_variable=True)
        action = match.group(2)
        inner_cmd = convert_command(action, 0).strip()
        if 'UNCONVERTED' in inner_cmd:
            inner_cmd = f'-- {action}'
        return f'{ind}{room_call}:at(function()\n{ind}    {inner_cmd}\n{ind}end)'

    # wpurge/mpurge with target - destroy specific entity
    match = re.match(r'^[wm]purge\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}world.destroy({target})'

    match = re.match(r'^[wm]purge\s+(\S+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        return f'{ind}world.destroy(self.room:find_actor("{target_name}"))'

    # opurge (object purge)
    match = re.match(r'^opurge\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        obj = convert_variable_expr(match.group(1))
        return f'{ind}world.destroy({obj})'

    match = re.match(r'^opurge\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        obj_name = match.group(1)
        return f'{ind}world.destroy(self.room:find_object("{obj_name}"))'

    # wpurge/mpurge without target (purge all in room) - use self.room:purge()
    if cmd_lower in ('wpurge', 'mpurge'):
        return f'{ind}self.room:purge()'

    # global (global variable declaration - single or multiple)
    match = re.match(r'^global\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        vars_str = match.group(1).strip()
        # Handle multiple space-separated variable names
        var_names = vars_str.split()
        if len(var_names) == 1:
            return f'{ind}globals.{var_names[0]} = globals.{var_names[0]} or true'
        else:
            # Multiple globals - initialize each
            inits = [f'globals.{v} = globals.{v} or true' for v in var_names]
            return f'{ind}' + '; '.join(inits)

    # mmobflag (set mob flags)
    match = re.match(r'^mmobflag\s+%([^%]+)%\s+(\w+)\s+(on|off)$', cmd, re.IGNORECASE)
    if match:
        mob = convert_variable_expr(match.group(1))
        flag = match.group(2)
        value = 'true' if match.group(3).lower() == 'on' else 'false'
        return f'{ind}{mob}:set_flag("{flag}", {value})'

    # oflagset (object set flag on actor)
    match = re.match(r'^oflagset\s+%([^%]+)%\s+(\w+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        flag = match.group(2)
        return f'{ind}{target}:set_flag("{flag}", true)'

    # mset (mob set attribute)
    match = re.match(r'^mset\s+(\S+)\s+(\w+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = match.group(1)
        attr = match.group(2)
        value = match.group(3)
        if target.startswith('%'):
            target = convert_variable_expr(target.strip('%'))
        else:
            target = f'self.room:find_actor("{target}")'
        if value.isdigit():
            return f'{ind}{target}:set_attr("{attr}", {value})'
        else:
            return f'{ind}{target}:set_attr("{attr}", "{value}")'

    # wrent (world rent - save and disconnect player)
    match = re.match(r'^wrent\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        return f'{ind}{target}:rent()'

    # wteleport by name (not variable)
    match = re.match(r'^wteleport\s+(\S+)\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        room_call = _get_room_call(match.group(2))
        if not target_name.startswith('%'):
            return f'{ind}find_player("{target_name}"):teleport({room_call})'

    # mforce/wforce by name (not variable) - use actor:command()
    # Recursively convert the inner command
    match = re.match(r'^[mw]force\s+(\S+)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        action = match.group(2)
        # If it's a variable, use convert_variable_expr
        if target_name.startswith('%'):
            target = convert_variable_expr(target_name.strip('%'))
        else:
            target = f'self.room:find_actor("{target_name}")'
        # Check for mload obj - should spawn into actor's inventory
        mload_result = _convert_mload_for_actor(action, target, ind)
        if mload_result:
            return mload_result
        # Recursively convert the inner command
        inner_cmd = convert_command(action, 0).strip()
        if 'UNCONVERTED' not in inner_cmd and inner_cmd.startswith('self:'):
            # Replace self: with target call
            inner_cmd = inner_cmd.replace('self:', f'{target}:', 1)
            return f'{ind}{inner_cmd}'
        return f'{ind}{target}:command("{action}")'

    # mteleport by name (not variable)
    match = re.match(r'^mteleport\s+(\S+)\s+%([^%]+)%$', cmd, re.IGNORECASE)
    if match:
        target_name = match.group(1)
        room = convert_variable_expr(match.group(2))
        room_call = _get_room_call(room, is_variable=True)
        # If it's a variable, use convert_variable_expr
        if target_name.startswith('%'):
            target = convert_variable_expr(target_name.strip('%'))
        else:
            target = f'self.room:find_actor("{target_name}")'
        return f'{ind}{target}:teleport({room_call})'

    match = re.match(r'^m_run_room_trig\s+(\d+)$', cmd, re.IGNORECASE)
    if match:
        return f'{ind}run_room_trigger({match.group(1)})'

    # === Mob Action Commands (pass-through) ===
    # These are standard commands that mobs execute directly

    # Helper to build command with variable substitution
    def build_command_string(action: str, args: str) -> str:
        """Build a Lua command string with proper variable interpolation."""
        if '%' not in args:
            return f'"{action} {args}"'
        # Convert the full command text with variables
        full_cmd = f'{action} {args}'
        return convert_text_with_vars(full_cmd)

    # give <item> <target> - with variable support
    match = re.match(r'^give\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        cmd_str = build_command_string('give', match.group(1))
        return f'{ind}self:command({cmd_str})'

    # drop <item>
    match = re.match(r'^drop\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        cmd_str = build_command_string('drop', match.group(1))
        return f'{ind}self:command({cmd_str})'

    # get/take <item> [container]
    match = re.match(r'^(?:get|take)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        cmd_str = build_command_string('get', match.group(1))
        return f'{ind}self:command({cmd_str})'

    # wear/wield/hold <item>
    match = re.match(r'^(wear|wield|hold)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        action = match.group(1).lower()
        cmd_str = build_command_string(action, match.group(2))
        return f'{ind}self:command({cmd_str})'

    # remove <item>
    match = re.match(r'^remove\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        cmd_str = build_command_string('remove', match.group(1))
        return f'{ind}self:command({cmd_str})'

    # open/close/lock/unlock <door/direction>
    match = re.match(r'^(open|close|lock|unlock)\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        action = match.group(1).lower()
        cmd_str = build_command_string(action, match.group(2))
        return f'{ind}self:command({cmd_str})'

    # === Social Commands ===
    # Comprehensive list of common MUD socials
    socials = [
        # Common expressions
        'smile', 'grin', 'smirk', 'laugh', 'chuckle', 'giggle', 'snicker', 'cackle',
        'cry', 'sob', 'weep', 'whine', 'moan', 'groan', 'sigh', 'yawn',
        # Physical actions
        'wave', 'nod', 'shake', 'shrug', 'bow', 'curtsey', 'curtsy', 'kneel', 'grovel',
        'flex', 'stretch', 'dance', 'sing', 'hum', 'whistle', 'stand', 'sit',
        'sweep', 'salute', 'tickle', 'vis',
        # Expressions with targets
        'wink', 'eye', 'peer', 'stare', 'glare', 'gaze', 'leer', 'consider',
        'pat', 'poke', 'nudge', 'tap', 'ruffle', 'slap', 'hug', 'kiss', 'caress',
        # Sounds
        'cough', 'sneeze', 'hiccup', 'burp', 'sniff', 'snort', 'roar', 'scream',
        'gasp', 'gag', 'shudder', 'shiver', 'tremble', 'mutter', 'grumble', 'mumble',
        # Combat-adjacent
        'flee', 'kick', 'punch', 'headbutt',
        # Mental states
        'ponder', 'think', 'wonder', 'blink', 'frown', 'roll', 'eyebrow',
        # Other common ones
        'drink', 'hic', 'growl', 'purr', 'meow', 'bark', 'clap', 'applaud', 'cheer',
        'cringe', 'faint', 'swoon', 'drool', 'blush', 'beam', 'sulk', 'pout',
        'thank', 'apologize', 'agree', 'disagree', 'comfort', 'console',
        # Added from common triggers
        'rem', 'score', 'panic', 'bleed', 'choke', 'whap',
        'fume', 'lick', 'wince', 'scratch', 'stomp', 'look', 'recite',
        'scan', 'bounce', 'sleep', 'point', 'steam', 'smi', 'bite', 'spank', 'spit', 'hide',
        # Additional socials from remaining triggers
        'fart', 'snap', 'strut', 'rofl', 'pur', 'daydream', 'pant', 'snarl', 'half', 'mosh',
        'glance', 'circle', 'fly', 'curse', 'corner', 'tip', 'rest', 'wake', 'dream', 'beg',
        'hiss', 'thanks', 'eat', 'junk', 'pour', 'put', 'enter', 'sell', 'steal', 'ask',
        'load', 'force', 'consent', 'wie', 'hol',  # abbreviated commands
        'grope', 'trip', 'con', 'l',  # additional commands
    ]

    for social in socials:
        match = re.match(rf'^{social}(?:\s+(.+))?$', cmd, re.IGNORECASE)
        if match:
            target = match.group(1)
            if target:
                # Use self:command for proper social execution with target
                cmd_str = build_command_string(social, target)
                return f'{ind}self:command({cmd_str})'
            else:
                return f'{ind}self:command("{social}")'

    # Nothing placeholder
    if cmd_lower in ('nothing.', 'nothing'):
        return f'{ind}-- (placeholder trigger)'

    # wizn (wizard notification)
    match = re.match(r'^wizn\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        text = convert_text_with_vars(match.group(1))
        return f'{ind}wizard_notify({text})'

    # mechoto (typo for mechoat/mecho?)
    match = re.match(r'^mechoto\s+%([^%]+)%\s+(.+)$', cmd, re.IGNORECASE)
    if match:
        target = convert_variable_expr(match.group(1))
        text = convert_text_with_vars(match.group(2))
        return f'{ind}{target}:send({text})  -- typo: mechoto'

    # Handle commands with trailing periods (typos in triggers)
    if cmd.endswith('.') and len(cmd) > 1:
        cleaned = convert_command(cmd[:-1], indent)
        if cleaned and 'UNCONVERTED' not in cleaned:
            return cleaned

    # === Orphaned Text / Fragment Detection ===
    # These patterns are likely artifacts from parsing issues or truncated DG scripts

    # DG script subroutine labels (label:) - convert to Lua label syntax
    if re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*:$', cmd):
        label = cmd[:-1]
        return f'{ind}::{label}::  -- DG subroutine label'

    # Bare subroutine name references (no colon, single word, lowercase with underscore)
    # These are likely jump targets or leftover labels like "purge_me", "do_it_to_it"
    if re.match(r'^[a-z_][a-z0-9_]*$', cmd) and '_' in cmd:
        return f'{ind}-- Label reference: {cmd}'

    # Orphaned text fragments (sentences with punctuation but no command prefix)
    # These are usually from truncated msend/mecho commands
    if re.match(r"^[A-Z].*[.!?]$", cmd) and ' ' in cmd:
        return f'{ind}-- Orphaned text: {cmd}'

    # Truncated variable assignment fragments (start with variable-like pattern)
    # e.g., "m_3bl_belt vnum_3bl_legs" - looks like incomplete variable chains
    if re.match(r'^[a-z_]\w*\s+[a-z_]\w*', cmd, re.IGNORECASE) and '%' not in cmd:
        # Could be a truncated assignment or malformed command
        return f'{ind}-- Fragment (possible truncation): {cmd}'

    # 'defalt' typo (common in DG scripts, should be 'default')
    if cmd_lower == 'defalt':
        return f'{ind}-- default (typo: defalt)'

    # Unknown command - preserve as comment
    return f'{ind}-- UNCONVERTED: {cmd}'


def convert_script_body(commands: str) -> str:
    """Convert the entire script body from DG Script to Lua."""
    lines = commands.split('\n')
    lua_lines = []
    indent = 0
    in_switch = False
    in_while = False  # Track if we're in a while loop
    switch_var = ""
    first_case = True
    switch_has_if = False  # Track if switch generated an if statement
    pending_cases = []  # For collecting fall-through cases
    has_return_value = False  # Track if we need the _return_value variable

    # Check if script uses return 0/1 (not immediately followed by halt)
    commands_lower = commands.lower()
    if 'return 0' in commands_lower or 'return 1' in commands_lower:
        has_return_value = True
        lua_lines.append('local _return_value = true  -- Default: allow action')

    i = 0
    while i < len(lines):
        line = lines[i].strip()
        i += 1

        if not line:
            continue

        line_lower = line.lower()

        # === Control Flow ===

        if line_lower.startswith('if '):
            cond = line[3:].strip()
            lua_lines.append('    ' * indent + f'if {convert_condition(cond)} then')
            indent += 1
            continue

        if line_lower.startswith('elseif '):
            indent = max(0, indent - 1)
            cond = line[7:].strip()
            lua_lines.append('    ' * indent + f'elseif {convert_condition(cond)} then')
            indent += 1
            continue

        if line_lower == 'else':
            indent = max(0, indent - 1)
            lua_lines.append('    ' * indent + 'else')
            indent += 1
            continue

        if line_lower in ('end', 'endif', 'end if'):
            indent = max(0, indent - 1)
            lua_lines.append('    ' * indent + 'end')
            continue

        # while loops
        if line_lower.startswith('while '):
            cond = line[6:].strip()
            lua_lines.append('    ' * indent + f'while {convert_condition(cond)} do')
            indent += 1
            in_while = True
            continue

        if line_lower.startswith('switch '):
            switch_expr = line[7:].strip()
            switch_var = re.sub(r'%([^%]+)%', lambda m: convert_variable_expr(m.group(1)), switch_expr)
            in_switch = True
            first_case = True
            switch_has_if = False  # Track if we actually generated an if statement
            pending_cases = []  # Collect fall-through cases
            lua_lines.append('    ' * indent + f'-- switch on {switch_var}')
            continue

        if line_lower.startswith('case '):
            case_val = line[5:].strip()
            # Quote the value if it's not a number and not already quoted
            if case_val and not case_val.isdigit() and not case_val.startswith('"'):
                case_val = f'"{case_val}"'
            if in_switch:
                pending_cases.append(case_val)
            continue

        if line_lower == 'default':
            if in_switch:
                # Flush any pending cases before default
                if pending_cases:
                    conditions = ' or '.join([f'{switch_var} == {c}' for c in pending_cases])
                    if first_case:
                        lua_lines.append('    ' * indent + f'if {conditions} then')
                        indent += 1
                        first_case = False
                        switch_has_if = True
                    else:
                        indent = max(0, indent - 1)
                        lua_lines.append('    ' * indent + f'elseif {conditions} then')
                        indent += 1
                    pending_cases = []
                # Default becomes else (only if we have an if)
                if not first_case and switch_has_if:
                    indent = max(0, indent - 1)
                    lua_lines.append('    ' * indent + 'else')
                    indent += 1
                # If switch only has default (no cases), just run the code unconditionally
            continue

        if line_lower == 'break':
            # In switch, break just ends the case - no action needed
            continue

        if line_lower == 'done':
            if in_while:
                # Close the while loop
                indent = max(0, indent - 1)
                lua_lines.append('    ' * indent + 'end')
                in_while = False
            elif in_switch:
                # Flush any remaining pending cases
                if pending_cases:
                    conditions = ' or '.join([f'{switch_var} == {c}' for c in pending_cases])
                    if first_case:
                        lua_lines.append('    ' * indent + f'if {conditions} then')
                        indent += 1
                        first_case = False
                        switch_has_if = True
                    else:
                        indent = max(0, indent - 1)
                        lua_lines.append('    ' * indent + f'elseif {conditions} then')
                        indent += 1
                    pending_cases = []
                # Only add 'end' if we actually generated an 'if'
                if switch_has_if:
                    indent = max(0, indent - 1)
                    lua_lines.append('    ' * indent + 'end')
                in_switch = False
                first_case = True
                switch_has_if = False
            continue

        # When we encounter a non-case line inside a switch, flush pending cases first
        if in_switch and pending_cases:
            conditions = ' or '.join([f'{switch_var} == {c}' for c in pending_cases])
            if first_case:
                lua_lines.append('    ' * indent + f'if {conditions} then')
                indent += 1
                first_case = False
                switch_has_if = True
            else:
                indent = max(0, indent - 1)
                lua_lines.append('    ' * indent + f'elseif {conditions} then')
                indent += 1
            pending_cases = []

        # Regular command
        converted = convert_command(line, indent)
        if converted:
            # Skip redundant halt after setting _return_value
            # In DG Scripts, "return 0" followed by "halt" is common
            if 'return _return_value' in converted and lua_lines:
                last_line = lua_lines[-1].strip()
                if last_line.startswith('_return_value ='):
                    # Previous line just set _return_value, keep the return
                    pass
            lua_lines.append(converted)

    # Close any unclosed blocks (DG Script is more lenient than Lua)
    # This handles scripts that end with an if/else block without explicit 'end'
    if in_switch:
        indent = max(0, indent - 1)
        lua_lines.append('    ' * indent + 'end  -- auto-close switch')
        indent = max(0, indent - 1)

    while indent > 0:
        indent -= 1
        lua_lines.append('    ' * indent + 'end  -- auto-close block')

    # Add final return if script uses _return_value but doesn't end with a return
    if has_return_value:
        # Check if last non-empty line is a return
        last_real_line = ''
        for line in reversed(lua_lines):
            if line.strip() and not line.strip().startswith('--') and not line.strip().startswith('end'):
                last_real_line = line.strip()
                break
        if not last_real_line.startswith('return'):
            lua_lines.append('return _return_value')

    return '\n'.join(lua_lines)


def convert_trigger(dg: DGTrigger) -> LuaTrigger:
    """
    Convert a DG Script trigger to Lua.

    Args:
        dg: Parsed DGTrigger object

    Returns:
        LuaTrigger object ready for database import
    """
    lua_commands = convert_script_body(dg.commands)

    # Build header
    header_lines = [
        f'-- Converted from DG Script #{dg.vnum}: {dg.name}',
        f'-- Original: {dg.script_type.name} trigger, flags: {", ".join(dg.flags)}, probability: {dg.probability}%',
        '',
    ]

    # Note: Pronoun helpers are no longer needed - use actor.subject, actor.object, actor.possessive

    # Probability check
    if dg.probability < 100:
        header_lines.extend([
            f'-- {dg.probability}% chance to trigger',
            f'if not percent_chance({dg.probability}) then',
            '    return true',
            'end',
            '',
        ])

    # COMMAND trigger keyword check
    if 'COMMAND' in dg.flags and dg.arg_string:
        keywords = dg.arg_string.split()
        if keywords:
            checks = ' or '.join([f'cmd == "{kw}"' for kw in keywords])
            header_lines.extend([
                f'-- Command filter: {dg.arg_string}',
                f'if not ({checks}) then',
                '    return true  -- Not our command',
                'end',
                '',
            ])

    # SPEECH trigger keyword check
    if 'SPEECH' in dg.flags and dg.arg_string:
        keywords = dg.arg_string.split()
        if keywords:
            checks = ' or '.join([f'string.find(string.lower(speech), "{kw.lower()}")' for kw in keywords])
            header_lines.extend([
                f'-- Speech keywords: {dg.arg_string}',
                'local speech_lower = string.lower(speech)',
                f'if not ({checks}) then',
                '    return true  -- No matching keywords',
                'end',
                '',
            ])

    full_script = '\n'.join(header_lines) + lua_commands

    # Clean up excessive blank lines
    full_script = re.sub(r'\n{3,}', '\n\n', full_script)

    return LuaTrigger(
        vnum=dg.vnum,
        name=dg.name,
        attach_type=dg.script_type.name,
        flags=dg.flags,
        commands=full_script,
        numeric_arg=dg.numeric_arg,
        arg_list=dg.arg_string.split() if dg.arg_string else [],
        original_dg=dg.commands
    )


def convert_all_triggers(dg_triggers: list[DGTrigger]) -> list[LuaTrigger]:
    """
    Convert a list of DG Script triggers to Lua.

    Args:
        dg_triggers: List of parsed DGTrigger objects

    Returns:
        List of LuaTrigger objects ready for database import
    """
    return [convert_trigger(dg) for dg in dg_triggers]
