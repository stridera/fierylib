"""System text and login message seeder for FieryMUD.

Seeds MOTD, welcome screens, credits, and login flow messages.
Based on text files from fierymud/data/text/ directory.
"""

import click
from pathlib import Path
from prisma import Prisma
from prisma.enums import SystemTextCategory, LoginStage


class TextSeeder:
    """Seeds system text and login messages."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    async def seed_system_text(
        self,
        key: str,
        category: SystemTextCategory,
        content: str,
        title: str | None = None,
        min_level: int = 0,
        is_active: bool = True,
    ) -> dict:
        """Upsert a system text entry."""
        return await self.prisma.systemtext.upsert(
            where={"key": key},
            data={
                "create": {
                    "key": key,
                    "category": category,
                    "title": title,
                    "content": content,
                    "minLevel": min_level,
                    "isActive": is_active,
                },
                "update": {
                    "category": category,
                    "title": title,
                    "content": content,
                    "minLevel": min_level,
                    "isActive": is_active,
                },
            },
        )

    async def seed_login_message(
        self,
        stage: LoginStage,
        message: str,
        variant: str = "default",
        is_active: bool = True,
    ) -> dict:
        """Upsert a login message."""
        return await self.prisma.loginmessage.upsert(
            where={"stage_variant": {"stage": stage, "variant": variant}},
            data={
                "create": {
                    "stage": stage,
                    "variant": variant,
                    "message": message,
                    "isActive": is_active,
                },
                "update": {
                    "message": message,
                    "isActive": is_active,
                },
            },
        )

    async def seed_default_system_text(self, verbose: bool = False) -> int:
        """Seed default system text content."""
        count = 0

        # MOTD - Message of the Day
        motd_content = """
================================================================================
                         Welcome to FieryMUD!
================================================================================

A classic fantasy MUD, forged in fire.

  * Type 'help' for a list of commands
  * Type 'who' to see who's online
  * Type 'quit' to leave the game

Have fun, and may your adventures be legendary!

================================================================================
"""
        await self.seed_system_text(
            key="motd",
            category=SystemTextCategory.LOGIN,
            title="Message of the Day",
            content=motd_content.strip(),
        )
        count += 1
        if verbose:
            click.echo("    motd")

        # Immortal MOTD
        imotd_content = """
================================================================================
                      Welcome, Immortal!
================================================================================

Staff Notes:
  * Please review the latest admin news
  * Remember to log all significant actions
  * Be fair and consistent with players

Type 'wizhelp' for immortal commands.

================================================================================
"""
        await self.seed_system_text(
            key="imotd",
            category=SystemTextCategory.IMMORTAL,
            title="Immortal Message of the Day",
            content=imotd_content.strip(),
            min_level=100,
        )
        count += 1
        if verbose:
            click.echo("    imotd")

        # News
        news_content = """
FieryMUD News
=============

Welcome to the modernized FieryMUD! This server now runs on a PostgreSQL
database backend with real-time web editing via Muditor.

Check back here for game updates and announcements.
"""
        await self.seed_system_text(
            key="news",
            category=SystemTextCategory.SYSTEM,
            title="News",
            content=news_content.strip(),
        )
        count += 1
        if verbose:
            click.echo("    news")

        # Credits
        credits_content = """
================================================================================
                              FieryMUD Credits
================================================================================

FieryMUD is based on CircleMUD 3.0, which was developed from DikuMUD.

Original DikuMUD by:
  Sebastian Hammer, Michael Seifert, Hans Henrik Staerfeldt,
  Tom Madsen, and Katja Nyboe

CircleMUD by:
  Jeremy Elson

FieryMUD Development:
  The FieryMUD Team (1995-present)

Modern C++23 Rewrite:
  The FieryMUD Development Team (2024-present)

Special thanks to all the players who have made FieryMUD their home!

================================================================================
"""
        await self.seed_system_text(
            key="credits",
            category=SystemTextCategory.SYSTEM,
            title="Credits",
            content=credits_content.strip(),
        )
        count += 1
        if verbose:
            click.echo("    credits")

        # Policies
        policies_content = """
================================================================================
                           FieryMUD Policies
================================================================================

1. PLAYER CONDUCT
   - Be respectful to other players and staff
   - No harassment, hate speech, or discrimination
   - No exploiting bugs (report them instead)
   - No sharing account credentials

2. GAMEPLAY
   - Multi-playing is allowed within reason
   - Botting/automation requires staff approval
   - PvP is allowed in designated areas only

3. COMMUNICATION
   - Keep public channels appropriate
   - No spamming or flooding
   - English is the primary language

Violations may result in warnings, muting, or banning at staff discretion.

================================================================================
"""
        await self.seed_system_text(
            key="policies",
            category=SystemTextCategory.SYSTEM,
            title="Server Policies",
            content=policies_content.strip(),
        )
        count += 1
        if verbose:
            click.echo("    policies")

        # Background/Lore
        background_content = """
================================================================================
                        The World of FieryMUD
================================================================================

In ages past, the world was shaped by the eternal struggle between Order and
Chaos. The gods walked among mortals, and magic flowed freely through all
things.

Then came the Sundering - a cataclysmic war that shattered the land and sealed
the gods away. Now, a thousand years later, the barriers grow thin once more.

Heroes are needed. Will you answer the call?

