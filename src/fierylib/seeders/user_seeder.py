"""User seeding functionality for initial database setup"""

import re
import uuid
import bcrypt
import click
from prisma import Prisma
from prisma.enums import UserRole, Race

from fierylib.combat_formulas import (
    class_stat_profile,
    derive_attack_power_baseline,
    derive_hit_roll_baseline,
)


# Map Race enum (uppercase) to the human-readable Race.name column.
# Only includes the enums actually used by seeded characters today;
# extend if/when other races get test users.
RACE_ENUM_TO_DISPLAY = {
    Race.HUMAN: "Human",
    Race.ELF: "Elf",
    Race.HALFLING: "Halfling",
    Race.HALF_ELF: "Half-Elf",
}


# Starter loadouts per test character. Each entry is
# ``(object_zone_id, object_id, equipped_location_or_None)``. None
# means inventory; "WIELD" / "HEAD" / etc. equip into that slot.
# Tier-matched to character level so combat math reads cleanly on
# a playtest session. Validated against the live Objects table:
#   - TestWarrior L25 → claymore (163, 0) — slashing 2H, L20 weapon
#   - TestCleric  L20 → mace of the grave (2, 142) — bludgeoning L20
#   - TestMage    L15 → yew staff (163, 2) wield + spellbook (10, 29)
#   - TestRogue   L10 → small silver dagger (557, 63) — Halfling-OK
# Re-runs of the seeder are idempotent: the grant skips characters
# that already carry the same prototype in the same slot.
STARTER_GEAR: dict[str, list[tuple[int, int, str | None]]] = {
    "TestWarrior": [(163, 0, "WIELD")],
    "TestCleric":  [(2, 142, "WIELD")],
    "TestMage":    [(163, 2, "WIELD"), (10, 29, None)],
    "TestRogue":   [(557, 63, "WIELD")],
}


_DICE_RE = re.compile(r"^\s*(?P<n>\d+)d(?P<m>\d+)\s*(?P<bonus>[+-]\d+)?\s*$")


def parse_hit_dice(expr: str) -> tuple[int, int, int]:
    """Parse ``NdM[+B]`` (or bare int) into ``(num, sides, bonus)``.

    Mirrors the Rust ``parse_hit_dice`` in
    ``fierymud-rs/crates/mud-server/src/combat.rs``. Returns ``(0,0,0)``
    on failure so callers degenerate to "no dice contribution".
    """
    expr = (expr or "").strip()
    if not expr:
        return (0, 0, 0)
    if expr.lstrip("+-").isdigit():
        return (0, 0, int(expr))
    m = _DICE_RE.match(expr)
    if not m:
        return (0, 0, 0)
    return (int(m["n"]), int(m["m"]), int(m["bonus"] or 0))


def avg_dice(expr: str) -> float:
    """Mean of ``NdM+B``. Used at seed time so character HP is
    deterministic (matches the average of what the live Rust roll
    would produce)."""
    n, m, b = parse_hit_dice(expr)
    if n <= 0 or m <= 0:
        return float(b)
    return n * (m + 1) / 2.0 + b


