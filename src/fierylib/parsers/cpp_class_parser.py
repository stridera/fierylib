"""
C++ Class and Race Parser

Extracts class and race data from FieryMUD legacy C++ source files.
Parses class.cpp, races.cpp, and defines.hpp to extract:
- Class definitions (ClassDef structs)
- Skill/spell/song/chant assignments
- Race definitions (RaceDef structs)
- Constant mappings (CLASS_*, SPELL_*, SKILL_*, CIRCLE_*)
"""

import re
import json
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import click
from mud.flags import SKILLS
from fierylib.converters.color_converter import convert_legacy_colors, strip_legacy_colors


class CppClassParser:
    """Parser for C++ class definition files"""

    def __init__(self, fierymud_path: Path):
        """
        Initialize parser

        Args:
            fierymud_path: Path to fierymud legacy directory
        """
        self.fierymud_path = Path(fierymud_path)
        self.src_path = self.fierymud_path / "legacy" / "src"

        # Constant mappings
        self.class_constants: Dict[str, int] = {}
        self.circle_constants: Dict[str, int] = {}
        self.spell_constants: Dict[str, int] = {}
        self.skill_constants: Dict[str, int] = {}

        # Parsed data
        self.classes: List[Dict] = []
        self.class_skills: List[Dict] = []

    def parse_defines(self) -> None:
        """Parse defines.hpp for constant mappings"""
        defines_file = self.src_path / "defines.hpp"

        if not defines_file.exists():
            click.echo(f"  ⚠️  defines.hpp not found at {defines_file}")
            return

        with open(defines_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Parse CIRCLE_ constants (spell circles map to levels)
        for match in re.finditer(r'#define\s+(CIRCLE_\d+)\s+(\d+)', content):
            name, value = match.groups()
            self.circle_constants[name] = int(value)

        click.echo(f"    ✅ Parsed {len(self.circle_constants)} CIRCLE constants")

    def parse_class_constants(self) -> None:
        """Parse class.hpp for CLASS_ constants"""
        class_hpp = self.src_path / "class.hpp"

        if not class_hpp.exists():
            click.echo(f"  ⚠️  class.hpp not found at {class_hpp}")
            return

        with open(class_hpp, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Parse CLASS_ constants
        for match in re.finditer(r'#define\s+(CLASS_\w+)\s+(-?\d+)', content):
            name, value = match.groups()
            self.class_constants[name] = int(value)

        click.echo(f"    ✅ Parsed {len(self.class_constants)} CLASS constants")

    def parse_skill_constants(self) -> None:
        """Load skill/spell constants from mud.flags.SKILLS"""
        # SKILLS dictionary already has ID->name mapping from flags.py
        # We need name->ID mapping for reverse lookup
        for skill_id, skill_name in SKILLS.items():
            if skill_name and skill_name != "NONE":
                self.skill_constants[skill_name] = skill_id

        click.echo(f"    ✅ Loaded {len(self.skill_constants)} skill/spell constants from flags.py")

    def parse_class_definitions(self) -> None:
        """Parse class.cpp for ClassDef array entries"""
        class_cpp = self.src_path / "class.cpp"

        if not class_cpp.exists():
            click.echo(f"  ⚠️  class.cpp not found at {class_cpp}")
            return

        with open(class_cpp, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Find the ClassDef array section
        array_match = re.search(r'ClassDef classes\[NUM_CLASSES\]\s*=\s*\{(.+?)\n\};', content, re.DOTALL)
        if not array_match:
            click.echo("  ⚠️  Could not find ClassDef array in class.cpp")
            return

        array_content = array_match.group(1)

        # Split by class comments to find individual class definitions
        # Pattern: /* CLASS_NAME */ followed by struct data
        class_pattern = r'/\*\s*(\w+(?:\s+\w+)?)\s*\*/\s*\{([^}]+(?:\{[^}]+\}[^}]*)?)\},'

        for class_index, match in enumerate(re.finditer(class_pattern, array_content)):
            comment_name = match.group(1).strip()
            struct_content = match.group(2)

            # Extract class name (first quoted string)
            name_match = re.search(r'\"([a-z][a-z\-]*?)\"', struct_content)
            if not name_match:
                continue

            class_name = name_match.group(1)

            # Extract display name and convert legacy color codes to XML-Lite format
            display_match = re.search(r'\"([^\"]*&[^\"]+)\"', struct_content)
            if display_match:
                raw_name = display_match.group(1)
                # Generate both versions:
                name = convert_legacy_colors(raw_name)  # With XML-Lite colors
                plain_name = strip_legacy_colors(raw_name)  # Without colors
            else:
                name = None
                plain_name = None

            # Extract homeroom
            homeroom_match = re.search(r'(\d{4}),\s*/\*\s*homeroom', struct_content)
            homeroom = int(homeroom_match.group(1)) if homeroom_match else None

            # Extract boolean fields (magical, active, isSubclass)
            # Pattern: true/false on their own lines
            bools = re.findall(r'^\s*(true|false),\s*/\*', struct_content, re.MULTILINE)
            magical = bools[0] == 'true' if len(bools) > 0 else None
            active = bools[1] == 'true' if len(bools) > 1 else None
            isSubclass = bools[2] == 'true' if len(bools) > 2 else None

            class_data = {
                'id': class_index,
                'name': name,  # Display name with XML-Lite colors
                'plainName': plain_name,  # Plain text name
                'className': class_name,  # Internal identifier (lowercase, no colors)
                'magical': magical,
                'active': active,
                'isSubclass': isSubclass,
                'homeroom': homeroom,
            }

            self.classes.append(class_data)
            click.echo(f"      ✓ Parsed class: {class_name} (ID: {class_index})")

        click.echo(f"    ✅ Parsed {len(self.classes)} class definitions")

    def parse_skill_assignments(self) -> None:
        """Parse class.cpp for skill_assign(), spell_assign(), etc. calls"""
        class_cpp = self.src_path / "class.cpp"

        if not class_cpp.exists():
            click.echo(f"  ⚠️  class.cpp not found at {class_cpp}")
            return

        with open(class_cpp, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Parse skill_assign calls
        # Pattern: skill_assign(SKILL_NAME, CLASS_NAME, level)
        # Pattern: spell_assign(SPELL_NAME, CLASS_NAME, CIRCLE_X)

        patterns = [
            r'skill_assign\s*\(\s*(\w+)\s*,\s*(\w+)\s*,\s*(\d+)\s*\)',
            r'spell_assign\s*\(\s*(\w+)\s*,\s*(\w+)\s*,\s*(\w+)\s*\)',
            r'chant_assign\s*\(\s*(\w+)\s*,\s*(\w+)\s*,\s*(\d+)\s*\)',
            r'song_assign\s*\(\s*(\w+)\s*,\s*(\w+)\s*,\s*(\d+)\s*\)',
        ]

        for pattern in patterns:
            for match in re.finditer(pattern, content):
                skill_name, class_name, level_or_circle = match.groups()

                # Resolve class ID
                class_id = self.class_constants.get(class_name, -1)
                if class_id == -1:
                    continue

                # For spells, preserve circle number and also compute level
                circle = None
                if 'CIRCLE_' in level_or_circle:
                    # Extract circle number from CIRCLE_X
                    circle = int(level_or_circle.replace('CIRCLE_', ''))
                    level = self.circle_constants.get(level_or_circle, 1)
                else:
                    level = int(level_or_circle)

                # Determine ability type
                if skill_name.startswith('SPELL_'):
                    ability_type = 'SPELL'
                elif skill_name.startswith('SKILL_'):
                    ability_type = 'SKILL'
                elif skill_name.startswith('SONG_'):
                    ability_type = 'SONG'
                elif skill_name.startswith('CHANT_'):
                    ability_type = 'CHANT'
                else:
                    ability_type = 'SKILL'  # Default

                # Remove prefix for database lookup
                normalized_name = skill_name
                for prefix in ['SPELL_', 'SKILL_', 'SONG_', 'CHANT_']:
                    if skill_name.startswith(prefix):
                        normalized_name = skill_name[len(prefix):]
                        break

                assignment = {
                    'classId': class_id,
                    'className': class_name,
                    'skillName': normalized_name,
                    'originalName': skill_name,
                    'minLevel': level,
                    'abilityType': ability_type,
                }

                # Add circle for spells
                if circle is not None:
                    assignment['circle'] = circle

                self.class_skills.append(assignment)

        click.echo(f"    ✅ Parsed {len(self.class_skills)} skill assignments")

    def parse_all(self) -> Dict:
        """Parse all C++ files and return structured data"""
        click.echo("  Parsing C++ source files...")

        self.parse_defines()
        self.parse_class_constants()
        self.parse_skill_constants()
        self.parse_class_definitions()
        self.parse_skill_assignments()

        return {
            'classes': self.classes,
            'classSkills': self.class_skills,
            'constants': {
                'classes': self.class_constants,
                'circles': self.circle_constants,
                'skills': self.skill_constants,
            }
        }

    def export_to_json(self, output_path: Path) -> None:
        """Export parsed data to JSON file"""
        data = self.parse_all()

        output_path.parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

        click.echo(f"  ✅ Exported class data to {output_path}")
        click.echo(f"     Classes: {len(data['classes'])}")
        click.echo(f"     Skill assignments: {len(data['classSkills'])}")


def main():
    """CLI entry point for testing"""
    fierymud_path = Path(__file__).parents[4] / "fierymud"
    output_path = Path(__file__).parents[3] / "data" / "classes.json"

    parser = CppClassParser(fierymud_path)
    parser.export_to_json(output_path)


if __name__ == "__main__":
    main()
