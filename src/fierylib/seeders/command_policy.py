"""Per-command policy flags: "Command".allowed_while_casting / allowed_while_paralyzed /
keeps_hidden / held_by_cast_lag.

Seed values are the exact lists the fierymud-rs server used to hard-code (casting.rs
CASTING_ALLOWED, commands.rs PARALYSIS_ALLOWED, hiding.rs HIDE_SAFE, input_queue.rs
LAG_HELD_VERBS), keyed by canonical command name. Entries with no registry command are
harmless (an UPDATE by name matches nothing). Shared by scripts/gen_command_policy_sql.py
(writes data/sql/2026-10-12-command-policy-flags.sql) and CommandSeeder (runs the same
statements after a reset).

Builder edits survive: a column is seeded only while no row has it set yet, so a rerun after
the first application (or after any Muditor edit of that column) changes nothing.
"""

# column -> command names that get the flag

ALLOWED_WHILE_CASTING = [
    "abort",
    "cancel",
    "alert",
    "cls",
    "world",
    "quest",
    "disengage",
    "flee",
    "look",
    "consent",
    "gossip",
    "tell",
    "reply",
    "gsay",
    "ctell",
    "qsay",
    "music",
    "ignore",
    "score",
    "inventory",
    "equipment",
    "experience",
    "level",
    "trophy",
    "who",
    "whoami",
    "where",
    "time",
    "date",
    "weather",
    "uptime",
    "version",
    "help",
    "commands",
    "socials",
    "skills",
    "spells",
    "songs",
    "chants",
    "innate",
    "quests",
    "prompt",
    "color",
    "title",
    "news",
    "motd",
    "credits",
    "policies",
    "lasttells",
    "lastgossips",
    "greport",
    "bug",
    "idea",
    "typo",
    "petition",
]

ALLOWED_WHILE_PARALYZED = [
    "abort",
    "bug",
    "clear",
    "cls",
    "color",
    "commands",
    "credits",
    "ctell",
    "date",
    "display",
    "equipment",
    "experience",
    "greport",
    "gsay",
    "gtell",
    "help",
    "inventory",
    "idea",
    "innate",
    "ignore",
    "info",
    "look",
    "lasttells",
    "lastgos",
    "level",
    "motd",
    "music",
    "news",
    "petition",
    "policy",
    "prompt",
    "quest",
    "quit",
    "qsay",
    "reply",
    "return",
    "say",
    "'",
    "score",
    "skills",
    "songs",
    "socials",
    "spells",
    "tell",
    "title",
    "time",
    "toggle",
    "trophy",
    "typo",
    "uptime",
    "version",
    "weather",
    "who",
    "whoami",
    "wizlist",
    "world",
]

KEEPS_HIDDEN = [
    "north",
    "south",
    "east",
    "west",
    "up",
    "down",
    "northeast",
    "northwest",
    "southeast",
    "southwest",
    "in",
    "out",
    "walk",
    "fly",
    "go",
    "stay",
    "hide",
    "visible",
    "sneak",
    "conceal",
    "backstab",
    "cartwheel",
    "lure",
    "palm",
    "pick",
    "steal",
    "stow",
    "scan",
    "look",
    "examine",
    "glance",
    "diagnose",
    "exits",
    "identify",
    "value",
    "score",
    "inventory",
    "equipment",
    "experience",
    "level",
    "skills",
    "spells",
    "songs",
    "innate",
    "socials",
    "help",
    "wizhelp",
    "commands",
    "credits",
    "motd",
    "news",
    "policies",
    "time",
    "date",
    "uptime",
    "weather",
    "version",
    "trophy",
    "world",
    "who",
    "whoami",
    "where",
    "users",
    "game",
    "title",
    "display",
    "prompt",
    "toggle",
    "color",
    "alias",
    "unalias",
    "consent",
    "subclass",
    "group",
    "quit",
    "save",
    "bug",
    "idea",
    "typo",
    "petition",
    "abort",
    "clear",
    "cls",
    "ignore",
    "unignore",
    "effects",
    "cooldowns",
    "achievements",
    "flags",
    "wealth",
    "practice",
    "tell",
    "reply",
    "lasttells",
    "gsay",
    "ctell",
    "qsay",
    "qecho",
    "music",
    "gossip",
    "wiznet",
    "mail",
    "mailbox",
    "readmail",
    "note",
    "pnote",
    "lastgossips",
    "lastshouts",
]

HELD_BY_CAST_LAG = [
    "cast",
    "chant",
    "perform",
    "recite",
    "quaff",
    "use",
    "zap",
    "tap",
    "play",
]

FLAGS: dict[str, list[str]] = {
    "allowed_while_casting": ALLOWED_WHILE_CASTING,
    "allowed_while_paralyzed": ALLOWED_WHILE_PARALYZED,
    "keeps_hidden": KEEPS_HIDDEN,
    "held_by_cast_lag": HELD_BY_CAST_LAG,
}

# Same DDL as Prisma `db push`; lets the patch run before the schema push.
COLUMN_DDL = [
    f'ALTER TABLE "Command" ADD COLUMN IF NOT EXISTS "{col}" BOOLEAN NOT NULL DEFAULT false'
    for col in FLAGS
]


def _lit(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def flag_sql(column: str, names: list[str]) -> str:
    """UPDATE that sets `column` on `names`; a no-op once any row has the column set."""
    in_list = ", ".join(_lit(n) for n in sorted(names))
    return (
        f'UPDATE "Command" SET "{column}" = true\n'
        f'WHERE "name" IN ({in_list})\n'
        f'  AND NOT EXISTS (SELECT 1 FROM "Command" WHERE "{column}")'
    )


def statements() -> list[str]:
    """Every seed UPDATE, no trailing semicolons."""
    return [flag_sql(col, names) for col, names in FLAGS.items()]


HEADER = """-- Command policy flags (data-over-code).
--
-- Four per-command allow lists were hard-coded in fierymud-rs (legacy CMD_* flags). They now
-- live on "Command", editable in Muditor (CODER role):
--   allowed_while_casting    casting.rs   CASTING_ALLOWED  ({n_casting} commands)
--   allowed_while_paralyzed  commands.rs  PARALYSIS_ALLOWED ({n_para} commands)
--   keeps_hidden             hiding.rs    HIDE_SAFE        ({n_hide} commands)
--   held_by_cast_lag         input_queue.rs LAG_HELD_VERBS ({n_lag} commands)
-- The server keeps the lists as the fallback for a database without the columns or a
-- command without a row, so behaviour is identical with or without this patch.
--
-- This patch adds the columns if missing (same DDL as Prisma `db push`) and sets each flag on
-- the command names of the old list. A column is seeded only while no row has it set, so a
-- rerun changes nothing and later Muditor edits are never overwritten.
--
-- Generated by scripts/gen_command_policy_sql.py. Idempotent.

BEGIN;

"""


def patch_sql() -> str:
    ddl = "".join(f"{s};\n" for s in COLUMN_DDL)
    body = "\n".join(f"{s};\n" for s in statements())
    header = HEADER.format(
        n_casting=len(ALLOWED_WHILE_CASTING),
        n_para=len(ALLOWED_WHILE_PARALYZED),
        n_hide=len(KEEPS_HIDDEN),
        n_lag=len(HELD_BY_CAST_LAG),
    )
    return header + ddl + "\n" + body + "\nCOMMIT;\n"