async def compute_max_hp(prisma: Prisma, level: int, race: Race, class_row) -> int:
    """Compute hit_points_max from the live tuning rows (LevelDefinition,
    Class, Races). Walks levels 1..level, summing per-level gain:

        gain[L] = max(1, LevelDef[L].hp_gain * race.hp_factor / 100)
                  + class.hp_per_level
                  + avg(class.hit_dice)

    Uses average dice rolls (deterministic) rather than rolling, so a
    re-seed produces stable HP totals.
    """
    race_factor = 100
    display_name = RACE_ENUM_TO_DISPLAY.get(race)
    if display_name is not None:
        row = await prisma.races.find_first(where={"name": display_name})
        if row is not None and row.hpFactor is not None:
            race_factor = row.hpFactor

    class_flat = class_row.hpPerLevel if class_row is not None else 0
    class_dice_avg = avg_dice(class_row.hitDice) if class_row is not None else 0.0

    level_defs = await prisma.leveldefinition.find_many(
        where={"level": {"gte": 1, "lte": level}}
    )
    by_level = {ld.level: ld for ld in level_defs}

    total = 0.0
    for L in range(1, level + 1):
        ld = by_level.get(L)
        baseline = ld.hpGain if ld is not None else 5
        race_scaled = max(1, (baseline * race_factor) // 100)
        total += race_scaled + class_flat + class_dice_avg
    return int(round(total))


async def compute_max_stamina(prisma: Prisma, level: int, race: Race) -> int:
    """Compute stamina_max from ``LevelDefinition.stamina_gain`` and the
    race ``hp_factor`` (used as a stamina factor too — there's no
    separate ``stamina_factor`` column today). Walks levels 1..level
    summing ``max(1, LevelDef.stamina_gain * race.hp_factor / 100)``.
    Mirrors the level-up formula in ``combat.rs::level_up`` so a
    re-seed produces the same totals a played-up character would have.
    """
    race_factor = 100
    display_name = RACE_ENUM_TO_DISPLAY.get(race)
    if display_name is not None:
        row = await prisma.races.find_first(where={"name": display_name})
        if row is not None and row.hpFactor is not None:
            race_factor = row.hpFactor

    level_defs = await prisma.leveldefinition.find_many(
        where={"level": {"gte": 1, "lte": level}}
    )
    by_level = {ld.level: ld for ld in level_defs}

    total = 0
    for L in range(1, level + 1):
        ld = by_level.get(L)
        baseline = ld.staminaGain if ld is not None else 5
        race_scaled = max(1, (baseline * race_factor) // 100)
        total += race_scaled
    return total


class UserSeeder:
    """Seeds test users for development and testing"""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    @staticmethod
    def calculate_role_from_level(max_level: int) -> UserRole:
        """
        Calculate UserRole based on maximum character level.

        Legacy level → modern UserRole:
        - 1-99   PLAYER
        - 100    IMMORTAL (LVL_IMMORT)
        - 101-102 BUILDER (LVL_GOD/LVL_GRGOD)
        - 103-104 HEAD_BUILDER (LVL_HEAD_B/LVL_HEAD_C)
        - 105+   IMPLEMENTOR (LVL_IMPL/LVL_OVERLORD)
        """
        if max_level >= 105:
            return UserRole.IMPLEMENTOR
        elif max_level >= 103:
            return UserRole.HEAD_BUILDER
        elif max_level >= 101:
            return UserRole.BUILDER
        elif max_level >= 100:
            return UserRole.IMMORTAL
        else:
            return UserRole.PLAYER

    async def create_character(
        self,
        user_id: str,
        name: str,
        level: int,
        race: Race = Race.HUMAN,
        password: str = "test123",
        class_plain_name: str = "Warrior",
    ) -> dict:
        """
        Create a test character for a user

        Args:
            user_id: User UUID
            name: Character name
            level: Character level
            race: Character race (default HUMAN)
            password: Character password (for legacy claiming)
            class_plain_name: CharacterClass.plain_name to assign;
                resolved to classId at write time. The runtime treats
                a NULL classId as "Classless"; pass a real class so
                test characters surface that way in `score`. A missing
                row prints a loud WARNING and falls through to NULL.

        Returns:
            Created character data
        """
        # Resolve class id from plain_name.
        class_row = await self.prisma.characterclass.find_unique(
            where={"plainName": class_plain_name}
        )
        if class_row is None:
            click.echo(
                f"    WARNING: no CharacterClass row with plain_name='{class_plain_name}' — {name} will be classless"
            )
            class_id = None
        else:
            class_id = class_row.id

        # Hash password for character
        password_hash = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt(rounds=12))

        # Per-level stat scaffold shared by create + update paths.
        # Combat stats use the canonical baseline (combat_formulas.
        # derive_hit_roll_baseline) so player and mob curves stay
        # symmetric at the 50% hit center for default-stat actors.
        # Fresh test characters have hit_roll=0; class/gear can bump
        # accuracy via apply_modify_delta(target="hitroll").
        # Stats use the class-aware profile (primary=95, secondary=75,
        # rest=50) on FieryMUD's 1-100 scale — matches the trained
        # mid-game profile real legacy characters reach. Replaces the
        # previous min(18, 10 + level/10) D&D-style cap, which produced
        # test characters with dex ~12 while real characters at the
        # same level have dex ~90 (200+ evasion gap). See gear-curves
        # §7 post-real-loadout audit.
        stats = class_stat_profile(class_plain_name)
        dex_score = stats["dex"]
        # Combat rates come from the Class row (data-only — see schema's
        # Class.{accuracy,evasion,dex_evasion,attack_power}_per_level
        # columns). Classless characters fall through to mob-symmetric
        # 2.0 defaults.
        acc_rate = class_row.accuracyPerLevel if class_row else 2.0
        eva_rate = class_row.evasionPerLevel if class_row else 2.0
        dex_mult = class_row.dexEvasionMult if class_row else 1.0
        ap_rate = class_row.attackPowerPerLevel if class_row else 2.0
        crit_chance = class_row.baseCritChance if class_row else 5
        baseline = derive_hit_roll_baseline(
            level,
            dex_score=dex_score,
            hit_roll=0,
            accuracy_per_level=acc_rate,
            evasion_per_level=eva_rate,
            dex_evasion_mult=dex_mult,
        )
        accuracy = baseline["accuracy"]
        evasion = baseline["evasion"]
        attack_power = derive_attack_power_baseline(level, attack_power_per_level=ap_rate)
        # HP from the live tuning rows (LevelDefinition, Class, Races)
        # so seeded test characters track the same curve as in-game
        # level-ups. Replaces the prior class-agnostic ``level * 10``
        # which over-leveled casters and under-leveled warriors.
        max_hp = await compute_max_hp(self.prisma, level, race, class_row)
        max_stamina = await compute_max_stamina(self.prisma, level, race)
        stat_block = {
            "level": level,
            "race": race,
            "passwordHash": password_hash.decode("utf-8"),
            "userId": user_id,
            # Class-aware stat profile (primary=95, secondary=75, rest=50)
            "strength": stats["str"],
            "intelligence": stats["int"],
            "wisdom": stats["wis"],
            "dexterity": dex_score,
            "constitution": stats["con"],
            "charisma": stats["cha"],
            "hitPoints": max_hp,
            "hitPointsMax": max_hp,
            "stamina": max_stamina,
            "staminaMax": max_stamina,
            # Combat baseline so seeded characters don't spawn at 0/0
            # (which would mean any same-level mob with the corrected
            # evasion formula outclasses them).
            "accuracy": accuracy,
            "evasion": evasion,
            "attackPower": attack_power,
            "critChance": crit_chance,
        }

        # Check if character already exists
        existing = await self.prisma.characters.find_unique(where={"name": name})

        if existing:
            update_data = dict(stat_block)
            if class_id is not None:
                update_data["classId"] = class_id
            character = await self.prisma.characters.update(
                where={"name": name},
                data=update_data,
            )
            click.echo(f"    Updated character: {name} (Level {level})")
        else:
            character_id = str(uuid.uuid4())
            create_data = {"id": character_id, "name": name, "gender": "male", **stat_block}
            if class_id is not None:
                create_data["classId"] = class_id
            character = await self.prisma.characters.create(data=create_data)
            click.echo(f"    Created character: {name} (Level {level})")

        # Grant all class-appropriate abilities so the character can
        # actually use their toolkit immediately — TestCleric should
        # be able to cast Heal without first running `study heal`.
        # Without this, group testing requires Implementor characters
        # since the cmd_cast class-gate also checks KnownAbilities.
        if class_id is not None:
            class_abilities = await self.prisma.classabilities.find_many(
                where={"classId": class_id}
            )
            # Schema stores proficiency 0..=1000 (raw practice
            # points). The runtime divides by 10 at formula time so
            # a "max" seeded test character lands at skill=100 in
            # pow(skill, K) formulas. 100 here would yield skill=10
            # downstream, which leaves Burning Hands at ~58 dmg
            # instead of the intended ~356.
            ability_ids: set[int] = set()
            for ca in class_abilities:
                ability_ids.add(ca.abilityId)
            # ClassSkills covers the non-spell-circle side (KICK,
            # BASH, RESCUE, BACKSTAB, etc.). Sorcerer has 0 here;
            # Warrior / Rogue have ~19 each. Without this branch a
            # seeded TestWarrior knows zero skills and `kick` /
            # `bash` etc. refuse with "you don't know that skill."
            class_skills = await self.prisma.classskills.find_many(
                where={"classId": class_id}
            )
            for cs in class_skills:
                ability_ids.add(cs.abilityId)
            granted = 0
            for ability_id in ability_ids:
                # Upsert per (character_id, ability_id) so re-runs of
                # the seeder are idempotent.
                await self.prisma.characterabilities.upsert(
                    where={
                        "characterId_abilityId": {
                            "characterId": character.id,
                            "abilityId": ability_id,
                        }
                    },
                    data={
                        "create": {
                            "characterId": character.id,
                            "abilityId": ability_id,
                            "known": True,
                            "proficiency": 1000,
                        },
                        "update": {"known": True, "proficiency": 1000},
                    },
                )
                granted += 1
            if granted > 0:
                click.echo(f"      → granted {granted} class abilities + skills")

        # Starter gear (see STARTER_GEAR table at module top). The
        # runtime's character spawn path reads CharacterItems on
        # login and re-equips items whose equipped_location is set;
        # null-location items land in inventory.
        gear = STARTER_GEAR.get(name)
        if gear:
            from datetime import datetime
            granted_items = 0
            for zone_id, object_id, slot in gear:
                # Idempotency: skip if the character already carries
                # this prototype in the same slot. Lets the seeder
                # rerun cleanly without piling up duplicate items.
                existing = await self.prisma.characteritems.find_first(
                    where={
                        "characterId": character.id,
                        "objectZoneId": zone_id,
                        "objectId": object_id,
                        "equippedLocation": slot,
                    }
                )
                if existing:
                    continue
                await self.prisma.characteritems.create(
                    data={
                        "characterId": character.id,
                        "objectZoneId": zone_id,
                        "objectId": object_id,
                        "equippedLocation": slot,
                        "condition": 100,
                        "charges": -1,
                        "updatedAt": datetime.utcnow(),
                    }
                )
                granted_items += 1
            if granted_items > 0:
                click.echo(f"      → granted {granted_items} starter item(s)")

        return character

    async def seed_users(self, skip_existing: bool = True, with_characters: bool = True) -> dict:
        """
        Create default test users and their characters

        Args:
            skip_existing: If True, skip users that already exist (default)
                          If False, update existing users with new passwords
            with_characters: If True, create test characters for each user

        Returns:
            Dictionary with created/updated user counts
        """
        click.echo("  Creating default users...")

        users_created = 0
        users_updated = 0
        characters_created = 0

        # ========================================
        # ADMIN USER (GOD level - requires level 115+ character)
        # ========================================
        admin_password = bcrypt.hashpw(b"admin123", bcrypt.gensalt(rounds=12))
        admin = await self.prisma.users.upsert(
            where={"email": "admin@muditor.dev"},
            data={
                "create": {
                    "id": str(uuid.uuid4()),
                    "email": "admin@muditor.dev",
                    "displayName": "admin",
                    "passwordHash": admin_password.decode("utf-8"),
                    "role": UserRole.PLAYER,  # Will be updated based on character level
                },
                "update": {} if skip_existing else {
                    "passwordHash": admin_password.decode("utf-8"),
                },
            },
        )
        if admin:
            users_created += 1 if skip_existing else 0
            users_updated += 0 if skip_existing else 1

            # Create GOD-level character (level 105 - max level)
            if with_characters:
                await self.create_character(admin.id, "AdminChar", 105, Race.HUMAN, "admin123", class_plain_name="Warrior")
                characters_created += 1

                # Update user role based on max character level
                await self.prisma.users.update(
                    where={"id": admin.id},
                    data={"role": self.calculate_role_from_level(105)}
                )

        # ========================================
        # BUILDER USER (BUILDER level - requires level 102+ character)
        # ========================================
        builder_password = bcrypt.hashpw(b"builder123", bcrypt.gensalt(rounds=12))
        builder = await self.prisma.users.upsert(
            where={"email": "builder@muditor.dev"},
            data={
                "create": {
                    "id": str(uuid.uuid4()),
                    "email": "builder@muditor.dev",
                    "displayName": "builder",
                    "passwordHash": builder_password.decode("utf-8"),
                    "role": UserRole.PLAYER,  # Will be updated based on character level
                },
                "update": {} if skip_existing else {
                    "passwordHash": builder_password.decode("utf-8"),
                },
            },
        )
        if builder:
            users_created += 1 if skip_existing else 0
            users_updated += 0 if skip_existing else 1

            # Create BUILDER-level character (level 102)
            if with_characters:
                await self.create_character(builder.id, "BuilderChar", 102, Race.ELF, "builder123", class_plain_name="Sorcerer")
                characters_created += 1

                # Update user role based on max character level
                await self.prisma.users.update(
                    where={"id": builder.id},
                    data={"role": self.calculate_role_from_level(102)}
                )

        # ========================================
        # TEST PLAYER (PLAYER level - normal character)
        # ========================================
        player_password = bcrypt.hashpw(b"player123", bcrypt.gensalt(rounds=12))
        player = await self.prisma.users.upsert(
            where={"email": "player@muditor.dev"},
            data={
                "create": {
                    "id": str(uuid.uuid4()),
                    "email": "player@muditor.dev",
                    "displayName": "testplayer",
                    "passwordHash": player_password.decode("utf-8"),
                    "role": UserRole.PLAYER,
                },
                "update": {} if skip_existing else {
                    "passwordHash": player_password.decode("utf-8"),
                },
            },
        )
        if player:
            users_created += 1 if skip_existing else 0
            users_updated += 0 if skip_existing else 1

            # Create multiple PLAYER-level characters
            if with_characters:
                await self.create_character(player.id, "TestWarrior", 25, Race.HUMAN, "player123", class_plain_name="Warrior")
                await self.create_character(player.id, "TestCleric", 20, Race.HUMAN, "player123", class_plain_name="Cleric")
                await self.create_character(player.id, "TestMage", 15, Race.ELF, "player123", class_plain_name="Sorcerer")
                await self.create_character(player.id, "TestRogue", 10, Race.HALFLING, "player123", class_plain_name="Rogue")
                characters_created += 4

                # Update user role based on max character level (25 = still PLAYER)
                await self.prisma.users.update(
                    where={"id": player.id},
                    data={"role": self.calculate_role_from_level(25)}
                )

        click.echo(f"  ✅ Created/updated users: admin, builder, testplayer")
        if with_characters:
            click.echo(f"  ✅ Created {characters_created} test characters")

        return {
            "created": users_created,
            "updated": users_updated,
            "characters_created": characters_created,
            "admin": admin,
            "builder": builder,
            "player": player,
        }
