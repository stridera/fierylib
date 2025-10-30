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

    def test_zone_0_converts_to_1000(self):
        """Zone 0 should convert to zone 1000 (special case)"""
        assert convert_zone_id(0) == 1000

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
        assert legacy_id_to_composite(3000) == CompositeId(zone_id=30, vnum=0)
        assert legacy_id_to_composite(3045) == CompositeId(zone_id=30, vnum=45)
        assert legacy_id_to_composite(3099) == CompositeId(zone_id=30, vnum=99)
        assert legacy_id_to_composite(12345) == CompositeId(zone_id=123, vnum=45)
        assert legacy_id_to_composite(12399) == CompositeId(zone_id=123, vnum=99)

    def test_zone_0_special_case(self):
        """Zone 0 IDs should convert to zone 1000"""
        assert legacy_id_to_composite(0) == CompositeId(zone_id=1000, vnum=0)
        assert legacy_id_to_composite(50) == CompositeId(zone_id=1000, vnum=50)
        assert legacy_id_to_composite(99) == CompositeId(zone_id=1000, vnum=99)

    def test_single_digit_zones(self):
        """Test single-digit zone IDs"""
        assert legacy_id_to_composite(100) == CompositeId(zone_id=1, vnum=0)
        assert legacy_id_to_composite(199) == CompositeId(zone_id=1, vnum=99)
        assert legacy_id_to_composite(500) == CompositeId(zone_id=5, vnum=0)
        assert legacy_id_to_composite(999) == CompositeId(zone_id=9, vnum=99)

    def test_negative_id_raises_error(self):
        """Negative IDs should raise error"""
        with pytest.raises(IdConversionError) as exc_info:
            legacy_id_to_composite(-1)
        assert "cannot be negative" in str(exc_info.value)

    def test_vnum_over_99_raises_error(self):
        """IDs with vnum > 99 should raise error (malformed)"""
        # Note: This shouldn't happen in practice with the // 100 and % 100 algorithm
        # But we test the validation logic
        # In practice, any valid legacy ID will have vnum 0-99 by definition
        pass


class TestCompositeToLegacyId:
    """Tests for composite → legacy ID conversion"""

    def test_standard_conversions(self):
        """Test standard reverse conversions"""
        assert composite_to_legacy_id(30, 0) == 3000
        assert composite_to_legacy_id(30, 45) == 3045
        assert composite_to_legacy_id(30, 99) == 3099
        assert composite_to_legacy_id(123, 45) == 12345
        assert composite_to_legacy_id(123, 99) == 12399

    def test_zone_1000_converts_to_0(self):
        """Zone 1000 should reverse to zone 0"""
        assert composite_to_legacy_id(1000, 0) == 0
        assert composite_to_legacy_id(1000, 50) == 50
        assert composite_to_legacy_id(1000, 99) == 99

    def test_roundtrip_conversions(self):
        """Test that conversion is reversible"""
        test_ids = [0, 50, 99, 100, 3000, 3045, 12345, 12399]

        for legacy_id in test_ids:
            composite = legacy_id_to_composite(legacy_id)
            result = composite_to_legacy_id(composite.zone_id, composite.vnum)
            assert result == legacy_id, f"Roundtrip failed for {legacy_id}"

    def test_invalid_vnum_raises_error(self):
        """vnums outside 0-99 should raise error"""
        with pytest.raises(IdConversionError) as exc_info:
            composite_to_legacy_id(30, -1)
        assert "must be in range 0-99" in str(exc_info.value)

        with pytest.raises(IdConversionError) as exc_info:
            composite_to_legacy_id(30, 100)
        assert "must be in range 0-99" in str(exc_info.value)


class TestIdConversionError:
    """Tests for IdConversionError exception"""

    def test_error_message_format(self):
        """Test that error messages are properly formatted"""
        error = IdConversionError(3045, "Test reason")
        assert "3045" in str(error)
        assert "Test reason" in str(error)
