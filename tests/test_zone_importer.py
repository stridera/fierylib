"""
Tests for zone importer module

Note: These tests require a running PostgreSQL database and Prisma setup.
Run with: pytest -m integration (mark integration tests separately)
"""

import pytest
from fierylib.importers import ZoneImporter
from fierylib.converters import convert_zone_id
import sys
from pathlib import Path

# Add parsers to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src" / "parsers"))

from mud.types.zone import Zone, ResetModes, Hemispheres, Climates


class TestZoneImporterEnumMapping:
    """Tests for enum mapping functions (no database required)"""

    def test_map_reset_mode_never(self):
        """ResetModes.Never should map to 'NEVER'"""
        assert ZoneImporter.map_reset_mode(ResetModes.Never) == "NEVER"

    def test_map_reset_mode_empty(self):
        """ResetModes.Empty should map to 'EMPTY'"""
        assert ZoneImporter.map_reset_mode(ResetModes.Empty) == "EMPTY"

    def test_map_reset_mode_normal(self):
        """ResetModes.Normal should map to 'NORMAL'"""
        assert ZoneImporter.map_reset_mode(ResetModes.Normal) == "NORMAL"

    def test_map_hemisphere(self):
        """Hemisphere enums should map to their name"""
        assert ZoneImporter.map_hemisphere(Hemispheres.NORTHWEST) == "NORTHWEST"
        assert ZoneImporter.map_hemisphere(Hemispheres.NORTHEAST) == "NORTHEAST"
        assert ZoneImporter.map_hemisphere(Hemispheres.SOUTHWEST) == "SOUTHWEST"
        assert ZoneImporter.map_hemisphere(Hemispheres.SOUTHEAST) == "SOUTHEAST"

    def test_map_climate(self):
        """Climate enums should map to their name"""
        assert ZoneImporter.map_climate(Climates.NONE) == "NONE"
        assert ZoneImporter.map_climate(Climates.TROPICAL) == "TROPICAL"
        assert ZoneImporter.map_climate(Climates.ARCTIC) == "ARCTIC"
        assert ZoneImporter.map_climate(Climates.TEMPERATE) == "TEMPERATE"


class TestZoneImporterDryRun:
    """Tests for dry run mode (no database required)"""

    @pytest.mark.asyncio
    async def test_dry_run_validation(self):
        """Dry run should validate without database writes"""
        # Mock Prisma client (not actually used in dry run)
        mock_prisma = None

        importer = ZoneImporter(mock_prisma)

        # Create test zone
        zone = Zone(
            id=30,
            name="Test Zone",
            top=3099,
            lifespan=10,
            reset_mode=ResetModes.Normal,
            hemisphere=Hemispheres.NORTHWEST,
            climate=Climates.TEMPERATE,
            resets=[],
        )

        # Dry run should not require database
        result = await importer.import_zone(zone, dry_run=True)

        assert result["success"] is True
        assert result["zone_id"] == 30
        assert result["zone_name"] == "Test Zone"
        assert result["action"] == "validated"
        assert result["data"]["resetMode"] == "NORMAL"
        assert result["data"]["hemisphere"] == "NORTHWEST"
        assert result["data"]["climate"] == "TEMPERATE"

    @pytest.mark.asyncio
    async def test_dry_run_zone_0_conversion(self):
        """Dry run should apply zone 0 → 1000 conversion"""
        mock_prisma = None
        importer = ZoneImporter(mock_prisma)

        zone = Zone(
            id=0,
            name="Special Zone",
            top=99,
            lifespan=5,
            reset_mode=ResetModes.Never,
            hemisphere=Hemispheres.NORTHWEST,
            climate=Climates.NONE,
            resets=[],
        )

        result = await importer.import_zone(zone, dry_run=True)

        assert result["success"] is True
        assert result["zone_id"] == 1000  # Zone 0 → 1000
        assert result["data"]["id"] == 1000


# Integration tests (require database)
@pytest.mark.integration
class TestZoneImporterIntegration:
    """Integration tests requiring PostgreSQL database"""

    @pytest.mark.asyncio
    async def test_import_zone_creates_record(self):
        """Test that import_zone actually creates a database record"""
        # This test requires:
        # 1. PostgreSQL running
        # 2. Prisma client initialized
        # 3. Database migrations applied
        pytest.skip("Integration test - requires database setup")

    @pytest.mark.asyncio
    async def test_import_zone_updates_existing(self):
        """Test that import_zone updates existing zones"""
        pytest.skip("Integration test - requires database setup")

    @pytest.mark.asyncio
    async def test_import_zone_from_file(self):
        """Test importing from actual .zon file"""
        pytest.skip("Integration test - requires database setup and lib/ files")
