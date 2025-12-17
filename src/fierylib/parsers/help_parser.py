"""Parser for CircleMUD-style help files (.hlp)."""

import re
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, field


@dataclass
class HelpEntry:
    """Represents a parsed help file entry."""

    keywords: List[str]
    content: str
    min_level: int = 0  # 0 = all players, 100+ = immortal

    # Parsed spell/skill metadata (if applicable)
    usage: Optional[str] = None
    min_position: Optional[str] = None
    ok_in_combat: Optional[bool] = None
    aggressive: Optional[bool] = None
    effect_type: Optional[str] = None
    area_of_effect: Optional[str] = None
    damage_type: Optional[str] = None
    duration: Optional[str] = None
    sphere: Optional[str] = None
    accumulative: Optional[bool] = None
    classes: Dict[str, int] = field(default_factory=dict)  # class -> circle/level

    # Clean description text
    description: str = ""


class HelpFileParser:
    """Parser for CircleMUD-style .hlp help files."""

    # Regex patterns for metadata extraction
    METADATA_PATTERNS = {
        'usage': re.compile(r'^Usage\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'min_position': re.compile(r'^Min\.?\s*position\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'ok_in_combat': re.compile(r'^OK\s+in\s+combat\s*:\s*(yes|no)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'aggressive': re.compile(r'^Aggressive\s*:\s*(yes|no|n/a)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'effect_type': re.compile(r'^Effect\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'area_of_effect': re.compile(r'^Area\s+of\s+effect\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'damage_type': re.compile(r'^Damage\s+type\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'duration': re.compile(r'^Duration\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'sphere': re.compile(r'^Sphere\s*:\s*(.+?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
        'accumulative': re.compile(r'^Accumulative\s*:\s*(yes|no|-?)(?:\n|$)', re.MULTILINE | re.IGNORECASE),
    }

    # Pattern for class/circle lines like: "Classes       : Pyromancer     Circle 7"
    CLASS_PATTERN = re.compile(
        r'^Classes\s*:\s*(\w+)\s+(?:Circle|Level)\s+(\d+)',
        re.MULTILINE | re.IGNORECASE
    )

    # Pattern for additional class entries on following lines
    ADDITIONAL_CLASS_PATTERN = re.compile(
        r'^\s+(\w+)\s+(?:Circle|Level)\s+(\d+)',
        re.MULTILINE
    )

    def __init__(self):
        self.entries: Dict[str, HelpEntry] = {}  # keyword -> entry (normalized)

    def parse_file(self, filepath: Path) -> Dict[str, HelpEntry]:
        """Parse a help file and return dictionary of entries by keyword."""

        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()

        # Split by entry delimiter (#<level>)
        # The format is: content#level where level is typically 0 or 100+
        raw_entries = re.split(r'\n#(\d+)\n?', content)

        # First element is before any #, which is the first entry
        # Then alternating: level, content, level, content...

        i = 0
        current_content = None

        while i < len(raw_entries):
            if i == 0:
                # First entry (before first #)
                current_content = raw_entries[i].strip()
                if current_content:
                    self._parse_entry(current_content, 0)
                i += 1
            else:
                # level followed by content
                if i + 1 < len(raw_entries):
                    level = int(raw_entries[i])
                    current_content = raw_entries[i + 1].strip()
                    if current_content:
                        self._parse_entry(current_content, level)
                    i += 2
                else:
                    i += 1

        return self.entries

    def _parse_entry(self, content: str, min_level: int):
        """Parse a single help entry."""

        lines = content.split('\n')
        if not lines:
            return

        # First line(s) contain keywords
        # Keywords can be: KEYWORD, "MULTI WORD", or multiple space-separated
        keyword_line = lines[0].strip()

        # Handle quoted keywords like "ACID BURST" or simple ones like ARMOR
        keywords = self._parse_keywords(keyword_line)
        if not keywords:
            return

        # Rest is content
        body = '\n'.join(lines[1:]).strip()

        # Create entry
        entry = HelpEntry(
            keywords=keywords,
            content=body,
            min_level=min_level,
        )

        # Extract metadata
        self._extract_metadata(entry, body)

        # Extract description (text after metadata block)
        entry.description = self._extract_description(body)

        # Store by each keyword (normalized)
        for kw in keywords:
            normalized = self._normalize_keyword(kw)
            self.entries[normalized] = entry

    def _parse_keywords(self, line: str) -> List[str]:
        """Parse keyword line which may have quoted multi-word keywords."""
        keywords = []

        # Match quoted strings first
        quoted = re.findall(r'"([^"]+)"', line)
        keywords.extend(quoted)

        # Remove quoted parts and get remaining words
        remaining = re.sub(r'"[^"]+"', '', line).strip()
        if remaining:
            keywords.extend(remaining.split())

        return keywords

    def _normalize_keyword(self, keyword: str) -> str:
        """Normalize keyword for lookup."""
        # Convert to title case with spaces
        return keyword.strip().lower().replace('_', ' ')

    def _extract_metadata(self, entry: HelpEntry, content: str):
        """Extract spell/skill metadata from content."""

        for field, pattern in self.METADATA_PATTERNS.items():
            match = pattern.search(content)
            if match:
                value = match.group(1).strip()

                if field in ('ok_in_combat', 'aggressive'):
                    setattr(entry, field, value.lower() == 'yes')
                elif field == 'accumulative':
                    setattr(entry, field, value.lower() == 'yes')
                else:
                    setattr(entry, field, value)

        # Extract class/circle information
        class_match = self.CLASS_PATTERN.search(content)
        if class_match:
            entry.classes[class_match.group(1)] = int(class_match.group(2))

            # Look for additional classes on following lines
            for add_match in self.ADDITIONAL_CLASS_PATTERN.finditer(content):
                entry.classes[add_match.group(1)] = int(add_match.group(2))

    def _extract_description(self, content: str) -> str:
        """Extract the descriptive text from help content.

        This removes the metadata block (=== delimited) and See Also section,
        leaving just the prose description.
        """

        # Remove color codes like &1, &0, &4&b etc
        content = re.sub(r'&\d&?[a-z]?', '', content)
        content = re.sub(r'&0', '', content)

        # Check if there's a metadata block (=== delimited)
        # Look for pattern: ===...metadata...===
        metadata_match = re.search(r'={10,}.*?={10,}', content, re.DOTALL)
        if metadata_match:
            # Take content after the metadata block
            content = content[metadata_match.end():].strip()

        # Remove "See also:" section
        see_also_match = re.search(r'\n\s*See\s+also\s*:', content, re.IGNORECASE)
        if see_also_match:
            content = content[:see_also_match.start()].strip()

        # Remove "See Also:" at end if present
        content = re.sub(r'\s*See\s+also\s*:.*$', '', content, flags=re.IGNORECASE | re.DOTALL)

        # Remove any remaining = lines at start
        content = re.sub(r'^=+\s*\n?', '', content)

        # Clean up whitespace
        content = re.sub(r'\n{3,}', '\n\n', content)
        content = content.strip()

        return content

    def get_entry(self, keyword: str) -> Optional[HelpEntry]:
        """Look up a help entry by keyword."""
        normalized = self._normalize_keyword(keyword)
        return self.entries.get(normalized)

    def get_spell_entries(self) -> Dict[str, HelpEntry]:
        """Get entries that appear to be spells/skills (have usage/classes info)."""
        return {
            kw: entry for kw, entry in self.entries.items()
            if entry.usage or entry.classes or entry.sphere
        }


def parse_all_help_files(help_dir: Path) -> HelpFileParser:
    """Parse all .hlp files in a directory."""
    parser = HelpFileParser()

    for hlp_file in help_dir.glob('*.hlp'):
        parser.parse_file(hlp_file)

    return parser


# CLI testing
if __name__ == '__main__':
    import sys

    if len(sys.argv) < 2:
        print("Usage: python help_parser.py <help_file.hlp>")
        sys.exit(1)

    filepath = Path(sys.argv[1])
    parser = HelpFileParser()
    entries = parser.parse_file(filepath)

    print(f"Parsed {len(entries)} entries")

    # Show some spell entries
    spell_entries = parser.get_spell_entries()
    print(f"\nFound {len(spell_entries)} spell/skill entries")

    for kw, entry in list(spell_entries.items())[:5]:
        print(f"\n=== {kw} ===")
        print(f"Keywords: {entry.keywords}")
        print(f"Sphere: {entry.sphere}")
        print(f"Classes: {entry.classes}")
        print(f"Description: {entry.description[:200]}..." if len(entry.description) > 200 else f"Description: {entry.description}")
