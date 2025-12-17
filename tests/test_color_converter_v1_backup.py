"""
Tests for color code converter module

Tests conversion from legacy CircleMUD color codes (&, @)
to modern XML-Lite markup system.
"""

import pytest
from fierylib.converters import convert_legacy_colors, strip_legacy_colors, ColorConverter


class TestRelativeColorCodes:
    """Tests for relative color codes (& prefix)"""

    def test_simple_foreground_color(self):
        """Test basic foreground color conversion"""
        assert convert_legacy_colors("&1Red text&0") == "<red>Red text</red>"
        assert convert_legacy_colors("&2Green text&0") == "<green>Green text</green>"
        assert convert_legacy_colors("&3Yellow text&0") == "<yellow>Yellow text</yellow>"
        assert convert_legacy_colors("&4Blue text&0") == "<blue>Blue text</blue>"

    def test_multiple_colors(self):
        """Test multiple color codes in sequence"""
        assert (
            convert_legacy_colors("&1Red&0 and &2Green&0")
            == "<red>Red</red> and <green>Green</green>"
        )

    def test_background_colors(self):
        """Test background color codes"""
        assert convert_legacy_colors("&R&7White on red&0") == "<bg-red><white>White on red</white></bg-red>"
        assert convert_legacy_colors("&G&9Black on green&0") == "<bg-green><black>Black on green</black></bg-green>"

    def test_style_codes(self):
        """Test text style codes (bold, underline, dim)"""
        assert convert_legacy_colors("&bBold text&0") == "<b>Bold text</b>"
        assert convert_legacy_colors("&uUnderlined&0") == "<u>Underlined</u>"
        assert convert_legacy_colors("&dDimmed&0") == "<dim>Dimmed</dim>"

    def test_combined_styles(self):
        """Test combining multiple style codes"""
        result = convert_legacy_colors("&b&1Bold red&0")
        assert result == "<b><red>Bold red</red></b>"

    def test_reset_code(self):
        """Test reset code (&0) closes all tags"""
        assert convert_legacy_colors("&1Red&0 normal") == "<red>Red</red> normal"
        assert convert_legacy_colors("&b&1&uBold red underlined&0") == "<b><red><u>Bold red underlined</u></red></b>"


class TestAbsoluteColorCodes:
    """Tests for absolute color codes (@ prefix)"""

    def test_basic_absolute_colors(self):
        """Test basic absolute color codes"""
        assert convert_legacy_colors("@1Red@0") == "<red>Red</red>"
        assert convert_legacy_colors("@gGreen@0") == "<green>Green</green>"
        assert convert_legacy_colors("@yYellow@0") == "<yellow>Yellow</yellow>"

    def test_bright_colors(self):
        """Test bright (uppercase) absolute colors"""
        assert convert_legacy_colors("@RBright red@0") == "<b:red>Bright red</b:red>"
        assert convert_legacy_colors("@GBright green@0") == "<b:green>Bright green</b:green>"
        assert convert_legacy_colors("@WBright white@0") == "<b:white>Bright white</b:white>"

    def test_absolute_reset_behavior(self):
        """Test that absolute codes reset previous formatting"""
        result = convert_legacy_colors("@RRed@GGreen@0")
        # Each @ should reset and apply new color
        assert "<b:red>" in result
        assert "<b:green>" in result

    def test_numbered_absolute_codes(self):
        """Test numbered absolute color codes"""
        assert convert_legacy_colors("@1Red@0") == "<red>Red</red>"
        assert convert_legacy_colors("@2Green@0") == "<green>Green</green>"


class TestEscapesAndSpecialCases:
    """Tests for escape sequences and special cases"""

    def test_escaped_ampersand(self):
        """Test && escapes to literal &"""
        assert convert_legacy_colors("Use &&1 for red") == "Use &1 for red"
        assert convert_legacy_colors("Text && more") == "Text & more"

    def test_escaped_at_sign(self):
        """Test @@ escapes to literal @"""
        assert convert_legacy_colors("Email: test@@example.com") == "Email: test@example.com"
        assert convert_legacy_colors("Use @@R for bright red") == "Use @R for bright red"

    def test_newline_code(self):
        """Test &_ converts to newline"""
        assert convert_legacy_colors("Line 1&_Line 2") == "Line 1\nLine 2"
        assert convert_legacy_colors("First&_Second&_Third") == "First\nSecond\nThird"

    def test_empty_string(self):
        """Test empty string returns empty"""
        assert convert_legacy_colors("") == ""
        assert convert_legacy_colors(None) == None

    def test_no_color_codes(self):
        """Test string without color codes passes through"""
        assert convert_legacy_colors("Plain text") == "Plain text"
        assert convert_legacy_colors("No codes here!") == "No codes here!"


class TestComplexScenarios:
    """Tests for complex real-world scenarios"""

    def test_mud_title(self):
        """Test typical MUD title with multiple colors"""
        legacy = "@Y== @WFIERY@RMUD @Y=="
        result = convert_legacy_colors(legacy)
        # Should have bright yellow, bright white, bright red
        assert "<b:yellow>" in result
        assert "<b:white>" in result
        assert "<b:red>" in result

    def test_error_message(self):
        """Test typical error message pattern"""
        legacy = "&1Error:&0 Invalid command!"
        result = convert_legacy_colors(legacy)
        assert result == "<red>Error:</red> Invalid command!"

    def test_room_description(self):
        """Test room description with mixed formatting"""
        legacy = "You see a &2forest&0 with &b&4dark blue&0 trees."
        result = convert_legacy_colors(legacy)
        assert "<green>forest</green>" in result
        assert "<b><blue>dark blue</blue></b>" in result

    def test_npc_name_with_color(self):
        """Test NPC name with color codes"""
        legacy = "&Ra &7fierce goblin&0"
        result = convert_legacy_colors(legacy)
        assert "<bg-red>" in result
        assert "<white>fierce goblin</white></bg-red>" in result

    def test_nested_resets(self):
        """Test multiple nested styles with resets"""
        legacy = "&b&u&1Bold underlined red&0 normal"
        result = convert_legacy_colors(legacy)
        assert result == "<b><u><red>Bold underlined red</red></u></b> normal"