================================================================================
"""
        await self.seed_system_text(
            key="background",
            category=SystemTextCategory.SYSTEM,
            title="World Background",
            content=background_content.strip(),
        )
        count += 1
        if verbose:
            click.echo("    background")

        return count

    async def seed_default_login_messages(self, verbose: bool = False) -> int:
        """Seed default login flow messages."""
        count = 0

        messages = [
            (LoginStage.WELCOME_BANNER, """
================================================================================
                    ___ _               __  __ _   _ ___
                   | __(_)___ _ _ _  _ |  \\/  | | | |   \\
                   | _|| / -_) '_| || || |\\/| | |_| | |) |
                   |_| |_\\___|_|  \\_, ||_|  |_|\\___/|___/
                                  |__/

                    A classic fantasy MUD, forged in fire.
================================================================================

  Enter your username or email to login.
  New players: Visit https://fierymud.org to register.

"""),
            (LoginStage.USERNAME_PROMPT, "Enter account username or email: "),
            (LoginStage.PASSWORD_PROMPT, "Password: "),
            (LoginStage.INVALID_LOGIN, "\nInvalid username or password. Please try again.\n"),
            (LoginStage.TOO_MANY_ATTEMPTS, "\nToo many failed login attempts. Please try again later.\n"),
            (LoginStage.CHARACTER_SELECT, """
================================================================================
                         Select Your Character
================================================================================

{character_list}

Enter character number to play, or 'new' to create a new character.
"""),
            (LoginStage.CREATE_NAME_PROMPT, "\nEnter a name for your new character: "),
            (LoginStage.CREATE_PASSWORD, "\nChoose a password (6-20 characters): "),
            (LoginStage.CONFIRM_PASSWORD, "Confirm password: "),
            (LoginStage.SELECT_CLASS, """
================================================================================
                         Choose Your Class
================================================================================

  1) Warrior   - Masters of combat and martial prowess
  2) Cleric    - Divine magic and healing arts
  3) Sorcerer  - Arcane magic and spell mastery
  4) Rogue     - Stealth, speed, and cunning

Enter class number: """),
            (LoginStage.SELECT_RACE, """
================================================================================
                          Choose Your Race
================================================================================

  1) Human    - Versatile and adaptable
  2) Elf      - Graceful and magical
  3) Dwarf    - Sturdy and resilient
  4) Halfling - Small but brave

Enter race number: """),
            (LoginStage.CREATION_COMPLETE, """
================================================================================
                    Character Created Successfully!
================================================================================

Welcome to FieryMUD, {character_name}!

Your adventure begins now. Type 'help newbie' for beginner tips.
"""),
            (LoginStage.RECONNECT_MESSAGE, "\nReconnecting to existing session...\n"),
        ]

        for stage, message in messages:
            await self.seed_login_message(stage, message.strip())
            count += 1
            if verbose:
                click.echo(f"    {stage.name}")

        return count

    async def import_text_file(
        self,
        file_path: Path,
        key: str,
        category: SystemTextCategory,
        title: str | None = None,
        min_level: int = 0,
    ) -> bool:
        """Import a text file as system text.

        Args:
            file_path: Path to the text file
            key: Unique key for the system text
            category: Category for the text
            title: Display title (defaults to key)
            min_level: Minimum level to view

        Returns:
            True if imported successfully
        """
        if not file_path.exists():
            return False

        content = file_path.read_text(encoding="utf-8", errors="replace")
        await self.seed_system_text(
            key=key,
            category=category,
            title=title or key.title(),
            content=content.strip(),
            min_level=min_level,
        )
        return True

    async def import_from_directory(
        self,
        text_dir: Path,
        verbose: bool = False,
    ) -> dict:
        """Import system text from a directory (e.g., fierymud/data/text/).

        Args:
            text_dir: Path to text directory
            verbose: Show detailed output

        Returns:
            Statistics dict
        """
        stats = {"imported": 0, "skipped": 0}

        # Map of files to import
        file_mappings = [
            ("motd", SystemTextCategory.LOGIN, "Message of the Day", 0),
            ("imotd", SystemTextCategory.IMMORTAL, "Immortal MOTD", 100),
            ("news", SystemTextCategory.SYSTEM, "News", 0),
            ("anews", SystemTextCategory.IMMORTAL, "Admin News", 100),
            ("credits", SystemTextCategory.SYSTEM, "Credits", 0),
            ("policies", SystemTextCategory.SYSTEM, "Policies", 0),
            ("background", SystemTextCategory.SYSTEM, "Background", 0),
            ("wizlist", SystemTextCategory.SYSTEM, "Wizard List", 0),
            ("immlist", SystemTextCategory.IMMORTAL, "Immortal List", 100),
        ]

        for filename, category, title, min_level in file_mappings:
            file_path = text_dir / filename
            if await self.import_text_file(file_path, filename, category, title, min_level):
                stats["imported"] += 1
                if verbose:
                    click.echo(f"    Imported: {filename}")
            else:
                stats["skipped"] += 1
                if verbose:
                    click.echo(f"    Skipped (not found): {filename}")

        return stats

    async def seed_all(self, verbose: bool = False) -> dict:
        """Seed all default text content."""
        stats = {
            "system_text": 0,
            "login_messages": 0,
            "total": 0,
        }

        click.echo("  Seeding system text...")
        stats["system_text"] = await self.seed_default_system_text(verbose)

        click.echo("  Seeding login messages...")
        stats["login_messages"] = await self.seed_default_login_messages(verbose)

        stats["total"] = stats["system_text"] + stats["login_messages"]
        return stats
