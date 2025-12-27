"""Game configuration seeder for FieryMUD.

Seeds all game configuration values from constants currently hardcoded in the C++ codebase.
These configs are loaded by the MUD at startup and can be edited via Muditor.
"""

import click
from prisma import Prisma
from prisma.enums import ConfigValueType


class ConfigSeeder:
    """Seeds game configuration values into the GameConfig table."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    async def upsert_config(
        self,
        category: str,
        key: str,
        value: str | int | float | bool,
        value_type: ConfigValueType,
        description: str | None = None,
        min_value: str | None = None,
        max_value: str | None = None,
        is_secret: bool = False,
        restart_req: bool = False,
    ) -> dict:
        """Upsert a single configuration value."""
        # Convert value to string for storage
        if isinstance(value, bool):
            str_value = "true" if value else "false"
        else:
            str_value = str(value)

        return await self.prisma.gameconfig.upsert(
            where={"category_key": {"category": category, "key": key}},
            data={
                "create": {
                    "category": category,
                    "key": key,
                    "value": str_value,
                    "valueType": value_type,
                    "description": description,
                    "minValue": min_value,
                    "maxValue": max_value,
                    "isSecret": is_secret,
                    "restartReq": restart_req,
                },
                "update": {
                    "value": str_value,
                    "description": description,
                    "minValue": min_value,
                    "maxValue": max_value,
                    "isSecret": is_secret,
                    "restartReq": restart_req,
                },
            },
        )

    async def seed_server_config(self, verbose: bool = False) -> int:
        """Seed server configuration values."""
        configs = [
            # Network settings
            ("server", "port", 4000, ConfigValueType.INT, "Main game port", "1024", "65535", False, True),
            ("server", "tls_port", 4443, ConfigValueType.INT, "TLS/SSL port", "1024", "65535", False, True),
            ("server", "max_connections", 200, ConfigValueType.INT, "Maximum concurrent connections", "10", "1000", False, True),
            ("server", "connection_timeout_seconds", 300, ConfigValueType.INT, "Connection timeout in seconds", "60", "3600", False, False),
            ("server", "target_tps", 10, ConfigValueType.INT, "Target ticks per second", "1", "100", False, True),
            ("server", "max_command_queue_size", 10000, ConfigValueType.INT, "Maximum command queue size", "100", "100000", False, True),

            # Persistence settings
            ("server", "auto_save_interval_seconds", 300, ConfigValueType.INT, "Auto-save interval in seconds", "60", "3600", False, False),
            ("server", "backup_interval_seconds", 3600, ConfigValueType.INT, "Backup interval in seconds", "300", "86400", False, False),
            ("server", "max_backups", 24, ConfigValueType.INT, "Maximum backup files to retain", "1", "168", False, False),

            # Display settings
            ("display", "mud_name", "FieryMUD", ConfigValueType.STRING, "MUD name displayed to players", None, None, False, False),
            ("display", "default_starting_room", 3001, ConfigValueType.INT, "Default room for new characters", "1", None, False, False),
        ]

        count = 0
        for cfg in configs:
            category, key, value, vtype, desc, min_val, max_val, secret, restart = cfg
            await self.upsert_config(category, key, value, vtype, desc, min_val, max_val, secret, restart)
            count += 1
            if verbose:
                click.echo(f"    {category}.{key} = {value}")

        return count

    async def seed_security_config(self, verbose: bool = False) -> int:
        """Seed security configuration values."""
        configs = [
            ("security", "max_login_attempts", 3, ConfigValueType.INT, "Max failed login attempts before lockout", "1", "10", False, False),
            ("security", "login_timeout_minutes", 15, ConfigValueType.INT, "Login timeout in minutes", "1", "60", False, False),
            ("security", "enable_new_player_creation", True, ConfigValueType.BOOL, "Allow new player registration", None, None, False, False),
            ("security", "enable_debug_commands", False, ConfigValueType.BOOL, "Enable debug commands (DEV ONLY)", None, None, False, True),
            ("security", "enable_tls", True, ConfigValueType.BOOL, "Enable TLS/SSL connections", None, None, False, True),
        ]

        count = 0
        for cfg in configs:
            category, key, value, vtype, desc, min_val, max_val, secret, restart = cfg
            await self.upsert_config(category, key, value, vtype, desc, min_val, max_val, secret, restart)
            count += 1
            if verbose:
                click.echo(f"    {category}.{key} = {value}")

        return count

    async def seed_timing_config(self, verbose: bool = False) -> int:
        """Seed game tick timing configuration."""
        configs = [
            # Legacy FieryMUD uses 10 passes per second (OPT_USEC = 100000)
            ("timing", "passes_per_second", 10, ConfigValueType.INT, "Game loop passes per second", "1", "100", False, True),
            ("timing", "pulse_zone", 100, ConfigValueType.INT, "Ticks between zone resets (10 sec @ 10 tps)", "10", "1000", False, False),
            ("timing", "pulse_mobile", 100, ConfigValueType.INT, "Ticks between mob AI updates (10 sec)", "10", "1000", False, False),
            ("timing", "pulse_violence", 40, ConfigValueType.INT, "Ticks per combat round (4 sec)", "10", "100", False, False),
            ("timing", "pulse_autosave", 600, ConfigValueType.INT, "Ticks between autosaves (60 sec)", "100", "6000", False, False),
        ]

        count = 0
        for cfg in configs:
            category, key, value, vtype, desc, min_val, max_val, secret, restart = cfg
            await self.upsert_config(category, key, value, vtype, desc, min_val, max_val, secret, restart)
            count += 1
            if verbose:
                click.echo(f"    {category}.{key} = {value}")

        return count

    async def seed_combat_config(self, verbose: bool = False) -> int:
        """Seed combat system configuration."""
        configs = [
            # Combat timing
            ("combat", "round_seconds", 4, ConfigValueType.INT, "Seconds per combat round", "1", "10", False, False),

            # Accuracy and evasion caps
            ("combat", "accuracy_soft_cap", 200, ConfigValueType.INT, "Maximum effective accuracy", "50", "500", False, False),
            ("combat", "evasion_soft_cap", 150, ConfigValueType.INT, "Maximum effective evasion", "50", "500", False, False),

            # Hit thresholds (margin required)
            ("combat", "critical_threshold", 50, ConfigValueType.INT, "Roll margin for critical hit", "10", "100", False, False),
            ("combat", "normal_hit_threshold", 10, ConfigValueType.INT, "Roll margin for normal hit", "0", "50", False, False),
            ("combat", "glancing_threshold", -10, ConfigValueType.INT, "Roll margin for glancing blow", "-50", "0", False, False),

            # Damage multipliers
            ("combat", "critical_multiplier", 2.0, ConfigValueType.FLOAT, "Critical hit damage multiplier", "1.0", "5.0", False, False),
            ("combat", "glancing_multiplier", 0.5, ConfigValueType.FLOAT, "Glancing blow damage multiplier", "0.1", "1.0", False, False),

            # Damage reduction caps
            ("combat", "damage_reduction_cap", 75, ConfigValueType.INT, "Maximum damage reduction %", "50", "99", False, False),
            ("combat", "penetration_cap", 50, ConfigValueType.INT, "Maximum armor penetration %", "25", "100", False, False),

            # HP thresholds
            ("combat", "hp_incapacitated", -3, ConfigValueType.INT, "HP threshold for incapacitation", "-20", "0", False, False),
            ("combat", "hp_mortally_wounded", -6, ConfigValueType.INT, "HP threshold for mortally wounded", "-20", "-1", False, False),
            ("combat", "hp_dead", -11, ConfigValueType.INT, "HP threshold for death", "-50", "-1", False, False),
            ("combat", "max_damage_per_hit", 1000, ConfigValueType.INT, "Maximum damage allowed per hit", "100", "10000", False, False),
        ]

        count = 0
        for cfg in configs:
            category, key, value, vtype, desc, min_val, max_val, secret, restart = cfg
            await self.upsert_config(category, key, value, vtype, desc, min_val, max_val, secret, restart)
            count += 1
            if verbose:
                click.echo(f"    {category}.{key} = {value}")

        return count

    async def seed_progression_config(self, verbose: bool = False) -> int:
        """Seed character progression configuration."""
        configs = [
            # Level caps
            ("progression", "max_mortal_level", 99, ConfigValueType.INT, "Maximum mortal player level", "50", "200", False, False),
            ("progression", "max_level", 105, ConfigValueType.INT, "Maximum level (including immortals)", "100", "200", False, True),

            # Experience formula: level^exponent * multiplier
            ("progression", "exp_exponent", 2.5, ConfigValueType.FLOAT, "Experience formula exponent", "1.5", "4.0", False, False),
            ("progression", "exp_multiplier", 1000, ConfigValueType.INT, "Experience formula base multiplier", "100", "10000", False, False),

            # Kill experience modifiers
            ("progression", "exp_higher_level_bonus", 10, ConfigValueType.INT, "% bonus per level above player", "0", "50", False, False),
            ("progression", "exp_lower_level_penalty", 5, ConfigValueType.INT, "% penalty per level below player", "0", "25", False, False),
            ("progression", "exp_minimum_percent", 10, ConfigValueType.INT, "Minimum % of base XP from kills", "1", "50", False, False),
        ]

        count = 0
        for cfg in configs:
            category, key, value, vtype, desc, min_val, max_val, secret, restart = cfg
            await self.upsert_config(category, key, value, vtype, desc, min_val, max_val, secret, restart)
            count += 1
            if verbose:
                click.echo(f"    {category}.{key} = {value}")

        return count

    async def seed_character_config(self, verbose: bool = False) -> int:
        """Seed new character default values."""
        configs = [
            # Starting stats
            ("character", "starting_str", 13, ConfigValueType.INT, "Starting strength", "1", "25", False, False),
            ("character", "starting_dex", 13, ConfigValueType.INT, "Starting dexterity", "1", "25", False, False),
            ("character", "starting_int", 13, ConfigValueType.INT, "Starting intelligence", "1", "25", False, False),
            ("character", "starting_wis", 13, ConfigValueType.INT, "Starting wisdom", "1", "25", False, False),
            ("character", "starting_con", 13, ConfigValueType.INT, "Starting constitution", "1", "25", False, False),
            ("character", "starting_cha", 13, ConfigValueType.INT, "Starting charisma", "1", "25", False, False),

            # Starting resources
            ("character", "starting_hp", 100, ConfigValueType.INT, "Starting hit points", "10", "500", False, False),
            ("character", "starting_stamina", 100, ConfigValueType.INT, "Starting stamina", "10", "500", False, False),

            # Starting combat stats (ACC/EVA system)
            ("character", "starting_accuracy", 50, ConfigValueType.INT, "Starting accuracy (hit chance modifier)", "0", "200", False, False),
            ("character", "starting_evasion", 30, ConfigValueType.INT, "Starting evasion (dodge chance modifier)", "0", "150", False, False),
            ("character", "starting_damage_bonus", 0, ConfigValueType.INT, "Starting damage bonus", "0", "100", False, False),

            # Stat bounds
            ("character", "min_stat", 1, ConfigValueType.INT, "Minimum ability score", "1", "10", False, False),
            ("character", "max_stat", 25, ConfigValueType.INT, "Maximum ability score", "20", "100", False, False),
        ]

        count = 0
        for cfg in configs:
            category, key, value, vtype, desc, min_val, max_val, secret, restart = cfg
            await self.upsert_config(category, key, value, vtype, desc, min_val, max_val, secret, restart)
            count += 1
            if verbose:
                click.echo(f"    {category}.{key} = {value}")

        return count

    async def seed_all(self, verbose: bool = False) -> dict:
        """Seed all configuration categories."""
        stats = {
            "server": 0,
            "security": 0,
            "timing": 0,
            "combat": 0,
            "progression": 0,
            "character": 0,
            "total": 0,
        }

        click.echo("  Server configuration...")
        stats["server"] = await self.seed_server_config(verbose)

        click.echo("  Security configuration...")
        stats["security"] = await self.seed_security_config(verbose)

        click.echo("  Timing configuration...")
        stats["timing"] = await self.seed_timing_config(verbose)

        click.echo("  Combat configuration...")
        stats["combat"] = await self.seed_combat_config(verbose)

        click.echo("  Progression configuration...")
        stats["progression"] = await self.seed_progression_config(verbose)

        click.echo("  Character defaults...")
        stats["character"] = await self.seed_character_config(verbose)

        stats["total"] = sum(v for k, v in stats.items() if k != "total")
        return stats
