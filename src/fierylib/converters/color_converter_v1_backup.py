"""
Color Code Converter - Transform legacy inline color codes to XML-Lite markup

Converts legacy CircleMUD color codes (&, @) to modern XML-Lite markup system.

Legacy System:
    - & prefix: Relative color codes (preserve formatting)
    - @ prefix: Absolute color codes (reset first)
    - Examples: &1Red&0, @RBright Red@0

Modern XML-Lite:
    - XML-like tags: <red>text</red>
    - Modifiers: <b:red>bold red</b:red>
    - Full reset: </>
    - More readable and nestable

References:
    - fierymud/docs/COLOR_CODES_LEGACY.md
    - fierymud/docs/COLOR_CODES_XMLLITE.md
"""

from typing import Optional
import re


# Legacy relative codes (&) to XML-Lite mapping
RELATIVE_FOREGROUND_CODES = {
    '0': None,           # Reset (handled specially)
    '1': 'red',
    '2': 'green',
    '3': 'yellow',
    '4': 'blue',
    '5': 'magenta',
    '6': 'cyan',
    '7': 'white',
    '9': 'black',
}

RELATIVE_BACKGROUND_CODES = {
    'R': 'bg-red',
    'G': 'bg-green',
    'Y': 'bg-yellow',
    'B': 'bg-blue',
    'M': 'bg-magenta',
    'C': 'bg-cyan',
    'W': 'bg-white',
    'L': 'bg-black',
    'K': 'bg-black',  # Light black (same as black in XML-Lite)
}

RELATIVE_STYLE_CODES = {
    'u': 'u',      # Underline
    'b': 'b',      # Bold
    'd': 'dim',    # Dim
}

# Legacy absolute codes (@) to XML-Lite mapping
ABSOLUTE_BASIC_CODES = {
    '0': None,     # Reset (handled specially)
    '1': 'red',
    '2': 'green',
    '3': 'yellow',
    '4': 'blue',
    '5': 'magenta',
    '6': 'cyan',
    '7': 'white',
    '9': 'black',
}

ABSOLUTE_LOWERCASE_CODES = {
    'r': 'red',
    'g': 'green',
    'y': 'yellow',
    'b': 'blue',
    'm': 'magenta',
    'c': 'cyan',
    'w': 'white',
    'd': 'black',
}

ABSOLUTE_BRIGHT_CODES = {
    'R': 'b:red',       # Bright = bold in XML-Lite
    'G': 'b:green',
    'Y': 'b:yellow',
    'B': 'b:blue',
    'M': 'b:magenta',
    'C': 'b:cyan',
    'W': 'b:white',
    'L': 'b:black',
}