class TestStripColors:
    """Tests for strip_legacy_colors function"""

    def test_strip_simple_colors(self):
        """Test stripping basic color codes"""
        assert strip_legacy_colors("&1Red text&0") == "Red text"
        assert strip_legacy_colors("@RBright@0") == "Bright"

    def test_strip_multiple_codes(self):
        """Test stripping multiple codes"""
        assert strip_legacy_colors("&b&1Bold red&0") == "Bold red"
        assert strip_legacy_colors("@Y== @WFIERY@RMUD @Y==") == "== FIERYMUD =="

    def test_strip_preserves_escapes(self):
        """Test that escapes are preserved as single characters"""
        assert strip_legacy_colors("Test && more") == "Test & more"
        assert strip_legacy_colors("Email@@example") == "Email@example"

    def test_strip_newlines(self):
        """Test that &_ becomes newline"""
        assert strip_legacy_colors("Line 1&_Line 2") == "Line 1\nLine 2"

    def test_strip_empty_and_plain(self):
        """Test edge cases"""
        assert strip_legacy_colors("") == ""
        assert strip_legacy_colors("Plain text") == "Plain text"


class TestColorConverter:
    """Tests for ColorConverter class"""

    def test_converter_reuse(self):
        """Test that converter can be reused for multiple conversions"""
        converter = ColorConverter()

        result1 = converter.convert("&1Red&0")
        assert result1 == "<red>Red</red>"

        result2 = converter.convert("&2Green&0")
        assert result2 == "<green>Green</green>"

        # Tag stack should be reset between conversions
        result3 = converter.convert("&b&1Bold red&0")
        assert result3 == "<b><red>Bold red</red></b>"

    def test_tag_stack_management(self):
        """Test that tag stack is properly managed"""
        converter = ColorConverter()

        # First conversion
        result1 = converter.convert("&1Red&2Green&0")
        assert "<red>" in result1
        assert "<green>" in result1

        # Tag stack should be empty after conversion
        assert converter.tag_stack == []

        # Second conversion should start fresh
        result2 = converter.convert("&bBold&0")
        assert result2 == "<b>Bold</b>"

    def test_unclosed_tags(self):
        """Test that unclosed tags are auto-closed at end"""
        result = convert_legacy_colors("&1Red text without reset")
        assert result == "<red>Red text without reset</red>"

        result2 = convert_legacy_colors("&b&1Bold red never closed")
        assert result2 == "<b><red>Bold red never closed</red></b>"


class TestEdgeCases:
    """Tests for edge cases and error conditions"""

    def test_unknown_color_codes(self):
        """Test that unknown codes are ignored"""
        # These should pass through unchanged (unknown code ignored)
        result = convert_legacy_colors("&ZUnknown")
        assert "Unknown" in result

    def test_incomplete_codes_at_end(self):
        """Test handling of incomplete codes at string end"""
        # & or @ at end without following character
        result = convert_legacy_colors("Text ends with &")
        assert "Text ends with &" == result

        result2 = convert_legacy_colors("Text ends with @")
        assert "Text ends with @" == result2

    def test_consecutive_resets(self):
        """Test multiple consecutive reset codes"""
        result = convert_legacy_colors("&1Red&0&0&0")
        # Multiple resets should be handled gracefully (no-ops after first)
        assert result == "<red>Red</red>"

    def test_mixed_relative_and_absolute(self):
        """Test mixing relative and absolute codes"""
        result = convert_legacy_colors("&1Relative @RAbsolute &2Back to relative")
        # @ should reset, then apply new color
        assert "<red>Relative </red>" in result
        assert "<b:red>Absolute <green>Back to relative</green></b:red>" in result


class TestRealWorldExamples:
    """Tests using actual examples from CircleMUD world files"""

    def test_zone_name(self):
        """Test typical zone name"""
        legacy = "@WThe @YGolden @WCity@0"
        result = convert_legacy_colors(legacy)
        assert "<b:white>The </b:white>" in result
        assert "<b:yellow>Golden </b:yellow>" in result

    def test_room_name(self):
        """Test typical room name"""
        legacy = "&bThe &6Throne Room&0"
        result = convert_legacy_colors(legacy)
        assert "<b>The <cyan>Throne Room</cyan></b>" in result

    def test_mob_description(self):
        """Test typical mob description"""
        legacy = "A &1fierce &Rred&0 dragon stands here, breathing fire."
        result = convert_legacy_colors(legacy)
        assert "<red>fierce <bg-red>red</bg-red></red>" in result

    def test_object_description(self):
        """Test typical object description"""
        legacy = "&ba &3golden &usword&0 lies here."
        result = convert_legacy_colors(legacy)
        assert "<b>a <yellow>golden <u>sword</u></yellow></b>" in result

    def test_help_text_formatting(self):
        """Test help text with formatting"""
        legacy = "&bSyntax:&0 cast '&2cure light&0' <target>&_&bExample:&0 cast '&2cure light&0' self"
        result = convert_legacy_colors(legacy)
        assert "<b>Syntax:</b>" in result
        assert "<green>cure light</green>" in result
        assert "\n" in result  # &_ should become newline
