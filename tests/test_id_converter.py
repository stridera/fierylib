"""
Tests for ID converter module
"""

import pytest
from fierylib.converters import (
    legacy_id_to_composite,
    composite_to_legacy_id,
    convert_zone_id,
    CompositeId,
)
from fierylib.converters.id_converter import IdConversionError


class TestConvertZoneId:
    """Tests for zone ID conversion"""

    def test_zone_0_unchanged(self):
        """Zone 0 should pass through unchanged"""
        assert convert_zone_id(0) == 0

    def test_regular_zones_unchanged(self):
        """Regular zone IDs should pass through unchanged"""
        assert convert_zone_id(1) == 1
        assert convert_zone_id(30) == 30
        assert convert_zone_id(123) == 123
        assert convert_zone_id(999) == 999

    def test_negative_zone_raises_error(self):
        """Negative zone IDs should raise error"""
        with pytest.raises(IdConversionError) as exc_info:
            convert_zone_id(-1)
        assert "cannot be negative" in str(exc_info.value)


class TestLegacyIdToComposite:
    """Tests for legacy → composite ID conversion"""

    def test_standard_conversions(self):
        """Test standard ID conversions"""
        assert legacy_id_to_composite(3000) == CompositeId(zone_id=30, id=0)
        assert legacy_id_to_composite(3045) == CompositeId(zone_id=30, id=45)
        assert legacy_id_to_composite(3099) == CompositeId(zone_id=30, id=99)
        assert legacy_id_to_composite(12345) == CompositeId(zone_id=123, id=45)
        assert legacy_id_to_composite(12399) == CompositeId(zone_id=123, id=99)

    def test_zone_0(self):
        """Zone 0 IDs should stay in zone 0"""
        assert legacy_id_to_composite(0) == CompositeId(zone_id=0, id=0)
        assert legacy_id_to_composite(50) == CompositeId(zone_id=0, id=50)
        assert legacy_id_to_composite(99) == CompositeId(zone_id=0, id=99)

    def test_single_digit_zones(self):
        """Test single-digit zone IDs"""
        assert legacy_id_to_composite(100) == CompositeId(zone_id=1, id=0)
        assert legacy_id_to_composite(199) == CompositeId(zone_id=1, id=99)
        assert legacy_id_to_composite(500) == CompositeId(zone_id=5, id=0)
        assert legacy_id_to_composite(999) == CompositeId(zone_id=9, id=99)

    def test_negative_id_raises_error(self):
        """Negative IDs should raise error"""
        with pytest.raises(IdConversionError) as exc_info:
            legacy_id_to_composite(-1)
        assert "cannot be negative" in str(exc_info.value)


class TestCompositeToLegacyId:
    """Tests for composite → legacy ID conversion"""

    def test_standard_conversions(self):
        """Test standard reverse conversions"""
        assert composite_to_legacy_id(30, 0) == 3000
        assert composite_to_legacy_id(30, 45) == 3045
        assert composite_to_legacy_id(30, 99) == 3099
        assert composite_to_legacy_id(123, 45) == 12345
        assert composite_to_legacy_id(123, 99) == 12399

    def test_extended_zone_ids(self):
        """Extended zone IDs (id > 99) should work"""
        assert composite_to_legacy_id(30, 108) == 3108
        assert composite_to_legacy_id(73, 175) == 7475
        assert composite_to_legacy_id(4, 100) == 500

    def test_zone_0(self):
        """Zone 0 should produce small legacy IDs"""
        assert composite_to_legacy_id(0, 0) == 0
        assert composite_to_legacy_id(0, 50) == 50
        assert composite_to_legacy_id(0, 99) == 99

    def test_roundtrip_conversions(self):
        """Test that conversion is reversible for standard ids (0-99)"""
        test_ids = [0, 50, 99, 100, 3000, 3045, 12345, 12399]

        for legacy_id in test_ids:
            composite = legacy_id_to_composite(legacy_id)
            result = composite_to_legacy_id(composite.zone_id, composite.id)
            assert result == legacy_id, f"Roundtrip failed for {legacy_id}"

    def test_negative_vnum_raises_error(self):
        """Negative vnums should raise error"""
        with pytest.raises(IdConversionError) as exc_info:
            composite_to_legacy_id(30, -1)
        assert "cannot be negative" in str(exc_info.value)


class TestIdConversionError:
    """Tests for IdConversionError exception"""

    def test_error_message_format(self):
        """Test that error messages are properly formatted"""
        error = IdConversionError(3045, "Test reason")
        assert "3045" in str(error)
        assert "Test reason" in str(error)
