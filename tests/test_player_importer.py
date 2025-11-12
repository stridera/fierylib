import ipaddress
from datetime import datetime
import pytest

from fierylib.importers.player_importer import PlayerImporter
from mud.types import Player, CurrentMax, Gender, Class, Race, Stats


class DummyPrisma:
    """Minimal prisma stub for dry_run tests"""
    class characters:
        @staticmethod
        async def create(data):  # pragma: no cover - not used in dry_run
            raise AssertionError("Should not be called in dry_run")

    class ability:
        @staticmethod
        async def find_first(where):  # pragma: no cover - not used in these tests
            return None

    class characterabilities:
        @staticmethod
        async def find_first(where):  # pragma: no cover - not used in these tests
            return None
        @staticmethod
        async def create(data):  # pragma: no cover - not used in these tests
            return None


@pytest.mark.asyncio
async def test_import_player_sets_race_type_elf():
    prisma = DummyPrisma()
    importer = PlayerImporter(prisma)

    player = Player(
        id=1,
        name="TestElf",
        password="pass",
        prompt="<%h/%Hhp %v/%Vmv>",
        level=10,
        home="100",
        birth_time=datetime.now(),
        time_played=0,
        last_login_time=datetime.now(),
        host=ipaddress.IPv4Address("127.0.0.1"),
        hit_points=CurrentMax(50, 50),
        move=CurrentMax(30, 30),
        stats={"strength":10,"intelligence":12,"wisdom":11,"dexterity":13,"constitution":9,"charisma":8},
        gender=Gender.MALE,
        player_class=Class.WARRIOR,
        race=Race.ELF,
    )  # type: ignore[arg-type]

    stats = await importer.import_player(player, dry_run=True)
    assert stats["character"] == 1
    assert "character_data" in stats
    assert stats["character_data"]["race"] == "ELF"
    assert stats["character_data"]["raceType"] == "elf"


@pytest.mark.asyncio
async def test_import_player_sets_race_type_halfelf():
    prisma = DummyPrisma()
    importer = PlayerImporter(prisma)

    player = Player(
        id=2,
        name="TestHalfElf",
        password="pass",
        prompt="<%h/%Hhp %v/%Vmv>",
        level=10,
        home="100",
        birth_time=datetime.now(),
        time_played=0,
        last_login_time=datetime.now(),
        host=ipaddress.IPv4Address("127.0.0.1"),
        hit_points=CurrentMax(50, 50),
        move=CurrentMax(30, 30),
        stats={"strength":10,"intelligence":12,"wisdom":11,"dexterity":13,"constitution":9,"charisma":8},
        gender=Gender.FEMALE,
        player_class=Class.WARRIOR,
        race=Race.HALF_ELF,
    )  # type: ignore[arg-type]

    stats = await importer.import_player(player, dry_run=True)
    assert stats["character_data"]["raceType"] == "halfelf"


@pytest.mark.asyncio
async def test_import_player_missing_race_errors():
    prisma = DummyPrisma()
    importer = PlayerImporter(prisma)

    player = Player(
        id=3,
        name="NoRace",
        password="pass",
        prompt="<%h/%Hhp %v/%Vmv>",
        level=10,
        home="100",
        birth_time=datetime.now(),
        time_played=0,
        last_login_time=datetime.now(),
        host=ipaddress.IPv4Address("127.0.0.1"),
        hit_points=CurrentMax(50, 50),
        move=CurrentMax(30, 30),
        stats={"strength":10,"intelligence":12,"wisdom":11,"dexterity":13,"constitution":9,"charisma":8},
        gender=Gender.FEMALE,
        player_class=Class.WARRIOR,
        race=None,
    )  # type: ignore[arg-type]

    with pytest.raises(ValueError) as exc:
        await importer.import_player(player, dry_run=True)
    assert "missing required race" in str(exc.value).lower()