class ColorConverter:
    """Converts legacy color codes to XML-Lite markup"""

    def __init__(self):
        self.tag_stack = []  # Track open tags for proper nesting

    def _get_tag_type(self, tag: str) -> str:
        """Determine if tag is foreground, background, or style"""
        if tag.startswith('bg-'):
            return 'background'
        elif tag in ['b', 'u', 'i', 's', 'dim', 'blink', 'reverse', 'hide']:
            return 'style'
        elif ':' in tag:
            # Multi-modifier tag like 'b:red' - extract color part
            parts = tag.split(':')
            if any(p.startswith('bg-') for p in parts):
                return 'background'
            return 'foreground'
        else:
            return 'foreground'

    def _close_tags_of_type(self, tag_type: str) -> str:
        """Close tags of specific type (foreground/background) and return closing markup"""
        closing_tags = []
        tags_to_keep = []

        # Find and close tags of the specified type (LIFO order)
        for tag in reversed(self.tag_stack):
            if self._get_tag_type(tag) == tag_type:
                # Found a tag to close - also close everything after it
                index = self.tag_stack.index(tag)
                # Close all tags from this point onward (LIFO)
                while len(self.tag_stack) > index:
                    closed_tag = self.tag_stack.pop()
                    closing_tags.append(f'</{closed_tag}>')
                # Reopen tags that weren't the target type
                for kept_tag in reversed(tags_to_keep):
                    self.tag_stack.append(kept_tag)
                    # Don't reopen in output - we'll apply new color instead
                break
            else:
                tags_to_keep.append(tag)

        return ''.join(closing_tags)

    def convert(self, text: str) -> str:
        """
        Convert legacy color codes to XML-Lite markup

        Args:
            text: Text containing legacy color codes (&1, @R, etc.)

        Returns:
            Text with XML-Lite markup (<red>, <b:red>, etc.)

        Examples:
            >>> converter = ColorConverter()
            >>> converter.convert("&1Red text&0")
            '<red>Red text</red>'
            >>> converter.convert("@RBright Red@0")
            '<b:red>Bright Red</b:red>'
            >>> converter.convert("&b&1Bold Red&0")
            '<b:red>Bold Red</b:red>'
        """
        if not text:
            return text

        # Reset tag stack for each conversion
        self.tag_stack = []
        result = []
        i = 0

        while i < len(text):
            char = text[i]

            # Check for color code prefix
            if char in ('&', '@') and i + 1 < len(text):
                next_char = text[i + 1]

                # Handle escapes (&&, @@)
                if next_char == char:
                    # Legacy escape → keep as literal character
                    result.append(char)
                    i += 2
                    continue

                # Handle newline (&_)
                if char == '&' and next_char == '_':
                    result.append('\n')
                    i += 2
                    continue

                # Process color code
                if char == '&':
                    xml_tag = self._convert_relative_code(next_char)
                else:  # char == '@'
                    xml_tag = self._convert_absolute_code(next_char)

                if xml_tag is not None:
                    result.append(xml_tag)
                    i += 2
                    continue

            # Regular character
            result.append(char)
            i += 1

        # Close any remaining open tags
        while self.tag_stack:
            tag_name = self.tag_stack.pop()
            result.append(f'</{tag_name}>')

        return ''.join(result)

    def _convert_relative_code(self, code: str) -> Optional[str]:
        """
        Convert relative color code to XML-Lite tag

        Relative codes preserve current formatting and add/change colors.
        - Foreground colors REPLACE any existing foreground color
        - Background colors REPLACE any existing background color
        - Text styles STACK (bold, underline, etc.)

        Args:
            code: Single character after & (e.g., '1', 'b', 'R')

        Returns:
            XML-Lite tag or None if reset
        """
        # Reset code
        if code == '0':
            return self._close_all_tags()

        # Foreground colors - REPLACE existing foreground
        if code in RELATIVE_FOREGROUND_CODES:
            color = RELATIVE_FOREGROUND_CODES[code]
            if color:
                # Close any existing foreground color tag
                closing = self._close_tags_of_type('foreground')
                # Add new foreground color
                self.tag_stack.append(color)
                return f'{closing}<{color}>'

        # Background colors - REPLACE existing background
        if code in RELATIVE_BACKGROUND_CODES:
            bg_color = RELATIVE_BACKGROUND_CODES[code]
            # Close any existing background color tag
            closing = self._close_tags_of_type('background')
            # Add new background color
            self.tag_stack.append(bg_color)
            return f'{closing}<{bg_color}>'

        # Text styles - STACK (preserve existing styles)
        if code in RELATIVE_STYLE_CODES:
            style = RELATIVE_STYLE_CODES[code]
            self.tag_stack.append(style)
            return f'<{style}>'

        # Unknown code - ignore
        return None

    def _convert_absolute_code(self, code: str) -> Optional[str]:
        """
        Convert absolute color code to XML-Lite tag

        Absolute codes reset all formatting first, then apply color.

        Args:
            code: Single character after @ (e.g., 'R', 'g', '1')

        Returns:
            XML-Lite tag or None if reset
        """
        # Reset code
        if code == '0':
            return self._close_all_tags()

        # Close all existing tags first (absolute reset behavior)
        reset_tags = self._close_all_tags()

        # Bright colors (uppercase - bold in XML-Lite)
        if code in ABSOLUTE_BRIGHT_CODES:
            color_tag = ABSOLUTE_BRIGHT_CODES[code]
            # Keep multi-modifier tags together as a single tag name
            self.tag_stack.append(color_tag)
            return f'{reset_tags}<{color_tag}>'

        # Lowercase alternative colors
        if code in ABSOLUTE_LOWERCASE_CODES:
            color = ABSOLUTE_LOWERCASE_CODES[code]
            self.tag_stack.append(color)
            return f'{reset_tags}<{color}>'

        # Basic numbered colors
        if code in ABSOLUTE_BASIC_CODES:
            color = ABSOLUTE_BASIC_CODES[code]
            if color:
                self.tag_stack.append(color)
                return f'{reset_tags}<{color}>'

        # Unknown code - just reset
        return reset_tags if reset_tags else None

    def _close_all_tags(self) -> str:
        """Close all open tags (reset to normal)"""
        if not self.tag_stack:
            return ''

        # Close tags in reverse order (LIFO) for proper nesting
        closing_tags = []
        while self.tag_stack:
            tag_name = self.tag_stack.pop()
            closing_tags.append(f'</{tag_name}>')

        return ''.join(closing_tags)


def convert_legacy_colors(text: str) -> str:
    """
    Convert legacy color codes to XML-Lite markup (convenience function)

    Args:
        text: Text with legacy color codes

    Returns:
        Text with XML-Lite markup

    Examples:
        >>> convert_legacy_colors("&1Error:&0 Invalid command!")
        '<red>Error:</red> Invalid command!'
        >>> convert_legacy_colors("@Y== @WFIERY@RMUD @Y==")
        '<b:yellow>== </><b:white>FIERY</><b:red>MUD </><b:yellow>=='
    """
    if not text:
        return text

    converter = ColorConverter()
    return converter.convert(text)


def strip_legacy_colors(text: str) -> str:
    """
    Remove all legacy color codes from text

    Args:
        text: Text with legacy color codes

    Returns:
        Plain text without color codes

    Examples:
        >>> strip_legacy_colors("&1Red text&0")
        'Red text'
        >>> strip_legacy_colors("@RBright@0 text")
        'Bright text'
    """
    if not text:
        return text

    # Remove all & and @ color codes (2 characters each)
    result = []
    i = 0

    while i < len(text):
        char = text[i]

        if char in ('&', '@') and i + 1 < len(text):
            next_char = text[i + 1]

            # Handle escapes - keep one character
            if next_char == char:
                result.append(char)
                i += 2
                continue

            # Handle newline &_
            if char == '&' and next_char == '_':
                result.append('\n')
                i += 2
                continue

            # Skip color code (both characters)
            i += 2
            continue

        result.append(char)
        i += 1

    return ''.join(result)
