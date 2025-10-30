"""User seeding functionality for initial database setup"""

import bcrypt
import click
from prisma import Prisma
from prisma.enums import UserRole


class UserSeeder:
    """Seeds test users for development and testing"""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    async def seed_users(self, skip_existing: bool = True) -> dict:
        """
        Create default test users

        Args:
            skip_existing: If True, skip users that already exist (default)
                          If False, update existing users with new passwords

        Returns:
            Dictionary with created/updated user counts
        """
        click.echo("  Creating default users...")

        users_created = 0
        users_updated = 0

        # Admin user (GOD level)
        admin_password = bcrypt.hashpw(b"admin123", bcrypt.gensalt(rounds=12))
        admin = await self.prisma.user.upsert(
            where={"email": "admin@muditor.dev"},
            data={
                "create": {
                    "email": "admin@muditor.dev",
                    "username": "admin",
                    "passwordHash": admin_password.decode("utf-8"),
                    "role": UserRole.GOD,
                },
                "update": {} if skip_existing else {
                    "passwordHash": admin_password.decode("utf-8"),
                },
            },
        )
        if admin:
            users_created += 1 if skip_existing else 0
            users_updated += 0 if skip_existing else 1

        # Builder user
        builder_password = bcrypt.hashpw(b"builder123", bcrypt.gensalt(rounds=12))
        builder = await self.prisma.user.upsert(
            where={"email": "builder@muditor.dev"},
            data={
                "create": {
                    "email": "builder@muditor.dev",
                    "username": "builder",
                    "passwordHash": builder_password.decode("utf-8"),
                    "role": UserRole.BUILDER,
                },
                "update": {} if skip_existing else {
                    "passwordHash": builder_password.decode("utf-8"),
                },
            },
        )
        if builder:
            users_created += 1 if skip_existing else 0
            users_updated += 0 if skip_existing else 1

        # Test player
        player_password = bcrypt.hashpw(b"player123", bcrypt.gensalt(rounds=12))
        player = await self.prisma.user.upsert(
            where={"email": "player@muditor.dev"},
            data={
                "create": {
                    "email": "player@muditor.dev",
                    "username": "testplayer",
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

        click.echo(f"  ✅ Created/updated users: admin, builder, testplayer")

        return {
            "created": users_created,
            "updated": users_updated,
            "admin": admin,
            "builder": builder,
            "player": player,
        }
