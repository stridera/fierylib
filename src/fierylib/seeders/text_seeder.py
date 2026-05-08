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

        # XML-Lite color tags (`<red>`, `<b:yellow>`, `<dim>`, ...) are
        # rendered to ANSI by the runtime — the schema stores the
        # markup verbatim so builders can edit it via Muditor without
        # touching escape sequences. Trailing whitespace and newlines
        # are intentional: each row is concatenated to the next at
        # send time (banner → prompt), so the row owns its own line
        # boundaries. The previous implementation called `.strip()`
        # at insert time, which collapsed `register.\n\n` + prompt
        # into `register.Enter account email:` on the wire. The strip
        # was removed; messages here should be authored with the
        # exact whitespace they want on the wire.
        messages = [
            # Block-letter "FIERYMUD" with the C++ logo's exact
            # 5-stop xterm-256 fire gradient: 196 (red) → 202 →
            # 208 → 214 → 220 (yellow), peaking at the Y in the
            # middle and fading back through 214 → 208 → 202 for
            # M U D — a flame brightest at its core. Glyphs are
            # the same `╗ ╝ ║ ═` Unicode box-drawing block characters
            # the C++ banner uses; modern MUD clients (Mudlet,
            # BlightMud, MUSHclient, the major web clients) all
            # render them with their default fonts. Truecolor- and
            # 256-color- capable clients see the full gradient;
            # 16-color clients quietly down-sample to the nearest
            # match. Trailing `\r\n\r\n` separates the banner from
            # the EMAIL_PROMPT row so they don't run together on
            # the wire.
            (LoginStage.WELCOME_BANNER,
             "\r\n"
             "   <c196> ███████╗</> <c196>██╗</><c202>███████╗</><c202>██████╗ </><c208>██╗   ██╗</><c214>███╗   ███╗</><c214>██╗   ██╗</><c220>██████╗ </>\r\n"
             "   <c196> ██╔════╝</> <c196>██║</><c202>██╔════╝</><c202>██╔══██╗</><c208>╚██╗ ██╔╝</><c214>████╗ ████║</><c214>██║   ██║</><c220>██╔══██╗</>\r\n"
             "   <c196> █████╗  </> <c196>██║</><c202>█████╗  </><c202>██████╔╝</><c208> ╚████╔╝ </><c214>██╔████╔██║</><c214>██║   ██║</><c220>██║  ██║</>\r\n"
             "   <c196> ██╔══╝  </> <c196>██║</><c202>██╔══╝  </><c202>██╔══██╗</><c208>  ╚██╔╝  </><c214>██║╚██╔╝██║</><c214>██║   ██║</><c220>██║  ██║</>\r\n"
             "   <c196> ██║     </> <c196>██║</><c202>███████╗</><c202>██║  ██║</><c208>   ██║   </><c214>██║ ╚═╝ ██║</><c214>╚██████╔╝</><c220>██████╔╝</>\r\n"
             "   <c196> ╚═╝     </> <c196>╚═╝</><c202>╚══════╝</><c202>╚═╝  ╚═╝</><c208>   ╚═╝   </><c214>╚═╝     ╚═╝</><c214> ╚═════╝ </><c220>╚═════╝ </>\r\n"
             "\r\n"
             "   <c238>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</>\r\n"
             "   <c220>             A classic fantasy MUD, forged in fire.</>\r\n"
             "   <c244>                         www.fierymud.org</>\r\n"
             "   <c238>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</>\r\n"
             "\r\n"
             "   <c244>Login with your account email or character name.</>\r\n"
             "   <c244>New players: visit https://fierymud.org to register.</>\r\n"
             "\r\n"),
            # Prompts: trailing space after the colon is intentional —
            # players type immediately after a single space, the
            # standard MUD convention.
            (LoginStage.EMAIL_PROMPT, "Email or character name: "),
            (LoginStage.PASSWORD_PROMPT, "Password: "),
            (LoginStage.INVALID_LOGIN, "\r\n<red>Invalid email or password. Please try again.</>\r\n\r\n"),
            (LoginStage.TOO_MANY_ATTEMPTS, "\r\n<red>Too many failed login attempts. Please try again later.</>\r\n\r\n"),
            (LoginStage.CHARACTER_SELECT,
             "\r\n<b:cyan>=== Select Your Character ===</>\r\n\r\n"
             "{character_list}\r\n\r\n"
             "Enter character number to play, or 'new' to create a new character: "),
            (LoginStage.CREATE_NAME_PROMPT, "\r\nEnter a name for your new character: "),
            (LoginStage.CREATE_PASSWORD, "\r\nChoose a password (6-20 characters): "),
            (LoginStage.CONFIRM_PASSWORD, "Confirm password: "),
            (LoginStage.SELECT_CLASS,
             "\r\n<b:cyan>=== Choose Your Class ===</>\r\n\r\n"
             "  <yellow>1) Warrior</>   - Masters of combat and martial prowess\r\n"
             "  <yellow>2) Cleric</>    - Divine magic and healing arts\r\n"
             "  <yellow>3) Sorcerer</>  - Arcane magic and spell mastery\r\n"
             "  <yellow>4) Rogue</>     - Stealth, speed, and cunning\r\n\r\n"
             "Enter class number: "),
            (LoginStage.SELECT_RACE,
             "\r\n<b:cyan>=== Choose Your Race ===</>\r\n\r\n"
             "  <yellow>1) Human</>    - Versatile and adaptable\r\n"
             "  <yellow>2) Elf</>      - Graceful and magical\r\n"
             "  <yellow>3) Dwarf</>    - Sturdy and resilient\r\n"
             "  <yellow>4) Halfling</> - Small but brave\r\n\r\n"
             "Enter race number: "),
            (LoginStage.CREATION_COMPLETE,
             "\r\n<b:yellow>=== Character Created! ===</>\r\n\r\n"
             "Welcome to FieryMUD, <yellow>{character_name}</>!\r\n\r\n"
             "<dim>Your adventure begins now. Type `help newbie` for beginner tips.</>\r\n\r\n"),
            (LoginStage.RECONNECT_MESSAGE, "\r\n<dim>Reconnecting to existing session...</>\r\n\r\n"),
            (LoginStage.LOGIN_APPROVAL_PENDING,
             "\r\n<yellow>A login approval request has been sent to your Muditor dashboard.</>\r\n"
             "<dim>Please approve it there to continue. This request expires in 5 minutes.</>\r\n\r\n"),
            (LoginStage.LOGIN_APPROVAL_APPROVED, "\r\n<green>Login approved! Loading your characters...</>\r\n\r\n"),
            (LoginStage.LOGIN_APPROVAL_DENIED, "\r\n<red>Login request was denied. Disconnecting.</>\r\n\r\n"),
            (LoginStage.LOGIN_APPROVAL_EXPIRED, "\r\n<red>Login request expired. Please try again.</>\r\n\r\n"),
        ]

        for stage, message in messages:
            # No `.strip()` — each row owns its own leading/trailing
            # whitespace and newlines. See the comment on `messages`.
            await self.seed_login_message(stage, message)
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
