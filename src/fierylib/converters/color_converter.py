"""
Color Code Converter V2 - Optimized XML-Lite output with collapsed tags

Key improvements:
- Combines modifiers into single tags: <b:black> instead of <black><b>
- Uses </> for resets instead of explicit closing tags
- Tracks state and only outputs tags when text changes
"""

from typing import Optional, Set
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

ABSOLUTE_BRIGHT_COLORS = {
    'R': 'red',
    'G': 'green',
    'Y': 'yellow',
    'B': 'blue',
    'M': 'magenta',
    'C': 'cyan',
    'W': 'white',
    'L': 'black',
}


class ColorState:
    """Tracks current color/style state"""

    def __init__(self):
        self.foreground: Optional[str] = None
        self.background: Optional[str] = None
        self.styles: Set[str] = set()

    def reset(self):
        """Clear all formatting"""
        self.foreground = None
        self.background = None
        self.styles.clear()

    def is_empty(self) -> bool:
        """Check if any formatting is active"""
        return not (self.foreground or self.background or self.styles)

    def to_tag(self) -> Optional[str]:
        """Convert current state to XML-Lite opening tag"""
        if self.is_empty():
            return None

        # Build modifier list
        modifiers = []

        # Add styles first (conventional order: b, u, etc.)
        if 'b' in self.styles:
            modifiers.append('b')
        if 'u' in self.styles:
            modifiers.append('u')
        if 'dim' in self.styles:
            modifiers.append('dim')

        # Add background
        if self.background:
            modifiers.append(self.background)

        # Add foreground
        if self.foreground:
            modifiers.append(self.foreground)

        # Combine with colons
        return '<' + ':'.join(modifiers) + '>'

    def copy(self) -> 'ColorState':
        """Create a copy of current state"""
        state = ColorState()
        state.foreground = self.foreground
        state.background = self.background
        state.styles = self.styles.copy()
        return state

    def __eq__(self, other) -> bool:
        """Check if two states are equal"""
        if not isinstance(other, ColorState):
            return False
        return (self.foreground == other.foreground and
                self.background == other.background and
                self.styles == other.styles)


class ColorConverter:
    """Converts legacy color codes to optimized XML-Lite markup"""

    def __init__(self):
        self.current_state = ColorState()
        self.active_state = ColorState()  # What's currently open in output

    def convert(self, text: str) -> str:
        """
        Convert legacy color codes to XML-Lite markup

        Args:
            text: Text with legacy color codes (&, @)

        Returns:
            Text with XML-Lite markup
        """
        result = []
        i = 0

        # Reset state for new conversion
        self.current_state.reset()
        self.active_state.reset()

        while i < len(text):
            char = text[i]

            # Check for color codes
            if char in ('&', '@'):
                if i + 1 < len(text):
                    next_char = text[i + 1]

                    # Escape sequences
                    if next_char == char:
                        result.append(char)
                        i += 2
                        continue

                    # Newline escape
                    if char == '&' and next_char == '_':
                        result.append('\n')
                        i += 2
                        continue

                    # Process color code
                    if char == '&':
                        self._process_relative_code(next_char)
                    else:  # @
                        self._process_absolute_code(next_char)

                    i += 2
                    continue

            # Regular character - output with current formatting
            markup = self._apply_state_change()
            if markup:
                result.append(markup)
            result.append(char)
            i += 1

        # Close any remaining tags
        if not self.active_state.is_empty():
            result.append('</>')

        return ''.join(result)

    def _process_relative_code(self, code: str):
        """Process relative color code (update state)"""
        # Reset
        if code == '0':
            self.current_state.reset()
            return

        # Foreground colors
        if code in RELATIVE_FOREGROUND_CODES:
            color = RELATIVE_FOREGROUND_CODES[code]
            if color:
                self.current_state.foreground = color
            return

        # Background colors
        if code in RELATIVE_BACKGROUND_CODES:
            self.current_state.background = RELATIVE_BACKGROUND_CODES[code]
            return

        # Styles
        if code in RELATIVE_STYLE_CODES:
            self.current_state.styles.add(RELATIVE_STYLE_CODES[code])
            return

    def _process_absolute_code(self, code: str):
        """Process absolute color code (reset then update state)"""
        # Reset first
        self.current_state.reset()

        # Then apply new color
        if code == '0':
            return

        # Bright colors (bold + color)
        if code in ABSOLUTE_BRIGHT_COLORS:
            self.current_state.styles.add('b')
            self.current_state.foreground = ABSOLUTE_BRIGHT_COLORS[code]
            return

        # Lowercase colors
        if code in ABSOLUTE_LOWERCASE_CODES:
            self.current_state.foreground = ABSOLUTE_LOWERCASE_CODES[code]
            return

        # Numbered colors
        if code in ABSOLUTE_BASIC_CODES:
            color = ABSOLUTE_BASIC_CODES[code]
            if color:
                self.current_state.foreground = color
            return

    def _apply_state_change(self) -> str:
        """Apply state change and return markup needed"""
        if self.current_state == self.active_state:
            return ''

        result = []

        # Close old tags if any
        if not self.active_state.is_empty():
            result.append('</>')

        # Open new tags if any
        if not self.current_state.is_empty():
            tag = self.current_state.to_tag()
            if tag:
                result.append(tag)

        # Update active state
        self.active_state = self.current_state.copy()

        return ''.join(result)


def convert_legacy_colors(text: str) -> str:
    """
    Convert legacy color codes to XML-Lite markup (convenience function)

    Args:
        text: Text with legacy color codes

    Returns:
        Text with XML-Lite markup
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
    """
    if not text:
        return text

    result = []
    i = 0

    while i < len(text):
        char = text[i]

        if char in ('&', '@'):
            if i + 1 < len(text):
                next_char = text[i + 1]

                # Escape sequences
                if next_char == char:
                    result.append(char)
                    i += 2
                    continue

                # Newline escape
                if char == '&' and next_char == '_':
                    result.append('\n')
                    i += 2
                    continue

                # Skip color code
                i += 2
                continue

        result.append(char)
        i += 1

    return ''.join(result)


def strip_markup(text: str) -> str:
    """
    Remove all XML-Lite color markup tags from text

    This strips tags like <red>, <b:black>, </>, etc. leaving only plain text.
    Used to generate plaintext versions of colored fields for database indexing.

    Args:
        text: Text with XML-Lite color markup

    Returns:
        Plain text without any markup tags

    Examples:
        >>> strip_markup("<red>Hello</> world")
        'Hello world'
        >>> strip_markup("<b:black>Night</><magenta>bringer</>")
        'Nightbringer'
    """
    if not text:
        return ''

    # Remove all XML-Lite tags: opening tags, closing tags, and full resets
    return re.sub(r'<[^>]*>', '', text)
