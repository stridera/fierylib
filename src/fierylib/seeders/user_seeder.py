"""User seeding functionality for initial database setup"""

import uuid
import bcrypt
import click
from datetime import datetime
from prisma import Prisma
from prisma.enums import UserRole, Race


class UserSeeder:
    """Seeds test users for development and testing"""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    @staticmethod
    def calculate_role_from_level(max_level: int) -> UserRole:
        """
        Calculate UserRole based on maximum character level

        Legacy FieryMUD level progression:
        - 1-99:  PLAYER (normal gameplay)
        - 100:   IMMORTAL (LVL_IMMORT - Avatar)
        - 101-102: BUILDER (LVL_GOD/LVL_GRGOD - Demi-God/Lesser God)
        - 103-104: CODER (LVL_HEAD_B/LVL_HEAD_C - Greater God/Implementer)
        - 105:   GOD (LVL_IMPL/LVL_OVERLORD - Overlord - maximum level)

        Args:
            max_level: Highest character level

        Returns:
            UserRole enum value
        """
        if max_level >= 105:
            return UserRole.GOD
        elif max_level >= 103:
            return UserRole.CODER
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

        # Check if character already exists
        existing = await self.prisma.characters.find_unique(where={"name": name})

        if existing:
            # Update existing character
            update_data = {
                "level": level,
                "race": race,
                "passwordHash": password_hash.decode("utf-8"),
                "userId": user_id,
                # Set stats based on level (higher level = better stats)
                "strength": min(18, 10 + (level // 10)),
                "intelligence": min(18, 10 + (level // 10)),
                "wisdom": min(18, 10 + (level // 10)),
                "dexterity": min(18, 10 + (level // 10)),
                "constitution": min(18, 10 + (level // 10)),
                "charisma": min(18, 10 + (level // 10)),
                # HP/Stamina based on level
                "hitPoints": level * 10,
                "hitPointsMax": level * 10,
                "stamina": 100 + (level * 2),
                "staminaMax": 100 + (level * 2),
            }
            if class_id is not None:
                update_data["classId"] = class_id
            character = await self.prisma.characters.update(
                where={"name": name},
                data=update_data,
            )
            click.echo(f"    Updated character: {name} (Level {level})")
        else:
            # Create new character
            character_id = str(uuid.uuid4())
            create_data = {
                "id": character_id,
                "name": name,
                "level": level,
                "race": race,
                "gender": "male",
                "passwordHash": password_hash.decode("utf-8"),
                "userId": user_id,
                "birthTime": datetime.now(),
                # Set stats based on level (higher level = better stats)
                "strength": min(18, 10 + (level // 10)),
                "intelligence": min(18, 10 + (level // 10)),
                "wisdom": min(18, 10 + (level // 10)),
                "dexterity": min(18, 10 + (level // 10)),
                "constitution": min(18, 10 + (level // 10)),
                "charisma": min(18, 10 + (level // 10)),
                # HP/Stamina based on level
                "hitPoints": level * 10,
                "hitPointsMax": level * 10,
                "stamina": 100 + (level * 2),
                "staminaMax": 100 + (level * 2),
            }
            if class_id is not None:
                create_data["classId"] = class_id
            character = await self.prisma.characters.create(data=create_data)
            click.echo(f"    Created character: {name} (Level {level})")

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
                await self.create_character(builder.id, "BuilderChar", 102, Race.ELF, "builder123", class_plain_name="Mage")
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
                await self.create_character(player.id, "TestMage", 15, Race.ELF, "player123", class_plain_name="Mage")
                await self.create_character(player.id, "TestRogue", 10, Race.HALFLING, "player123", class_plain_name="Rogue")
                characters_created += 3

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
